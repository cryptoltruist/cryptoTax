#' @title Calculate capital gains from realized gain transactions
#'
#' @description Calculate realized and unrealized capital gains/losses
#' @param data The dataframe
#' @param transaction Name of transaction column
#' @param price Name of price column
#' @param quantity Name of quantity column
#' @param fees Name of fees column
#' @param total.price Name of total.price column
#' @param as.revenue Name of as.revenue column
#' @keywords money crypto
#' @export
#' @examples
#' \dontrun{
#' ACB(data)
#' }
#' @importFrom dplyr mutate relocate %>%
#' @importFrom rlang .data

ACB_suploss <- function(data,
                        transaction = "transaction",
                        price = "price",
                        quantity = "quantity",
                        fees = "fees",
                        total.price = "total.price",
                        as.revenue = c("staking", "interest", "mining")) {
  # Excludes staking, interest, mining

  # Setup progress bar
  pb <- progress::progress_bar$new(
    format = paste(
      data$currency2[1],
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

  # List all possible revenue sources
  all.revenue.type <- c(
    "airdrop", "referrals", "promo", "rewards",
    "rebate", "staking", "interest", "mining"
  )

  # List all non-revenue
  not.revenue <- all.revenue.type[!(all.revenue.type %in% as.revenue)]

  # Change total.price of non-revenue sources to 0$
  # Also keep the original total.price information in a "value" row for revenue calculations...
  data <- data %>%
    mutate(
      value = .data$total.price,
      total.price = ifelse(.data$revenue.type %in% not.revenue,
        0,
        .data$total.price
      )
    ) %>%
    relocate("value", .after = "revenue.type")

  # Define empty rows for later reuse
  data["gains"] <- 0
  data["gains.sup"] <- NA
  data["gains.excess"] <- NA
  data["gains.uncorrected"] <- NA
  data$gains.uncorrected <- NA

  for (i in 1:nrow(data)) {
    # Update progress bar
    pb$tick()

    # Set total price if it is missing
    if (missing(total.price)) {
      data[i, total.price] <- data[i, "spot.rate"] * data[i, quantity]
    }

    # First row: add first quantity
    if (i == 1) {
      data[i, "total.quantity"] <- data[i, quantity]
    }

    # First row: calculate ACB for added quantities
    if (i == 1 & (data[i, transaction] == "buy" |
      data[i, transaction] == "revenue" |
      data[i, transaction] == "rebate")) {
      data[i, "ACB"] <- data[i, total.price] + data[i, fees]
    }

    # After first row: add new quantities
    if (i > 1 & (data[i, transaction] == "buy" |
      data[i, transaction] == "revenue" |
      data[i, transaction] == "rebate")) {
      data[i, "total.quantity"] <- data[i - 1, "total.quantity"] + data[i, quantity]
    }

    # After first row: calculate ACB for added quantities
    if (i > 1 & (data[i, transaction] == "buy" |
      data[i, transaction] == "revenue" |
      data[i, transaction] == "rebate")) {
      data[i, "ACB"] <- data[i - 1, "ACB"] +
        data[i, total.price] + data[i, fees]
    }

    # After first row: remove new quantities
    if (i > 1 & data[i, transaction] == "sell") {
      data[i, "total.quantity"] <- data[i - 1, "total.quantity"] - data[i, quantity]
    }

    # After first row: calculate ACB for removed quantities
    if (i > 1 & data[i, transaction] == "sell") {
      data[i, "ACB"] <- data[i - 1, "ACB"] *
        ((data[i - 1, "total.quantity"] - data[i, quantity]) /
          data[i - 1, "total.quantity"])
    }

    # Calculate ACB per share (total ACB / number of shares)
    data[i, "ACB.share"] <- ifelse(data[i, "ACB"] > 0,
      data[i, "ACB"] / data[i, "total.quantity"],
      0
    )

    # After first row: calculate capital gains and losses
    if (i > 1 & data[i, transaction] == "sell") {
      data[i, "gains"] <- data[i, total.price] - data[i, fees] -
        data[i - 1, "ACB.share"] * data[i, quantity]
    }

    # Keep track of uncorrected gains
    data[i, "gains.uncorrected"] <- data[i, "gains"]

    ################################
    ####### Superficial loss #######
    ################################

    # Create a superficial gains only column
    # data[i, "gains.sup"] <- ifelse(data[i, "sup.loss"] == TRUE,
    #                               data[i, "gains"],
    #                               0)

    # Change sup.loss to FALSE if the gain is positive!
    if (i > 1 & data[i, "sup.loss"] == TRUE) {
      data[i, "sup.loss"] <- ifelse(data[i, "gains"] >= 0,
        FALSE,
        data[i, "sup.loss"]
      )
    }

    # After first row: calculate superficial capital gains and losses
    if (i > 1 & data[i, transaction] == "sell" & data[i, "sup.loss"] == TRUE) {
      data[i, "gains.sup"] <- data[i, "gains"] * (min(
        data[i, "quantity.60days"],
        data[i, "sup.loss.quantity"],
        data[i, "share.left60"]
      ) / data[i, "sup.loss.quantity"])
      # data[i, total.price] - data[i, fees] -
      # data[i-1, "ACB.share"] * min(data[i, "quantity.60days"],
      #                             data[i, "sup.loss.quantity"],
      #                             data[i, "share.left60"])
    }

    # Correct gains.sup for actual gains
    data[i, "gains.sup"] <- ifelse(data[i, "sup.loss"] == TRUE,
      data[i, "gains.sup"],
      0
    )

    # After first row: calculate superficial capital gains and losses for any excess
    if (i > 1 & data[i, "sup.loss"] == TRUE & data[i, "sup.loss.quantity"] > data[i, "quantity.60days"]) {
      # data[i, "gains"] <- data[i, total.price] - data[i, fees] -
      # data[i-1, "ACB.share"] * (data[i, "sup.loss.quantity"] - data[i, "quantity.60days"])
      data[i, "gains.excess"] <- data[i, "gains"] - data[i, "gains.sup"]

      # data[i, "gains"] * (data[i, "quantity.60days"] / data[i, "sup.loss.quantity"])
      # right amount for gains (excess, non-superficial capital losses) = gains * (quantity.60days / quantity)
      # right amount for gains.sup = gains - excess capital gains
      # data[i, "gains.sup"] <- data[i, "gains"] - data[i, "gains.excess"]
    }

    # After first row: recalculate ACB for added quantities MINUS sup loss
    if (i > 1 & (data[i, transaction] == "buy" |
      data[i, transaction] == "revenue" |
      data[i, transaction] == "rebate")) {
      data[i, "ACB"] <- data[i - 1, "ACB"] +
        data[i, total.price] + data[i, fees] - data[i - 1, "gains.sup"]
    }

    # After first row: calculate ACB for removed quantities MINUS sup loss
    if (i > 1 & data[i, transaction] == "sell") {
      data[i, "ACB"] <- data[i - 1, "ACB"] *
        ((data[i - 1, "total.quantity"] - data[i, quantity]) /
          data[i - 1, "total.quantity"]) - data[i, "gains.sup"]
    }

    # Calculate ACB per share (total ACB / number of shares)
    data[i, "ACB.share"] <- ifelse(data[i, "ACB"] > 0,
      data[i, "ACB"] / data[i, "total.quantity"],
      0
    )

    # Correct ACB to 0 if quantity is zero!
    data[i, "ACB"] <- ifelse(data[i, "total.quantity"] == 0,
      0,
      data[i, "ACB"]
    )

    # Correct ACB.share to 0 if quantity is zero!
    data[i, "ACB.share"] <- ifelse(data[i, "total.quantity"] == 0,
      0,
      data[i, "ACB.share"]
    )
  }

  # Remove "sup gains" when sup.loss is FALSE.
  data <- data %>%
    mutate(
      gains = ifelse(.data$sup.loss == TRUE,
        .data$gains.excess,
        # gains - gains.sup,
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
      .data$sup.loss, .data$gains.uncorrected, .data$gains.sup,
      .data$gains.excess, .data$gains
    ), .before = .data$ACB)
  # relocate(gains.excess, .after = gains.sup) %>%
  # relocate(gains.uncorrected, .before = gains.sup) %>%
  # relocate(gains, .after = gains.excess)

  data
}

#' @rdname ACB_suploss
ACB <- function(data,
                transaction = "transaction",
                price = "price",
                quantity = "quantity",
                fees = "fees",
                total.price = "total.price",
                as.revenue = c("staking", "interest", "mining")) {
  # Excludes staking, interest, mining

  # Setup progress bar
  pb <- progress::progress_bar$new(
    format = "Formatting ACB [:bar] :current/:total (:percent) [Elapsed: :elapsedfull || Remaining: :eta]",
    total = nrow(data),
    complete = "=", # Completion bar character
    incomplete = "-", # Incomplete bar character
    current = ">", # Current bar character
    clear = FALSE, # If TRUE, clears the bar when finish
    show_after = 0, # Seconds necessary before showing progress bar
    width = 100
  ) # Width of the progress bar

  pb$tick(0)

  # List all possible revenue sources
  all.revenue.type <- c(
    "airdrop", "referrals", "promo", "rewards",
    "rebate", "staking", "interest", "mining"
  )

  # List all non-revenue
  not.revenue <- all.revenue.type[!(all.revenue.type %in% as.revenue)]

  # Change total.price of non-revenue sources to 0$
  # Also keep the original total.price information in a "value" row for revenue calculations...
  data <- data %>%
    mutate(
      value = .data$total.price,
      total.price = ifelse(.data$revenue.type %in% not.revenue,
        0,
        .data$total.price
      )
    ) %>%
    relocate(.data$value, .after = .data$revenue.type)

  for (i in 1:nrow(data)) {
    # Update progress bar
    pb$tick()

    # Set total price if it is missing
    if (missing(total.price)) {
      data[i, total.price] <- data[i, "spot.rate"] * data[i, quantity]
    }

    # First row: add first quantity
    if (i == 1) {
      data[i, "total.quantity"] <- data[i, quantity]
    }

    # After first row: add new quantities
    if (i > 1 & (data[i, transaction] == "buy" |
      data[i, transaction] == "revenue" |
      data[i, transaction] == "rebate")) {
      data[i, "total.quantity"] <- data[i - 1, "total.quantity"] + data[i, quantity]
    }

    # After first row: remove new quantities
    if (i > 1 & data[i, transaction] == "sell") {
      data[i, "total.quantity"] <- data[i - 1, "total.quantity"] - data[i, quantity]
    }

    # First row: calculate ACB for added quantities
    if (i == 1 & (data[i, transaction] == "buy" |
      data[i, transaction] == "revenue" |
      data[i, transaction] == "rebate")) {
      data[i, "ACB"] <- data[i, total.price] + data[i, fees]
    }

    # After first row: calculate ACB for removed quantities
    if (i > 1 & data[i, transaction] == "sell") {
      data[i, "ACB"] <- data[i - 1, "ACB"] *
        ((data[i - 1, "total.quantity"] - data[i, quantity]) /
          data[i - 1, "total.quantity"])
    }

    # After first row: calculate ACB for added quantities
    if (i > 1 & (data[i, transaction] == "buy" |
      data[i, transaction] == "revenue" |
      data[i, transaction] == "rebate")) {
      data[i, "ACB"] <- data[i - 1, "ACB"] +
        data[i, total.price] + data[i, fees]
    }

    # Calculate ACB per share (total ACB / number of shares)
    data[i, "ACB.share"] <- ifelse(data[i, "ACB"] > 0,
      data[i, "ACB"] / data[i, "total.quantity"],
      0
    )

    # After first row: calculate capital gains and losses
    if (i > 1 & data[i, transaction] == "sell") {
      data[i, "gains"] <- data[i, total.price] - data[i, fees] -
        data[i - 1, "ACB.share"] * data[i, quantity]
    }
  }
  data
}
