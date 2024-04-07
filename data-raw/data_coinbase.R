## code to prepare `data_coinbase` dataset goes here

data_coinbase <- structure(list(Timestamp = c(
  "2024-04-02 14:07:05 UTC", "2024-04-02 11:03:55 UTC",
  "2024-04-02 11:02:12 UTC", "2024-02-02 17:18:24 UTC", "2024-02-02 17:18:24 UTC"
), Transaction.Type = c(
  "Send", "Convert", "Convert", "Receive",
  "Receive"
), Asset = c("ADA", "ETH", "BTC", "ETH", "BTC"), Quantity.Transacted = c(
  90.287162,
  0.00844271, 0.00042515, 0.00844271, 0.00042515
), Spot.Price.Currency = c(
  "CAD",
  "CAD", "CAD", "CAD", "CAD"
), Spot.Price.at.Transaction = c(
  0.76,
  4752.22, 90352.95, 2355.25, 47221.99
), Subtotal = c(
  72.25, 43.18,
  54.44, 22.12, 28.62
), Total..inclusive.of.fees.and.or.spread. = c(
  72.25,
  32.59, 41.56, 22.12, 28.62
), Fees.and.or.Spread = c(
  0, -9.52,
  -12.14, 0, 0
), Notes = c(
  "Sent 90.287162 ADA to abcdefghijklmnopqrstuvwxyz",
  "Converted 0.00844271 ETH to 40.712521 ADA", "Converted 0.00042515 BTC to 49.57464 ADA",
  "Received 0.00844271 ETH from Celsius Network LLC Crypto Di...",
  "Received 0.00042515 BTC from Celsius Network LLC Crypto Di..."
)), class = "data.frame", row.names = c(NA, -5L))

usethis::use_data(data_coinbase, overwrite = TRUE)
