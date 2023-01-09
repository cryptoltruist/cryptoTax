## code to prepare `data_generic` data sets goes here

data_generic1 <- data.frame(
  Date = c("2021-03-02 10:36:06 EST", "2021-03-10 12:49:04 EST", "2021-03-15 14:12:08 EST"),
  Currency = c("BTC", "ETH", "ETH"),
  Quantity = c(0.001240, 0.063067, 0.065048),
  Total.Price = c(50.99, 50.99, 150.99),
  Transaction = c("buy", "buy", "sell"),
  Fees = c(0.72, 0.72, 1.75),
  Exchange = c("generic_exchange", "generic_exchange", "generic_exchange")
)
usethis::use_data(data_generic1, overwrite = TRUE)

data_generic2 <- data.frame(
  Date.Transaction = c("2021-03-02 10:36:06 EST", "2021-03-10 12:49:04 EST", "2021-03-15 14:12:08 EST"),
  Coin = c("BTC", "ETH", "ETH"),
  Amount = c(0.001240, 0.063067, 0.065048),
  Price = c(50.99, 50.99, 150.99),
  Type = c("buy", "buy", "sell"),
  Fee = c(0.72, 0.72, 1.75),
  Platform = c("generic_exchange", "generic_exchange", "generic_exchange")
)
usethis::use_data(data_generic2, overwrite = TRUE)

data_generic3 <- data.frame(
  Date = c("2021-03-02 10:36:06 EST", "2021-03-10 12:49:04 EST", "2021-03-15 14:12:08 EST"),
  Currency = c("BTC", "ETH", "ETH"),
  Quantity = c(0.001240, 0.063067, 0.065048),
  Spot.Rate = c(41120.9677, 808.5052, 2321.2090),
  Transaction = c("buy", "buy", "sell"),
  Fees = c(0.72, 0.72, 1.75),
  Exchange = c("generic_exchange", "generic_exchange", "generic_exchange")
)
usethis::use_data(data_generic3, overwrite = TRUE)

data_generic4 <- data.frame(
  Date = c("2021-03-02 10:36:06 EST", "2021-03-10 12:49:04 EST", "2021-03-15 14:12:08 EST"),
  Currency = c("BTC", "ETH", "ETH"),
  Quantity = c(0.001240, 0.063067, 0.065048),
  Transaction = c("buy", "buy", "sell"),
  Fees = c(0.72, 0.72, 1.75),
  Exchange = c("generic_exchange", "generic_exchange", "generic_exchange")
)
usethis::use_data(data_generic4, overwrite = TRUE)
