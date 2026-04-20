test_that("coinsmart_add_total_price uses credit and debit values without rowwise recycling", {
  input <- data.frame(
    Credit = c(2, NA_real_),
    Debit = c(NA_real_, 3),
    spot.rate = c(5, 7),
    stringsAsFactors = FALSE
  )

  result <- cryptoTax:::.coinsmart_add_total_price(input)

  expect_equal(result$total.price, c(10, 21))
})

test_that("coinsmart_attach_buy_fees aligns fee rows by explicit row id and fills missing fees with NA", {
  buy_rows <- data.frame(
    date = as.POSIXct(c("2021-01-01", "2021-01-02"), tz = "UTC"),
    currency = c("BTC", "ETH"),
    quantity = c(1, 2),
    total.price = c(10, 20),
    spot.rate = c(10, 10),
    transaction = c("buy", "buy"),
    description = c("purchase", "purchase"),
    comment = c("Trade", "Trade"),
    rate.source = c("coinmarketcap", "coinmarketcap"),
    stringsAsFactors = FALSE
  )
  fee_rows <- data.frame(
    .buy_fee_row_id = 1,
    fees = 0.1,
    fees.quantity = 0.01,
    fees.currency = "BTC",
    stringsAsFactors = FALSE
  )

  result <- cryptoTax:::.coinsmart_attach_buy_fees(buy_rows, fee_rows)

  expect_equal(result$fees, c(0.1, NA))
  expect_equal(result$fees.quantity, c(0.01, NA))
  expect_equal(result$fees.currency, c("BTC", NA))
})
