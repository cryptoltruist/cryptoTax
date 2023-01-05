## code to prepare `shakepay` dataset goes here

shakepay <- structure(
  list(
    Transaction.Type = c(
      "fiat funding", "purchase/sale", "other", "crypto cashout", "shakingsats", "shakingsats", "shakingsats", "shakingsats", "shakingsats", "purchase/sale"
    ),
    Date = c(
      "2021-04-07T14:48:56+00", "2021-04-07T14:50:41+00", "2021-04-07T21:25:36+00", "2021-04-08T00:48:06+00", "2021-04-08T12:12:57+00", "2021-04-08T12:22:07+00", "2021-04-10T12:47:14+00", "2021-04-11T12:03:31+00", "2021-04-11T12:21:49+00", "2021-04-25T00:52:19+00"
    ),
    Amount.Debited = c(
      NA, 53.03335, NA, 0.00051991, NA, NA, NA, NA, NA, 0.00052991
    ),
    Debit.Currency = c("", "CAD", "", "BTC", "", "", "", "", "", "BTC"),
    Amount.Credited = c(55, 0.00103982, 30, NA, 0.0000048, 0.000003, 0.0000033, 0.0000035, 0.0000038, 31.26848),
    Credit.Currency = c(
      "CAD", "BTC", "CAD", "", "BTC", "BTC", "BTC", "BTC", "BTC", "CAD"
    ),
    Buy...Sell.Rate = c(NA, 51002.4318, NA, NA, NA, NA, NA, NA, NA, 59007.1441),
    Direction = c("credit", "purchase", "credit", "debit", "credit", "credit", "credit", "credit", "credit", "sale"),
    Spot.Rate = c(NA, NA, NA, 51052.3351, 52582.0324, 50287.0079, 56527.6188, 59978.0477, 58099.1770, NA),
    Source...Destination = c("", "", "", "", "", "", "", "", "", ""),
    Blockchain.Transaction.ID = c("", "", "", "", "", "", "", "", "", "")
  ),
  row.names = c(2L, 3L, 8L, 9L, 14L, 15L, 16L, 17L, 18L, 12L), class = "data.frame"
)

usethis::use_data(shakepay, overwrite = TRUE)
