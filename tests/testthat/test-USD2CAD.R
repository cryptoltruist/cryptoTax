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

test_that("prepare_price_slugs falls back to popular slug mapping", {
  input <- data.frame(currency = c("BTC", "ETH"), stringsAsFactors = FALSE)

  result <- cryptoTax:::.prepare_price_slugs(input)

  expect_equal(result, c("bitcoin", "ethereum"))
})

test_that("prepare_price_start_date defaults to the earliest transaction date", {
  input <- data.frame(
    date = as.POSIXct(c("2021-01-03 00:00:00", "2021-01-01 00:00:00"), tz = "UTC")
  )

  result <- cryptoTax:::.prepare_price_start_date(input)

  expect_equal(result, as.POSIXct("2021-01-01 00:00:00", tz = "UTC"))
})

test_that("prepare_list_price_inputs combines slug and start-date preparation", {
  input <- data.frame(
    date = as.POSIXct(c("2021-01-03 00:00:00", "2021-01-01 00:00:00"), tz = "UTC"),
    currency = c("BTC", "ETH")
  )

  result <- cryptoTax:::.prepare_list_price_inputs(input)

  expect_equal(result$slug, c("bitcoin", "ethereum"))
  expect_equal(result$start.date, as.POSIXct("2021-01-01 00:00:00", tz = "UTC"))
})

test_that("add_popular_slugs inserts slug after currency and honors custom dictionaries", {
  input <- data.frame(
    currency = c("AAA", "BBB"),
    quantity = c(1, 2)
  )
  slug_dictionary <- data.frame(
    currency = c("AAA", "BBB"),
    slug = c("alpha", "beta")
  )

  result <- add_popular_slugs(input, slug_dictionary = slug_dictionary)

  expect_equal(names(result), c("currency", "slug", "quantity"))
  expect_equal(result$slug, c("alpha", "beta"))
})

test_that("prepare_list_prices_slugs rejects USD-only slugs", {
  input <- data.frame(
    date = as.POSIXct("2021-01-01 10:00:00", tz = "UTC"),
    currency = "USD",
    slug = "USD"
  )

  expect_message(
    result <- prepare_list_prices_slugs(input, slug = "USD"),
    "Slug cannot be only USD for 'prepare_list_prices\\(\\)'"
  )

  expect_null(result)
})

test_that("resolve_list_prices prefers explicit input over cached state", {
  local({
    list.prices <<- data.frame(
      currency = "BTC",
      spot.rate2 = 1,
      date2 = as.Date("2021-01-01")
    )

    explicit_list_prices <- data.frame(
      currency = "ETH",
      spot.rate2 = 2,
      date2 = as.Date("2021-01-02")
    )

    result <- cryptoTax:::.resolve_list_prices(
      force = FALSE,
      list.prices = explicit_list_prices,
      verbose = TRUE
    )

    expect_identical(result, explicit_list_prices)
  })
})

test_that("build_list_prices_from_history appends USD rows for each date", {
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

  result <- cryptoTax:::.build_list_prices_from_history(
    coin_hist = coin_hist,
    USD2CAD.table = fx_rates
  )

  usd_rows <- result[result$currency == "USD", ]

  expect_equal(nrow(usd_rows), 2)
  expect_equal(usd_rows$spot.rate2, c(1.30, 1.31))
  expect_equal(usd_rows$date2, as.Date(c("2021-01-01", "2021-01-02")))
})

test_that("validate_coin_history rejects malformed history tables", {
  bad_hist <- data.frame(timestamp = as.POSIXct("2021-01-01 00:00:00", tz = "UTC"))

  expect_message(
    result <- cryptoTax:::.validate_coin_history(bad_hist, verbose = TRUE),
    "'coin_hist' could not fetch correctly. Please try again."
  )

  expect_null(result)
})

test_that("fetch_coin_history uses explicit coins.list and returns fetched history", {
  coin_list <- data.frame(
    slug = c("bitcoin", "ethereum"),
    symbol = c("BTC", "ETH"),
    stringsAsFactors = FALSE
  )
  expected <- data.frame(
    timestamp = as.POSIXct("2021-01-01 00:00:00", tz = "UTC"),
    slug = "bitcoin",
    name = "Bitcoin",
    symbol = "BTC",
    open = 100,
    close = 110
  )

  testthat::local_mocked_bindings(
    .package = "crypto2",
    crypto_history = function(coin_list, start_date, end_date, sleep, finalWait) {
      expected
    }
  )

  result <- cryptoTax:::.fetch_coin_history(
    my.coins = c(bitcoin = "bitcoin"),
    start.date = "2021-01-01",
    end.date = "2021-01-02",
    force = FALSE,
    verbose = TRUE,
    coins.list = coin_list
  )

  expect_identical(result, expected)
})

test_that("join_usd2cad_rates can preserve Date output when restore_datetime is FALSE", {
  input <- data.frame(
    date = as.POSIXct("2021-01-01 10:00:00", tz = "UTC")
  )
  rates <- data.frame(
    date2 = as.Date("2021-01-01"),
    CAD.rate = 1.25
  )

  result <- cryptoTax:::.join_usd2cad_rates(
    data = input,
    USD2CAD.table = rates,
    by_col = "date2",
    restore_datetime = FALSE
  )

  expect_equal(result$CAD.rate, 1.25)
  expect_s3_class(result$date, "Date")
})

test_that("resolve_usd2cad_table prefers explicit rates", {
  explicit_rates <- data.frame(
    date = as.Date("2021-01-01"),
    USD = 1.25,
    CAD = 1
  )

  result <- cryptoTax:::.resolve_usd2cad_table(
    force = FALSE,
    USD2CAD.table = explicit_rates
  )

  expect_identical(result, explicit_rates)
})

test_that("build_usd2cad_crypto2_table derives CAD rates from USD and CAD rows", {
  list_prices <- data.frame(
    ref_cur = c("USD", "CAD"),
    spot.rate2 = c(1.25, 1),
    date2 = as.Date(c("2021-01-01", "2021-01-01"))
  )

  result <- cryptoTax:::.build_usd2cad_crypto2_table(list_prices)

  expect_equal(result$CAD.rate[1], 0.8)
  expect_equal(result$diff[1], 0.2)
})

test_that("build_usd2cad_crypto2_table returns NULL when USD or CAD rows are missing", {
  list_prices <- data.frame(
    ref_cur = "USD",
    spot.rate2 = 1.25,
    date2 = as.Date("2021-01-01")
  )

  result <- cryptoTax:::.build_usd2cad_crypto2_table(list_prices)

  expect_null(result)
})

test_that("normalize_usd2cad_pricer_table standardizes the output schema", {
  raw_rates <- data.frame(
    date = "2021-01-01",
    rate = 1.25
  )

  result <- cryptoTax:::.normalize_usd2cad_pricer_table(raw_rates)

  expect_s3_class(result$date, "Date")
  expect_true("CAD.rate" %in% names(result))
  expect_equal(result$CAD.rate, 1.25)
})

test_that("fetch_usd2cad_crypto2_table builds rates from prepared prices", {
  prepared_prices <- data.frame(
    ref_cur = c("USD", "CAD"),
    spot.rate2 = c(1.25, 1),
    date2 = as.Date(c("2021-01-01", "2021-01-01"))
  )

  testthat::local_mocked_bindings(
    prepare_list_prices = function(slug, start.date, force) {
      prepared_prices
    },
    .package = "cryptoTax"
  )

  result <- cryptoTax:::.fetch_usd2cad_crypto2_table(
    start.date = "2021-01-01",
    force = TRUE
  )

  expect_equal(result$CAD.rate[1], 0.8)
})

test_that("fetch_usd2cad_pricer_table normalizes fetched exchange-rate data", {
  testthat::local_mocked_bindings(
    .package = "priceR",
    historical_exchange_rates = function(...) {
      data.frame(date = "2021-01-01", rate = 1.25)
    }
  )

  result <- cryptoTax:::.fetch_usd2cad_pricer_table(
    conversion = "USD",
    currency = "CAD"
  )

  expect_s3_class(result$date, "Date")
  expect_equal(result$CAD.rate, 1.25)
})

test_that("requires_online_prices is FALSE when explicit price inputs are provided", {
  expect_false(cryptoTax:::.requires_online_prices(
    list.prices = data.frame(currency = "BTC"),
    verbose = TRUE
  ))

  expect_false(cryptoTax:::.requires_online_prices(
    coin_hist = data.frame(symbol = "BTC"),
    verbose = TRUE
  ))
})

test_that("requires_online_prices returns TRUE offline when no price inputs are available", {
  testthat::local_mocked_bindings(
    has_internet = function() FALSE,
    .package = "curl"
  )

  expect_message(
    result <- cryptoTax:::.requires_online_prices(
      list.prices = NULL,
      coin_hist = NULL,
      verbose = TRUE
    ),
    "This function requires Internet access."
  )

  expect_true(result)
})

test_that("resolve_match_prices delegates to prepare_list_prices_slugs", {
  explicit_list_prices <- data.frame(
    currency = "BTC",
    spot.rate2 = 123.45,
    date2 = as.Date("2021-01-01")
  )

  testthat::local_mocked_bindings(
    prepare_list_prices_slugs = function(...) {
      explicit_list_prices
    },
    .package = "cryptoTax"
  )

  result <- cryptoTax:::.resolve_match_prices(
    data = data.frame(
      date = as.POSIXct("2021-01-01 10:00:00", tz = "UTC"),
      currency = "BTC"
    ),
    verbose = TRUE
  )

  expect_identical(result, explicit_list_prices)
})

test_that("handle_missing_list_prices returns prices unchanged when available", {
  explicit_list_prices <- data.frame(
    currency = "BTC",
    spot.rate2 = 123.45,
    date2 = as.Date("2021-01-01")
  )

  result <- cryptoTax:::.handle_missing_list_prices(
    explicit_list_prices,
    verbose = TRUE
  )

  expect_identical(result, explicit_list_prices)
})

test_that("handle_missing_list_prices emits one message when prices are missing", {
  expect_message(
    result <- cryptoTax:::.handle_missing_list_prices(NULL, verbose = TRUE),
    "Could not reach the CoinMarketCap API at this time"
  )

  expect_null(result)
})

test_that("prepare_list_prices_slugs surfaces missing list.prices through the shared handler", {
  testthat::local_mocked_bindings(
    prepare_list_prices = function(...) NULL,
    .package = "cryptoTax"
  )

  input <- data.frame(
    date = as.POSIXct("2021-01-01 10:00:00", tz = "UTC"),
    currency = "BTC"
  )

  expect_message(
    result <- prepare_list_prices_slugs(input, verbose = TRUE),
    "Could not reach the CoinMarketCap API at this time"
  )

  expect_null(result)
})

test_that("match_prices surfaces missing list.prices through the shared handler", {
  testthat::local_mocked_bindings(
    prepare_list_prices_slugs = function(...) NULL,
    .package = "cryptoTax"
  )

  tx <- data.frame(
    date = as.POSIXct("2021-01-01 10:00:00", tz = "UTC"),
    currency = "BTC",
    quantity = 1
  )

  expect_message(
    result <- match_prices(
      tx,
      coin_hist = data.frame(symbol = "BTC"),
      verbose = TRUE
    ),
    "Could not reach the CoinMarketCap API at this time"
  )

  expect_null(result)
})


