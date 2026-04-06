#' @title Format Adalite wallet file
#'
#' @description Format a .csv transaction history file from the Adalite
#' wallet for later ACB processing.
#' @param data The dataframe
#' @param list.prices A `list.prices` object from which to fetch coin prices.
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
  outputs <- .format_adalite_outputs(data)
  data <- .format_adalite_finalize(outputs)

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

  # Actually correct network fees sold for zero!
  # data <- data %>%
  #  mutate(total.price = ifelse(description == "Sent",
  #                              0,
  #                              total.price))

  # Reorder columns properly
  data <- data %>%
    select(
      "date", "currency", "quantity", "total.price", "spot.rate", "transaction",
      "description", "comment", "revenue.type", "exchange", "rate.source"
    )

  # Return result
  data
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
      revenue.type = "staking"
    ) %>%
    select(
      "date", "quantity", "currency", "transaction",
      "revenue.type", "description"
    )
}

#' @noRd
.format_adalite_withdrawals <- function(data) {
  data %>%
    filter(.data$description == "Sent") %>%
    mutate(
      quantity = .data$Fee.amount,
      transaction = "sell",
      comment = "Withdrawal Fee"
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
  merge_exchanges(outputs$earn, outputs$withdrawals) %>%
    mutate(exchange = "adalite")
}
