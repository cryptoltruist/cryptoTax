#' @title Format CDC exchange file (FOR TRADES ONLY)
#'
#' @description Format a .csv transaction history file from the Crypto.com
#' exchange for later ACB processing. Processes all transactions, including
#' trades, rewards, withdrawal fees, etc., but only for transactions of
#' prior to the 3.0 version Exchange upgrade of November 1st, 2022.
#' (see `format_CDC_exchange_rewards` and `format_CDC_exchange_trades`
#' for older transactions).
#' @details  The necessary file for this function can be accessed by logging
#' to the exchange clicking on "Orders", then select the "Transactions" tab,
#' then for the "Transaction Type" selector, select "All", and choose your
#' desired 180-day period. The correct file will be named
#' "OEX_TRANSACTION.csv", make sure you have the right one.
#'
#' In newer versions of this transaction history file, CDC has added
#' three disclaimer character lines at the top of the file, which is
#' messing with the headers. Thus, when reading the file with
#' `read.csv()`, add the argument `skip = 3`. You will then be able to
#' read the file normally.
#'
#' Also note that the USD bundle ("USD_Stable_Coin") is treated as USDC for
#' our purposes since it can be withdrawn as USDC and it is easier to
#' calculate prices with CoinMarketCap and later capital gains and so on.
#'
#' @param data The dataframe
#' @param list.prices A `list.prices` object from which to fetch coin prices.
#' @param force Whether to force recreating `list.prices` even though
#' it already exists (e.g., if you added new coins or new dates).
#' @return A data frame of exchange transactions, formatted for further processing.
#' @export
#' @examples
#' \dontrun{
#' # Requires a Crypto.com Exchange "OEX_TRANSACTION.csv" export
#' # in the newer all-transactions format described above.
#' format_CDC_exchange(my_cdc_exchange_transactions)
#' }
#' @importFrom dplyr %>% rename mutate case_when filter select arrange bind_rows
#' mutate_at row_number
#' @importFrom rlang .data

format_CDC_exchange <- function(data, list.prices = NULL, force = FALSE) {
  known.transactions <- c(
    "OFFCHAIN_WITHDRAWAL", "ONCHAIN_WITHDRAWAL", "TRADING",
    "SOFT_STAKE_REWARD", "TRADE_FEE", "ONCHAIN_DEPOSIT",
    "OFFCHAIN_DEPOSIT", "CORRECTION_REWARD"
  )

  data <- .format_cdc_exchange_prepare_input(data, known.transactions)
  outputs <- .format_cdc_exchange_outputs(data)

  # Merge the "buy" and "sell" objects
  data <- merge_exchanges(outputs$buy, outputs$sell, outputs$fees, outputs$earn)

  # Determine spot rate and value of coins
  data <- cryptoTax::match_prices(data, list.prices = list.prices, force = force)

  if (is.null(data)) {
    message("Could not reach the CoinMarketCap API at this time")
    return(NULL)
  }

  data <- data %>%
    mutate(total.price = ifelse(is.na(.data$total.price),
      .data$quantity * .data$spot.rate,
      .data$total.price
    ))

  data <- .format_cdc_exchange_apply_sell_prices(data) %>%
    mutate(exchange = "CDC.exchange") %>%
    arrange(.data$date, desc(.data$total.price), .data$transaction)

  # Add fees to BUY
  data <- .format_cdc_exchange_attach_fees(data)

  # Reorder columns properly
  data <- data %>%
    select(
      "date", "currency", "quantity", "total.price", "spot.rate", "transaction",
      "fees", "fees.quantity", "fees.currency", "description", "comment", 
      "revenue.type", "exchange", "rate.source"
    )

  # Return result
  data
}

.format_cdc_exchange_prepare_input <- function(data, known.transactions) {
  data <- data %>%
    rename(
      quantity = "Transaction.Quantity",
      currency = "Instrument",
      description = "Journal.Type",
      comment = "Side",
      date = "Time..UTC."
    )

  check_new_transactions(data,
    known.transactions = known.transactions,
    transactions.col = "description"
  )

  data %>%
    mutate(
      date = lubridate::as_datetime(.data$date),
      currency = ifelse(.data$currency == "USD_Stable_Coin", "USDC", .data$currency),
      quantity = abs(.data$quantity)
    )
}

.format_cdc_exchange_trade_rows <- function(data, description_value, transaction_value) {
  data %>%
    filter(.data$description == description_value) %>%
    arrange(.data$Trade.ID, .data$date) %>%
    group_by(.data$Trade.ID) %>%
    mutate(row = row_number()) %>%
    ungroup() %>%
    mutate(
      transaction = transaction_value,
      currency = .data$currency
    )
}

.format_cdc_exchange_buy <- function(data) {
  .format_cdc_exchange_trade_rows(data, "TRADING", "buy") %>%
    filter(.data$comment == "BUY") %>%
    select(
      "date", "quantity", "currency", "transaction",
      "description", "comment", "Trade.ID", "row"
    )
}

.format_cdc_exchange_sell <- function(data) {
  data %>%
    filter(.data$comment == "SELL") %>%
    mutate(
      transaction = "sell",
      currency = .data$currency
    ) %>%
    select(
      "date", "quantity", "currency", "transaction",
      "description", "comment"
    )
}

.format_cdc_exchange_fees <- function(data) {
  data %>%
    filter(.data$description == "TRADE_FEE") %>%
    arrange(.data$Trade.ID, .data$date) %>%
    group_by(.data$Trade.ID) %>%
    mutate(row = row_number()) %>%
    ungroup() %>%
    mutate(
      transaction = "fees",
      currency = .data$currency
    ) %>%
    select(
      "date", "quantity", "currency", "transaction",
      "description", "comment", "Trade.ID", "row"
    )
}

.format_cdc_exchange_earn <- function(data) {
  data %>%
    filter(.data$description %in% c(
      "SOFT_STAKE_REWARD", "CORRECTION_REWARD",
      "referral_gift", "Rebate"
    )) %>%
    mutate(
      transaction = "revenue",
      revenue.type = replace(
        .data$description,
        .data$description %in% c("SOFT_STAKE_REWARD", "CORRECTION_REWARD"),
        "interests"
      ),
      revenue.type = replace(
        .data$revenue.type,
        .data$revenue.type %in% c("referral_gift"),
        "referrals"
      ),
      revenue.type = replace(
        .data$revenue.type,
        grepl("Rebate", .data$comment),
        "rebates"
      )
    ) %>%
    select(
      "date", "quantity", "currency", "transaction",
      "revenue.type", "description", "comment"
    )
}

.format_cdc_exchange_outputs <- function(data) {
  list(
    buy = .format_cdc_exchange_buy(data),
    sell = .format_cdc_exchange_sell(data),
    fees = .format_cdc_exchange_fees(data),
    earn = .format_cdc_exchange_earn(data)
  )
}

.format_cdc_exchange_apply_sell_prices <- function(data) {
  coin.prices <- data %>%
    filter(.data$transaction %in% c("buy")) %>%
    mutate(transaction = "sell")
  sell <- data %>%
    filter(
      .data$transaction %in% c("sell"),
      !grepl("Trading fee paid with", .data$description)
    )

  match_index <- which(sell$date %in% coin.prices$date)
  if (!length(match_index)) {
    return(data)
  }

  sell[match_index, "total.price"] <- coin.prices[which(
    coin.prices$date %in% sell$date
  ), "total.price"]
  sell <- sell %>%
    mutate(spot.rate = .data$total.price / .data$quantity)
  sell[match_index, "rate.source"] <- "coinmarketcap (buy price)"

  trading.fees <- data %>%
    filter(grepl("Trading fee paid with", .data$description))
  data <- data %>%
    filter(!grepl("Trading fee paid with", .data$description))
  data[which(data$transaction == "sell"), ] <- sell
  bind_rows(data, trading.fees)
}

.format_cdc_exchange_attach_fees <- function(data) {
  fees.temp <- data %>%
    filter(.data$description == "TRADE_FEE") %>%
    select(
      "Trade.ID", "row",
      fees = "total.price",
      fees.quantity = "quantity",
      fees.currency = "currency"
    )

  data %>%
    filter(.data$description != "TRADE_FEE") %>%
    right_join(fees.temp, by = c("Trade.ID", "row")) %>%
    arrange(.data$date, desc(.data$total.price), .data$transaction)
}

