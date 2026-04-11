#' @title Format Crypto.com App file
#'
#' @description Format a .csv transaction history file from Crypto.com for later
#' ACB processing.
#' @details Be aware that CDC unfortunately does not include the withdrawal
#' fees in their exported transaction files (please lobby to include this feature).
#' This function attempts to guess some known withdrawal fees at some point in time
#' but depending on when the withdrawals were made, the withdrawal fees are most
#' certainly inaccurate. You will have to make a manual correction for the
#' withdrawal fees after using `format_CDC`, on the resulting dataframe.
#' @param data The dataframe
#' @param USD2CAD.table Optional explicit USD/CAD rate table to use instead of
#' relying on session cache or network access for USD conversions.
#' @return A data frame of exchange transactions, formatted for further processing.
#' @export
#' @examples
#' format_CDC(data_CDC)
#' @importFrom dplyr %>% rename mutate rowwise filter select arrange bind_rows case_when
#' @importFrom rlang .data

format_CDC <- function(data, USD2CAD.table = NULL) {
  # Known transactions ####
  known.transactions <- c(
    "crypto_earn_program_withdrawn", "rewards_platform_deposit_credited",
    "crypto_earn_extra_interest_paid", "crypto_earn_interest_paid",
    "reimbursement", "crypto_withdrawal", "mco_stake_reward", "referral_card_cashback",
    "crypto_transfer", "transfer_cashback", "card_cashback_reverted",
    "crypto_earn_program_created", "crypto_viban_exchange", "admin_wallet_credited",
    "card_top_up", "crypto_wallet_swap_credited", "crypto_wallet_swap_debited",
    "viban_purchase", "supercharger_reward_to_app_credited", "supercharger_withdrawal",
    "crypto_to_exchange_transfer", "supercharger_deposit", "crypto_exchange",
    "exchange_to_crypto_transfer", "crypto_deposit", "lockup_upgrade",
    "reimbursement_reverted", "mobile_airtime_reward", "crypto_payment",
    "pay_checkout_reward", "gift_card_reward", "crypto_purchase",
    "referral_gift", "lockup_lock", "reward.loyalty_program.trading_rebate.crypto_wallet",
    "recurring_buy_order", "admin_wallet_debited",
    "finance.crypto_earn.loyalty_program_extra_interest_paid.crypto_wallet"
  )

  data <- .format_cdc_prepare_input(data, known.transactions)

  # Convert USD value to CAD ####
  data.tmp <- cryptoTax::USD2CAD(data, USD2CAD.table = USD2CAD.table)

  if (is.null(data.tmp)) {
    message("Could not fetch exchange rates from coinmarketcap.")
    return(NULL)
  }

  data <- data.tmp %>%
    mutate(
      CAD.rate = ifelse(
        .data$Native.Currency == "USD",
        .data$CAD.rate,
        1
      ),
      rate.source = ifelse(
        .data$Native.Currency == "USD",
        "exchange (USD conversion)",
        "exchange"
      ),
      total.price = .data$Native.Amount * .data$CAD.rate
    )

  outputs <- .format_cdc_outputs(data)

  # "Update as of 26 October 23: Please be informed that Crypto.com has
  # completed the Efinity (EFI) token swap and Enjin (ENJ) coin migration.
  # Existing EFI tokens have been converted to ENJ tokens in a 4:1 (EFI to
  # ENJ) ratio according to the EFI balances in eligible users’ Crypto Wallet
  # in the Crypto.com App and Spot Wallet in the Crypto.com Exchange at the
  # time of the delist."
  # https://crypto.com/product-news/crypto-com-supports-the-enjin-blockchain-launch
  # Therefore this transaction admin_wallet_debited represents in a way a
  # sell at current market price value

  # Actually withdrawal fees should be like "selling at zero", so correct total.price
  # WITHDRAWALS <- WITHDRAWALS %>%
  #  mutate(total.price = 0)

  # Merge the "buy" and "sell" objects ####
  data <- merge_exchanges(
    outputs$buy,
    outputs$buy2,
    outputs$credit,
    outputs$earn,
    outputs$sell,
    outputs$sell2,
    outputs$withdrawals
  ) %>%
    mutate(exchange = "CDC")

  # Reorder columns properly
  data <- data %>%
    select(
      "date", "currency", "quantity", "total.price", "spot.rate", "transaction",
      "description", "comment", "revenue.type", "exchange", "rate.source"
    )

  # Return result
  data
}

.format_cdc_prepare_input <- function(data, known.transactions) {
  data <- data %>%
    rename(
      quantity = "Amount",
      currency = "Currency",
      description = "Transaction.Kind",
      comment = "Transaction.Description",
      date = "Timestamp..UTC."
    )

  check_new_transactions(data,
    known.transactions = known.transactions,
    transactions.col = "description",
    description.col = "comment"
  )

  data %>%
    mutate(
      date = lubridate::as_datetime(.data$date),
      currency = ifelse(.data$currency == "LUNA", "LUNC", .data$currency),
      currency = ifelse(.data$currency == "LUNA2", "LUNA", .data$currency)
    )
}

.format_cdc_tcad_rates <- function(data) {
  data %>%
    mutate(
      spot.rate = ifelse(.data$currency == "TCAD", 1, .data$spot.rate),
      total.price = ifelse(.data$currency == "TCAD",
        .data$spot.rate * .data$quantity,
        .data$total.price
      )
    )
}

.format_cdc_buy <- function(data) {
  data %>%
    filter(.data$description == "crypto_purchase") %>%
    mutate(
      transaction = "buy",
      spot.rate = .data$total.price / .data$quantity
    ) %>%
    select(
      "date", "quantity", "currency", "total.price", "spot.rate",
      "transaction", "description", "comment", "rate.source"
    ) %>%
    filter(.data$currency != "CAD")
}

.format_cdc_buy2 <- function(data) {
  data %>%
    filter(.data$description == "crypto_exchange") %>%
    mutate(
      currency = .data$To.Currency,
      quantity = .data$To.Amount,
      transaction = "buy",
      spot.rate = .data$total.price / .data$quantity
    ) %>%
    select(
      "date", "quantity", "currency", "total.price", "spot.rate",
      "transaction", "description", "comment", "rate.source"
    ) %>%
    filter(.data$currency != "CAD")
}

.format_cdc_credit <- function(data) {
  data %>%
    filter(.data$description %in% c("viban_purchase", "recurring_buy_order")) %>%
    mutate(
      total.price = abs(.data$total.price),
      quantity = .data$To.Amount,
      currency = .data$To.Currency,
      transaction = "buy",
      spot.rate = .data$total.price / .data$quantity
    ) %>%
    select(
      "date", "quantity", "currency", "total.price", "spot.rate",
      "transaction", "description", "comment", "rate.source"
    )
}

.format_cdc_earn <- function(data) {
  data %>%
    filter(
      .data$description %in% c(
        "reimbursement",
        "referral_card_cashback",
        "crypto_earn_interest_paid",
        "crypto_earn_extra_interest_paid",
        "finance.crypto_earn.loyalty_program_extra_interest_paid.crypto_wallet",
        "mco_stake_reward",
        "transfer_cashback",
        "mobile_airtime_reward",
        "pay_checkout_reward",
        "gift_card_reward",
        "referral_gift",
        "rewards_platform_deposit_credited",
        "card_cashback_reverted",
        "reimbursement_reverted",
        "admin_wallet_credited",
        "supercharger_reward_to_app_credited", # Mission Rewards Deposit
        "reward.loyalty_program.trading_rebate.crypto_wallet"
      )
    ) %>%
    mutate(
      transaction = "revenue",
      revenue.type = replace(
        .data$description,
        .data$description %in% c(
          "reimbursement", # Card cashback
          "referral_card_cashback", # Card cashback
          "card_cashback_reverted", # Card cashback
          "reimbursement_reverted", # Card cashback
          "mobile_airtime_reward", # Pay cashback (phone top-up)
          "pay_checkout_reward", # Pay cashback (internet purchase)
          "gift_card_reward", # Pay cashback (gift card)
          "reward.loyalty_program.trading_rebate.crypto_wallet" # Rewards+ Trading Rebate
        ),
        "rebates"
      ),
      revenue.type = replace(
        .data$revenue.type,
        .data$revenue.type %in% c(
          "crypto_earn_interest_paid",
          "crypto_earn_extra_interest_paid",
          "finance.crypto_earn.loyalty_program_extra_interest_paid.crypto_wallet",
          "mco_stake_reward",
          "supercharger_reward_to_app_credited"
        ),
        "interests"
      ),
      revenue.type = replace(
        .data$revenue.type,
        .data$revenue.type %in% c(
          "transfer_cashback",
          "rewards_platform_deposit_credited" # Mission Rewards Deposit
        ),
        "rewards"
      ),
      revenue.type = replace(
        .data$revenue.type,
        .data$revenue.type %in% c("referral_gift"),
        "referrals"
      ),
      revenue.type = replace(
        .data$revenue.type,
        .data$revenue.type %in% c("admin_wallet_credited"),
        "forks"
      ),
      total.price = abs(.data$total.price),
      spot.rate = abs(.data$total.price / .data$quantity)
    ) %>%
    select(
      "date", "quantity", "currency", "total.price", "spot.rate",
      "transaction", "revenue.type", "description", "comment", "rate.source"
    ) %>%
    .format_cdc_tcad_rates()
}

.format_cdc_sell <- function(data) {
  data %>%
    filter(.data$description %in% c(
      "crypto_viban_exchange",
      "card_top_up",
      "crypto_payment",
      "admin_wallet_debited"
    )) %>%
    mutate(
      quantity = abs(.data$quantity),
      total.price = abs(.data$total.price),
      transaction = "sell",
      spot.rate = .data$total.price / .data$quantity
    ) %>%
    select(
      "date", "quantity", "currency", "total.price", "spot.rate",
      "transaction", "description", "comment", "rate.source"
    ) %>%
    .format_cdc_tcad_rates()
}

.format_cdc_sell2 <- function(data) {
  data %>%
    filter(.data$description %in% c("crypto_exchange")) %>%
    mutate(
      quantity = abs(.data$quantity),
      total.price = abs(.data$total.price),
      transaction = "sell",
      spot.rate = .data$total.price / .data$quantity
    ) %>%
    select(
      "date", "quantity", "currency", "total.price", "spot.rate",
      "transaction", "description", "comment", "rate.source"
    ) %>%
    .format_cdc_tcad_rates()
}

.format_cdc_withdrawals <- function(data) {
  withdrawals <- data %>%
    filter(.data$description == "crypto_withdrawal") %>%
    mutate(
      withdraw.fees = case_when(
        .data$comment == "Withdraw CRO" ~ 0.001,
        .data$comment == "Withdraw CRO (CRO)" ~ 0.001,
        .data$comment == "Withdraw CRO (Crypto.org)" ~ 0.001,
        .data$comment == "Withdraw CRO (Cronos POS)" ~ 0.001,
        .data$comment == "Withdraw CRO (Cronos POS (prev. Crypto.org))" ~ 0.001,
        .data$comment == "Withdraw CRO (Cronos)" ~ 0.2,
        .data$comment == "Withdraw LTC (LTC)" ~ 0.001,
        .data$comment == "Withdraw LTC" ~ 0.001,
        .data$comment == "Withdraw ETH (BSC)" ~ 0.0005,
        .data$comment == "Withdraw ETH" ~ 0.005,
        .data$comment == "Withdraw ADA" ~ 0.5,
        .data$comment == "Withdraw ADA (Cardano)" ~ 0.5,
        .data$comment == "Withdraw BTC" ~ 0.0004,
        .data$comment == "Withdraw USDC (BSC)" ~ 1
      ),
      spot.rate = abs(.data$Native.Amount / .data$quantity),
      quantity = .data$withdraw.fees,
      total.price = .data$quantity * .data$spot.rate,
      transaction = "sell"
    ) %>%
    select(
      "date", "quantity", "currency", "total.price", "spot.rate",
      "transaction", "description", "comment", "rate.source"
    )

  if (any(is.na(withdrawals$quantity))) {
    withdrawals.na <- unique(withdrawals[is.na(withdrawals$quantity), "currency"])
    withdrawals.na <- paste(withdrawals.na, collapse = ", ")
    warning(
      "Some withdrawal fees could not be detected automatically. ",
      "You will have to make manual corrections for: ", withdrawals.na
    )
  }

  withdrawals
}

.format_cdc_outputs <- function(data) {
  list(
    buy = .format_cdc_buy(data),
    buy2 = .format_cdc_buy2(data),
    credit = .format_cdc_credit(data),
    earn = .format_cdc_earn(data),
    sell = .format_cdc_sell(data),
    sell2 = .format_cdc_sell2(data),
    withdrawals = .format_cdc_withdrawals(data)
  )
}
