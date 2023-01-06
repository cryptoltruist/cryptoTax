## code to prepare `koinly` dataset goes here
# https://koinly.io/blog/calculating-crypto-taxes-canada/

koinly.io <- data.frame(
  date = as.Date(c("2019-01-06", "2019-11-03", "2019-11-04")),
  transaction = c("buy", "sell", "buy"),
  currency = "ETH",
  quantity = 100,
  spot.rate = c(50, 30, 30)
)
usethis::use_data(koinly.io, overwrite = TRUE)
