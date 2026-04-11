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

test_that("apply_buy_price_reference copies matching buy totals onto sell rows", {
  target_rows <- data.frame(
    date = as.POSIXct(c("2021-01-01 00:00:00", "2021-01-03 00:00:00"), tz = "UTC"),
    quantity = c(2, 4),
    total.price = c(NA, NA),
    spot.rate = c(NA, NA),
    rate.source = c(NA, NA)
  )
  reference_rows <- data.frame(
    date = as.POSIXct(c("2021-01-01 00:00:00", "2021-01-02 00:00:00"), tz = "UTC"),
    total.price = c(10, 20)
  )

  result <- cryptoTax:::.apply_buy_price_reference(target_rows, reference_rows)

  expect_equal(result$total.price, c(10, NA))
  expect_equal(result$spot.rate, c(5, NA))
  expect_equal(result$rate.source, c("coinmarketcap (buy price)", NA))
})

test_that("reuse_buy_total_prices_for_sells updates sell rows and preserves others", {
  input <- data.frame(
    date = as.POSIXct(c(
      "2021-01-01 00:00:00",
      "2021-01-01 00:00:00",
      "2021-01-02 00:00:00"
    ), tz = "UTC"),
    transaction = c("buy", "sell", "revenue"),
    quantity = c(2, 2, 1),
    total.price = c(10, NA, 3),
    spot.rate = c(5, NA, 3),
    description = c("buy", "sell", "reward"),
    rate.source = c("coinmarketcap", NA, "exchange"),
    stringsAsFactors = FALSE
  )

  result <- cryptoTax:::.reuse_buy_total_prices_for_sells(input)
  sell_row <- result[result$transaction == "sell", ]
  revenue_row <- result[result$transaction == "revenue", ]

  expect_equal(sell_row$total.price, 10)
  expect_equal(sell_row$spot.rate, 5)
  expect_equal(sell_row$rate.source, "coinmarketcap (buy price)")
  expect_equal(revenue_row$total.price, 3)
})

test_that("reuse_buy_total_prices_for_sells can preserve excluded rows separately", {
  input <- data.frame(
    date = as.POSIXct(c(
      "2021-01-01 00:00:00",
      "2021-01-01 00:00:00",
      "2021-01-01 00:00:00"
    ), tz = "UTC"),
    transaction = c("buy", "sell", "sell"),
    quantity = c(2, 2, 1),
    total.price = c(10, NA, 1),
    spot.rate = c(5, NA, 1),
    description = c("buy", "paired sell", "Trading fee paid with CRO"),
    rate.source = c("coinmarketcap", NA, "exchange"),
    stringsAsFactors = FALSE
  )

  result <- cryptoTax:::.reuse_buy_total_prices_for_sells(
    input,
    sell_mask = input$transaction %in% "sell" &
      !grepl("Trading fee paid with", input$description),
    preserve_mask = grepl("Trading fee paid with", input$description)
  )

  paired_sell <- result[result$description == "paired sell", ]
  fee_sell <- result[result$description == "Trading fee paid with CRO", ]

  expect_equal(paired_sell$total.price, 10)
  expect_equal(paired_sell$rate.source, "coinmarketcap (buy price)")
  expect_equal(fee_sell$total.price, 1)
  expect_equal(fee_sell$rate.source, "exchange")
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

test_that("formatter sell-price helpers all use the shared buy-price propagation behavior", {
  input <- data.frame(
    date = as.POSIXct(c("2021-01-01 00:00:00", "2021-01-01 00:00:00"), tz = "UTC"),
    transaction = c("buy", "sell"),
    quantity = c(2, 2),
    total.price = c(10, NA),
    spot.rate = c(5, NA),
    description = c("trade", "trade"),
    rate.source = c("coinmarketcap", NA),
    stringsAsFactors = FALSE
  )

  blockfi <- cryptoTax:::.format_blockfi_apply_sell_prices(input)
  gemini <- cryptoTax:::.format_gemini_apply_sell_prices(input)
  uphold <- cryptoTax:::.format_uphold_apply_sell_prices(input)

  expect_equal(blockfi[blockfi$transaction == "sell", "total.price"], 10)
  expect_equal(gemini[gemini$transaction == "sell", "total.price"], 10)
  expect_equal(uphold[uphold$transaction == "sell", "total.price"], 10)
})
