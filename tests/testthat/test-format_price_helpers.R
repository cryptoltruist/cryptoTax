test_that("resolve_formatted_prices returns priced data when match_prices succeeds", {
  priced <- data.frame(
    quantity = 2,
    spot.rate = 5,
    total.price = NA
  )

  testthat::local_mocked_bindings(
    match_prices = function(...) priced,
    .package = "cryptoTax"
  )

  result <- cryptoTax:::.resolve_formatted_prices(data.frame(quantity = 2))

  expect_identical(result, priced)
})

test_that("resolve_formatted_prices surfaces the standard pricing failure message", {
  testthat::local_mocked_bindings(
    match_prices = function(...) NULL,
    .package = "cryptoTax"
  )

  expect_message(
    result <- cryptoTax:::.resolve_formatted_prices(data.frame(quantity = 2)),
    "Could not reach the CoinMarketCap API at this time"
  )

  expect_null(result)
})

test_that("resolve_formatted_prices can warn on missing spot rates", {
  priced <- data.frame(
    quantity = 2,
    spot.rate = NA_real_,
    total.price = NA_real_
  )

  testthat::local_mocked_bindings(
    match_prices = function(...) priced,
    .package = "cryptoTax"
  )

  expect_warning(
    cryptoTax:::.resolve_formatted_prices(
      data.frame(quantity = 2),
      warn_on_missing_spot = TRUE
    ),
    "Could not calculate spot rate"
  )
})

test_that("fill_missing_total_price_from_spot fills only missing totals", {
  input <- data.frame(
    quantity = c(2, 3),
    spot.rate = c(5, 7),
    total.price = c(NA, 10)
  )

  result <- cryptoTax:::.fill_missing_total_price_from_spot(input)

  expect_equal(result$total.price, c(10, 10))
})
