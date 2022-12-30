#' @title Format custom Binance Smart Chain file
#'
#' @description Format a custom .csv transaction history file from the Binance Smart Chain wallet for later ACB processing.
#' @param data The dataframe
#' @keywords money crypto
#' @export
#' @examples
#' \dontrun{
#' format_BSC(data)
#' }
#' @importFrom dplyr %>% mutate filter select arrange
#' @importFrom rlang .data

format_BSC <- function(data) {
  # Add single dates to dataframe
  data <- data %>%
    mutate(date = lubridate::with_tz(.data$date, tz = "UTC"))
  # UTC confirmed

  # Convert USD value to CAD
  data <- data %>%
    cryptoTax::USD2CAD() %>%
    mutate(
      spot.rate = .data$CAD.rate * .data$spot.rate.USD,
      total.price = .data$quantity * .data$spot.rate
    )

  # Create a "earn" object
  EARN <- data %>%
    filter(.data$currency %in% c("GB")) %>%
    mutate(
      transaction = "revenue",
      revenue.type = "airdrop"
    ) %>%
    select(
      "date", "quantity", "currency", "spot.rate", "total.price",
      "transaction", "revenue.type"
    )

  # Merge the "buy" and "sell" objects
  data <- EARN %>%
    mutate(
      fees = 0,
      exchange = "binance",
      rate.source = "exchange"
    ) %>%
    arrange(date)

  # Return result
  data
}
