#' @title Format Binance withdrawal file
#'
#' @description Format a .xlsx withdrawal history file from Binance for later
#' ACB processing.
#' @details To get this file, connect to your Binance account on
#' desktop, click "Wallet" (top right), "Transaction History", then in the
#' "Type" column, choose "Withdraw". Next, click on "Export Withdrawal History"
#' on the right and choose your time frame (you will probably need to choose
#' "Customized"). You are only allowed to choose up to 3 months, so you might
#' have to download more than one file and merge them before using this function.
#'
#' Warning: This does NOT process TRADES See the `format_binance_trades()`
#' function for this purpose.
#' @param data The dataframe
#' @export
#' @examples
#' \dontrun{
#' format_binance_withdrawals(data)
#' }
#' @importFrom dplyr %>% rename mutate across select arrange bind_rows
#' @importFrom rlang .data

format_binance_withdrawals <- function(data) {
  # Rename columns
  data <- data %>%
    rename(
      currency = "Coin",
      quantity = "TransactionFee",
      date = "Date(UTC)"
    )

  # Add single dates to dataframe
  data <- data %>%
    mutate(date = lubridate::as_datetime(.data$date))
  # UTC confirmed

  # Make relevant columns numeric
  data <- data %>%
    mutate(across(.data$Amount:.data$quantity, as.numeric))

  # Determine spot rate and value of coins
  data <- cryptoTax::match_prices(data)

  data <- data %>%
    mutate(total.price = ifelse(is.na(.data$total.price),
      .data$quantity * .data$spot.rate,
      .data$total.price
    ))

  # Actually no need to determine spot rate because network fees are as if sold for 0
  # data <- data %>%
  # mutate(total.price = 0)

  # Create a "sell" object
  SELL <- data %>%
    mutate(
      transaction = "sell",
      currency = .data$currency,
      description = "Withdrawal fees"
    ) %>%
    select(
      "date", "quantity", "currency", "total.price",
      "spot.rate", "transaction", "description", "rate.source"
    )

  # Merge the "buy" and "sell" objects
  data <- bind_rows(SELL) %>%
    mutate(
      fees = 0,
      exchange = "binance"
    ) %>%
    arrange(date)

  # Return result
  data
}
