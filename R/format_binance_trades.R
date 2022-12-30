#' @title Format Binance trades file
#'
#' @description Format a .xlsx trades history file from Binance for later ACB processing.
#'
#' Warning: This does NOT process WITHDRAWALS and associated fees. See the format_binance_withdrawals() function for this purpose.
#' @param data The dataframe
#' @keywords money crypto
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
      quantity = "Amount",
      description = "Type",
      comment = "Market",
      date = "Date(UTC)"
    )

  # Add single dates to dataframe
  data <- data %>%
    mutate(date = lubridate::as_datetime(.data$date))
  # UTC confirmed

  # Make relevant columns numeric
  data <- data %>%
    mutate(across(.data$Price:.data$Fee, as.numeric))

  # Separate trade transactions
  data <- data %>%
    rowwise() %>%
    mutate(
      pair.currency1 = paste(strsplit(.data$comment, "")[[1]][1:3], collapse = ""),
      pair.currency2 = paste(strsplit(.data$comment, "")[[1]][4:6], collapse = "")
    )

  # Determine spot rate and value of fees
  data.fees <- data %>%
    mutate(currency = .data$`Fee Coin`)

  data.fees <- cryptoTax::match_prices(data.fees)

  data$fees <- data.fees$Fee * data.fees$spot.rate

  data$rate.source <- data.fees$rate.source

  # Create a "buy" object
  BUY <- data %>%
    filter(.data$description == "BUY") %>%
    mutate(
      transaction = "buy",
      currency = .data$pair.currency1
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
      currency = .data$pair.currency2,
      quantity = .data$Total,
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
      currency = .data$pair.currency1
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
      currency = .data$pair.currency2,
      quantity = .data$Total,
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
