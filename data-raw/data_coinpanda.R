## code to prepare `coinpanda.io` data sets goes here
# https://coinpanda.io/blog/crypto-taxes-canada-adjusted-cost-base/

data_coinpanda1 <- data.frame(
  type = c("buy", "buy", "sell", "buy"),
  date = as.Date(c("2019-08-14", "2019-10-29", "2020-06-05", "2020-09-23")),
  currency = "BTC",
  amount = c(0.2, 0.6, 0.8, 1.2),
  price = c(1800, 4300, 5700, 8200),
  fees = c(20, 20, 0, 0)
)
usethis::use_data(data_coinpanda1, overwrite = TRUE)

data_coinpanda2 <- data.frame(
  type = c("buy", "buy", "sell", "buy"),
  date = as.Date(c("2019-08-14", "2019-10-29", "2020-06-05", "2020-06-07")),
  currency = "BTC",
  amount = c(0.2, 0.6, 0.8, 1.2),
  price = c(1800, 4300, 5700, 7000),
  fees = c(20, 20, 0, 0)
)
usethis::use_data(data_coinpanda2, overwrite = TRUE)
