#' @title Format Uphold file
#'
#' @description Format a .csv transaction history file from Uphold for later ACB processing.
#' @param data The dataframe
#' @param list.prices An optional explicit `list.prices` object from which to
#' fetch coin prices. For exchanges that require external pricing, it must
#' contain at least `currency`, `spot.rate2`, and `date2`.
#' @param force Whether to force recreating `list.prices` even though
#' it already exists (e.g., if you added new coins or new dates).
#' @return A data frame of exchange transactions, formatted for further processing.
#' @export
#' @examples
#' format_uphold(data_uphold)
#' @importFrom dplyr %>% rename mutate rowwise filter select bind_rows arrange
#' @importFrom rlang .data

format_uphold <- function(data, list.prices = NULL, force = FALSE) {
  known.transactions <- c("in", "out", "transfer")

  data <- .format_uphold_prepare_input(data, known.transactions)
  outputs <- .format_uphold_outputs(data)

  # Actually withdrawal fees should be like "selling at zero", so correct total.price
  # WITHDRAWALS <- WITHDRAWALS %>%
  #  mutate(total.price = 0)

  # Merge the "buy" and "sell" objects
  data <- merge_exchanges(
    outputs$buy,
    outputs$earn,
    outputs$sell,
    outputs$withdrawals,
    outputs$brave
  ) %>%
    mutate(exchange = "uphold")

  # Rename transfers as trades for clarity
  data <- data %>%
    mutate(description = ifelse(.data$description == "transfer",
      "trade",
      .data$description
    ))

  # Determine spot rate and value of coins
  data <- .resolve_formatted_prices(
    data,
    list.prices = list.prices,
    force = force
  )
  if (is.null(data)) {
    return(NULL)
  }

  data <- .fill_missing_total_price_from_spot(data)

  data <- .format_uphold_apply_sell_prices(data)

  # Arrange in correct order
  data <- data %>%
    arrange(date, desc(.data$total.price))

  # Reorder columns properly
  data <- data %>%
    select(
      "date", "currency", "quantity", "total.price", "spot.rate", "transaction",
      "description", "comment", "revenue.type", "exchange", "rate.source"
    )

  # Return result
  data
}

.format_uphold_prepare_input <- function(data, known.transactions) {
  data <- data %>%
    rename(
      quantity = "Destination.Amount",
      currency = "Destination.Currency",
      description = "Type",
      date = "Date"
    )

  check_new_transactions(data,
    known.transactions = known.transactions,
    transactions.col = "description"
  )

  data %>%
    mutate(date = lubridate::mdy_hms(.data$date))
}

.format_uphold_buy <- function(data) {
  data %>%
    filter(.data$description %in% c("purchase_TEMP", "transfer")) %>%
    mutate(
      transaction = "buy",
      comment = paste0(.data$Origin.Currency, "-", .data$currency)
    ) %>%
    select(
      "date", "quantity", "currency",
      "transaction", "description", "comment"
    )
}

.format_uphold_earn <- function(data) {
  data %>%
    filter(.data$description %in% c("in")) %>%
    mutate(
      transaction = "revenue",
      revenue.type = replace(
        .data$description,
        .data$description %in% c("in"),
        "airdrops"
      )
    ) %>%
    select(
      "date", "quantity", "currency", "transaction",
      "revenue.type", "description"
    )
}

.format_uphold_sell <- function(data) {
  data %>%
    filter(.data$description %in% c("sell_TEMP", "transfer")) %>%
    mutate(
      transaction = "sell",
      comment = paste0(.data$Origin.Currency, "-", .data$currency),
      quantity = .data$Origin.Amount,
      currency = .data$Origin.Currency
    ) %>%
    select(
      "date", "quantity", "currency",
      "transaction", "description", "comment"
    )
}

.format_uphold_withdrawals <- function(data) {
  data %>%
    filter(.data$description == "out" & .data$Destination != "uphold") %>%
    mutate(
      quantity = .data$Fee.Amount,
      transaction = "sell",
      comment = "withdrawal fees"
    ) %>%
    select(
      "date", "quantity", "currency", "transaction",
      "description", "comment"
    )
}

.format_uphold_brave <- function(data) {
  data %>%
    filter(.data$description == "out" & .data$Destination == "uphold") %>%
    mutate(
      quantity = .data$quantity,
      transaction = "sell",
      comment = "Brave Auto-Contribute"
    ) %>%
    select(
      "date", "quantity", "currency", "transaction",
      "description", "comment"
    )
}

.format_uphold_outputs <- function(data) {
  list(
    buy = .format_uphold_buy(data),
    earn = .format_uphold_earn(data),
    sell = .format_uphold_sell(data),
    withdrawals = .format_uphold_withdrawals(data),
    brave = .format_uphold_brave(data)
  )
}

.format_uphold_apply_sell_prices <- function(data) {
  .reuse_buy_total_prices_for_sells(data)
}
