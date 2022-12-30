#' @title Format Crypto.com App file
#'
#' @description Format a .csv transaction history file from Crypto.com for later ACB processing.
#' @param data The dataframe
#' @keywords money crypto
#' @export
#' @examples
#' \dontrun{
#' format_CDC(data)
#' }
#' @importFrom dplyr %>% rename mutate rowwise filter select arrange bind_rows case_when
#' @importFrom rlang .data

format_CDC <- function(data) {
  # Rename columns
  data <- data %>%
    rename(
      quantity = "Amount",
      currency = "Currency",
      description = "Transaction.Kind",
      comment = "Transaction.Description",
      date = "Timestamp..UTC."
    )

  # Add single dates to dataframe
  data <- data %>%
    mutate(date = lubridate::as_datetime(.data$date))
  # UTC confirmed

  # Convert USD value to CAD
  data <- data %>%
    cryptoTax::USD2CAD() %>%
    mutate(
      CAD.rate = ifelse(.data$Native.Currency == "USD",
        .data$CAD.rate,
        1
      ),
      total.price = .data$Native.Amount * .data$CAD.rate
    )

  # Create a "buy" object
  BUY <- data %>%
    filter(.data$description == "crypto_purchase") %>%
    mutate(
      transaction = "buy",
      spot.rate = .data$total.price / .data$quantity
    ) %>%
    select(
      "date", "quantity", "currency", "total.price", "spot.rate",
      "transaction", "description", "comment"
    ) %>%
    filter(.data$currency != "CAD")

  # Create a second "buy" object
  BUY2 <- data %>%
    filter(.data$description == "crypto_exchange") %>%
    mutate(
      currency = .data$To.Currency,
      quantity = .data$To.Amount,
      transaction = "buy",
      spot.rate = .data$total.price / .data$quantity
    ) %>%
    select(
      "date", "quantity", "currency", "total.price", "spot.rate",
      "transaction", "description", "comment"
    ) %>%
    filter(.data$currency != "CAD")

  # Create a "credit card purchase" object
  CREDIT <- data %>%
    filter(.data$description == "viban_purchase") %>%
    mutate(
      total.price = abs(.data$total.price),
      quantity = .data$To.Amount,
      currency = .data$To.Currency,
      transaction = "buy",
      spot.rate = .data$total.price / .data$quantity
    ) %>%
    select(
      "date", "quantity", "currency", "total.price", "spot.rate",
      "transaction", "description", "comment"
    )

  # Create a "EARN" object
  EARN <- data %>%
    filter(
      .data$description %in% c(
        "reimbursement",
        "referral_card_cashback",
        "crypto_earn_interest_paid",
        "crypto_earn_extra_interest_paid",
        "mco_stake_reward",
        "transfer_cashback",
        "mobile_airtime_reward",
        "pay_checkout_reward",
        "gift_card_reward",
        "referral_gift",
        "rewards_platform_deposit_credited",
        "card_cashback_reverted",
        "reimbursement_reverted"
      )
    ) %>%
    # Mission Rewards Deposit for last one
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
          "gift_card_reward"
        ), # Pay cashback (gift card)
        "rebate"
      ),
      revenue.type = replace(
        .data$revenue.type,
        .data$revenue.type %in% c(
          "crypto_earn_interest_paid",
          "crypto_earn_extra_interest_paid",
          "mco_stake_reward"
        ),
        "interests"
      ),
      revenue.type = replace(
        .data$revenue.type,
        .data$revenue.type %in% c(
          "transfer_cashback",
          "rewards_platform_deposit_credited"
        ),
        # Mission Rewards Deposit for last one
        "rewards"
      ),
      revenue.type = replace(
        .data$revenue.type,
        .data$revenue.type %in% c("referral_gift"),
        "referrals"
      ),
      spot.rate = .data$total.price / .data$quantity
    ) %>%
    select(
      "date", "quantity", "currency", "total.price", "spot.rate",
      "transaction", "revenue.type", "description", "comment"
    )

  # Correct EARN object for TCAD! Spot.rate = 1, and correct price accordingly...
  EARN <- EARN %>%
    mutate(
      spot.rate = ifelse(.data$currency == "TCAD",
        1,
        .data$spot.rate
      ),
      total.price = ifelse(.data$currency == "TCAD",
        .data$spot.rate * .data$quantity,
        .data$total.price
      )
    )

  # Create a "sell" object
  SELL <- data %>%
    filter(.data$description %in% c(
      "crypto_sell_TEMP",
      "crypto_payment"
    )) %>%
    mutate(
      quantity = abs(.data$quantity),
      total.price = abs(.data$total.price),
      transaction = "sell",
      spot.rate = .data$total.price / .data$quantity
    ) %>%
    select(
      "date", "quantity", "currency", "total.price", "spot.rate",
      "transaction", "description", "comment"
    )

  # Correct EARN object for TCAD! Spot.rate = 1, and correct price accordingly...
  SELL <- SELL %>%
    mutate(
      spot.rate = ifelse(.data$currency == "TCAD",
        1,
        .data$spot.rate
      ),
      total.price = ifelse(.data$currency == "TCAD",
        .data$spot.rate * .data$quantity,
        .data$total.price
      )
    )

  # Create a second "sell" object for exchanges
  SELL2 <- data %>%
    filter(.data$description %in% c("crypto_exchange")) %>%
    mutate(
      quantity = abs(.data$quantity),
      total.price = abs(.data$total.price),
      transaction = "sell",
      spot.rate = .data$total.price / .data$quantity
    ) %>%
    select(
      "date", "quantity", "currency", "total.price", "spot.rate",
      "transaction", "description", "comment"
    )

  # Correct EARN object for TCAD! Spot.rate = 1, and correct price accordingly...
  SELL2 <- SELL2 %>%
    mutate(
      spot.rate = ifelse(.data$currency == "TCAD",
        1,
        .data$spot.rate
      ),
      total.price = ifelse(.data$currency == "TCAD",
        .data$spot.rate * .data$quantity,
        .data$total.price
      )
    )

  # Create a "withdrawals" object
  WITHDRAWALS <- data %>%
    filter(.data$description == "crypto_withdrawal") %>%
    mutate(
      withdraw.fees = case_when(
        .data$comment == "Withdraw LTC (LTC)" ~ 0.001,
        .data$comment == "Withdraw LTC" ~ 0.001,
        .data$comment == "Withdraw CRO (CRO)" ~ 0.001,
        .data$comment == "Withdraw CRO" ~ 0.001,
        .data$comment == "Withdraw ETH (BSC)" ~ 0.0005,
        .data$comment == "Withdraw ETH" ~ 0.005,
        .data$comment == "Withdraw BTC" ~ 0.0004,
        .data$comment == "Withdraw ADA" ~ 0.8,
        .data$comment == "Withdraw ADA (Cardano)" ~ 0.8
      ),
      spot.rate = .data$Native.Amount / .data$quantity,
      quantity = .data$withdraw.fees,
      total.price = .data$quantity * .data$spot.rate,
      transaction = "sell"
    ) %>%
    select(
      "date", "quantity", "currency", "total.price", "spot.rate",
      "transaction", "description", "comment"
    )

  # Actually withdrawal fees should be like "selling at zero", so correct total.price
  # WITHDRAWALS <- WITHDRAWALS %>%
  #  mutate(total.price = 0)

  # Merge the "buy" and "sell" objects
  data <- bind_rows(BUY, BUY2, CREDIT, EARN, SELL, SELL2, WITHDRAWALS) %>%
    mutate(
      fees = 0,
      exchange = "CDC",
      rate.source = "exchange"
    ) %>%
    arrange(date)

  # Return result
  data
}
