## code to prepare `data_gemini` dataset goes here

data_gemini <- structure(list(
  DATE = c(
    "2021-04-16T05:02:47.000Z", "2021-04-17T04:25:21.000Z",
    "2021-04-17T04:23:33.450Z", "2021-05-25T22:06:11.505Z", "2021-05-25T23:02:52.000Z",
    "2021-05-25T23:08:12.000Z", "2021-06-12T12:15:28.738Z", "2021-06-12T22:31:35.000Z"
  ), TYPE = c(
    "deposit", "deposit", "deposit", "withdrawal", "deposit",
    "withdrawal", "withdrawal", "withdrawal"
  ), FROMPORTFOLIO = c(
    "",
    "", "", "exodus_0", "", "exodus_0", "exodus_0", "exodus_0"
  ),
  TOPORTFOLIO = c(
    "exodus_0", "exodus_0", "exodus_0", "", "exodus_0",
    "", "", ""
  ), OUTAMOUNT = c(
    NA, NA, NA, -1.110513, NA, -4.42123,
    -0.001051231, -0.065123152141241
  ), OUTCURRENCY = c(
    "", "",
    "", "LTC", "", "ADA", "BTC", "ETH"
  ), FEEAMOUNT = c(
    NA, NA,
    NA, -0.001443, NA, -0.178241, -0.00005030, -0.00145
  ), FEECURRENCY = c(
    "",
    "", "", "LTC", "", "ADA", "BTC", "ETH"
  ), TOADDRESS = c(
    "",
    "", "", "abcdefghijklmnopqrstuvwxyz", "", "abcdefghijklmnopqrstuvwxyz",
    "abcdefghijklmnopqrstuvwxyz", "abcdefghijklmnopqrstuvwxyz"
  ), OUTTXID = c(
    "", "", "", "abcdefghijklmnopqrstuvwxyz",
    "", "abcdefghijklmnopqrstuvwxyz",
    "abcdefghijklmnopqrstuvwxyz",
    "abcdefghijklmnopqrstuvwxyz"
  ), OUTTXURL = c(
    "", "", "", "https://live.blockcypher.com/ltc/tx/abcdefghijklmnopqrstuvwxyz",
    "", "https://cardanoscan.io/transaction/abcdefghijklmnopqrstuvwxyz",
    "https://mempool.space/tx/abcdefghijklmnopqrstuvwxyz",
    "https://etherscan.io/tx/abcdefghijklmnopqrstuvwxyz"
  ), INAMOUNT = c(
    0.00125124, 0.01241, 0.10251, NA, 5, NA,
    NA, NA
  ), INCURRENCY = c(
    "BTC", "ETH", "LTC", "", "ADA", "",
    "", ""
  ), INTXID = c(
    "abcdefghijklmnopqrstuvwxyz",
    "abcdefghijklmnopqrstuvwxyz",
    "abcdefghijklmnopqrstuvwxyz",
    "", "abcdefghijklmnopqrstuvwxyz",
    "", "", ""
  ), INTXURL = c(
    "https://mempool.space/tx/abcdefghijklmnopqrstuvwxyz",
    "https://etherscan.io/tx/abcdefghijklmnopqrstuvwxyz",
    "https://live.blockcypher.com/ltc/tx/abcdefghijklmnopqrstuvwxyz",
    "", "https://cardanoscan.io/transaction/abcdefghijklmnopqrstuvwxyz",
    "", "", ""
  ), ORDERID = c(NA, NA, NA, NA, NA, NA, NA, NA),
  PERSONALNOTE = c(NA, NA, NA, NA, NA, NA, NA, NA)
), row.names = c(
  2L,
  3L, 4L, 33L, 37L, 38L, 40L, 41L
), class = "data.frame")

usethis::use_data(data_gemini, overwrite = TRUE)

