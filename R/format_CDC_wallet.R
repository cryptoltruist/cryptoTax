#' @title Format CDC wallet file
#'
#' @description Format a .csv transaction history file from the Crypto.com DeFi
#' wallet for later ACB processing.
#'
#' One way to download the CRO staking rewards data from the blockchain is to
#' visit http://crypto.barkisoft.de/ and input your CRO address. Keep the default
#' export option ("Koinly"). It will output a CSV file with your transactions.
#' Note: the site does not use a secure connection: use at your own risks.
#' The file is semi-column separated; when using `read.csv`, add the `sep = ";"`
#' argument.
#'
#' Superseded by [fetch_cronos_pos()] and [format_cronos_pos()] since
#' http://crypto.barkisoft.de/ does not provide a valid CSV file anymore.
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
#' format_CDC_wallet(data_CDC_wallet)
#' @importFrom dplyr %>% rename mutate filter select arrange bind_rows mutate_at
#' @importFrom rlang .data

format_CDC_wallet <- function(data, list.prices = NULL, force = FALSE) {
  known.transactions <- c("", "cost", "Reward")

  data <- .format_cdc_wallet_prepare_input(data, known.transactions)
  outputs <- .format_cdc_wallet_outputs(data)

  # Actually withdrawal fees should be like "selling at zero", so correct total.price
  # WITHDRAWALS <- WITHDRAWALS %>%
  #  mutate(total.price = 0)

  # Merge the "buy" and "sell" objects
  data <- merge_exchanges(outputs$earn, outputs$withdrawals, outputs$staking) %>%
    mutate(exchange = "CDC.wallet")

  # Determine spot rate and value of coins
  data <- .resolve_and_fill_formatted_prices(
    data,
    list.prices = list.prices,
    force = force,
    warn_on_missing_spot = TRUE
  )
  if (is.null(data)) {
    return(NULL)
  }

  # Reorder columns properly
  data <- data %>%
    select(
      "date", "currency", "quantity", "total.price", "spot.rate", "transaction",
      "description", "comment", "revenue.type", "exchange", "rate.source"
    )

  # Return result
  data
}

.format_cdc_wallet_prepare_input <- function(data, known.transactions) {
  data <- data %>%
    rename(
      quantity = "Received.Amount",
      currency = "Received.Currency",
      description = "Label",
      comment = "Description",
      date = "Date"
    )

  check_new_transactions(data,
    known.transactions = known.transactions,
    transactions.col = "description"
  )

  data %>%
    mutate(
      date = lubridate::as_datetime(.data$date),
      description = ifelse(grepl("Incoming", .data$comment),
        "Deposit",
        ifelse(grepl("Outgoing", .data$comment),
          "Withdrawal",
          .data$description
        )
      ),
      currency = ifelse(.data$Sent.Currency != "", .data$Sent.Currency, .data$currency),
      quantity = ifelse(!is.na(.data$Sent.Amount), .data$Sent.Amount, .data$quantity)
    )
}

.format_cdc_wallet_earn <- function(data) {
  data %>%
    filter(.data$description %in% c("Reward")) %>%
    mutate(
      transaction = "revenue",
      revenue.type = "staking"
    ) %>%
    select(
      "date", "quantity", "currency", "transaction",
      "revenue.type", "description", "comment"
    )
}

.format_cdc_wallet_withdrawals <- function(data) {
  .format_fee_sell_rows(
    data,
    filter_expr = .data$description == "Withdrawal",
    fee_col = "Fee.Amount"
  ) %>%
    select(
      "date", "quantity", "currency", "transaction",
      "description", "comment"
    )
}

.format_cdc_wallet_staking <- function(data) {
  data %>%
    filter(.data$description == "cost") %>%
    mutate(
      quantity = .data$Sent.Amount,
      transaction = "sell",
      description = "staking cost"
    ) %>%
    select(
      "date", "quantity", "currency", "transaction",
      "description", "comment"
    )
}

.format_cdc_wallet_outputs <- function(data) {
  list(
    earn = .format_cdc_wallet_earn(data),
    withdrawals = .format_cdc_wallet_withdrawals(data),
    staking = .format_cdc_wallet_staking(data)
  )
}
