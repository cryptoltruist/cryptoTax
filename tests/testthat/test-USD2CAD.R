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
    clear_pricing_cache()
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

test_that("resolve_list_prices ignores cached objects with the wrong schema", {
  local({
    clear_pricing_cache()
    list.prices <<- data.frame(date = as.Date("2021-01-01"), CAD.rate = 1.25)
    on.exit(clear_pricing_cache(), add = TRUE)
    on.exit(rm(list = "list.prices", envir = .GlobalEnv), add = TRUE)

    result <- cryptoTax:::.resolve_list_prices(
      force = FALSE,
      list.prices = NULL,
      verbose = TRUE
    )

    expect_null(result)
  })
})

test_that("resolve_list_prices reports package-cache reuse with the new message", {
  local({
    clear_pricing_cache()
    on.exit(clear_pricing_cache(), add = TRUE)

    cryptoTax:::.set_cached_pricing_object(
      "list.prices",
      data.frame(
        currency = "BTC",
        spot.rate2 = 1,
        date2 = as.Date("2021-01-01")
      )
    )

    expect_message(
      result <- cryptoTax:::.resolve_list_prices(
        force = FALSE,
        list.prices = NULL,
        verbose = TRUE
      ),
      "Using cached 'list.prices'"
    )

    expect_true(is.data.frame(result))
  })
})

test_that("resolve_list_prices warns when reusing the legacy global cache path", {
  local({
    clear_pricing_cache()
    on.exit(clear_pricing_cache(), add = TRUE)

    assign(
      "list.prices",
      data.frame(
        currency = "BTC",
        spot.rate2 = 1,
        date2 = as.Date("2021-01-01")
      ),
      envir = .GlobalEnv
    )
    on.exit(rm(list = "list.prices", envir = .GlobalEnv), add = TRUE)

    expect_message(
      result <- cryptoTax:::.resolve_list_prices(
        force = FALSE,
        list.prices = NULL,
        verbose = TRUE
      ),
      "Using deprecated legacy '.GlobalEnv' cache for 'list.prices'"
    )

    expect_true(is.data.frame(result))
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

test_that("resolve_coins_list reports package-cache reuse with the new message", {
  local({
    clear_pricing_cache()
    on.exit(clear_pricing_cache(), add = TRUE)

    cached_coin_list <- data.frame(
      slug = c("bitcoin", "ethereum"),
      symbol = c("BTC", "ETH"),
      stringsAsFactors = FALSE
    )
    cryptoTax:::.set_cached_pricing_object("coins.list", cached_coin_list)

    expect_message(
      result <- cryptoTax:::.resolve_coins_list(
        force = FALSE,
        coins.list = NULL,
        verbose = TRUE
      ),
      "Using cached 'coins.list'"
    )

    expect_identical(result, cached_coin_list)
  })
})

test_that("resolve_coins_list warns when reusing the legacy global cache path", {
  local({
    clear_pricing_cache()
    on.exit(clear_pricing_cache(), add = TRUE)

    cached_coin_list <- data.frame(
      slug = c("bitcoin", "ethereum"),
      symbol = c("BTC", "ETH"),
      stringsAsFactors = FALSE
    )
    assign("coins.list", cached_coin_list, envir = .GlobalEnv)
    on.exit(rm(list = "coins.list", envir = .GlobalEnv), add = TRUE)

    expect_message(
      result <- cryptoTax:::.resolve_coins_list(
        force = FALSE,
        coins.list = NULL,
        verbose = TRUE
      ),
      "Using deprecated legacy '.GlobalEnv' cache for 'coins.list'"
    )

    expect_identical(result, cached_coin_list)
  })
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

test_that("resolve_usd2cad_table refetches when cached rates lack the requested conversion column", {
  refreshed_rates <- data.frame(
    date = as.Date("2021-01-01"),
    USD = 1.25,
    CAD = 1
  )

  local({
    clear_pricing_cache()
    USD2CAD.table <<- data.frame(
      date = as.Date("2021-01-01"),
      CAD.rate = 1.25
    )
    on.exit(clear_pricing_cache(), add = TRUE)
    on.exit(rm(list = "USD2CAD.table", envir = .GlobalEnv), add = TRUE)

    testthat::local_mocked_bindings(
      cur2CAD_table = function() refreshed_rates,
      .package = "cryptoTax"
    )

    result <- cryptoTax:::.resolve_usd2cad_table(
      force = FALSE,
      USD2CAD.table = NULL,
      conversion = "USD"
    )

    expect_identical(result, refreshed_rates)
  })
})

test_that("resolve_usd2cad_table reports package-cache reuse with the new message", {
  local({
    clear_pricing_cache()
    on.exit(clear_pricing_cache(), add = TRUE)

    cryptoTax:::.set_cached_pricing_object(
      "USD2CAD.table",
      data.frame(
        date = as.Date("2021-01-01"),
        USD = 1.25,
        CAD = 1
      )
    )

    expect_message(
      result <- cryptoTax:::.resolve_usd2cad_table(
        force = FALSE,
        USD2CAD.table = NULL,
        conversion = "USD"
      ),
      "Using cached 'USD2CAD.table'"
    )

    expect_true(is.data.frame(result))
  })
})

test_that("resolve_usd2cad_table warns when reusing the legacy global cache path", {
  local({
    clear_pricing_cache()
    on.exit(clear_pricing_cache(), add = TRUE)

    assign(
      "USD2CAD.table",
      data.frame(
        date = as.Date("2021-01-01"),
        USD = 1.25,
        CAD = 1
      ),
      envir = .GlobalEnv
    )
    on.exit(rm(list = "USD2CAD.table", envir = .GlobalEnv), add = TRUE)

    expect_message(
      result <- cryptoTax:::.resolve_usd2cad_table(
        force = FALSE,
        USD2CAD.table = NULL,
        conversion = "USD"
      ),
      "Using deprecated legacy '.GlobalEnv' cache for 'USD2CAD.table'"
    )

    expect_true(is.data.frame(result))
  })
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

test_that("cache_usd2cad_table returns cached rates unchanged", {
  local({
    rates <- data.frame(
      date = as.Date("2021-01-01"),
      CAD.rate = 1.25
    )

    result <- cryptoTax:::.cache_usd2cad_table(rates)

    expect_identical(result, rates)
    expect_equal(pricing_cache("USD2CAD.table")$CAD.rate, 1.25)
  })
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

test_that("USD2CAD_crypto2 reuses cached package rates without refetching", {
  local({
    clear_pricing_cache()
    on.exit(clear_pricing_cache(), add = TRUE)

    cached_rates <- data.frame(
      date2 = as.Date("2021-01-01"),
      CAD.rate = 1.25
    )
    cryptoTax:::.set_cached_pricing_object("USD2CAD.table", cached_rates)

    input <- data.frame(
      date = as.Date("2021-01-01")
    )

    testthat::local_mocked_bindings(
      .package = "cryptoTax",
      .fetch_usd2cad_crypto2_table = function(...) {
        stop("should not refetch")
      }
    )

    expect_message(
      result <- USD2CAD_crypto2(input, force = FALSE),
      "Using cached 'USD2CAD.table'"
    )

    expect_equal(result$CAD.rate, 1.25)
  })
})

test_that("USD2CAD_priceR reuses cached package rates without refetching", {
  local({
    clear_pricing_cache()
    on.exit(clear_pricing_cache(), add = TRUE)

    cached_rates <- data.frame(
      date = as.Date("2021-01-01"),
      CAD.rate = 1.25
    )
    cryptoTax:::.set_cached_pricing_object("USD2CAD.table", cached_rates)

    input <- data.frame(
      date = as.Date("2021-01-01")
    )

    testthat::local_mocked_bindings(
      .package = "curl",
      has_internet = function() TRUE
    )

    testthat::local_mocked_bindings(
      .package = "cryptoTax",
      .fetch_usd2cad_pricer_table = function(...) {
        stop("should not refetch")
      }
    )

    result <- expect_no_message(USD2CAD_priceR(input))

    expect_equal(result$CAD.rate, 1.25)
  })
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

test_that("handle_invalid_match_prices returns prices unchanged when join columns are available", {
  explicit_list_prices <- data.frame(
    currency = "BTC",
    spot.rate2 = 123.45,
    date2 = as.Date("2021-01-01")
  )

  result <- cryptoTax:::.handle_invalid_match_prices(
    explicit_list_prices,
    verbose = TRUE
  )

  expect_identical(result, explicit_list_prices)
})

test_that("handle_invalid_match_prices emits one message when join columns are missing", {
  expect_message(
    result <- cryptoTax:::.handle_invalid_match_prices(
      data.frame(currency = "BTC"),
      verbose = TRUE
    ),
    "Could not use 'list.prices' because it must contain 'currency', 'spot.rate2', and 'date2'."
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

test_that("match_prices rejects explicit list.prices tables that are not joinable", {
  tx <- data.frame(
    date = as.POSIXct("2021-01-01 10:00:00", tz = "UTC"),
    currency = "BTC",
    quantity = 1
  )

  expect_message(
    result <- match_prices(
      tx,
      list.prices = data.frame(currency = "BTC"),
      verbose = TRUE
    ),
    "Could not use 'list.prices' because it must contain 'currency', 'spot.rate2', and 'date2'."
  )

  expect_null(result)
})

test_that("pricing cache helpers detect and reuse cached objects safely", {
  local({
    cache_name <- "pricing.cache.helper.test"
    cache_env <- cryptoTax:::.pricing_cache_env()

    expect_false(cryptoTax:::.has_cached_pricing_object(cache_name))
    expect_false(cryptoTax:::.can_reuse_cached_pricing_object(cache_name))

    assign(cache_name, data.frame(
      currency = "BTC",
      spot.rate2 = 1,
      date2 = as.Date("2021-01-01")
    ), envir = cache_env)
    on.exit(rm(list = cache_name, envir = cache_env), add = TRUE)

    expect_true(cryptoTax:::.has_cached_pricing_object(cache_name))
    expect_true(cryptoTax:::.can_reuse_cached_pricing_object(cache_name))
    expect_false(cryptoTax:::.can_reuse_cached_pricing_object(cache_name, force = TRUE))
    expect_identical(
      cryptoTax:::.get_cached_pricing_object(cache_name),
      get(cache_name, envir = cache_env)
    )
  })
})

test_that("pricing cache helpers can treat NULL caches as present when requested", {
  local({
    cache_name <- "pricing.cache.helper.null.test"
    cache_env <- cryptoTax:::.pricing_cache_env()
    assign(cache_name, NULL, envir = cache_env)
    on.exit(rm(list = cache_name, envir = cache_env), add = TRUE)

    expect_false(cryptoTax:::.has_cached_pricing_object(cache_name))
    expect_true(cryptoTax:::.has_cached_pricing_object(cache_name, allow_null = TRUE))
    expect_true(cryptoTax:::.can_reuse_cached_pricing_object(cache_name, allow_null = TRUE))
  })
})

test_that("pricing cache helpers use the package-owned cache ahead of local objects", {
  local({
    cache_name <- "pricing.cache.helper.scope.test"
    cache_env <- cryptoTax:::.pricing_cache_env()

    on.exit(rm(list = cache_name, envir = cache_env), add = TRUE)

    expect_false(exists(cache_name, envir = cache_env, inherits = FALSE))

    local_value <- data.frame(
      currency = "BTC",
      spot.rate2 = 1,
      date2 = as.Date("2021-01-01")
    )
    assign(cache_name, local_value, envir = environment())

    expect_false(cryptoTax:::.has_cached_pricing_object(cache_name))

    cached_value <- data.frame(
      currency = "ETH",
      spot.rate2 = 2,
      date2 = as.Date("2021-01-02")
    )
    cryptoTax:::.set_cached_pricing_object(cache_name, cached_value)

    expect_true(cryptoTax:::.has_cached_pricing_object(cache_name))
    expect_identical(
      cryptoTax:::.get_cached_pricing_object(cache_name),
      cached_value
    )
    expect_identical(get(cache_name, envir = environment()), local_value)
  })
})

test_that("pricing cache helpers can fall back to legacy global cache objects", {
  local({
    cache_name <- "pricing.cache.helper.legacy.test"
    cache_env <- cryptoTax:::.pricing_cache_env()

    on.exit(rm(list = cache_name, envir = .GlobalEnv), add = TRUE)

    expect_false(exists(cache_name, envir = cache_env, inherits = FALSE))

    legacy_value <- data.frame(
      currency = "BTC",
      spot.rate2 = 5,
      date2 = as.Date("2021-01-03")
    )
    assign(cache_name, legacy_value, envir = .GlobalEnv)

    expect_true(cryptoTax:::.has_cached_pricing_object(cache_name))
    expect_identical(
      cryptoTax:::.get_cached_pricing_object(cache_name),
      legacy_value
    )
  })
})

test_that("reuse_cached_pricing_object validates cached values before reusing them", {
  local({
    clear_pricing_cache()
    on.exit(clear_pricing_cache(), add = TRUE)

    cryptoTax:::.set_cached_pricing_object(
      "list.prices",
      data.frame(date = as.Date("2021-01-01"))
    )

    result <- cryptoTax:::.reuse_cached_pricing_object(
      name = "list.prices",
      validator = cryptoTax:::.is_valid_list_prices_table,
      verbose = TRUE
    )

    expect_null(result)
  })
})

test_that("pricing_cache inspects the package-owned cache and legacy fallback", {
  local({
    clear_pricing_cache()

    cache_value <- data.frame(
      currency = "BTC",
      spot.rate2 = 7,
      date2 = as.Date("2021-01-04")
    )
    cryptoTax:::.set_cached_pricing_object("list.prices", cache_value)
    assign("USD2CAD.table", data.frame(date = as.Date("2021-01-04"), USD = 1.2), envir = .GlobalEnv)
    on.exit(rm(list = "USD2CAD.table", envir = .GlobalEnv), add = TRUE)

    cache_state <- pricing_cache()
    expect_identical(cache_state$list.prices, cache_value)
    expect_null(cache_state$USD2CAD.table)

    expect_identical(pricing_cache("list.prices"), cache_value)
    expect_true(is.data.frame(pricing_cache("USD2CAD.table", include.legacy = TRUE)))
  })
})

test_that("clear_pricing_cache removes package cache entries without touching globals", {
  local({
    cache_value <- data.frame(
      currency = "BTC",
      spot.rate2 = 8,
      date2 = as.Date("2021-01-05")
    )
    cryptoTax:::.set_cached_pricing_object("list.prices", cache_value)
    assign("list.prices", cache_value, envir = .GlobalEnv)
    on.exit(rm(list = "list.prices", envir = .GlobalEnv), add = TRUE)

    expect_identical(pricing_cache("list.prices"), cache_value)

    clear_pricing_cache("list.prices")

    expect_null(pricing_cache("list.prices"))
    expect_true(exists("list.prices", envir = .GlobalEnv, inherits = FALSE))
  })
})

test_that("match_prices ignores cached list.prices objects with the wrong schema", {
  local({
    clear_pricing_cache()
    list.prices <<- data.frame(date = as.Date("2021-01-01"), CAD.rate = 1.25)
    on.exit(clear_pricing_cache(), add = TRUE)
    on.exit(rm(list = "list.prices", envir = .GlobalEnv), add = TRUE)

    testthat::local_mocked_bindings(
      has_internet = function() FALSE,
      .package = "curl"
    )

    tx <- data.frame(
      date = as.POSIXct("2021-01-01 10:00:00", tz = "UTC"),
      currency = "BTC",
      quantity = 1
    )

    expect_message(
      result <- match_prices(tx, verbose = TRUE),
      "This function requires Internet access."
    )

    expect_null(result)
  })
})

test_that("cur2CAD_table returns NULL cleanly when the Bank of Canada fetch fails", {
  testthat::local_mocked_bindings(
    .package = "curl",
    has_internet = function() TRUE
  )

  testthat::local_mocked_bindings(
    .package = "utils",
    read.csv = function(...) stop("fetch failed")
  )

  expect_message(
    result <- cur2CAD_table(),
    "Could not fetch exchange rates from Bank of Canada"
  )

  expect_null(result)
})


