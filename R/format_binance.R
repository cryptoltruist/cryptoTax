#' @title Format Binance earn file
#'
#' @description Format a .csv earn history file from Binance for later
#' ACB processing.
#' @details To get this file. Download your overall transaction report
#' (this will include your trades, rewards, & "Referral Kickback" rewards).
#' To get this file, connect to your Binance account on desktop, click
#' "Wallet" (top right), "Transaction History", then in the top-right,
#' "Generate all statements". For "Time", choose "Customized" and pick
#' your time frame.
#'
#' Warning: This does NOT process WITHDRAWALS (see the
#' `format_binance_withdrawals()` function for this purpose).
#' @param data The dataframe
#' @export
#' @examples
#' \dontrun{
#' format_binance_earn(data)
#' }
#' @importFrom dplyr %>% rename mutate across select arrange bind_rows desc
#' @importFrom rlang .data

format_binance <- function(data) {
  # Rename columns
  data <- data %>%
    rename(
      currency = "Coin",
      quantity = "Change",
      date = "UTC_Time",
      description = "Operation",
      comment = "Account"
    )

  # Add single dates to dataframe
  data <- data %>%
    mutate(date = lubridate::as_datetime(.data$date))
  # UTC confirmed

  # Remove withdrawals since those are treated separately
  # Because this file does not provide exact withdrawal fees
  # We also don't need deposits
  data <- data %>%
    filter(!.data$description %in% c("Withdraw", "Deposit"))

  # Label buys and sells properly
  data <- data %>%
    mutate(
      transaction = case_when(
        .data$description %in% c(
          "Buy", "Sell", "Fee", "Stablecoins Auto-Conversion"
        ) &
          quantity > 0 ~ "buy",
        .data$description %in% c(
          "Buy", "Sell", "Fee", "Stablecoins Auto-Conversion"
        ) &
          .data$quantity < 0 ~ "sell"
      ),
      quantity = abs(.data$quantity)
    )

  # Determine spot rate and value of coins
  data <- cryptoTax::match_prices(data)

  data <- data %>%
    mutate(
      total.price = ifelse(is.na(.data$total.price),
        .data$quantity * .data$spot.rate,
        .data$total.price
      )
    ) %>%
    arrange(.data$date, desc(.data$total.price))

  # Match buys and sells (because these are coin-to-coin exchanges,
  # total.price of buys should overwrite that of sells)
  BUY <- data %>%
    filter(.data$transaction == "buy")

  SELL <- data %>%
    filter(.data$transaction == "sell") %>%
    filter(.data$description != "Fee") %>%
    mutate(
      total.price = BUY$total.price,
      spot.rate = .data$total.price / .data$quantity
    )

  # Extract fees
  FEES <- data %>%
    filter(.data$description == "Fee")

  # "Stablecoins Auto-Conversion"
  CONVERSIONS <- BUY %>%
    filter(.data$description == "Stablecoins Auto-Conversion")

  BUY <- BUY %>%
    filter(.data$description != "Stablecoins Auto-Conversion") %>%
    mutate(fees = FEES$total.price)

  # Process revenues
  EARN <- data %>%
    filter(grepl("Interest", .data$description) |
      grepl("Referral", .data$description) |
      grepl("Distribution", .data$description)) %>%
    mutate(
      transaction = "revenue",
      revenue.type = case_when(
        grepl("Interest", .data$description) ~ "interests",
        grepl("Referral", .data$description) ~ "rebates",
        grepl("Distribution", .data$description) ~ "airdrops"
      )
    )

  # Merge the "buy" and "sell" objects
  data <- bind_rows(BUY, SELL, EARN, CONVERSIONS) %>%
    mutate(exchange = "binance") %>%
    arrange(date, desc(.data$total.price)) %>%
    select(
      "date", "quantity", "currency", "total.price", "spot.rate", "transaction", 
      "description", "comment", "revenue.type", "rate.source", "exchange"
    )

  # Return result
  data
}
