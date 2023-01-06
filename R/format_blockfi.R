#' @title Format BlockFi file
#'
#' @description Format a .csv transaction history file from BlockFi for later ACB processing.
#' @param data The dataframe
#' @export
#' @examples
#' \dontrun{
#' format_blockfi(data)
#' }
#' @importFrom dplyr %>% rename mutate filter select arrange bind_rows
#' @importFrom rlang .data

format_blockfi <- function(data) {
  # Rename columns
  data <- data %>%
    rename(
      quantity = "Amount",
      currency = "Cryptocurrency",
      description = "Transaction.Type",
      date = "Confirmed.At"
    )

  # Add single dates to dataframe
  data <- data %>%
    mutate(date = lubridate::as_datetime(.data$date))
  # UTC confirmed

  # Create a "buy" object
  BUY <- data %>%
    filter(
      .data$description %in% c(
        "purchase_TEMP",
        "Trade"
      ),
      .data$quantity > 0
    ) %>%
    mutate(transaction = "buy") %>%
    select(
      "date", "quantity", "currency",
      "transaction", "description"
    )

  # Create a "earn" object
  EARN <- data %>%
    filter(.data$description %in% c(
      "Interest Payment",
      "Referral Bonus",
      "Bonus Payment"
    )) %>%
    mutate(
      transaction = "revenue",
      revenue.type = replace(
        .data$description,
        .data$description %in% c("Interest Payment"),
        "interests"
      ),
      revenue.type = replace(
        .data$revenue.type,
        .data$revenue.type %in% c("Referral Bonus"),
        "referrals"
      ),
      revenue.type = replace(
        .data$revenue.type,
        .data$revenue.type %in% c("Bonus Payment"),
        "promos"
      )
    ) %>%
    select(
      "date", "quantity", "currency", "transaction",
      "revenue.type", "description"
    )

  # Create a "sell" object
  SELL <- data %>%
    filter(
      .data$description %in% c(
        "sell_TEMP",
        "Trade"
      ),
      .data$quantity < 0
    ) %>%
    mutate(
      transaction = "sell",
      quantity = abs(.data$quantity)
    ) %>%
    select(
      "date", "quantity", "currency",
      "transaction", "description"
    )

  # Merge the "buy" and "sell" objects
  data <- bind_rows(BUY, EARN, SELL) %>%
    mutate(
      fees = 0,
      exchange = "blockfi"
    ) %>%
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
