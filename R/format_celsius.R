#' @noRd
.format_celsius_prepare_input <- function(data) {
  data %>%
    rename(
      quantity = "Coin.amount",
      currency = "Coin.type",
      description = "Transaction.type",
      date = "Date.and.time"
    ) %>%
    mutate(date = lubridate::mdy_hm(.data$date))
}

#' @noRd
.format_celsius_add_cad_prices <- function(data, USD2CAD.table = NULL) {
  data.tmp <- data %>%
    cryptoTax::USD2CAD(USD2CAD.table = USD2CAD.table)

  if (is.null(data.tmp)) {
    message("Could not fetch exchange rates from the exchange rate API.")
    return(NULL)
  }

  data.tmp %>%
    mutate(total.price = .data$USD.Value * .data$CAD.rate)
}

#' @noRd
.format_celsius_revenue_type <- function(description) {
  dplyr::case_when(
    description %in% "Reward" ~ "interests",
    description %in% "Referred Award" ~ "referrals",
    description %in% "Promo Code Reward" ~ "promos",
    TRUE ~ description
  )
}

#' @noRd
.format_celsius_earn_rows <- function(data) {
  data %>%
    filter(.data$description %in% c(
      "Referred Award",
      "Reward",
      "Promo Code Reward"
    )) %>%
    mutate(
      transaction = "revenue",
      revenue.type = .format_celsius_revenue_type(.data$description),
      quantity = abs(.data$quantity),
      spot.rate = .data$total.price / .data$quantity
    ) %>%
    select(
      "date", "quantity", "currency", "total.price", "spot.rate",
      "transaction", "revenue.type", "description"
    )
}

#' @noRd
.format_celsius_output <- function(earn) {
  .finalize_formatted_exchange(
    earn,
    exchange = "celsius",
    rate_source = "exchange (USD conversion)",
    columns = c(
      "date", "currency", "quantity", "total.price", "spot.rate", "transaction",
      "description", "revenue.type", "exchange", "rate.source"
    )
  )
}

#' @title Format Celsius file
#'
#' @description Format a .csv transaction history file from Celsius for later ACB processing.
#' @param data The dataframe
#' @param USD2CAD.table Optional explicit USD/CAD rate table to use instead of
#' relying on session cache or network access for USD conversions.
#' @return A data frame of exchange transactions, formatted for further processing.
#' @export
#' @examples
#' format_celsius(data_celsius)
#' @importFrom dplyr %>% rename mutate rowwise filter select arrange
#' @importFrom rlang .data

format_celsius <- function(data, USD2CAD.table = NULL) {
  known.transactions <- c(
    "Reward", "Transfer", "Withdrawal", "Promo Code Reward",
    "Referrer Award", "Referred Award"
  )

  data <- .format_celsius_prepare_input(data)

  # Check if there's any new transactions
  check_new_transactions(data,
    known.transactions = known.transactions,
    transactions.col = "description"
  )

  data <- .format_celsius_add_cad_prices(data, USD2CAD.table = USD2CAD.table)
  if (is.null(data)) {
    return(NULL)
  }

  .format_celsius_output(.format_celsius_earn_rows(data))
}
