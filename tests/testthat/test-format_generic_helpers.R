test_that("format_generic_resolve_prices derives total.price from spot.rate", {
  data <- data.frame(
    quantity = c(2, 3),
    spot.rate = c(10, 20)
  )

  result <- cryptoTax:::.format_generic_resolve_prices(
    data = data,
    list.prices = NULL,
    force = FALSE
  )

  expect_equal(result$total.price, c(20, 60))
})

test_that("format_generic_resolve_prices derives spot.rate from total.price", {
  data <- data.frame(
    quantity = c(2, 4),
    total.price = c(20, 40)
  )

  result <- cryptoTax:::.format_generic_resolve_prices(
    data = data,
    list.prices = NULL,
    force = FALSE
  )

  expect_equal(result$spot.rate, c(10, 10))
  expect_equal(result$rate.source, c("exchange", "exchange"))
})

test_that("format_generic_resolve_prices errors when neither prices nor currency are available", {
  expect_error(
    cryptoTax:::.format_generic_resolve_prices(
      data = data.frame(quantity = 1),
      list.prices = NULL,
      force = FALSE
    ),
    "Cannot calculate 'total.price' without 'spot.rate' or 'currency' columns!"
  )
})

test_that("format_generic_resolve_prices uses the shared formatted-pricing helper when only currency is available", {
  input <- data.frame(
    quantity = 2,
    currency = "BTC",
    stringsAsFactors = FALSE
  )
  priced <- data.frame(
    quantity = 2,
    currency = "BTC",
    spot.rate = 5,
    total.price = 10,
    stringsAsFactors = FALSE
  )

  testthat::local_mocked_bindings(
    .resolve_and_fill_formatted_prices = function(data, list.prices, force, warn_on_missing_spot) {
      expect_identical(data, input)
      expect_null(list.prices)
      expect_false(force)
      expect_true(warn_on_missing_spot)
      priced
    },
    .package = "cryptoTax"
  )

  result <- cryptoTax:::.format_generic_resolve_prices(
    data = input,
    list.prices = NULL,
    force = FALSE
  )

  expect_identical(result, priced)
})

test_that("format_generic_standardize_columns matches names case-insensitively", {
  data <- data.frame(
    Date.Transaction = "2021-01-01 00:00:00",
    Coin = "BTC",
    Amount = 1,
    Price = 100,
    Type = "buy",
    Platform = "demo",
    stringsAsFactors = FALSE
  )

  result <- cryptoTax:::.format_generic_standardize_columns(
    data = data,
    date = "Date.Transaction",
    currency = "Coin",
    quantity = "Amount",
    total.price = "Price",
    spot.rate = "spot.rate",
    transaction = "Type",
    fees = "fees",
    description = "description",
    comment = "comment",
    revenue.type = "revenue.type",
    exchange = "Platform",
    timezone = "UTC"
  )

  expect_true(all(c("date", "currency", "quantity", "total.price", "transaction", "exchange") %in% names(result)))
})
