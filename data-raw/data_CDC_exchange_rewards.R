## code to prepare `data_CDC_exchange_rewards` dataset goes here

data_CDC_exchange_rewards <- structure(list(
  Date = c(
    "2021-06-27T01:34:00.000Z", "2021-02-21T00:00:00.000Z",
    "2021-04-18T00:00:00.000Z", "2021-02-19T00:00:00.000Z", "2021-07-13T00:00:00.000Z",
    "2021-09-07T00:00:00.000Z", "2021-07-07T00:00:00.000Z", "2021-04-15T16:04:21.000Z",
    "2021-06-12T15:21:34.000Z", "2021-05-14T06:02:22.000Z"
  ), Sent.Amount = c(
    5.47845204,
    NA, NA, NA, NA, NA, NA, NA, NA, NA
  ), Sent.Currency = c(
    "CRO",
    "", "", "", "", "", "", NA, NA, NA
  ), Received.Amount = c(
    NA,
    1.36945123, 1.3651231, 1.36512341, 0.0535123, 0.0152131, 0.01512903,
    0.00000023, 0.0000063, 0.00000035
  ), Received.Currency = c(
    "",
    "CRO", "CRO", "CRO", "CRO", "CRO", "CRO", "BTC", "BTC", "BTC"
  ), Fee.Amount = c(0.001, NA, NA, NA, NA, NA, NA, NA, NA, NA),
  Fee.Currency = c("CRO", "", "", "", "", "", "", NA, NA, NA), Net.Worth.Amount = c(
    NA, NA, NA, NA, NA, NA, NA, NA, NA,
    NA
  ), Net.Worth.Currency = c(
    NA, NA, NA, NA, NA, NA, NA, NA,
    NA, NA
  ), Label = c(
    "", "Reward", "Reward", "Reward", "Reward",
    "Reward", "Reward", "Reward", "Reward", "Reward"
  ), Description = c(
    "Withdrawal to abcdefghijklmnopqrstuvwxyz (Completed)",
    "Interest on 5000.00000000 at 10% APR (Completed)", "Interest on 5000.00000000 at 10% APR (Completed)",
    "Interest on 5000.00000000 at 10% APR (Completed)", "Rebate on 0.5231512346 CRO at 10%",
    "Rebate on 0.155125123 CRO at 10%", "Rebate on 0.18512341 CRO at 10%",
    "BTC Supercharger reward", "BTC Supercharger reward", "BTC Supercharger reward"
  ), TxHash = c(
    "abcdefghijklmnopqrstuvwxyz", "", "", "", "",
    "", "", NA, NA, NA
  )
), row.names = c(NA, -10L), class = "data.frame")

usethis::use_data(data_CDC_exchange_rewards, overwrite = TRUE)
