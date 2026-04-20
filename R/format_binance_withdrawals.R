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
#' @param list.prices An optional explicit `list.prices` object from which to
#' fetch coin prices. For exchanges that require external pricing, it must
#' contain at least `currency`, `spot.rate2`, and `date2`.
#' @param force Whether to force recreating `list.prices` even though
#' it already exists (e.g., if you added new coins or new dates).
#' @return A data frame of exchange transactions, formatted for further processing.
#' @export
#' @examples
#' format_binance_withdrawals(data_binance_withdrawals)
#' @importFrom dplyr %>% rename mutate across select arrange bind_rows
#' @importFrom rlang .data

format_binance_withdrawals <- function(data, list.prices = NULL, force = FALSE) {
  # There are no transaction types at all for this file type

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
    mutate(across("Amount":"quantity", as.numeric))

  data <- .resolve_and_fill_formatted_prices(
    data,
    list.prices = list.prices,
    force = force,
    warn_on_missing_spot = TRUE
  )
  if (is.null(data)) {
    return(NULL)
  }

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

  .finalize_formatted_exchange(
    SELL,
    exchange = "binance"
  )
}
