## code to prepare `data_newton` dataset goes here

data_newton <- structure(list(Date = c(
  "06/16/2021 14:49:11", "05/12/2021 17:52:40",
  "05/12/2021 17:37:42", "04/21/2021 15:57:26", "04/04/2021 19:28:17",
  "04/04/2021 19:23:13", "04/04/2021 18:55:55", "04/04/2021 18:53:46",
  "04/04/2021 18:50:12"
), Type = c(
  "DEPOSIT", "TRADE", "TRADE",
  "TRADE", "WITHDRAWN", "WITHDRAWN", "TRADE", "DEPOSIT", "TRADE"
), Received.Quantity = c(
  25, 156.124134098, 0.000004, 0.00343,
  NA, NA, 0.0198712, 25, 0.1048291
), Received.Currency = c(
  "CAD",
  "CAD", "BTC", "BTC", "", "", "ETH", "CAD", "LTC"
), Sent.Quantity = c(
  NA,
  0.003213, 0.30490127, 153.1241354, 0.0182109, 0.0123412, 25.0142098,
  NA, 23.491273124
), Sent.Currency = c(
  "", "BTC", "CAD", "CAD", "LTC",
  "ETH", "CAD", "", "CAD"
), Fee.Amount = c(
  "Referral Program",
  "", "", "", "", "", "", "Referral Program", ""
), Fee.Currency = c(
  NA,
  NA, NA, NA, NA, NA, NA, NA, NA
), Tag = c(
  NA, NA, NA, NA, NA,
  NA, NA, NA, NA
)), row.names = c(NA, -9L), class = "data.frame")

usethis::use_data(data_newton, overwrite = TRUE)
