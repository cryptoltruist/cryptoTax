#' @title Format Newton file
#'
#' @description Format a .csv transaction history file from Newton for later ACB
#' processing. When downloading from Newton, please choose the yearly reports
#' format (the "CoinTracker Version" and "Koinly Version" are not supported
#' at this time). If you have multiple years, that means you might have to
#' merge the two datasets.
#' @param data The dataframe
#' @param filetype Which Newton file format to use, one of c("yearly",
#' "cointracker", or "koinly"). Only "yearly" (default) supported at this time.
#' @return A data frame of exchange transactions, formatted for further processing.
#' @export
#' @examples
#' format_newton(data_newton)
#' @importFrom dplyr %>% rename mutate rowwise filter select bind_rows arrange
#' @importFrom rlang .data

format_newton <- function(data, filetype = "yearly") {
  known.transactions <- c("WITHDRAWN", "TRADE", "DEPOSIT")

  data <- .format_newton_prepare_input(data, known.transactions)
  outputs <- .format_newton_outputs(data)
  .format_newton_finalize(outputs)
}

.format_newton_prepare_input <- function(data, known.transactions) {
  data <- data %>%
    rename(
      description = "Type",
      date = "Date"
    )

  check_new_transactions(data,
    known.transactions = known.transactions,
    transactions.col = "description"
  )

  data %>%
    mutate(
      date = lubridate::mdy_hms(.data$date, tz = "America/New_York"),
      date = lubridate::with_tz(.data$date, tz = "UTC")
    )
}

.format_newton_buy <- function(data) {
  data %>%
    filter(.data$description == "TRADE") %>%
    rename(
      quantity = "Received.Quantity",
      currency = "Received.Currency",
      total.price = "Sent.Quantity"
    ) %>%
    mutate(
      transaction = "buy",
      spot.rate = .data$total.price / .data$quantity
    ) %>%
    select(
      "date", "quantity", "currency", "total.price", "spot.rate",
      "transaction", "description"
    ) %>%
    filter(.data$currency != "CAD")
}

.format_newton_sell <- function(data) {
  data %>%
    filter(.data$description == "TRADE") %>%
    rename(
      quantity = "Sent.Quantity",
      currency = "Sent.Currency",
      total.price = "Received.Quantity"
    ) %>%
    mutate(
      transaction = "sell",
      spot.rate = .data$total.price / .data$quantity
    ) %>%
    select(
      "date", "quantity", "currency", "total.price", "spot.rate",
      "transaction", "description"
    ) %>%
    filter(.data$currency != "CAD")
}

.format_newton_earn <- function(data) {
  earn <- data %>%
    filter(.data$Fee.Amount %in% c("Referral Program")) %>%
    mutate(
      quantity = .data$Received.Quantity,
      currency = .data$Received.Currency,
      total.price = .data$Received.Quantity,
      description = .data$Fee.Amount,
      transaction = "revenue",
      revenue.type = replace(
        .data$description,
        .data$description %in% c("Referral Program"),
        "referrals"
      ),
      spot.rate = ifelse(.data$currency == "CAD", 1, NA)
    ) %>%
    select(
      "date", "quantity", "currency", "total.price", "spot.rate",
      "transaction", "revenue.type", "description"
    )

  earn$description <- as.character(earn$description)
  earn
}

.format_newton_outputs <- function(data) {
  list(
    buy = .format_newton_buy(data),
    sell = .format_newton_sell(data),
    earn = .format_newton_earn(data)
  )
}

#' @noRd
.format_newton_finalize <- function(outputs) {
  .finalize_formatted_exchange(
    outputs$buy,
    outputs$sell,
    outputs$earn,
    exchange = "newton",
    rate_source = "exchange",
    columns = c(
      "date", "currency", "quantity", "total.price", "spot.rate", "transaction",
      "description", "revenue.type", "exchange", "rate.source"
    )
  )
}
