#' @title Format Binance trades file
#'
#' @description Format a .xlsx trades history file from Binance for later
#' ACB processing.
#' @details To get this file, connect to your Binance account on
#' desktop, click "Orders" (top right), "Spot Order", then in the
#' "Spot Order" submenu, choose "Trade History". Next, click on "Export Trade
#' History" and choose your time frame (you will probably need to choose
#' "Beyond 6 months - Custom"). You are in this case allowed one year of
#' transactions. If you have more, you might have to download more than one
#' file and merge them before using this function.
#'
#' Warning: This does NOT process WITHDRAWALS and associated fees. See the
#' `format_binance_withdrawals()` function for this purpose.
#' @param data The dataframe
#' @export
#' @examples
#' \dontrun{
#' format_binance_trades(data)
#' }
#' @importFrom dplyr %>% rename mutate rowwise select filter bind_rows mutate_at
#' @importFrom rlang .data

format_binance_trades <- function(data) {
  # Rename columns
  data <- data %>%
    rename(
      description = "Side",
      comment = "Pair",
      date = "Date.UTC.",
    )

  # Add single dates to dataframe
  data <- data %>%
    mutate(date = lubridate::as_datetime(.data$date))
  # UTC confirmed

  # Split trading fees to a separate column
  data <- data %>%
    mutate(
      Executed = gsub(",", "", .data$Executed),
      Amount = gsub(",", "", .data$Amount)
    ) %>%
    tidyr::extract(
      col = "Executed", into = c("quantity.pair1", "currency.pair1"),
      regex = "^([0-9.]+)(\\D+)", convert = TRUE
    ) %>%
    tidyr::extract(
      col = "Amount", into = c("quantity.pair2", "currency.pair2"),
      regex = "^([0-9.]+)(\\D+)", convert = TRUE
    ) %>%
    tidyr::extract(
      col = "Fee", into = c("Fee", "fee.currency"),
      regex = "^([0-9.]+)(\\D+)", convert = TRUE
    )

  # Determine spot rate and value of fees
  data.fees <- data %>%
    mutate(currency = .data$fee.currency)

  data.fees <- cryptoTax::match_prices(data.fees)

  data$fees <- data.fees$Fee * data.fees$spot.rate

  data$rate.source <- data.fees$rate.source

  # Create a "buy" object
  BUY <- data %>%
    filter(.data$description == "BUY") %>%
    mutate(
      transaction = "buy",
      quantity = .data$quantity.pair1,
      currency = .data$currency.pair1
    ) %>%
    select(
      "date", "quantity", "currency", "transaction",
      "description", "comment", "fees", "rate.source"
    )

  # Create a second "buy" object for sell trades
  BUY2 <- data %>%
    filter(.data$description == "BUY") %>%
    mutate(
      transaction = "sell",
      currency = .data$currency.pair2,
      quantity = .data$quantity.pair2,
      description = "SELL"
    ) %>%
    select(
      "date", "quantity", "currency", "transaction",
      "description", "comment", "rate.source"
    )

  # Create a "sell" object
  SELL <- data %>%
    filter(.data$description == "SELL") %>%
    mutate(
      transaction = "sell",
      quantity = .data$quantity.pair1,
      currency = .data$currency.pair1
    ) %>%
    select(
      "date", "quantity", "currency", "transaction",
      "description", "comment", "fees", "rate.source"
    )

  # Create a second "sell" object
  SELL2 <- data %>%
    filter(.data$description == "SELL") %>%
    mutate(
      transaction = "buy",
      quantity = .data$quantity.pair2,
      currency = .data$currency.pair2,
      description = "BUY"
    ) %>%
    select(
      "date", "quantity", "currency", "transaction",
      "description", "comment", "rate.source"
    )

  # Merge the "buy" and "sell" objects
  data <- bind_rows(BUY, BUY2, SELL, SELL2) %>%
    mutate(exchange = "binance") %>%
    arrange(date)

  # Determine spot rate and value of coins
  data <- cryptoTax::match_prices(data)

  data <- data %>%
    mutate(total.price = ifelse(is.na(.data$total.price),
      .data$quantity * .data$spot.rate,
      .data$total.price
    ))

  # Return result
  data
}
