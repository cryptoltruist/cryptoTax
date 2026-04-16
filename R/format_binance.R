#' @title Format Binance earn file
#'
#' @description Format a .csv earn history file from Binance for later
#' ACB processing.
#' @details To get this file. Download your overall transaction report
#' (this will include your trades, rewards, & "Referral Kickback" rewards).
#' To get this file, connect to your Binance account on desktop, click
#' "Wallet" (top right), "Transaction History", then in the top-right,
#' "Generate all statements". For "Time", choose "Customized" and pick
#' your time frame.
#'
#' Warning: This does NOT process WITHDRAWALS (see the
#' `format_binance_withdrawals()` function for this purpose).
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
#' format_binance(data_binance)
#' }
#' @importFrom dplyr %>% rename mutate across select arrange bind_rows desc
#' @importFrom rlang .data

format_binance <- function(data, list.prices = NULL, force = FALSE) {
  known.transactions <- c(
    "Deposit", "Withdraw", "Buy", "Fee", "Referral Kickback", "Sell",
    "Simple Earn Flexible Interest", "Distribution", "Stablecoins Auto-Conversion"
  )

  data <- .format_binance_prepare_input(data, known.transactions)

  data <- .resolve_and_fill_formatted_prices(
    data,
    list.prices = list.prices,
    force = force,
    warn_on_missing_spot = TRUE
  )
  if (is.null(data)) {
    return(NULL)
  }
  data <- data %>%
    arrange(.data$date, desc(.data$total.price))

  outputs <- .format_binance_outputs(data)

  .finalize_formatted_exchange(
    bind_rows(
    outputs$buy,
    outputs$sell,
    outputs$earn,
    outputs$conversions.buy,
    outputs$conversions.sell
    ) %>%
      arrange(date, desc(.data$total.price), .data$transaction),
    exchange = "binance",
    columns = c(
      "date", "currency", "quantity", "total.price", "spot.rate", "transaction",
      "fees", "fees.quantity", "fees.currency", "description", "comment", 
      "revenue.type", "exchange", "rate.source"
    )
  )
}

.format_binance_prepare_input <- function(data, known.transactions) {
  data <- data %>%
    rename(
      currency = "Coin",
      quantity = "Change",
      date = "UTC_Time",
      description = "Operation",
      comment = "Account"
    )

  check_new_transactions(data,
    known.transactions = known.transactions,
    transactions.col = "description"
  )

  data %>%
    mutate(date = lubridate::as_datetime(.data$date)) %>%
    filter(!.data$description %in% c("Withdraw", "Deposit")) %>%
    mutate(
      transaction = dplyr::case_when(
        .data$description %in% c(
          "Buy", "Sell", "Fee", "Stablecoins Auto-Conversion"
        ) &
          .data$quantity > 0 ~ "buy",
        .data$description %in% c(
          "Buy", "Sell", "Fee", "Stablecoins Auto-Conversion"
        ) &
          .data$quantity < 0 ~ "sell"
      ),
      quantity = abs(.data$quantity)
    )
}

.format_binance_fees <- function(data) {
  data %>%
    filter(.data$description == "Fee") %>%
    mutate(
      fees = .data$total.price,
      fees.quantity = .data$quantity,
      fees.currency = .data$currency
    )
}

.format_binance_earn <- function(data) {
  data %>%
    filter(grepl("Interest", .data$description) |
      grepl("Referral", .data$description) |
      grepl("Distribution", .data$description)) %>%
    mutate(
      transaction = "revenue",
      revenue.type = dplyr::case_when(
        grepl("Interest", .data$description) ~ "interests",
        grepl("Referral", .data$description) ~ "rebates",
        grepl("Distribution", .data$description) ~ "forks"
      )
    )
}

.format_binance_outputs <- function(data) {
  fee_rows <- .format_binance_fees(data)
  buy <- data %>%
    filter(.data$transaction == "buy")
  conversions.buy <- buy %>%
    filter(.data$description == "Stablecoins Auto-Conversion")
  buy <- buy %>%
    filter(.data$description != "Stablecoins Auto-Conversion") %>%
    mutate(
      fees = fee_rows$fees,
      fees.quantity = fee_rows$fees.quantity,
      fees.currency = fee_rows$fees.currency
    )

  sell <- data %>%
    filter(.data$transaction == "sell") %>%
    filter(.data$description != "Fee")
  conversions.sell <- sell %>%
    filter(.data$description == "Stablecoins Auto-Conversion")
  sell <- sell %>%
    filter(.data$description != "Stablecoins Auto-Conversion") %>%
    mutate(
      total.price = buy$total.price,
      spot.rate = .data$total.price / .data$quantity,
      rate.source = "coinmarketcap (buy price)"
    )

  list(
    buy = buy,
    sell = sell,
    earn = .format_binance_earn(data),
    conversions.buy = conversions.buy,
    conversions.sell = conversions.sell
  )
}
