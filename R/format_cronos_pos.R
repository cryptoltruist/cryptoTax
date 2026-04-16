#' @title Format transaction data from the Cronos POS chain
#'
#' @description Format a .csv transaction history file from the Crypto.com DeFi
#' wallet for later ACB processing.
#'
#' Use [fetch_cronos_pos()] to first download the data.
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
#' \donttest{
#' data <- fetch_cronos_pos(
#'   limit = 30,
#'   "cro1juv4wda4ty2tas8dwh7jc2ea73ewhtc26eyxwt"
#' )
#' format_cronos_pos(data)
#' }
#' @importFrom dplyr %>% rename mutate filter select arrange bind_rows bind_cols
#' @importFrom rlang .data

format_cronos_pos <- function(data, list.prices = NULL, force = FALSE) {
  rlang::check_installed(c("readr"), reason = "for this function.")
  data <- .format_cronos_pos_prepare_input(data)
  outputs <- .format_cronos_pos_outputs(data)

  # Final
  data <- dplyr::bind_rows(
    outputs$manual_reward,
    outputs$auto_reward_staking,
    outputs$staking_costs,
    outputs$withdrawal,
    outputs$bridge
  ) %>%
    arrange(.data$date) %>%
    select(-"blockHash")

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

  .finalize_formatted_exchange(
    data,
    exchange = NULL,
    columns = c(
      "date", "currency", "quantity", "total.price", "spot.rate", "transaction",
      "description", "comment", "revenue.type", "exchange", "rate.source"
    )
  )
}

.format_cronos_pos_prepare_input <- function(data) {
  ratio <- 100000000

  data %>%
    mutate(
      quantity = readr::parse_number(.data$transfer_amount) / ratio,
      quantity = tidyr::replace_na(.data$quantity, 0),
      fee_amount = as.numeric(.data$fee.amount) / ratio,
      currency = ifelse(.data$fee.denom == "basecro", "CRO", .data$fee.denom),
      transaction = "revenue",
      description = .data$message_module,
      revenue.type = "staking",
      exchange = "CDC.wallet"
    )
}

.format_cronos_pos_manual_reward <- function(data) {
  data %>%
    filter(.data$description == "distribution") %>%
    mutate(comment = paste("Withdraw Reward from", .data$withdraw_rewards_validator)) %>%
    select(
      "date", "currency", "quantity", "transaction", "description",
      "comment", "revenue.type", "exchange", "blockHash"
    )
}

.format_cronos_pos_auto_reward_staking <- function(data) {
  data %>%
    filter(.data$description == "staking") %>%
    mutate(
      proper_validator = dplyr::case_when(
        .data$message_action == "begin_redelegate" ~ .data$redelegate_source_validator,
        .data$message_action == "begin_unbonding" ~ .data$unbond_validator,
        .default = .data$delegate_validator
      ),
      comment = paste("Auto Withdraw Reward from", .data$proper_validator)
    ) %>%
    select(
      "date", "currency", "quantity", "transaction", "description",
      "comment", "revenue.type", "exchange", "blockHash"
    )
}

.format_cronos_pos_sell_prep <- function(data) {
  data %>%
    mutate(
      quantity = .data$fee_amount,
      transaction = "sell"
    )
}

.format_cronos_pos_staking_costs <- function(sell_prep) {
  sell_prep %>%
    filter(.data$description %in% c("distribution", "staking", "error")) %>%
    mutate(
      description = "staking cost",
      proper_action = dplyr::case_when(
        .data$message_action == "begin_unbonding" ~ "Unstake from",
        .data$message_action == "withdraw_delegator_reward" |
          grepl("WithdrawDelegatorReward", .data$message_action) ~
          "Withdraw staking reward from",
        .default = "Stake on Validator"
      ),
      proper_validator = dplyr::case_when(
        .data$message_action == "begin_redelegate" ~ .data$redelegate_source_validator,
        .data$message_action == "begin_unbonding" ~ .data$unbond_validator,
        .data$message_action == "withdraw_delegator_reward" |
          grepl("WithdrawDelegatorReward", .data$message_action) ~
          .data$withdraw_rewards_validator,
        .default = .data$delegate_validator
      ),
      comment = paste(.data$proper_action, .data$proper_validator),
      comment = ifelse(.data$message_action == "error", .data$log, .data$comment)
    ) %>%
    select(
      "date", "currency", "quantity", "transaction", "description",
      "comment", "exchange", "blockHash"
    )
}

.format_cronos_pos_withdrawal <- function(sell_prep) {
  sell_prep %>%
    filter(
      .data$message_module == "bank",
      .data$transfer_sender == .data$account
    ) %>%
    mutate(
      description = "withdrawal",
      comment = paste0(
        "Outgoing Transaction to (", .data$message_action, ") ",
        .data$transfer_recipient
      )
    ) %>%
    select(
      "date", "currency", "quantity", "transaction", "description",
      "comment", "exchange", "blockHash"
    )
}

.format_cronos_pos_bridge <- function(sell_prep) {
  sell_prep %>%
    filter(grepl("ibc_client", .data$log)) %>%
    mutate(comment = paste0("Bridging chains (", .data$memo, ")")) %>%
    select(
      "date", "currency", "quantity", "transaction", "description",
      "comment", "exchange", "blockHash"
    )
}

.format_cronos_pos_outputs <- function(data) {
  sell_prep <- .format_cronos_pos_sell_prep(data)

  list(
    manual_reward = .format_cronos_pos_manual_reward(data),
    auto_reward_staking = .format_cronos_pos_auto_reward_staking(data),
    staking_costs = .format_cronos_pos_staking_costs(sell_prep),
    withdrawal = .format_cronos_pos_withdrawal(sell_prep),
    bridge = .format_cronos_pos_bridge(sell_prep)
  )
}
