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

  # Check if there's any new transactions
  check_new_transactions(data,
    known.transactions = known.transactions,
    transactions.col = "Transaction.Type"
  )

  # Rename columns
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

  # Reverse sign of fees
  data$fees <- abs(data$fees)
  outputs <- .format_coinbase_outputs(data)

  # Merge the "buy" and "sell" objects
  data <- merge_exchanges(
    outputs$buy,
    outputs$sell,
    outputs$earn,
    outputs$withdrawals
  ) %>%
    mutate(exchange = "coinbase", rate.source = "exchange") %>%
    arrange(date, desc(.data$transaction))

  # Reorder columns properly
  data <- data %>%
    select(
      "date", "currency", "quantity", "total.price", "spot.rate", "transaction",
      "fees", "description", "comment", "revenue.type", "exchange", "rate.source"
    )

  # Return result
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
      spot.rate = .data$total.price / .data$quantity
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
