#' @title Format BlockFi file
#'
#' @description Format a .csv transaction history file from BlockFi for later ACB processing.
#' @param data The dataframe
#' @param list.prices An optional explicit `list.prices` object from which to
#' fetch coin prices. For exchanges that require external pricing, it must
#' contain at least `currency`, `spot.rate2`, and `date2`.
#' @param force Whether to force recreating `list.prices` even though
#' it already exists (e.g., if you added new coins or new dates).
#' @return A data frame of exchange transactions, formatted for further processing.
#' @export
#' @examples
#' format_blockfi(data_blockfi)
#' @importFrom dplyr %>% rename mutate filter select arrange bind_rows
#' @importFrom rlang .data

format_blockfi <- function(data, list.prices = NULL, force = FALSE) {
  known.transactions <- c(
    "Withdrawal", "Withdrawal Fee", "BIA Withdraw", "BIA Deposit", "Interest Payment",
    "Crypto Transfer", "Trade", "Bonus Payment", "Referral Bonus"
  )

  data <- .format_blockfi_prepare_input(data, known.transactions)
  outputs <- .format_blockfi_outputs(data)

  # Merge the "buy" and "sell" objects
  data <- merge_exchanges(
    outputs$buy,
    outputs$earn,
    outputs$sell,
    outputs$withdrawals
  ) %>%
    mutate(exchange = "blockfi")

  # Determine spot rate and value of coins
  data <- .resolve_formatted_prices(
    data,
    list.prices = list.prices,
    force = force,
    warn_on_missing_spot = TRUE
  )
  if (is.null(data)) {
    return(NULL)
  }

  data <- .fill_missing_total_price_from_spot(data)

  data <- .format_blockfi_apply_sell_prices(data)

  # Arrange in correct order
  data <- data %>%
    arrange(date, desc(.data$total.price))

  # Reorder columns properly
  data <- data %>%
    select(
      "date", "currency", "quantity", "total.price", "spot.rate", "transaction",
      "description", "revenue.type", "exchange", "rate.source"
    )

  # Return result
  data
}

.format_blockfi_prepare_input <- function(data, known.transactions) {
  data <- data %>%
    rename(
      quantity = "Amount",
      currency = "Cryptocurrency",
      description = "Transaction.Type",
      date = "Confirmed.At"
    )

  check_new_transactions(data,
    known.transactions = known.transactions,
    transactions.col = "description"
  )

  data %>%
    mutate(date = lubridate::as_datetime(.data$date))
}

.format_blockfi_buy <- function(data) {
  data %>%
    filter(
      .data$description %in% c("purchase_TEMP", "Trade"),
      .data$quantity > 0
    ) %>%
    mutate(transaction = "buy") %>%
    select(
      "date", "quantity", "currency",
      "transaction", "description"
    )
}

.format_blockfi_earn <- function(data) {
  data %>%
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
}

.format_blockfi_sell <- function(data) {
  data %>%
    filter(
      .data$description %in% c("sell_TEMP", "Trade"),
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
}

.format_blockfi_withdrawals <- function(data) {
  data %>%
    filter(.data$description == "Withdrawal Fee") %>%
    mutate(
      quantity = abs(.data$quantity),
      transaction = "sell"
    ) %>%
    select(
      "date", "quantity", "currency", "transaction",
      "description"
    )
}

.format_blockfi_outputs <- function(data) {
  list(
    buy = .format_blockfi_buy(data),
    earn = .format_blockfi_earn(data),
    sell = .format_blockfi_sell(data),
    withdrawals = .format_blockfi_withdrawals(data)
  )
}

.format_blockfi_apply_sell_prices <- function(data) {
  .reuse_buy_total_prices_for_sells(data)
}
