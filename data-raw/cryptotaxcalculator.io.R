## code to prepare `cryptotaxcalculator.io` data sets goes here
# https://cryptotaxcalculator.io/guides/crypto-tax-canada-cra/

cryptotaxcalculator.io1 <- data.frame(
  date = as.Date(c("2020-01-01", "2020-02-03", "2020-02-04", "2021-02-04")),
  trade = c("buy", "sell", "buy", "sell"),
  currency = "BTC",
  price = c(5000, 3000, 3000, 10000),
  quantity = 2
)
usethis::use_data(cryptotaxcalculator.io1, overwrite = TRUE)

cryptotaxcalculator.io2 <- data.frame(
  date = as.Date(c("2020-01-01", "2020-02-05", "2020-02-06", "2021-02-06")),
  trade = c("buy", "buy", "sell", "sell"),
  currency = "BTC",
  price = c(5000, 1000, 1000, 10000),
  quantity = 2
)
usethis::use_data(cryptotaxcalculator.io2, overwrite = TRUE)

