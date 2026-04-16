#' @title Format Adalite wallet file
#'
#' @description Format a .csv transaction history file from the Adalite
#' wallet for later ACB processing.
#' @param data The dataframe
#' @param list.prices An optional explicit `list.prices` object from which to
#' fetch coin prices. For exchanges that require external pricing, it must
#' contain at least `currency`, `spot.rate2`, and `date2`.
#' @param force Whether to force recreating `list.prices` even though
#' it already exists (e.g., if you added new coins or new dates).
#' @return A data frame of exchange transactions, formatted for further processing.
#' @export
#' @examples
#' data <- data_adalite
#' format_adalite(data)
#' @importFrom dplyr %>% rename mutate select filter bind_rows
#' @importFrom rlang .data

format_adalite <- function(data, list.prices = NULL, force = FALSE) {
  known.transactions <- c("Reward awarded", "Received", "Sent")

  data <- .format_adalite_prepare_input(data, known.transactions)
  data <- .format_adalite_finalize(.format_adalite_outputs(data))

  data <- .resolve_and_fill_formatted_prices(
    data,
    list.prices = list.prices,
    force = force,
    warn_on_missing_spot = TRUE
  )
  if (is.null(data)) {
    return(NULL)
  }

  # Actually correct network fees sold for zero!
  # data <- data %>%
  #  mutate(total.price = ifelse(description == "Sent",
  #                              0,
  #                              total.price))

  .finalize_formatted_exchange(
    data,
    exchange = NULL,
    columns = c(
      "date", "currency", "quantity", "total.price", "spot.rate", "transaction",
      "description", "comment", "revenue.type", "exchange", "rate.source"
    )
  )
}

#' @noRd
.format_adalite_prepare_input <- function(data, known.transactions) {
  data <- data %>%
    rename(
      quantity = "Received.amount",
      currency = "Received.currency",
      description = "Type",
      date = "Date"
    )

  check_new_transactions(data,
    known.transactions = known.transactions,
    transactions.col = "description"
  )

  data %>%
    mutate(
      date = lubridate::mdy_hm(.data$date),
      currency = ifelse(.data$currency == "",
        .data$Sent.currency,
        .data$currency
      )
    )
}

#' @noRd
.format_adalite_earn <- function(data) {
  data %>%
    filter(.data$description == "Reward awarded") %>%
    mutate(
      transaction = "revenue",
      revenue.type = "staking",
      comment = NA_character_
    ) %>%
    select(
      "date", "quantity", "currency", "transaction",
      "revenue.type", "description", "comment"
    )
}

#' @noRd
.format_adalite_withdrawals <- function(data) {
  .format_fee_sell_rows(
    data,
    filter_expr = .data$description == "Sent",
    fee_col = "Fee.amount",
    comment_value = "Withdrawal Fee"
  ) %>%
    select(
      "date", "quantity", "currency", "transaction",
      "description", "comment"
    )
}

#' @noRd
.format_adalite_outputs <- function(data) {
  list(
    earn = .format_adalite_earn(data),
    withdrawals = .format_adalite_withdrawals(data)
  )
}

#' @noRd
.format_adalite_finalize <- function(outputs) {
  normalize_output <- function(data) {
    if (is.null(data)) {
      return(data)
    }

    if (!"revenue.type" %in% names(data)) {
      data$revenue.type <- NA_character_
    }

    if (!"comment" %in% names(data)) {
      data$comment <- NA_character_
    }

    data
  }

  .finalize_formatted_exchange(
    normalize_output(outputs$earn),
    normalize_output(outputs$withdrawals),
    exchange = "adalite",
    columns = c(
      "date", "currency", "quantity", "transaction",
      "revenue.type", "description", "comment", "exchange"
    )
  )
}
