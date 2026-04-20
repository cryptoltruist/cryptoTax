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
    # Supported fee contracts:
    # - separate acquisition fees: total.price excludes fees, so add fees here
    # - fee-inclusive acquisition totals: formatter must zero fees beforehand
    # - fee-in-kind / withdrawal fees as separate sell rows: handled elsewhere
    data[i, "ACB"] <- data[i, total.price] + data[i, "fees"]
    return(data)
  }

  data[i, "total.quantity"] <- data[i - 1, "total.quantity"] + data[i, quantity]
  # See supported fee contracts above. ACB() assumes non-zero fees are separate
  # from acquisition total.price; fee-inclusive acquisitions must already have
  # fees zeroed by the formatter contract.
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

.superficial_loss_denied_quantity <- function(data, i) {
  denied.quantity <- min(
    as.numeric(data[i, "quantity.60days"]),
    as.numeric(data[i, "sup.loss.quantity"]),
    as.numeric(data[i, "share.left60"]),
    na.rm = TRUE
  )

  if (!is.finite(denied.quantity)) {
    return(0)
  }

  denied.quantity
}

.acb_scalar <- function(data, i, column) {
  data[[column]][[i]]
}

.set_acb_scalar <- function(data, i, column, value) {
  data[[column]][[i]] <- value
  data
}

.acb_prior_sup_loss_carry <- function(data, i, transaction) {
  if (i <= 1) {
    return(0)
  }

  previous_transaction <- data[[transaction]][[i - 1]]
  previous_sup_loss <- isTRUE(.acb_scalar(data, i - 1, "sup.loss"))
  previous_quantity <- as.numeric(.acb_scalar(data, i - 1, "total.quantity"))

  if (!identical(previous_transaction, "sell") ||
    !previous_sup_loss ||
    !identical(previous_quantity, 0)) {
    return(0)
  }

  previous_gains_sup <- .acb_scalar(data, i - 1, "gains.sup")

  if (is.na(previous_gains_sup)) {
    return(0)
  }

  previous_gains_sup
}

#' @title Calculate capital gains from realized gain transactions
#'
#' @description Calculate realized and unrealized capital gains/losses
#' @details The current superficial-loss implementation is scoped to the
#' transaction history supplied for a single taxpayer-facing asset pool. It is
#' intended to handle same-pool replacement-property timing and ACB adjustments.
#' Different `currency` values are treated as different property pools by
#' default. The function does not independently model affiliated-person
#' acquisitions or make legal judgments about whether two different crypto
#' instruments should be treated as "identical property". Cases involving
#' spouses, corporations, trusts, wrapped assets, liquid staking derivatives,
#' bridge assets, exchange-specific wrappers, or other substitute-property edge
#' cases should still be reviewed carefully. More broadly, [ACB()] implements a
#' capital-account style cost-base and disposition workflow; it does not decide
#' whether a user's facts should instead be reported on income account as
#' business income. In particular, a result based on one supplied ledger should
#' not be read as proof that no affiliated-person superficial-loss issue exists;
#' the function only evaluates the transaction history you provide.
#'
#' Fee handling assumes one of three normalized contracts:
#'
#' - acquisition/disposition rows with a separate `fees` column, where
#'   `total.price` excludes those fees;
#' - fee-inclusive acquisition totals, where the formatter has already zeroed
#'   the separate `fees` field to avoid double-counting; or
#' - fee-in-kind / withdrawal fees represented as their own disposition rows
#'   instead of a `fees` column attached to another transaction.
#'
#' If a raw import mixes fee-inclusive `total.price` values with non-zero
#' attached `fees` on the same acquisition row, that ambiguity should be
#' resolved in the formatter/import step before calling [ACB()].
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

  if (isTRUE(verbose)) {
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
    }

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
      data <- .set_acb_scalar(
        data,
        i,
        "gains.uncorrected",
        .acb_scalar(data, i, "gains")
      )

      # Change sup.loss to FALSE if the gain is positive!
      if (i > 1 && isTRUE(.acb_scalar(data, i, "sup.loss"))) {
        if (.acb_scalar(data, i, "gains") >= 0) {
          data <- .set_acb_scalar(data, i, "sup.loss", FALSE)
        }
      }

      # After first row: calculate superficial capital gains and losses
      if (i > 1 && is_sell_transaction && isTRUE(.acb_scalar(data, i, "sup.loss"))) {
        denied.quantity <- .superficial_loss_denied_quantity(data, i)

        if (denied.quantity <= 0) {
          data <- .set_acb_scalar(data, i, "sup.loss", FALSE)
          data <- .set_acb_scalar(data, i, "gains.sup", 0)
        } else {
          data <- .set_acb_scalar(
            data,
            i,
            "gains.sup",
            .acb_scalar(data, i, "gains") *
              (denied.quantity / .acb_scalar(data, i, "sup.loss.quantity"))
          )
        }
      }

      # Correct gains.sup for actual gains
      if (isTRUE(.acb_scalar(data, i, "sup.loss"))) {
        data <- .set_acb_scalar(data, i, "gains.sup", .acb_scalar(data, i, "gains.sup"))
      } else {
        data <- .set_acb_scalar(data, i, "gains.sup", 0)
      }

      # Preserve the deductible remainder whenever only part of the loss is superficial.
      if (i > 1 && isTRUE(.acb_scalar(data, i, "sup.loss")) &&
        !is.na(.acb_scalar(data, i, "gains.sup"))) {
        data <- .set_acb_scalar(
          data,
          i,
          "gains.excess",
          .acb_scalar(data, i, "gains") - .acb_scalar(data, i, "gains.sup")
        )
      }

      # After first row: recalculate ACB for added quantities MINUS sup loss
      if (i > 1 && is_add_transaction) {
        prior_sup_loss_carry <- .acb_prior_sup_loss_carry(
          data,
          i,
          transaction = transaction
        )

        data[i, "ACB"] <- data[i - 1, "ACB"] +
          data[i, total.price] + data[i, fees] - prior_sup_loss_carry
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
        gains.excess = ifelse(.data$gains.excess == 0,
          NA,
          .data$gains.excess
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
