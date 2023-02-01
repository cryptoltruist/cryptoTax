## code to prepare `data_CDC_wallet` dataset goes here

data_CDC_wallet <- structure(list(Date = c(
  "2021-04-12 18:23:01 UTC", "2021-04-18 18:28:50 UTC",
  "2021-04-12 18:28:50 UTC", "2021-04-23 18:50:21 UTC", "2021-04-25 18:51:53 UTC",
  "2021-04-23 18:51:53 UTC", "2021-05-21 01:19:01 UTC", "2021-06-25 15:43:08 UTC",
  "2021-06-25 04:11:53 UTC", "2021-06-26 14:51:02 UTC"
), Sent.Amount = c(
  NA,
  0.0002, NA, NA, 0.0002, NA, 541.741231512, NA, 0.0002, NA
), Sent.Currency = c(
  "",
  "CRO", "", "", "CRO", "", "CRO", "", "CRO", ""
), Received.Amount = c(
  531.651,
  NA, 0.51251, 0.999, NA, 1.65670754, NA, 2852.5781231, NA, 6.051235
), Received.Currency = c(
  "CRO", "", "CRO", "CRO", "", "CRO",
  "", "CRO", "", "CRO"
), Fee.Amount = c(
  NA, NA, NA, NA, NA, NA,
  0.0002, NA, NA, 0.0002
), Fee.Currency = c(
  "", "", "", "", "",
  "", "CRO", "", "", "CRO"
), Net.Worth.Amount = c(
  NA, NA, NA, NA,
  NA, NA, NA, NA, NA, NA
), Net.Worth.Currency = c(
  NA, NA, NA, NA,
  NA, NA, NA, NA, NA, NA
), Label = c(
  "", "cost", "Reward", "",
  "cost", "Reward", "", "", "cost", "Reward"
), Description = c(
  "Incoming Transaction from abcdefghijklmnopqrstuvwxyz",
  "Stake on Validator(abcdefghijklmnopqrstuvwxyz)",
  "Auto Withdraw Reward from ", "Incoming Transaction from abcdefghijklmnopqrstuvwxyz",
  "Unstake from Validator(abcdefghijklmnopqrstuvwxyz)",
  "Auto Withdraw Reward from ", "Outgoing Transaction to abcdefghijklmnopqrstuvwxyz",
  "Incoming Transaction from abcdefghijklmnopqrstuvwxyz",
  "Move 10,830.19278519 CRO from Validator(abcdefghijklmnopqrstuvwxyz) to Validator(abcdefghijklmnopqrstuvwxyz)",
  "Withdraw Reward from abcdefghijklmnopqrstuvwxyz"
), TxHash = c(
  "abcdefghijklmnopqrstuvwxyz", "abcdefghijklmnopqrstuvwxyz",
  "abcdefghijklmnopqrstuvwxyz", "abcdefghijklmnopqrstuvwxyz", "abcdefghijklmnopqrstuvwxyz",
  "abcdefghijklmnopqrstuvwxyz", "abcdefghijklmnopqrstuvwxyz", "abcdefghijklmnopqrstuvwxyz",
  "abcdefghijklmnopqrstuvwxyz", "abcdefghijklmnopqrstuvwxyz"
)), row.names = c(
  NA,
  -10L
), class = "data.frame")

usethis::use_data(data_CDC_wallet, overwrite = TRUE)

