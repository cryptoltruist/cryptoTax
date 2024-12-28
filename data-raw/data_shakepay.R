## code to prepare `data_shakepay` dataset goes here

data_shakepay <- structure(
  list(
    Date = c(
      "2021-05-07T14:50:41+00", "2021-05-08T00:48:06+00", "2021-05-08T12:12:57+00", "2021-05-09T12:22:07+00", "2021-05-21T12:47:14+00", "2021-06-11T12:03:31+00", "2021-06-23T12:21:49+00", "2021-07-10T00:52:19+00"
    ),
    Amount.Debited = c(
      NA, 0.00051991, NA, NA, NA, NA, NA, 0.00052991
    ),
    Asset.Debited = c("", "BTC", "", "", "", "", "", "BTC"),
    Amount.Credited = c(0.00103982, NA, 0.00011, 0.00012, 0.00013, 0.00014, 0.00015, NA),
    Asset.Credited = c("BTC", "", "BTC", "BTC", "BTC", "BTC", "BTC", ""),
    Book.Cost = c(53.06974, NA, NA, NA, NA, NA, NA, 31.26847),
    Book.Cost.Currency = rep("CAD", 8),
    Type = c("Buy", "Send", "Reward", "Reward", "Reward", "Reward", "Reward", "Sell"),
    Description = c(
      "Bought @ $51,002.432 CAD", "Bitcoin address abcdefghijklmnopqrstuvwxyz", "ShakingSats", "ShakingSats", "ShakingSats", "ShakingSats", "ShakingSats", "Bought @ $59,007.14 CAD"
    ),
    Mid.Market.Rate = c(51037.4327, 51052.3351, 52582.0324, 50287.0079, 56527.6188, 59978.0477, 59017.1621, 59017.1922),
    Spot.Rate = c(51002.4318, NA, NA, NA, NA, NA, NA, 59007.1441)),
  row.names = c(
    NA,
    -8L
  ), class = "data.frame"
)

usethis::use_data(data_shakepay, overwrite = TRUE)

# data_shakepay_old <- structure(
#   list(
#     Transaction.Type = c(
#       "fiat funding", "purchase/sale", "other", "crypto cashout", "shakingsats", "shakingsats", "shakingsats", "shakingsats", "shakingsats", "purchase/sale"
#     ),
#     Date = c(
#       "2021-05-07T14:48:56+00", "2021-05-07T14:50:41+00", "2021-05-07T21:25:36+00", "2021-05-08T00:48:06+00", "2021-05-08T12:12:57+00", "2021-05-09T12:22:07+00", "2021-05-21T12:47:14+00", "2021-06-11T12:03:31+00", "2021-06-23T12:21:49+00", "2021-07-10T00:52:19+00"
#     ),
#     Amount.Debited = c(
#       NA, 53.03335, NA, 0.00051991, NA, NA, NA, NA, NA, 0.00052991
#     ),
#     Debit.Currency = c("", "CAD", "", "BTC", "", "", "", "", "", "BTC"),
#     Amount.Credited = c(55, 0.00103982, 30, NA, 0.00011, 0.00012, 0.00013, 0.00014, 0.00015, 31.26848),
#     Credit.Currency = c(
#       "CAD", "BTC", "CAD", "", "BTC", "BTC", "BTC", "BTC", "BTC", "CAD"
#     ),
#     Buy...Sell.Rate = c(NA, 51002.4318, NA, NA, NA, NA, NA, NA, NA, 59007.1441),
#     Direction = c("credit", "purchase", "credit", "debit", "credit", "credit", "credit", "credit", "credit", "sale"),
#     Spot.Rate = c(NA, NA, NA, 51052.3351, 52582.0324, 50287.0079, 56527.6188, 59978.0477, 58099.1770, NA),
#     Source...Destination = c("", "", "", "", "", "", "", "", "", ""),
#     Blockchain.Transaction.ID = c("", "", "", "", "", "", "", "", "", "")
#   ),
#   row.names = c(
#     NA,
#     -10L
#   ), class = "data.frame"
# )
