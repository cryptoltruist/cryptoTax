## code to prepare `CDC` dataset goes here

data_CDC <- structure(list(
  Timestamp..UTC. = structure(c(
    1627514584, 1627237322,
    1627060879, 1626286827, 1626034795, 1625609920, 1624828670, 1624137390,
    1624050951, 1623874469, 1623438838, 1623366744, 1622661112, 1622329859,
    1621807779, 1621724934, 1621102030, 1620428810, 1620079550
  ), tzone = "UTC", class = c(
    "POSIXct",
    "POSIXt"
  )), Transaction.Description = c(
    "ETH -> CAD", "BTC -> CAD",
    "CRO Stake Rewards", "Mission Rewards Deposit", "Adjustment (Credit)",
    "Crypto Earn (Extra)", "Crypto Earn", "Pay Rewards", "Supercharger Reward",
    "Card Rebate: Expedia", "Card Rebate: Amazon Prime", "Card Rebate: Netflix",
    "Card Rebate: Spotify", "Card Cashback", "Sign-up Bonus Unlocked",
    "CRO Stake", "Buy CRO", "Buy ETH", "Buy BTC"
  ), Currency = c(
    "ETH",
    "BTC", "CRO", "CRO", "ETHW", "CRO", "ETH", "CRO", "ETH", "CRO",
    "CRO", "CRO", "CRO", "CRO", "CRO", "CRO", "CRO", "ETH", "BTC"
  ), Amount = c(
    0.00996365482758792, 0.000532054153123365, 37.1602562661344,
    2.47619047619048, 0.35580671798495, 0.320799213147475, 0.000763266828087167,
    8.45262096774194, 0.000013775, 22.5041772605727, 17.36889942,
    86.35723665, 53.61366877, 6.40395445376923, 117.94682303, -197.465723308151,
    182.436009084234, 0.0205920059257571, 0.000733370962484796
  ),
  To.Currency = c(
    "CAD", "CAD", "", "", "", "", "", "", "",
    "", "", "", "", "", "", "", "", "", ""
  ), To.Amount = c(
    35,
    35, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,
    NA, NA, NA
  ), Native.Currency = c(
    "CAD", "CAD", "CAD", "CAD",
    "CAD", "CAD", "CAD", "CAD", "CAD", "CAD", "CAD", "CAD", "CAD",
    "CAD", "USD", "CAD", "CAD", "CAD", "CAD"
  ), Native.Amount = c(
    35,
    35, 6.98, 1.2, 3.2, 0.26, 3.12, 1.25, 0.05, 11.65, 9.19,
    16.94, 10.99, 1.13, 25, 50, 53.42, 54.21, 51.25
  ), Native.Amount..in.USD. = c(
    25.9,
    25.9, 5.1652, 0.888, 2.368, 0.1924, 2.3088, 0.925, 0.037,
    8.621, 6.8006, 12.5356, 8.1326, 0.8362, 25, 37, 39.5308,
    40.1154, 37.925
  ), Transaction.Kind = c(
    "crypto_viban_exchange",
    "crypto_viban_exchange", "mco_stake_reward", "rewards_platform_deposit_credited",
    "admin_wallet_credited", "crypto_earn_extra_interest_paid",
    "crypto_earn_interest_paid", "pay_checkout_reward", "supercharger_reward_to_app_credited",
    "reimbursement", "reimbursement", "reimbursement", "reimbursement",
    "referral_card_cashback", "referral_gift", "lockup_lock",
    "crypto_purchase", "crypto_purchase", "crypto_purchase"
  ),
  Transaction.Hash = c(
    "", "", "", "", "", "", "", "", "",
    "", "", "", "", "", "", "", "", "", ""
  )
), row.names = c(
  NA,
  -19L
), class = "data.frame")

usethis::use_data(data_CDC, overwrite = TRUE)
