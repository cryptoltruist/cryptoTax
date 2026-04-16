#' @title Format CDC exchange file (FOR TRADES ONLY)
#'
#' @description Format a .csv transaction history file from the Crypto.com
#' exchange for later ACB processing. Only processes trades, not rewards
#' (see `format_CDC_exchange_rewards` for this).
#' @details  Original file name of the right file from the exchange is
#' called "SPOT_TRADE.csv", make sure you have the right one. It can
#' usually be accessed with the following steps: (1) connect to the
#' CDC exchange. On the left menu, click on "Wallet", and choose the
#' "Transactions" tab. Pick your desired dates. Unfortunately, the CDC
#' exchange history export only supports 30 days at a time. So if you
#' have more than that, you will need to export each file and merge them
#' manually before you use this function.
#'
#' As of the new changes to the exchange (3.0) transactions before
#' November 1st, 2022, one can go instead through the "Archive" button
#' on the left vertical menu, choose dates (max 100 days), and
#' download trade transactions. It will be a zip file with several
#' transaction files inside. Choose the "SPOT_TRADE.csv".
#'
#' In newer versions of this transaction history file, CDC has added
#' three disclaimer character lines at the top of the file, which is
#' messing with the headers. Thus, when reading the file with
#' `read.csv()`, add the argument `skip = 3`. You will then be able to
#' read the file normally.
#'
#' Update 2024: the unzipped correct file is now named "OEX_TRADE.csv" instead
#' of "SPOT_TRADE.csv".
#'
#' Also note that the USD bundle ("USD_Stable_Coin") is treated as USDC for
#' our purposes since it can be withdrawn as USDC and it is easier to
#' calculate prices with CoinMarketCap and later capital gains and so on.
#'
#' @param data The dataframe
#' @param list.prices An optional explicit `list.prices` object from which to
#' fetch coin prices. For exchanges that require external pricing, it must
#' contain at least `currency`, `spot.rate2`, and `date2`.
#' @param force Whether to force recreating `list.prices` even though
#' it already exists (e.g., if you added new coins or new dates).
#' @return A data frame of exchange transactions, formatted for further processing.
#' @export
#' @examples
#' format_CDC_exchange_trades(data_CDC_exchange_trades)
#' @importFrom dplyr %>% rename mutate case_when filter select arrange bind_rows mutate_at
#' @importFrom rlang .data

format_CDC_exchange_trades <- function(data, list.prices = NULL, force = FALSE) {
  known.transactions <- c("SELL", "BUY")

  data <- .format_cdc_exchange_trades_prepare_input(data, known.transactions)

  # Determine spot rate and value of fees
  data.fees <- .format_cdc_exchange_trades_fee_prices(
    data,
    list.prices = list.prices,
    force = force
  )

  if (is.null(data.fees)) {
    return(NULL)
  }

  data$fees <- data.fees$fees.quantity * data.fees$spot.rate

  outputs <- .format_cdc_exchange_trades_outputs(data, data.fees)

  data <- merge_exchanges(
    outputs$buy,
    outputs$buy2,
    outputs$sell,
    outputs$sell2,
    outputs$sell3
  )

  data <- .resolve_and_fill_formatted_prices(
    data,
    list.prices = list.prices,
    force = force,
    warn_on_missing_spot = TRUE
  )

  if (is.null(data)) {
    return(NULL)
  }

  data <- .format_cdc_exchange_trades_apply_sell_prices(data)

  .finalize_formatted_exchange(
    data %>%
      arrange(date, desc(.data$total.price), .data$transaction),
    exchange = "CDC.exchange",
    columns = c(
      "date", "currency", "quantity", "total.price", "spot.rate", "transaction",
      "fees", "fees.quantity", "fees.currency", "description", "comment", 
      "exchange", "rate.source"
    )
  )
}

.format_cdc_exchange_trades_prepare_input <- function(data, known.transactions) {
  data <- data %>%
    rename(
      quantity = "Trade.Amount",
      description = "Side",
      comment = "Symbol",
      date = "Time..UTC.",
      fees.quantity = "Fee",
      fees.currency = "Fee.Currency"
    )

  check_new_transactions(data,
    known.transactions = known.transactions,
    transactions.col = "description"
  )

  data %>%
    mutate(
      date = lubridate::as_datetime(.data$date),
      pair.currency1 = gsub("_.*", "", .data$comment),
      pair.currency2 = gsub(".*_", "", .data$comment),
      pair.currency2 = dplyr::case_when(
        .data$fees.currency == "USD_Stable_Coin" & .data$pair.currency2 == "USD" ~ "USDC",
        .default = .data$pair.currency2
      ),
      fees.currency = ifelse(
        .data$fees.currency == "USD_Stable_Coin", "USDC", .data$fees.currency
      ),
      fees.currency.temp = .data$fees.currency,
      fees.currency = ifelse(
        .data$fees.currency == "USD_Stable_Coin", "USD", .data$fees.currency
      ),
      third.currency = dplyr::case_when(
        .data$description == "BUY" ~ .data$fees.currency != .data$pair.currency1,
        .data$description == "SELL" ~ .data$fees.currency != .data$pair.currency2
      )
    ) %>%
    select(-"fees.currency.temp")
}

.format_cdc_exchange_trades_fee_prices <- function(data, list.prices, force) {
  data %>%
    mutate(currency = .data$fees.currency) %>%
    .resolve_formatted_prices(
      list.prices = list.prices,
      force = force,
      warn_on_missing_spot = TRUE
    )
}

.format_cdc_exchange_trades_buy <- function(data) {
  data %>%
    filter(.data$description == "BUY") %>%
    mutate(
      transaction = "buy",
      currency = .data$pair.currency1
    ) %>%
    select(
      "date", "quantity", "currency", "transaction",
      "description", "comment", "fees", "fees.quantity", "fees.currency"
    )
}

.format_cdc_exchange_trades_buy2 <- function(data) {
  data %>%
    filter(.data$description == "BUY") %>%
    mutate(
      transaction = "sell",
      currency = .data$pair.currency2,
      quantity = .data$Volume.of.Business,
      description = "SELL"
    ) %>%
    select(
      "date", "quantity", "currency", "transaction",
      "description", "comment"
    )
}

.format_cdc_exchange_trades_sell <- function(data) {
  data %>%
    filter(.data$description == "SELL") %>%
    mutate(
      transaction = "sell",
      currency = .data$pair.currency1
    ) %>%
    select(
      "date", "quantity", "currency", "transaction",
      "description", "comment"
    )
}

.format_cdc_exchange_trades_sell2 <- function(data) {
  data %>%
    filter(.data$description == "SELL") %>%
    mutate(
      transaction = "buy",
      currency = .data$pair.currency2,
      quantity = .data$Volume.of.Business,
      description = "BUY"
    ) %>%
    select(
      "date", "quantity", "currency", "transaction",
      "description", "comment", "fees", "fees.quantity", "fees.currency"
    )
}

.format_cdc_exchange_trades_sell3 <- function(data, data.fees) {
  sell3 <- data %>%
    filter(.data$third.currency == TRUE) %>%
    mutate(
      transaction = "sell",
      currency = .data$fees.currency,
      quantity = .data$fees.quantity,
      total.price = .data$fees,
      description = "Trading fee paid with CRO"
    ) %>%
    select(
      "date", "quantity", "currency", "total.price", "transaction",
      "description", "comment"
    )

  data.fees %>%
    filter(.data$third.currency == TRUE) %>%
    select("spot.rate", "rate.source") %>%
    cbind(sell3)
}

.format_cdc_exchange_trades_outputs <- function(data, data.fees) {
  list(
    buy = .format_cdc_exchange_trades_buy(data),
    buy2 = .format_cdc_exchange_trades_buy2(data),
    sell = .format_cdc_exchange_trades_sell(data),
    sell2 = .format_cdc_exchange_trades_sell2(data),
    sell3 = .format_cdc_exchange_trades_sell3(data, data.fees)
  )
}

.format_cdc_exchange_trades_apply_sell_prices <- function(data) {
  .reuse_buy_total_prices_for_sells(
    data,
    sell_mask = data$transaction %in% "sell" &
      !grepl("Trading fee paid with", data$description),
    preserve_mask = grepl("Trading fee paid with", data$description)
  )
}
