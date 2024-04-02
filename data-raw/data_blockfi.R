## code to prepare `data_blockfi` dataset goes here

data_blockfi <- structure(list(Cryptocurrency = c(
  "LTC", "LTC", "LTC", "USDC", "BTC",
  "BTC", "BTC", "USDC", "USDC", "LTC", "BTC", "BTC", "BTC", "LTC",
  "LTC", "BTC"
), Amount = c(
  0.00174213, 0.00174213, -0.16512214,
  55, 0.00044123, -0.00025, -0.0192145123, 1.1712421, 0.038241, 0.01012512,
  0.000047234, 0.00018412, 0.000018512, 0.0224512, 1.22412, 0.0204212
), Transaction.Type = c(
  "BIA Deposit", "BIA Withdraw", "Trade", "Trade", "Bonus Payment", "Withdrawal Fee",
  "Withdrawal", "Crypto Transfer", "Interest Payment", "Interest Payment", 
  "Interest Payment", "Referral Bonus", "Interest Payment", "Interest Payment", 
  "Crypto Transfer", "Crypto Transfer"
), Confirmed.At = c(
  "2022-04-02 23:04:42", "2022-03-21 15:27:52", "2021-10-24 04:29:23", "2021-10-24 04:29:23",
  "2021-08-07 21:43:44", "2021-08-05 18:34:06", "2021-08-05 18:34:06", "2021-07-14 04:55:35",
  "2021-07-29 21:43:44", "2021-06-30 21:43:44", "2021-06-30 21:43:44",
  "2021-06-13 21:43:44", "2021-05-29 21:43:44", "2021-05-29 21:43:44",
  "2021-05-01 22:02:45", "2021-05-01 04:25:56"
)), row.names = c(
  NA,
  -16L
), class = "data.frame")

usethis::use_data(data_blockfi, overwrite = TRUE)
