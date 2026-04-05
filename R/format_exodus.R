#' @title Format Exodus wallet file
#'
#' @description Format a .csv transaction history file from the Exodus wallet for later ACB processing.
#' @param data The dataframe
#' @param list.prices A `list.prices` object from which to fetch coin prices.
#' @param force Whether to force recreating `list.prices` even though
#' it already exists (e.g., if you added new coins or new dates).
#' @return A data frame of exchange transactions, formatted for further processing.
#' @export
#' @examples
#' \donttest{
#' format_exodus(data_exodus)
#' }
#' @importFrom dplyr %>% rename mutate rowwise filter select bind_rows arrange transmute
#' @importFrom rlang .data

format_exodus <- function(data, list.prices = NULL, force = FALSE) {
  known.transactions <- c("deposit", "withdrawal")

  data <- .format_exodus_prepare_input(data, known.transactions)
  outputs <- .format_exodus_outputs(data)

  # Merge the "buy" and "sell" objects
  data <- merge_exchanges(outputs$earn, outputs$withdrawals, outputs$staking.fees) %>%
    mutate(exchange = "exodus")

  # Actually correct network fees sold for zero!
  # data <- data %>%
  #  mutate(total.price = ifelse(description == "withdrawal",
  #                              0,
  #                              total.price))

  # Determine spot rate and value of coins
  data <- match_prices(data, list.prices = list.prices, force = force)

  if (is.null(data)) {
    message("Could not reach the CoinMarketCap API at this time")
    return(NULL)
  }

  data <- data %>%
    mutate(total.price = ifelse(is.na(.data$total.price),
      .data$quantity * .data$spot.rate,
      .data$total.price
    ))

  # Reorder columns properly
  data <- data %>%
    select(
      "date", "currency", "quantity", "total.price", "spot.rate", "transaction",
      "description", "revenue.type", "exchange", "rate.source"
    )

  # Return result
  data
}

.format_exodus_prepare_input <- function(data, known.transactions) {
  data <- data %>%
    rename(
      quantity = "INAMOUNT",
      currency = "INCURRENCY",
      description = "TYPE",
      date = "DATE"
    )

  check_new_transactions(data,
    known.transactions = known.transactions,
    transactions.col = "description"
  )

  data %>%
    mutate(
      date = lubridate::ymd_hms(.data$date),
      currency = ifelse(.data$currency == "", .data$OUTCURRENCY, .data$currency)
    )
}

.format_exodus_earn <- function(data) {
  data %>%
    filter(
      .data$currency %in% c("XNO"),
      .data$description == "deposit"
    ) %>%
    mutate(
      transaction = "revenue",
      revenue.type = "airdrops"
    ) %>%
    select(
      "date", "quantity", "currency", "transaction",
      "revenue.type", "description"
    )
}

.format_exodus_withdrawals <- function(data) {
  data %>%
    filter(.data$description == "withdrawal") %>%
    mutate(
      quantity = .data$FEEAMOUNT * -1,
      transaction = "sell"
    ) %>%
    select(
      "date", "quantity", "currency", "transaction",
      "description"
    )
}

.format_exodus_staking_fees <- function(data) {
  data %>%
    filter(.data$description == "deposit" & .data$FEEAMOUNT < 0) %>%
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
}

.format_exodus_outputs <- function(data) {
  list(
    earn = .format_exodus_earn(data),
    withdrawals = .format_exodus_withdrawals(data),
    staking.fees = .format_exodus_staking_fees(data)
  )
}
