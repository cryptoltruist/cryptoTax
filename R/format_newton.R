#' @title Format Newton file
#'
#' @description Format a .csv transaction history file from Newton for later ACB processing.
#' @param data The dataframe
#' @keywords money crypto
#' @export
#' @examples
#' \dontrun{
#' format_newton(data)
#' }
#' @importFrom dplyr %>% rename mutate rowwise filter select bind_rows arrange
#' @importFrom rlang .data

format_newton <- function(data) {
  # Rename columns
  data <- data %>%
    rename(
      description = "Type",
      date = "Date"
    )

  # Add single dates to dataframe
  data <- data %>%
    mutate(
      date = lubridate::mdy_hms(.data$date, tz = "America/New_York"),
      date = lubridate::with_tz(.data$date, tz = "UTC")
    )
  # UTC confirmed (original time = "America/New_York"))

  # Create a "buy" object
  BUY <- data %>%
    filter(.data$description == "TRADE") %>%
    rename(
      quantity = .data$Received.Quantity,
      currency = .data$Received.Currency,
      total.price = .data$Sent.Quantity
    ) %>%
    mutate(
      transaction = "buy",
      spot.rate = .data$total.price / .data$quantity
    ) %>%
    select(
      "date", "quantity", "currency", "total.price", "spot.rate",
      "transaction", "description"
    ) %>%
    filter(.data$currency != "CAD")

  # Create a "sell" object
  SELL <- data %>%
    filter(.data$description == "TRADE") %>%
    rename(
      quantity = .data$Sent.Quantity,
      currency = .data$Sent.Currency,
      total.price = .data$Received.Quantity
    ) %>%
    mutate(
      transaction = "sell",
      spot.rate = .data$total.price / .data$quantity
    ) %>%
    select(
      "date", "quantity", "currency", "total.price", "spot.rate",
      "transaction", "description"
    ) %>%
    filter(.data$currency != "CAD")

  # Create a "earn" object
  EARN <- data %>%
    filter(.data$Tag %in% c("Referral Program")) %>%
    mutate(
      quantity = .data$Received.Quantity,
      currency = .data$Received.Currency,
      total.price = .data$Received.Quantity,
      description = .data$Tag,
      transaction = "revenue",
      revenue.type = replace(
        .data$description,
        .data$description %in% c("Referral Program"),
        "referrals"
      ),
      spot.rate = ifelse(.data$currency == "CAD", 1, NA)
    ) %>%
    select(
      "date", "quantity", "currency", "total.price", "spot.rate",
      "transaction", "revenue.type", "description"
    )

  # Merge the "buy" and "sell" objects
  data <- bind_rows(BUY, SELL, EARN) %>%
    mutate(
      fees = 0,
      exchange = "newton",
      rate.source = "exchange"
    ) %>%
    arrange(date)

  # Return result
  data
}
