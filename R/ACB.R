.is_acb_add_transaction <- function(transaction) {
  transaction %in% c("buy", "revenue", "rebates")
}

.prepare_acb_revenue_values <- function(data, total.price, as.revenue) {
  # List all possible revenue sources
  all.revenue.type <- c(
    "airdrops", "referrals", "promos", "rewards",
    "rebates", "staking", "interests", "mining"
  )

  # List all non-revenue
  not.revenue <- all.revenue.type[!(all.revenue.type %in% as.revenue)]

  if (!missing(total.price) && "revenue.type" %in% names(data)) {
    return(data %>%
      mutate(
        value = .data[[total.price]],
        total.price = ifelse(.data$revenue.type %in% not.revenue,
          0,
          .data[[total.price]]
        )
      ) %>%
      relocate("value", .after = "revenue.type"))
  }

  data
}

.ensure_acb_total_price <- function(data, total.price, spot.rate, quantity) {
  if (total.price %in% names(data)) {
    return(data)
  }

  if (spot.rate %in% names(data)) {
    data[total.price] <- data[spot.rate] * data[quantity]
    return(data)
  }

  stop(
    "Cannot calculate column 'total.price'. ",
    "Please provide either 'spot.rate' or 'total.price' columns."
  )
}

.ensure_acb_fees <- function(data, total.price) {
  if (!"fees" %in% names(data)) {
    data <- data %>%
      mutate(fees = 0, .after = all_of(total.price))
  }

  data %>%
    mutate(fees = ifelse(is.na(.data$fees), 0, .data$fees))
}

.acb_currency_label <- function(data) {
  if ("currency2" %in% names(data)) {
    return(data$currency2[1])
  }

  if ("currency" %in% names(data)) {
    return(data$currency[1])
  }

  ""
}

.initialize_acb_quantity <- function(data, i, quantity) {
  if (i == 1) {
    data[i, "total.quantity"] <- data[i, quantity]
  }

  data
}

.update_acb_add_row <- function(data, i, quantity, total.price) {
  if (i == 1) {
    data[i, "ACB"] <- data[i, total.price] + data[i, "fees"]
    return(data)
  }

  data[i, "total.quantity"] <- data[i - 1, "total.quantity"] + data[i, quantity]
  data[i, "ACB"] <- data[i - 1, "ACB"] + data[i, total.price] + data[i, "fees"]
  data
}

.update_acb_sell_row <- function(data, i, quantity) {
  data[i, "total.quantity"] <- data[i - 1, "total.quantity"] - data[i, quantity]
  data[i, "ACB"] <- data[i - 1, "ACB"] *
    ((data[i - 1, "total.quantity"] - data[i, quantity]) /
      data[i - 1, "total.quantity"])
  data
}

.update_acb_share <- function(data, i) {
  data[i, "ACB.share"] <- ifelse(data[i, "ACB"] > 0,
    data[i, "ACB"] / data[i, "total.quantity"],
    0
  )
  data
}

.update_acb_gains <- function(data, i, total.price, quantity) {
  data[i, "gains"] <- data[i, total.price] - data[i, "fees"] -
    data[i - 1, "ACB.share"] * data[i, quantity]
  data
}

.correct_zero_quantity_acb <- function(data, i) {
  data[i, "ACB"] <- ifelse(data[i, "total.quantity"] == 0,
    0,
    data[i, "ACB"]
  )

  data[i, "ACB.share"] <- ifelse(data[i, "total.quantity"] == 0,
    0,
    data[i, "ACB.share"]
  )

  data
}

#' @title Calculate capital gains from realized gain transactions
#'
#' @description Calculate realized and unrealized capital gains/losses
#' @param data The dataframe
#' @param transaction Name of transaction column
#' @param price Name of price column
#' @param quantity Name of quantity column
#' @param fees Name of fees column
#' @param total.price Name of total.price column
#' @param spot.rate Name of spot.rate column
#' @param as.revenue Name of as.revenue column
#' @param sup.loss Logical, whether to calculate superficial losses
#' @param cl Number of cores to use for parallel processing.
#' @param verbose Logical: if `FALSE`, does not print progress bar or
#' warnings to console.
#' @return A data frame, with the following columns: date, transaction,
#' quantity, price, fees, total.price, total.quantity, ACB, ACB.share,
#' gains
#' @export
#' @examples
#' data <- data_adjustedcostbase1
#' ACB(data, spot.rate = "price", sup.loss = FALSE)
#' ACB(data, spot.rate = "price")
#' @importFrom dplyr mutate relocate %>% all_of
#' @importFrom rlang .data

ACB <- function(data,
                transaction = "transaction",
                price = "price",
                quantity = "quantity",
                fees = "fees",
                total.price = "total.price",
                spot.rate = "spot.rate",
                as.revenue = c("staking", "interests", "mining"),
                sup.loss = TRUE,
                cl = NULL,
                verbose = TRUE) {
  # Excludes staking, interests, mining

  if (!data[1, transaction] %in% c("buy", "revenue")) {
    stop(
      "The first transaction for this currency cannot be a sale. ",
      "Please make sure you are not missing any transactions."
    )
  }

  if ("currency" %in% names(data)) {
    if (length(unique(data$currency)) > 1) {
      stop(
        "ACB can only work on one currency at a time. ",
        "For multiple coins, use 'format_ACB'."
      )
    }
  }

  # Change total.price of non-taxable revenue sources to 0$
  # Also keep the original total.price information in a "value" row for revenue calculations...
  data <- .prepare_acb_revenue_values(
    data = data,
    total.price = total.price,
    as.revenue = as.revenue
  )
  data <- .ensure_acb_total_price(
    data = data,
    total.price = total.price,
    spot.rate = spot.rate,
    quantity = quantity
  )

  # Handle fees
  data <- .ensure_acb_fees(data, total.price = total.price)

  if (isTRUE(sup.loss)) {
    data <- data %>%
      format_suploss(transaction = transaction, quantity = quantity, cl = cl)

    # Define empty rows for later reuse
    data$gains <- 0
    data$gains.sup <- NA
    data$gains.excess <- NA
    data$gains.uncorrected <- NA
  }

  # Setup progress bar
  currency <- .acb_currency_label(data)

  pb <- progress::progress_bar$new(
    format = paste(
      currency,
      "[:bar] :current/:total (:percent) [Elapsed: :elapsedfull || Remaining: :eta]"
    ),
    total = nrow(data),
    complete = "=", # Completion bar character
    incomplete = "-", # Incomplete bar character
    current = ">", # Current bar character
    clear = FALSE, # If TRUE, clears the bar when finish
    show_after = 0, # Seconds necessary before showing progress bar
    width = 100
  ) # Width of the progress bar

  if (isTRUE(verbose)) {
    pb$tick(0)
  }

  for (i in seq_len(nrow(data))) {
    if (isTRUE(verbose)) {
      # Update progress bar
      pb$tick()
    }

    current_transaction <- data[[transaction]][i]
    is_add_transaction <- .is_acb_add_transaction(current_transaction)
    is_sell_transaction <- identical(current_transaction, "sell")

    # Loop ####

    # First row: add first quantity
    data <- .initialize_acb_quantity(data, i, quantity = quantity)

    if (is_add_transaction) {
      data <- .update_acb_add_row(
        data,
        i,
        quantity = quantity,
        total.price = total.price
      )
    } # Remove fees from total quantity too?? (comment before refactor)

    if (i > 1 && is_sell_transaction) {
      data <- .update_acb_sell_row(data, i, quantity = quantity)
    }

    data <- .update_acb_share(data, i)

    # After first row: calculate capital gains and losses
    if (i > 1 && is_sell_transaction) {
      data <- .update_acb_gains(
        data,
        i,
        total.price = total.price,
        quantity = quantity
      )
    }

    ################################
    ####### Superficial loss #######
    ################################

    if (isTRUE(sup.loss)) {
      # Keep track of uncorrected gains
      data[i, "gains.uncorrected"] <- data[i, "gains"]

      # Change sup.loss to FALSE if the gain is positive!
      if (i > 1 && isTRUE(data[[i, "sup.loss"]])) {
        data[i, "sup.loss"] <- ifelse(data[i, "gains"] >= 0,
          FALSE,
          data[i, "sup.loss"]
        )
      }

      # After first row: calculate superficial capital gains and losses
      if (i > 1 && is_sell_transaction && isTRUE(data[[i, "sup.loss"]])) {
        data[i, "gains.sup"] <- data[i, "gains"] * (min(
          data[i, "quantity.60days"],
          data[i, "sup.loss.quantity"],
          data[i, "share.left60"]
        ) / data[i, "sup.loss.quantity"])
        if (is.na(data[i, "gains.sup"]) && data[i, "sup.loss.quantity"] == 0) {
          data[i, "gains.sup"] <- 0
        }
      }

      # Correct gains.sup for actual gains
      data[i, "gains.sup"] <- ifelse(isTRUE(data[[i, "sup.loss"]]),
        data[i, "gains.sup"],
        0
      )

      # After first row: calculate superficial capital gains and losses for any excess
      if (i > 1 && isTRUE(data[[i, "sup.loss"]]) &&
        data[i, "sup.loss.quantity"] > data[i, "quantity.60days"]) {
        data[i, "gains.excess"] <- data[i, "gains"] - data[i, "gains.sup"]
      }

      # After first row: recalculate ACB for added quantities MINUS sup loss
      if (i > 1 && is_add_transaction) {
        data[i, "ACB"] <- data[i - 1, "ACB"] +
          data[i, total.price] + data[i, fees] - data[i - 1, "gains.sup"]
      }

      # After first row: calculate ACB for removed quantities MINUS sup loss
      if (i > 1 && is_sell_transaction) {
        data[i, "ACB"] <- data[i - 1, "ACB"] *
          ((data[i - 1, "total.quantity"] - data[i, quantity]) /
            data[i - 1, "total.quantity"]) - data[i, "gains.sup"]
      }

      # Calculate ACB per share (total ACB / number of shares)
      data[i, "ACB.share"] <- ifelse(data[i, "ACB"] > 0,
        data[i, "ACB"] / data[i, "total.quantity"],
        0
      )

      data <- .correct_zero_quantity_acb(data, i)
    }
  }

  if (isTRUE(sup.loss)) {
    # Remove "sup gains" when sup.loss is FALSE.
    data <- data %>%
      mutate(
        gains = ifelse(.data$sup.loss == TRUE,
          .data$gains.excess,
          .data$gains
        ),
        gains = ifelse(.data$gains == 0,
          NA,
          .data$gains
        ),
        gains.sup = ifelse(.data$gains.sup == 0,
          NA,
          .data$gains.sup
        )
      ) %>%
      relocate(c(
        "sup.loss", "gains.uncorrected", "gains.sup",
        "gains.excess", "gains"
      ), .before = "ACB")
  }

  data <- as.data.frame(data)

  data
}
