#' @title Format Coinbase file
#'
#' @description Format a .csv transaction history file from Coinbase for later ACB
#' processing.
#' @param data The dataframe
#' @return A data frame of exchange transactions, formatted for further processing.
#' @export
#' @examples
#' format_coinbase(data_coinbase)
#' @importFrom dplyr %>% rename mutate rowwise filter select bind_rows arrange case_when case_match desc
#' @importFrom rlang .data

format_coinbase <- function(data) {
  known.transactions <- c("Send", "Convert", "Receive")

  data <- .format_coinbase_prepare_input(data, known.transactions)
  outputs <- .format_coinbase_outputs(data)
  .format_coinbase_finalize(outputs)
}

#' @noRd
.format_coinbase_prepare_input <- function(data, known.transactions) {
  check_new_transactions(data,
    known.transactions = known.transactions,
    transactions.col = "Transaction.Type"
  )

  data <- format_generic(
    data,
    date = "Timestamp",
    currency = "Asset",
    quantity = "Quantity.Transacted",
    total.price = "Total..inclusive.of.fees.and.or.spread.",
    spot.rate = "Spot.Price.at.Transaction",
    fees = "Fees.and.or.Spread",
    description = "Transaction.Type",
    comment = "Notes"
  )

  data$fees <- abs(data$fees)
  data
}

.format_coinbase_sell <- function(data) {
  # For consistency with other functions, the fee is on the buy not the sell
  data %>%
    filter(.data$description == "Convert") %>%
    mutate(
      transaction = "sell",
      fees = 0
    )
}

.format_coinbase_buy <- function(data) {
  data %>%
    filter(.data$description == "Convert") %>%
    mutate(
      transaction = "buy",
      currency = stringr::word(.data$comment, -1),
      quantity = as.numeric(stringr::word(.data$comment, -2)),
      spot.rate = .data$total.price / .data$quantity,
      # Coinbase reports this total as inclusive of fees/spread, so leaving the
      # fee here would double-count it later in ACB().
      fees = 0
    )
}

.format_coinbase_earn <- function(data) {
  data %>%
    filter(grepl("from Celsius Network LLC", .data$comment)) %>%
    mutate(
      transaction = "revenue",
      description = "bankruptcy distribution",
      revenue.type = "interest"
    )
}

.format_coinbase_withdrawals <- function(data) {
  data %>%
    filter(.data$description == "Send") %>%
    mutate(
      quantity = .data$fees,
      total.price = .data$quantity * .data$spot.rate,
      transaction = "sell",
      fees = 0
    )
}

.format_coinbase_outputs <- function(data) {
  list(
    buy = .format_coinbase_buy(data),
    sell = .format_coinbase_sell(data),
    earn = .format_coinbase_earn(data),
    withdrawals = .format_coinbase_withdrawals(data)
  )
}

#' @noRd
.format_coinbase_finalize <- function(outputs) {
  .finalize_formatted_exchange(
    outputs$buy,
    outputs$sell,
    outputs$earn,
    outputs$withdrawals,
    exchange = "coinbase",
    rate_source = "exchange",
    columns = c(
      "date", "currency", "quantity", "total.price", "spot.rate", "transaction",
      "fees", "description", "comment", "revenue.type", "exchange", "rate.source"
    )
  ) %>%
    arrange(date, desc(.data$transaction))
}
