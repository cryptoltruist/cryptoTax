#' @title Format Gemini file
#'
#' @description Format a .csv transaction history file from Gemini for later ACB processing.
#' Open the xlsx data file using `readxl::read_excel()`.
#' @param data The dataframe
#' @param list.prices An optional explicit `list.prices` object from which to
#' fetch coin prices. For exchanges that require external pricing, it must
#' contain at least `currency`, `spot.rate2`, and `date2`.
#' @param force Whether to force recreating `list.prices` even though
#' it already exists (e.g., if you added new coins or new dates).
#' @return A data frame of exchange transactions, formatted for further processing.
#' @export
#' @examples
#' format_gemini(data_gemini)
#' @importFrom dplyr %>% slice rename mutate rowwise filter select bind_rows
#' arrange transmute n contains full_join
#' @importFrom rlang .data

format_gemini <- function(data, list.prices = NULL, force = FALSE) {
  known.transactions <- c("Credit", "Sell", "Buy", "Debit")

  data <- .format_gemini_prepare_input(data, known.transactions)

  # Pivot from wide to long
  amount <- data %>%
    select("date", "description":"comment", contains("Amount")) %>%
    mutate(nrow = 1:n()) %>%
    tidyr::pivot_longer(-c("nrow", "date", "description":"comment"),
      names_to = "currency",
      values_to = "value",
      values_drop_na = FALSE
    ) %>%
    tidyr::separate(.data$currency, c(NA, "Type", "currency")) %>%
    tidyr::pivot_wider(
      names_from = "Type",
      values_from = "value"
    )

  fee <- data %>%
    select("date", "description":"comment", contains("Fee (")) %>%
    mutate(nrow = 1:n()) %>%
    tidyr::pivot_longer(-c("nrow", "date", "description":"comment"),
      names_to = "currency",
      values_to = "value",
      values_drop_na = FALSE
    ) %>%
    tidyr::separate(.data$currency, c("Type", NA, "currency")) %>%
    tidyr::pivot_wider(
      names_from = "Type",
      values_from = "value"
    )
  
  fee <- .format_gemini_fee_prices(fee, list.prices = list.prices, force = force)

  if (is.null(fee)) {
    return(NULL)
  }

  # Rename Fee column and make it positive.
  fee <- fee %>%
    mutate(fees.quantity = abs(.data$Fee), 
           fees = .data$fees.quantity * .data$spot.rate,
           fees.currency = .data$currency)

  balance <- data %>%
    select("date", "description":"comment", contains("Balance")) %>%
    mutate(nrow = 1:n()) %>%
    tidyr::pivot_longer(-c("nrow", "date", "description":"comment"),
      names_to = "currency",
      values_to = "value",
      values_drop_na = FALSE
    ) %>%
    tidyr::separate(.data$currency, c(NA, "Type", "currency")) %>%
    tidyr::pivot_wider(
      names_from = "Type",
      values_from = "value"
    )

  full <- Reduce(
    function(dtf1, dtf2) {
      full_join(
        dtf1, dtf2,
        by = c(
          "date", "currency", "description",
          "Symbol", "comment", "nrow"
        )
      )
    },
    list(amount, fee, balance)
  )

  full2 <- full %>%
    filter(!is.na(.data$Amount))

  data <- full2 %>%
    rename(quantity = "Amount")
  outputs <- .format_gemini_outputs(data)

  # Gemini clearing automatically selling BAT is due to Canadian regulations
  # That Gemini could not hold BAT (among others) anymore:
  # https://www.reddit.com/r/Gemini/comments/16n27ay/canadian_regulators_important_changes_to_your/

  # Merge the "buy" and "sell" objects
  data <- merge_exchanges(outputs$buy, outputs$earn, outputs$earn2, outputs$sell) %>%
    mutate(exchange = "gemini")

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

  data <- .format_gemini_apply_sell_prices(data)

  # Arrange in correct order and remove CAD buys
  data <- data %>%
    arrange(date, desc(.data$total.price)) %>%
    filter(.data$currency != "CAD")

  # Reorder columns properly
  data <- data %>%
    select(
      "date", "currency", "quantity", "total.price", "spot.rate", "transaction",
      "fees", "fees.quantity", "fees.currency", "description", "comment", 
      "revenue.type", "exchange", "rate.source"
    ) %>%
    as.data.frame()

  # Return result
  data
}

.format_gemini_prepare_input <- function(data, known.transactions) {
  data <- data %>%
    slice(1:n() - 1) %>%
    rename(
      description = "Type",
      comment = "Specification",
      date = "Date"
    )

  check_new_transactions(data,
    known.transactions = known.transactions,
    transactions.col = "description",
    description.col = "comment"
  )

  data %>%
    mutate(date = lubridate::as_datetime(.data$date))
}

.format_gemini_fee_prices <- function(fee, list.prices, force) {
  fee <- .resolve_formatted_prices(
    fee,
    list.prices = list.prices,
    force = force,
    warn_on_missing_spot = TRUE
  )
  if (is.null(fee)) {
    return(NULL)
  }

  fee %>%
    mutate(
      fees.quantity = abs(.data$Fee),
      fees = .data$fees.quantity * .data$spot.rate,
      fees.currency = .data$currency
    )
}

.format_gemini_buy <- function(data) {
  data %>%
    filter(
      .data$description %in% c("Buy", "Sell"),
      .data$quantity > 0
    ) %>%
    mutate(
      transaction = "buy",
      description = .data$Symbol
    ) %>%
    select(
      "date", "quantity", "currency", "transaction",
      "fees", "fees.quantity", "fees.currency", "description", "comment"
    )
}

.format_gemini_earn <- function(data) {
  data %>%
    filter(.data$comment %in% c("Administrative Credit")) %>%
    mutate(
      transaction = "revenue",
      revenue.type = replace(
        .data$comment,
        .data$comment %in% c("Administrative Credit"),
        "referrals"
      )
    ) %>%
    select(
      "date", "quantity", "currency", "transaction",
      "revenue.type", "description", "comment"
    )
}

.format_gemini_earn2 <- function(data) {
  data %>%
    filter(.data$comment == "Deposit" & .data$currency == "BAT") %>%
    mutate(
      transaction = "revenue",
      revenue.type = "airdrops"
    ) %>%
    select(
      "date", "quantity", "currency", "transaction",
      "revenue.type", "description", "comment"
    )
}

.format_gemini_sell <- function(data) {
  data %>%
    filter(
      .data$description %in% c("Buy", "Sell"),
      .data$quantity < 0
    ) %>%
    mutate(
      transaction = "sell",
      description = .data$Symbol,
      quantity = abs(.data$quantity)
    ) %>%
    select(
      "date", "quantity", "currency", "transaction",
      "fees", "fees.quantity", "fees.currency", "description", "comment"
    )
}

.format_gemini_outputs <- function(data) {
  list(
    buy = .format_gemini_buy(data),
    earn = .format_gemini_earn(data),
    earn2 = .format_gemini_earn2(data),
    sell = .format_gemini_sell(data)
  )
}

.format_gemini_apply_sell_prices <- function(data) {
  .reuse_buy_total_prices_for_sells(data)
}
