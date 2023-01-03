#' @title Format Exodus wallet file
#'
#' @description Format a .csv transaction history file from the Exodus wallet for later ACB processing.
#' @param data The dataframe
#' @keywords money crypto
#' @export
#' @examples
#' \dontrun{
#' format_exodus(data)
#' }
#' @importFrom dplyr %>% rename mutate rowwise filter select bind_rows arrange transmute
#' @importFrom rlang .data

format_exodus <- function(data) {
  # Rename columns
  data <- data %>%
    rename(
      quantity = "INAMOUNT",
      currency = "INCURRENCY",
      description = "TYPE",
      date = "DATE"
    )

  # Add single dates to dataframe
  data <- data %>%
    mutate(date = lubridate::ymd_hms(.data$date))
  # mutate(date = lubridate::mdy_hms(.data$date))
  # UTC confirmed

  # Add currency to missing places
  data <- data %>%
    mutate(currency = ifelse(.data$currency == "",
      .data$OUTCURRENCY,
      .data$currency
    ))

  # Create a "earn" object
  EARN <- data %>%
    filter(
      .data$currency %in% c("XNO"),
      .data$description == "deposit"
    ) %>%
    mutate(
      transaction = "revenue",
      revenue.type = "airdrop"
    ) %>%
    select(
      "date", "quantity", "currency", "transaction",
      "revenue.type", "description"
    )

  # Create a "withdrawals" object
  WITHDRAWALS <- data %>%
    filter(.data$description == "withdrawal") %>%
    mutate(
      quantity = .data$FEEAMOUNT * -1,
      transaction = "sell"
    ) %>%
    select(
      "date", "quantity", "currency", "transaction",
      "description"
    )

  # Create a "staking fees" object
  STAKING.FEES <- data %>%
    filter(.data$description == "deposit" &
      .data$FEEAMOUNT < 0) %>%
    mutate(
      quantity = .data$FEEAMOUNT * -1,
      transaction = "sell",
      description = "Initial staking fee",
      total.price = 0
    ) %>%
    select(
      "date", "quantity", "currency", "total.price", "transaction",
      "description"
    )

  # Merge the "buy" and "sell" objects
  data <- bind_rows(EARN, WITHDRAWALS, STAKING.FEES) %>%
    mutate(
      fees = 0,
      exchange = "exodus"
    ) %>%
    arrange(date)

  # Actually correct network fees sold for zero!
  # data <- data %>%
  #  mutate(total.price = ifelse(description == "withdrawal",
  #                              0,
  #                              total.price))

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
