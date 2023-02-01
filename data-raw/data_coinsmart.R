## code to prepare `data_coinsmart` dataset goes here

data_coinsmart <- structure(list(
  Credit = c(0, 0.00004, 15, 0, 0, 198.5, 0, 250),
  Debit = c(0.3, 0, 0, 0.197, 237.93743, 0, 2.25, 0), TransactionType = c(
    "Fee",
    "Other", "Other", "Fee", "Trade", "Trade", "Fee", "Other"
  ), ReferenceType = c(
    "Withdraw", "Quiz", "Referral ", "Trade",
    "Trade", "Trade", "Deposit", "Deposit"
  ), Product = c(
    "ADA",
    "BTC", "CAD", "ADA", "CAD", "ADA", "CAD", "CAD"
  ), Balance = c(
    0,
    0.00004, 24.81254, 98.303, 9.81254, 98.5, 247.75, 250
  ), TimeStamp = c(
    "2021/06/02 20:04:49.084",
    "2021/05/15 10:42:07.220", "2021/04/28 12:37:15.521", "2021/04/25 10:11:24.182",
    "2021/04/25 10:11:24.180", "2021/04/25 10:11:24.179", "2021/03/15 14:37:18.233",
    "2021/03/15 14:37:18.233"
  )
), row.names = c(NA, -8L), class = "data.frame")

usethis::use_data(data_coinsmart, overwrite = TRUE)
