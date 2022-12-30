#' @title Format CDC exchange file (FOR TRADES ONLY)
#'
#' @description Format a .csv transaction history file from the Crypto.com exchange for later ACB processing. Only processes trades, not rewards (see `format_CDC_exchange_rewards` for this).
#'
#' Original file name of the right file from the exchange is called "SPOT_TRADE.csv", make sure you have the right one.
#'
#' @param data The dataframe
#' @keywords money crypto
#' @export
#' @examples
#' \dontrun{
#' format_CDC_exchange_trades(data)
#' }
#' @importFrom dplyr %>% rename mutate case_when filter select arrange bind_rows mutate_at
#' @importFrom rlang .data

format_CDC_exchange_trades <- function(data) {
  # Rename columns
  data <- data %>%
    rename(
      quantity = "Trade.Amount",
      description = "Side",
      comment = "Symbol",
      date = "Time..UTC."
    )

  # Add single dates to dataframe
  data <- data %>%
    mutate(date = lubridate::as_datetime(.data$date))
  # UTC confirmed

  # Separate trade transactions
  data <- data %>%
    mutate(
      pair.currency1 = gsub("_.*", "", .data$comment),
      pair.currency2 = gsub(".*_", "", .data$comment)
    )

  # Determine if fees were paid in a third currency or not
  data <- data %>%
    mutate(
      third.currency =
        case_when(
          description == "BUY" ~ .data$Fee.Currency != .data$pair.currency1,
          description == "SELL" ~ .data$Fee.Currency != .data$pair.currency2
        )
    )

  # Determine spot rate and value of fees
  data.fees <- data %>%
    mutate(currency = .data$Fee.Currency)

  data.fees <- cryptoTax::match_prices(data.fees)

  data$fees <- data.fees$Fee * data.fees$spot.rate

  # Create a "buy" object
  BUY <- data %>%
    filter(.data$description == "BUY") %>%
    mutate(
      transaction = "buy",
      currency = .data$pair.currency1
    ) %>%
    select(
      "date", "quantity", "currency", "transaction",
      "description", "comment", "fees"
    )

  # Create a second "buy" object for sell trades
  BUY2 <- data %>%
    filter(.data$description == "BUY") %>%
    mutate(
      transaction = "sell",
      currency = .data$pair.currency2,
      quantity = .data$Volume.of.Business,
      description = "SELL"
    ) %>%
    select(
      "date", "quantity", "currency", "transaction",
      "description", "comment"
    )

  # Create a "sell" object
  SELL <- data %>%
    filter(.data$description == "SELL") %>%
    mutate(
      transaction = "sell",
      currency = .data$pair.currency1
    ) %>%
    select(
      "date", "quantity", "currency", "transaction",
      "description", "comment", "fees"
    )

  # Create a second "sell" object
  SELL2 <- data %>%
    filter(.data$description == "SELL") %>%
    mutate(
      transaction = "buy",
      currency = .data$pair.currency2,
      quantity = .data$Volume.of.Business,
      description = "BUY"
    ) %>%
    select(
      "date", "quantity", "currency", "transaction",
      "description", "comment"
    )

  # Create a third "sell" object for third currencies...
  SELL3 <- data %>%
    filter(.data$third.currency == "TRUE") %>%
    mutate(
      transaction = "sell",
      currency = .data$Fee.Currency,
      quantity = .data$Fee,
      total.price = .data$fees,
      description = "Trading fee paid with CRO"
    ) %>%
    select(
      "date", "quantity", "currency", "total.price", "transaction",
      "description", "comment"
    )

  SELL3 <- data.fees %>%
    filter(.data$third.currency == "TRUE") %>%
    select(.data$spot.rate, .data$rate.source) %>%
    cbind(SELL3)

  # Merge the "buy" and "sell" objects
  data <- bind_rows(BUY, BUY2, SELL, SELL2, SELL3) %>%
    mutate(exchange = "CDC.exchange") %>%
    arrange(date)

  # Replace NAs with zeros (for the fees column)
  data <- data %>%
    mutate_at("fees", ~ replace(., is.na(.), 0))

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
