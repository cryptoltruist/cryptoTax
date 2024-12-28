## code to prepare `data_binance_withdrawals` dataset goes here

data_binance_withdrawals <- structure(list(
  `Date(UTC)` = c(
    "2021-04-28 18:15:14", "2021-04-28 17:13:50",
    "2021-05-06 19:55:52"
  ), Coin = c("ETH", "LTC", "ETH"), Network = c(
    "BSC",
    "LTC", "BSC"
  ), Amount = c("0.7129831", "2.412512", "0.002224"), TransactionFee = c("0.000071", "0.001", "0.000062"), Address = c(
    "abcdefghijklmnopqrstuvwxyz",
    "abcdefghijklmnopqrstuvwxyz", "abcdefghijklmnopqrstuvwxyz"
  ),
  TXID = c(
    "abcdefghijklmnopqrstuvwxyz", "abcdefghijklmnopqrstuvwxyz",
    "abcdefghijklmnopqrstuvwxyz"
  ), SourceAddress = c(
    NA, NA,
    NA
  ), PaymentID = c(NA, NA, NA), Status = c(
    "Completed", "Completed",
    "Completed"
  )
), row.names = c(NA, -3L), class = c(
  "data.frame"
))

usethis::use_data(data_binance_withdrawals, overwrite = TRUE)
