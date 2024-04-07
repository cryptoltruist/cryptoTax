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
                         transactions.col = "Transaction.Type")
  
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
  
  # Create a "sell" object
  # For consistency with other functions, the fee is on the buy not the sell
  SELL <- data %>%
    filter(.data$description == "Convert") %>%
    mutate(transaction = "sell",
           fees = 0)
  
  # Create a "buy" object
  BUY <- data %>%
    filter(.data$description == "Convert") %>%
    mutate(transaction = "buy",
           currency = stringr::word(comment, -1),
           quantity = as.numeric(stringr::word(comment, -2)),
           spot.rate = .data$total.price / .data$quantity)
  
  # Create a "earn" object
  EARN <- data %>%
    filter(grepl("from Celsius Network LLC", .data$comment)) %>% 
    mutate(transaction = "revenue",
           revenue.type = "bankruptcy distribution")
      
  # Create a "withdrawals" object
  WITHDRAWALS <- data %>%
    filter(description == "Send") %>%
    mutate(
      quantity = .data$fees,
      total.price = .data$quantity * .data$spot.rate,
      transaction = "sell",
      fees = 0)
  
  # Merge the "buy" and "sell" objects
  data <- merge_exchanges(BUY, SELL, EARN, WITHDRAWALS) %>%
    mutate(exchange = "Coinbase", rate.source = "exchange") %>% 
    arrange(date, desc(.data$transaction))
  
  # Reorder columns properly
  data <- data %>%
    select(
      "date", "currency", "quantity", "total.price", "spot.rate", "transaction", 
      "fees", "comment", "revenue.type", "exchange", "rate.source"
    )
  
  # Return result
  data
}