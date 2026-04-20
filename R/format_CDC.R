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
    "finance.crypto_earn.loyalty_program_extra_interest_paid.crypto_wallet",
    "finance.lockup.dpos_compound_interest.crypto_wallet",
    "finance.lockup.dpos_lock.crypto_wallet",
    "lockup_unlock",
    "transfer.p2p_transfer.crypto_wallet.crypto_wallet.credit",
    "transfer.p2p_transfer.crypto_wallet.crypto_wallet.debit"
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
  )

  .finalize_formatted_exchange(
    data,
    exchange = "CDC"
  )
}

#' @title Review Crypto.com App withdrawal fee assumptions
#'
#' @description Build a compact review table of Crypto.com App withdrawal rows
#' and the policy-estimated network fees that `format_CDC()` would apply.
#' @param data Either the raw Crypto.com App dataframe or the formatted output
#' returned by `format_CDC()`.
#' @return A data frame of withdrawal rows with estimated withdrawal fees for
#' manual review against the app UI or the transaction email.
#' @export
#' @examples
#' review_CDC_withdrawals(data_CDC)
review_CDC_withdrawals <- function(data) {
  if (.is_formatted_cdc_withdrawal_input(data)) {
    return(
      data %>%
        filter(
          .data$exchange == "CDC",
          .data$description == "crypto_withdrawal"
        ) %>%
        mutate(withdraw.fees = .data$quantity) %>%
        .cdc_withdrawal_review_table()
    )
  }

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
    "finance.crypto_earn.loyalty_program_extra_interest_paid.crypto_wallet",
    "finance.lockup.dpos_compound_interest.crypto_wallet",
    "finance.lockup.dpos_lock.crypto_wallet",
    "lockup_unlock",
    "transfer.p2p_transfer.crypto_wallet.crypto_wallet.credit",
    "transfer.p2p_transfer.crypto_wallet.crypto_wallet.debit"
  )

  .format_cdc_prepare_input(data, known.transactions) %>%
    filter(.data$description == "crypto_withdrawal") %>%
    mutate(withdraw.fees = .detect_cdc_withdrawal_fee(.data$comment)) %>%
    .cdc_withdrawal_review_table()
}

#' @title Apply manual Crypto.com App withdrawal fee overrides
#'
#' @description Update policy-estimated Crypto.com App withdrawal fee rows on a
#' formatted CDC ledger using a small override table, then recompute
#' `total.price` from the updated `quantity` and existing `spot.rate`.
#' @param data The formatted output returned by `format_CDC()`.
#' @param overrides A data frame containing a replacement `quantity` column and
#' a `date` column, with optional additional match columns such as `currency`
#' or `comment`.
#' @return The formatted CDC data frame with matching withdrawal rows updated.
#' @export
#' @examples
#' overrides <- data.frame(
#'   date = lubridate::as_datetime("2021-04-18 03:57:41"),
#'   quantity = 0.01
#' )
#' apply_CDC_withdrawal_overrides(format_CDC(data_CDC), overrides)
apply_CDC_withdrawal_overrides <- function(data, overrides) {
  .validate_cdc_withdrawal_override_inputs(data, overrides)

  join_keys <- .cdc_withdrawal_override_keys(overrides)
  override_rows <- overrides %>%
    select(all_of(c(join_keys, "quantity"))) %>%
    rename(quantity.override = "quantity")

  data %>%
    dplyr::left_join(override_rows, by = join_keys) %>%
    mutate(
      quantity = ifelse(
        .data$exchange == "CDC" & .data$description == "crypto_withdrawal" &
          !is.na(.data$quantity.override),
        .data$quantity.override,
        .data$quantity
      ),
      total.price = ifelse(
        .data$exchange == "CDC" & .data$description == "crypto_withdrawal" &
          !is.na(.data$quantity.override),
        abs(.data$quantity * .data$spot.rate),
        .data$total.price
      )
    ) %>%
    select(-"quantity.override")
}

.is_formatted_cdc_withdrawal_input <- function(data) {
  is.data.frame(data) &&
    all(c("date", "currency", "quantity", "description", "comment", "exchange") %in% names(data))
}

.cdc_withdrawal_override_allowed_keys <- function() {
  c("date", "currency", "comment", "description", "exchange")
}

.cdc_withdrawal_override_keys <- function(overrides) {
  keys <- intersect(.cdc_withdrawal_override_allowed_keys(), names(overrides))

  if (!"date" %in% keys) {
    stop("`overrides` must contain a 'date' column.")
  }

  keys
}

.validate_cdc_withdrawal_override_inputs <- function(data, overrides) {
  if (!.is_formatted_cdc_withdrawal_input(data)) {
    stop("`data` must be a formatted transaction table returned by `format_CDC()`.")
  }

  if (!is.data.frame(overrides)) {
    stop("`overrides` must be a data.frame.")
  }

  if (!"quantity" %in% names(overrides)) {
    stop("`overrides` must contain a 'quantity' column.")
  }

  keys <- .cdc_withdrawal_override_keys(overrides)
  duplicate_override_rows <- duplicated(overrides[keys])

  if (any(duplicate_override_rows)) {
    stop(
      "`overrides` contains duplicate match rows for columns: ",
      paste(keys, collapse = ", "),
      "."
    )
  }
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
        "finance.lockup.dpos_compound_interest.crypto_wallet",
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
          "finance.lockup.dpos_compound_interest.crypto_wallet",
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
      withdraw.fees = .detect_cdc_withdrawal_fee(.data$comment),
      spot.rate = abs(.data$Native.Amount / .data$quantity),
      quantity = .data$withdraw.fees,
      total.price = .data$quantity * .data$spot.rate,
      transaction = "sell"
    ) %>%
    .report_cdc_withdrawal_review() %>%
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

.cdc_withdrawal_review_table <- function(withdrawals) {
  withdrawals %>%
    select(
      "date",
      "currency",
      withdrawal.description = "comment",
      policy.withdrawal.fee = "withdraw.fees"
    )
}

.report_cdc_withdrawal_review <- function(withdrawals) {
  if (!nrow(withdrawals)) {
    return(withdrawals)
  }

  message(
    "Crypto.com App exports do not include withdrawal/network fees in the CSV. ",
    "Please confirm them against the app or the transaction email with ",
    "`review_CDC_withdrawals(formatted.CDC)`."
  )

  withdrawals
}

.detect_cdc_withdrawal_fee <- function(comment) {
  dplyr::case_when(
    comment %in% c(
      "Withdraw CRO",
      "Withdraw CRO (CRO)",
      "Withdraw CRO (Crypto.org)",
      "Withdraw CRO (Cronos POS)",
      "Withdraw CRO (Cronos POS (prev. Crypto.org))"
    ) ~ 0.001,
    comment %in% c("Withdraw CRO (Cronos)") ~ 0.2,
    comment %in% c("Withdraw LTC", "Withdraw LTC (LTC)") ~ 0.001,
    comment %in% c(
      "Withdraw ETH",
      "Withdraw ETH (Ethereum)",
      "Withdraw ETH (ERC20)",
      "Withdraw ETH (Ethereum (ERC20))"
    ) ~ 0.005,
    comment %in% c("Withdraw ETH (BSC)", "Withdraw ETH (BEP20)") ~ 0.0005,
    comment %in% c("Withdraw ADA", "Withdraw ADA (Cardano)") ~ 0.5,
    comment %in% c("Withdraw BTC", "Withdraw BTC (Bitcoin)") ~ 0.0004,
    comment %in% c("Withdraw USDC (BSC)", "Withdraw USDC (BEP20)") ~ 1,
    .default = NA_real_
  )
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
