#' @title Format Adalite wallet file
#'
#' @description Format a .csv transaction history file from the Adalite wallet for later ACB processing.
#' @param data The dataframe
#' @export
#' @examples
#' \dontrun{
#' format_adalite(data)
#' }
#' @importFrom dplyr %>% rename mutate select filter bind_rows
#' @importFrom rlang .data

format_adalite <- function(data) {
  # Rename columns
  data <- data %>%
    rename(
      quantity = "Received.amount",
      currency = "Received.currency",
      description = "Type",
      date = "Date"
    )

  # Add single dates to dataframe
  data <- data %>%
    mutate(date = lubridate::mdy_hm(.data$date))
  # UTC confirmed

  # Add currency to missing places
  data <- data %>%
    mutate(currency = ifelse(.data$currency == "",
      .data$Sent.currency,
      .data$currency
    ))

  # Create a "earn" object
  EARN <- data %>%
    filter(.data$description %in% c("Reward awarded")) %>%
    mutate(
      transaction = "revenue",
      revenue.type = replace(
        .data$description,
        .data$description %in% c("Reward awarded"),
        "staking"
      )
    ) %>%
    select(
      "date", "quantity", "currency", "transaction",
      "revenue.type", "description"
    )

  # Create a "withdrawals" object
  WITHDRAWALS <- data %>%
    filter(.data$description == "Sent") %>%
    mutate(
      quantity = .data$Fee.amount,
      transaction = "sell",
      comment = "Withdrawal Fee"
    ) %>%
    select(
      "date", "quantity", "currency", "transaction",
      "description", "comment"
    )

  # Merge the "buy" and "sell" objects
  data <- bind_rows(EARN, WITHDRAWALS) %>%
    mutate(
      fees = 0,
      exchange = "adalite"
    ) %>%
    arrange(date)

  # Determine spot rate and value of coins
  data <- cryptoTax::match_prices(data)

  data <- data %>%
    mutate(total.price = ifelse(is.na(.data$total.price),
      .data$quantity * .data$spot.rate,
      .data$total.price
    ))

  # Actually correct network fees sold for zero!
  # data <- data %>%
  #  mutate(total.price = ifelse(description == "Sent",
  #                              0,
  #                              total.price))

  # Return result
  data
}
