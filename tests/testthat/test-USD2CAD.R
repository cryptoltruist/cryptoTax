test_that("USD2CAD uses an explicit rate table when provided", {
  explicit_rates <- data.frame(
    date = as.Date(c("2021-01-01", "2021-01-02")),
    USD = c(1.25, 1.26),
    CAD = c(1, 1)
  )

  input <- data.frame(
    date = as.POSIXct(c("2021-01-01 10:00:00", "2021-01-02 10:00:00"), tz = "UTC")
  )

  result <- expect_no_message(USD2CAD(input, USD2CAD.table = explicit_rates))

  expect_equal(result$CAD.rate, c(1.25, 1.26))
  expect_equal(result$date, input$date)
})

test_that("prepare_list_prices builds deterministic output from injected history", {
  coin_hist <- data.frame(
    timestamp = as.POSIXct(c("2021-01-01 00:00:00", "2021-01-02 00:00:00"), tz = "UTC"),
    slug = c("bitcoin", "bitcoin"),
    name = c("Bitcoin", "Bitcoin"),
    symbol = c("BTC", "BTC"),
    open = c(100, 120),
    close = c(110, 130)
  )

  fx_rates <- data.frame(
    date = as.Date(c("2021-01-01", "2021-01-02")),
    USD = c(1.30, 1.31),
    CAD = c(1, 1)
  )

  result <- expect_no_message(
    prepare_list_prices(
      slug = "bitcoin",
      start.date = "2021-01-01",
      coin_hist = coin_hist,
      USD2CAD.table = fx_rates
    )
  )

  btc_rows <- result[result$currency == "BTC", ]
  usd_rows <- result[result$currency == "USD", ]

  expect_equal(btc_rows$spot.rate2, c(136.5, 163.75))
  expect_equal(usd_rows$spot.rate2, c(1.30, 1.31))
  expect_equal(btc_rows$date2, as.Date(c("2021-01-01", "2021-01-02")))
})

test_that("match_prices works offline with an explicit list.prices table", {
  tx <- data.frame(
    date = as.POSIXct(c("2021-01-01 10:00:00", "2021-01-02 10:00:00"), tz = "UTC"),
    currency = c("BTC", "CAD"),
    quantity = c(1, 2)
  )

  explicit_list_prices <- data.frame(
    currency = "BTC",
    spot.rate2 = 123.45,
    date2 = as.Date("2021-01-01")
  )

  result <- expect_no_message(match_prices(tx, list.prices = explicit_list_prices))

  expect_equal(result$spot.rate, c(123.45, 1))
  expect_equal(result$rate.source, c("coinmarketcap", "exchange"))
})

test_that("ensure_match_price_columns adds missing columns and CAD defaults", {
  tx <- data.frame(
    currency = c("CAD", "TCAD", "BTC"),
    stringsAsFactors = FALSE
  )

  result <- cryptoTax:::.ensure_match_price_columns(tx)

  expect_true(all(c("spot.rate", "total.price", "rate.source") %in% names(result)))
  expect_equal(result$spot.rate, c(1, 1, NA))
})

test_that("finalize_match_prices prefers existing exchange prices and fills missing ones", {
  joined <- data.frame(
    currency = c("BTC", "ETH"),
    spot.rate = c(100, NA),
    rate.source = c("exchange", NA),
    date2 = as.Date(c("2021-01-01", "2021-01-01")),
    spot.rate2 = c(123, 456)
  )

  result <- cryptoTax:::.finalize_match_prices(joined)

  expect_equal(result$spot.rate, c(100, 456))
  expect_equal(result$rate.source, c("exchange", "coinmarketcap"))
  expect_false(any(c("date2", "spot.rate2") %in% names(result)))
})

test_that("prepare_list_prices_slugs returns explicit list.prices unchanged", {
  explicit_list_prices <- data.frame(
    currency = "BTC",
    spot.rate2 = 123.45,
    date2 = as.Date("2021-01-01")
  )

  input <- data.frame(
    date = as.POSIXct("2021-01-01 10:00:00", tz = "UTC"),
    currency = "BTC"
  )

  result <- prepare_list_prices_slugs(input, list.prices = explicit_list_prices)

  expect_identical(result, explicit_list_prices)
})

test_that("prepare_list_prices returns explicit list.prices unchanged even when forced", {
  explicit_list_prices <- data.frame(
    currency = "BTC",
    spot.rate2 = 999.99,
    date2 = as.Date("2021-01-01")
  )

  result <- prepare_list_prices(
    slug = "bitcoin",
    start.date = "2021-01-01",
    force = TRUE,
    verbose = FALSE,
    list.prices = explicit_list_prices
  )

  expect_identical(result, explicit_list_prices)
})


