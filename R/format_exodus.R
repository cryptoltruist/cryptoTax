#' @title Format Exodus wallet file
#'
#' @description Format a .csv transaction history file from the Exodus wallet for later ACB processing.
#' @param data The dataframe
#' @param list.prices An optional explicit `list.prices` object from which to
#' fetch coin prices. For exchanges that require external pricing, it must
#' contain at least `currency`, `spot.rate2`, and `date2`.
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
  data <- .format_exodus_finalize(outputs)

  # Actually correct network fees sold for zero!
  # data <- data %>%
  #  mutate(total.price = ifelse(description == "withdrawal",
  #                              0,
  #                              total.price))

  # Determine spot rate and value of coins
  data <- .resolve_and_fill_formatted_prices(
    data,
    list.prices = list.prices,
    force = force
  )
  if (is.null(data)) {
    return(NULL)
  }

  .finalize_formatted_exchange(
    data,
    exchange = NULL
  )
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
  .format_fee_sell_rows(
    data,
    filter_expr = .data$description == "withdrawal",
    fee_col = "FEEAMOUNT"
  ) %>%
    select(
      "date", "quantity", "currency", "transaction",
      "description"
    )
}

.format_exodus_staking_fees <- function(data) {
  .format_fee_sell_rows(
    data,
    filter_expr = .data$description == "deposit" & .data$FEEAMOUNT < 0,
    fee_col = "FEEAMOUNT",
    description_value = "Initial staking fee",
    total_price_value = 0
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

#' @noRd
.format_exodus_finalize <- function(outputs) {
  .finalize_formatted_exchange(
    outputs$earn,
    outputs$withdrawals,
    outputs$staking.fees,
    exchange = "exodus",
    columns = c(
      "date", "currency", "quantity", "transaction",
      "description", "revenue.type", "exchange"
    )
  )
}
