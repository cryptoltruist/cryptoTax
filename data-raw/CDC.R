## code to prepare `CDC` dataset goes here

CDC <- structure(list(Timestamp..UTC. = c(
  "2021-05-03 22:05:50", "2021-05-07 23:06:50",
  "2021-05-15 18:07:10", "2021-05-22 23:08:54", "2021-05-23 22:09:39",
  "2021-05-29 23:10:59", "2021-06-02 19:11:52", "2021-06-10 23:12:24",
  "2021-06-11 19:13:58", "2021-06-16 20:14:29", "2021-06-18 21:15:51",
  "2021-06-19 21:16:30", "2021-06-27 21:17:50", "2021-07-06 22:18:40",
  "2021-07-11 20:19:55", "2021-07-14 18:20:27", "2021-07-23 17:21:19",
  "2021-07-25 18:22:02", "2021-07-28 23:23:04"
), Transaction.Description = c(
  "Buy BTC",
  "Buy ETH", "Buy CRO", "CRO Stake", "Sign-up Bonus Unlocked",
  "Card Cashback", "Card Rebate: Spotify", "Card Rebate: Netflix",
  "Card Rebate: Amazon Prime", "Card Rebate: Expedia", "Supercharger Reward",
  "Pay Rewards", "Crypto Earn", "Crypto Earn (Extra)", "Adjustment (Credit)",
  "Mission Rewards Deposit", "CRO Stake Rewards", "BTC -> CAD",
  "ETH -> CAD"
), Currency = c(
  "BTC", "ETH", "CRO", "CRO", "CRO",
  "CRO", "CRO", "CRO", "CRO", "CRO", "ETH", "CRO", "ETH", "CRO",
  "ETHW", "CRO", "CRO", "BTC", "ETH"
), Amount = c(
  0.000733370962484796,
  0.0205920059257571, 182.436009084234, -197.465723308151, 117.94682303,
  6.40395445376923, 53.61366877, 86.35723665, 17.36889942, 22.5041772605727,
  0.000013775, 8.45262096774194, 0.000763266828087167, 0.320799213147475,
  0.35580671798495, 0.247619047619048, 37.1602562661344, 0.000532054153123365,
  0.00996365482758792
), To.Currency = c(
  "", "", "", "", "", "",
  "", "", "", "", "", "", "", "", "", "", "", "CAD", "CAD"
), To.Amount = c(
  NA,
  NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,
  35, 35
), Native.Currency = c(
  "CAD", "CAD", "CAD", "CAD", "USD",
  "CAD", "CAD", "CAD", "CAD", "CAD", "CAD", "CAD", "CAD", "CAD",
  "CAD", "CAD", "CAD", "CAD", "CAD"
), Native.Amount = c(
  51.25,
  54.21, 53.42, 50, 25, 1.13, 10.99, 16.94, 9.19, 11.65, 0.05,
  1.25, 3.12, 0.26, 3.2, 0.12, 6.98, 35, 35
), Native.Amount..in.USD. = c(
  69.7,
  73.7256, 72.6512, 68, 25, 1.5368, 14.9464, 23.0384, 12.4984,
  15.844, 0.068, 1.7, 4.2432, 0.3536, 4.352, 0.1632, 9.4928, 47.6,
  47.6
), Transaction.Kind = c(
  "crypto_purchase", "crypto_purchase",
  "crypto_purchase", "lockup_lock", "referral_gift", "referral_card_cashback",
  "reimbursement", "reimbursement", "reimbursement", "reimbursement",
  "supercharger_reward_to_app_credited", "pay_checkout_reward",
  "crypto_earn_interest_paid", "crypto_earn_extra_interest_paid",
  "admin_wallet_credited", "rewards_platform_deposit_credited",
  "mco_stake_reward", "crypto_viban_exchange", "crypto_viban_exchange"
), Transaction.Hash = c(
  "", "", "", "", "", "", "", "", "", "",
  "", "", "", "", "", "", "", "", ""
)), row.names = c(NA, -19L), class = "data.frame")

usethis::use_data(CDC, overwrite = TRUE)
