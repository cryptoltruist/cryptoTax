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

test_that("resolve_formatted_prices does not relabel malformed explicit prices as API failures", {
  testthat::local_mocked_bindings(
    match_prices = function(...) NULL,
    .package = "cryptoTax"
  )

  expect_no_message(
    result <- cryptoTax:::.resolve_formatted_prices(
      data.frame(quantity = 2),
      list.prices = data.frame(date2 = as.Date("2021-01-01"))
    )
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

test_that("generic pricing failure helper only surfaces API messages for reusable prices", {
  expect_true(cryptoTax:::.should_surface_generic_pricing_failure(NULL))
  expect_true(cryptoTax:::.should_surface_generic_pricing_failure(
    data.frame(currency = "BTC", spot.rate2 = 1, date2 = as.Date("2021-01-01"))
  ))
  expect_false(cryptoTax:::.should_surface_generic_pricing_failure(
    data.frame(date2 = as.Date("2021-01-01"))
  ))
})

test_that("formatted pricing failure helper only emits the generic API message when appropriate", {
  expect_message(
    result <- cryptoTax:::.handle_formatted_pricing_failure(NULL),
    "Could not reach the CoinMarketCap API at this time"
  )
  expect_null(result)

  expect_no_message(
    result <- cryptoTax:::.handle_formatted_pricing_failure(
      data.frame(date2 = as.Date("2021-01-01"))
    )
  )
  expect_null(result)
})

test_that("format_coinsmart surfaces malformed explicit prices without relabeling them as API failures", {
  messages <- testthat::capture_messages(
    result <- format_coinsmart(
      data_coinsmart,
      list.prices = data.frame(date2 = as.Date("2021-01-01"))
    )
  )

  expect_null(result)
  expect_true(any(grepl(
    "Could not use 'list.prices' because it must contain 'currency', 'spot.rate2', and 'date2'.",
    messages,
    fixed = TRUE
  )))
  expect_false(any(grepl(
    "Could not reach the CoinMarketCap API at this time",
    messages,
    fixed = TRUE
  )))
})

test_that("format_gemini surfaces malformed explicit prices without relabeling them as API failures", {
  messages <- testthat::capture_messages(
    result <- format_gemini(
      data_gemini,
      list.prices = data.frame(date2 = as.Date("2021-01-01"))
    )
  )

  expect_null(result)
  expect_true(any(grepl(
    "Could not use 'list.prices' because it must contain 'currency', 'spot.rate2', and 'date2'.",
    messages,
    fixed = TRUE
  )))
  expect_false(any(grepl(
    "Could not reach the CoinMarketCap API at this time",
    messages,
    fixed = TRUE
  )))
})

test_that("format_CDC_exchange_trades surfaces malformed explicit prices without relabeling them as API failures", {
  messages <- testthat::capture_messages(
    result <- format_CDC_exchange_trades(
      data_CDC_exchange_trades,
      list.prices = data.frame(date2 = as.Date("2021-01-01"))
    )
  )

  expect_null(result)
  expect_true(any(grepl(
    "Could not use 'list.prices' because it must contain 'currency', 'spot.rate2', and 'date2'.",
    messages,
    fixed = TRUE
  )))
  expect_false(any(grepl(
    "Could not reach the CoinMarketCap API at this time",
    messages,
    fixed = TRUE
  )))
})
