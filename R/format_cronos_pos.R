#' @title Format transaction data from the Cronos POS chain
#'
#' @description Format a .csv transaction history file from the Crypto.com DeFi
#' wallet for later ACB processing.
#'
#' Use [fetch_cronos_pos()] to first download the data.
#' 
#' @param data The dataframe
#' @param list.prices A `list.prices` object from which to fetch coin prices.
#' @param force Whether to force recreating `list.prices` even though
#' it already exists (e.g., if you added new coins or new dates).
#' @return A data frame of exchange transactions, formatted for further processing.
#' @export
#' @examples
#' \donttest{
#' data <- fetch_cronos_pos(limit = 30,
#'  "cro1juv4wda4ty2tas8dwh7jc2ea73ewhtc26eyxwt")
#' format_cronos_pos(data)
#' }
#' @importFrom dplyr %>% rename mutate filter select arrange bind_rows bind_cols 
#' @importFrom rlang .data

format_cronos_pos <- function(data, list.prices = NULL, force = FALSE) {
  rlang::check_installed(c("readr"), reason = "for this function.")
  # Initialize
  ratio <- 100000000
  
  # Create an EARN object
  data <- data %>% 
    mutate(quantity = readr::parse_number(.data$transfer_amount) / 100000000,
           quantity = tidyr::replace_na(.data$quantity, 0),
           fee_amount = as.numeric(.data$fee.amount) / ratio,
           currency = ifelse(.data$fee.denom == "basecro", "CRO", .data$fee.denom),
           transaction = "revenue",
           description = .data$message_module,
           revenue.type = "staking",
           exchange = "CDC.wallet")
  
  # manual_reward
  manual_reward <- data %>% 
    filter(.data$description == "distribution") %>% 
    mutate(comment = paste(
      "Withdraw Reward from", .data$withdraw_rewards_validator)) %>% 
    select("date", "currency", "quantity", "transaction", "description", 
           "comment", "revenue.type", "exchange", "blockHash")
  
  # auto_reward_staking
  auto_reward_staking <- data %>% 
    filter(.data$description == "staking") %>% 
    mutate(proper_validator = dplyr::case_when(
      .data$message_action == "begin_redelegate" ~ .data$redelegate_source_validator,
      .data$message_action == "begin_unbonding" ~ .data$unbond_validator,
      .default = .data$delegate_validator),
      comment = paste("Auto Withdraw Reward from", .data$proper_validator)) %>% 
    select("date", "currency", "quantity", "transaction", "description", 
           "comment", "revenue.type", "exchange", "blockHash")
  
  # Create a SELL object
  SELL_prep <- data %>% 
    mutate(quantity = .data$fee_amount,
           transaction = "sell")
  
  # Staking costs
  STAKING.COSTS <- SELL_prep %>% 
    filter(.data$description %in% c("distribution", "staking", "error")) %>% 
    mutate(description = "staking cost",
           proper_action = dplyr::case_when(
             .data$message_action == "begin_unbonding" ~ "Unstake from",
             .data$message_action == "withdraw_delegator_reward" |
               grepl("WithdrawDelegatorReward", .data$message_action) ~ 
               "Withdraw staking reward from",
             .default = "Stake on Validator"),
           proper_validator = dplyr::case_when(
             .data$message_action == "begin_redelegate" ~ 
               .data$redelegate_source_validator,
             .data$message_action == "begin_unbonding" ~ 
               .data$unbond_validator,
             .data$message_action == "withdraw_delegator_reward" |
               grepl("WithdrawDelegatorReward", .data$message_action) ~ 
               .data$withdraw_rewards_validator,
             .default = .data$delegate_validator),
           comment = paste(.data$proper_action, .data$proper_validator),
           comment = ifelse(.data$message_action == "error", .data$log, .data$comment)) %>% 
    select("date", "currency", "quantity", "transaction", "description", 
           "comment", "exchange", "blockHash")
  
  # Create a WITHDRAWAL object
  WITHDRAWAL <- SELL_prep %>% 
    filter(.data$message_module == "bank",
           .data$transfer_sender == .data$account) %>% 
    mutate(description = "withdrawal",
           comment = paste0("Outgoing Transaction to (", .data$message_action, ") ", 
                            .data$transfer_recipient)) %>% 
    select("date", "currency", "quantity", "transaction", "description", 
           "comment", "exchange", "blockHash")
  
  # Create a BRIDGE object
  BRIDGE <- SELL_prep %>% 
    filter(grepl("ibc_client", .data$log)) %>% 
    mutate(comment = paste0("Bridging chains (", .data$memo, ")")) %>% 
    select("date", "currency", "quantity", "transaction", "description", 
           "comment", "exchange", "blockHash")
  
  # Final
  data <- dplyr::bind_rows(manual_reward, auto_reward_staking, 
                           STAKING.COSTS, WITHDRAWAL, BRIDGE) %>% 
    arrange(.data$date) %>% 
    select(-"blockHash")
  
  # Determine spot rate and value of coins
  data <- cryptoTax::match_prices(data, list.prices = list.prices, force = force)
  
  if (is.null(data)) {
    message("Could not reach the CoinMarketCap API at this time")
    return(NULL)
  }
  
  if (any(is.na(data$spot.rate))) {
    warning("Could not calculate spot rate. Use `force = TRUE`.")
  }
  
  data <- data %>%
    mutate(total.price = ifelse(is.na(.data$total.price),
                                .data$quantity * .data$spot.rate,
                                .data$total.price
    ))
  
  # Reorder columns properly
  data <- data %>%
    select(
      "date", "currency", "quantity", "total.price", "spot.rate", "transaction", 
      "description", "comment", "revenue.type", "exchange", "rate.source"
    )
  
  # Return result
  data
}
