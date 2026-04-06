test_that("format_celsius_revenue_type maps Celsius reward labels", {
  descriptions <- c("Reward", "Referred Award", "Promo Code Reward", "Transfer")

  result <- cryptoTax:::.format_celsius_revenue_type(descriptions)

  expect_equal(result, c("interests", "referrals", "promos", "Transfer"))
})

test_that("format_celsius_add_cad_prices returns NULL when FX conversion fails", {
  input <- data.frame(
    USD.Value = 10
  )

  testthat::local_mocked_bindings(
    USD2CAD = function(...) NULL,
    .package = "cryptoTax"
  )

  expect_message(
    result <- cryptoTax:::.format_celsius_add_cad_prices(input),
    "Could not fetch exchange rates from the exchange rate API."
  )

  expect_null(result)
})

test_that("format_celsius_earn_rows keeps only Celsius revenue transactions", {
  input <- data.frame(
    date = as.POSIXct(c("2021-01-01 00:00:00", "2021-01-02 00:00:00"), tz = "UTC"),
    quantity = c(-1, 2),
    currency = c("BTC", "ETH"),
    total.price = c(100, 50),
    description = c("Reward", "Transfer")
  )

  result <- cryptoTax:::.format_celsius_earn_rows(input)

  expect_equal(nrow(result), 1)
  expect_equal(result$transaction, "revenue")
  expect_equal(result$revenue.type, "interests")
  expect_equal(result$quantity, 1)
  expect_equal(result$spot.rate, 100)
})
