testthat::skip_on_cran()

options(scipen = 999)

list.prices <- list_prices_example

# Tests start here ####

test_that("shakepay", {
  x <- format_shakepay(data_shakepay)
  formatted.shakepay <- as.data.frame(format_ACB(x, verbose = FALSE))
  expect_snapshot(formatted.shakepay)
})

test_that("newton", {
  x <- format_newton(data_newton)
  formatted.newton <- as.data.frame(format_ACB(x, verbose = FALSE))
  expect_snapshot(formatted.newton)
})

test_that("pooltool", {
  x <- format_pooltool(data_pooltool)
  formatted.pooltool <- as.data.frame(format_ACB(x, verbose = FALSE))
  expect_snapshot(formatted.pooltool)
})

test_that("CDC", {
  x <- format_CDC(data_CDC)
  formatted.CDC <- suppressMessages(as.data.frame(format_ACB(x, verbose = FALSE)))
  expect_snapshot(formatted.CDC)
})

test_that("celsius", {
  x <- format_celsius(data_celsius)
  formatted.celsius <- as.data.frame(format_ACB(x, verbose = FALSE))
  expect_snapshot(formatted.celsius)
})

test_that("blockfi", {
  x <- format_blockfi(data_blockfi, list.prices = list.prices)
  formatted.blockfi <- as.data.frame(format_ACB(x, verbose = FALSE))
  expect_snapshot(formatted.blockfi)
})

test_that("adalite", {
  x <- format_adalite(data_adalite, list.prices = list.prices)
  formatted.adalite <- as.data.frame(format_ACB(x, verbose = FALSE))
  expect_snapshot(formatted.adalite)
})

test_that("coinsmart", {
  x <- format_coinsmart(data_coinsmart, list.prices = list.prices)
  formatted.coinsmart <- as.data.frame(format_ACB(x, verbose = FALSE))
  expect_snapshot(formatted.coinsmart)
})

test_that("presearch", {
  x <- format_presearch(data_presearch, list.prices = list.prices)
  formatted.presearch <- as.data.frame(format_ACB(x, verbose = FALSE))
  expect_snapshot(formatted.presearch)
})

test_that("CDC exchange rewards", {
  x <- format_CDC_exchange_rewards(data_CDC_exchange_rewards, list.prices = list.prices)
  formatted.binance.rewards <- as.data.frame(format_ACB(x, verbose = FALSE))
  expect_snapshot(formatted.binance.rewards)
})

test_that("CDC wallet", {
  x <- format_CDC_wallet(data_CDC_wallet, list.prices = list.prices)
  formatted.CDC.wallet <- as.data.frame(format_ACB(x, verbose = FALSE))
  expect_snapshot(formatted.CDC.wallet)
})

test_that("uphold", {
  x <- format_uphold(data_uphold, list.prices = list.prices)
  formatted.uphold <- as.data.frame(format_ACB(x, verbose = FALSE))
  expect_snapshot(formatted.uphold)
})

test_that("gemini", {
  x <- format_gemini(data_gemini, list.prices = list.prices)
  x <- .acb_seed_buy(
    x,
    date = "2021-04-08 22:22:22",
    currency = "LTC",
    quantity = 1,
    total.price = 286,
    exchange = "gemini"
  )
  formatted.gemini <- as.data.frame(format_ACB(x, verbose = FALSE))
  expect_snapshot(formatted.gemini)
})

test_that("exodus", {
  x <- format_exodus(data_exodus, list.prices = list.prices)
  x <- .acb_seed_from_existing(x)
  formatted.exodus <- as.data.frame(format_ACB(x, verbose = FALSE))
  expect_snapshot(formatted.exodus)
})

test_that("binance", {
  x <- format_binance(data_binance, list.prices = list.prices)
  x <- .acb_seed_buy(
    x,
    date = "2021-03-08 22:22:22",
    currency = "ETH",
    quantity = 1,
    total.price = 3098.137539,
    exchange = "binance"
  ) %>%
    .acb_seed_buy(
      date = "2021-03-08 22:22:22",
      currency = "USDC",
      quantity = 5.77124200,
      total.price = 7.736523,
      spot.rate = 1.340530,
      exchange = "binance"
    )
  formatted.binance <- as.data.frame(format_ACB(x, verbose = FALSE))
  expect_snapshot(formatted.binance)
})

test_that("binance withdrawals", {
  x <- format_binance_withdrawals(data_binance_withdrawals, list.prices = list.prices)
  x <- .acb_seed_from_existing(x)
  formatted.binance.withdrawals <- as.data.frame(format_ACB(x, verbose = FALSE))
  expect_snapshot(formatted.binance.withdrawals)
})

test_that("CDC exchange trades", {
  x <- format_CDC_exchange_trades(data_CDC_exchange_trades, list.prices = list.prices)
  x <- .acb_seed_buy(
    x,
    date = "2021-03-08 22:22:22",
    currency = "ETH",
    quantity = 1,
    total.price = 3098.137539,
    exchange = "CDC.exchange"
  )
  formatted.CDC.exchange.trades <- as.data.frame(format_ACB(x, verbose = FALSE))
  expect_snapshot(formatted.CDC.exchange.trades)
})

test_that("format_ACB keeps currency pools separate across a mixed multi-asset history", {
  data <- data.frame(
    date = as.POSIXct(c(
      "2021-01-01 00:00:00",
      "2021-01-02 00:00:00",
      "2021-01-03 00:00:00",
      "2021-01-04 00:00:00"
    ), tz = "UTC"),
    currency = c("BTC", "ETH", "BTC", "ETH"),
    quantity = c(1, 2, 0.4, 1),
    total.price = c(100, 200, 60, 150),
    spot.rate = c(100, 100, 150, 150),
    transaction = c("buy", "buy", "sell", "sell"),
    exchange = "manual",
    rate.source = "manual",
    stringsAsFactors = FALSE
  )

  result <- as.data.frame(format_ACB(data, sup.loss = FALSE, verbose = FALSE))

  btc <- result[result$currency == "BTC", ]
  eth <- result[result$currency == "ETH", ]

  expect_equal(btc$total.quantity, c(1, 0.6))
  expect_equal(btc$ACB, c(100, 60))
  expect_equal(btc$ACB.share, c(100, 100))
  expect_equal(btc$gains, c(NA, 20))

  expect_equal(eth$total.quantity, c(2, 1))
  expect_equal(eth$ACB, c(200, 100))
  expect_equal(eth$ACB.share, c(100, 100))
  expect_equal(eth$gains, c(NA, 50))
})

test_that("format_ACB treats fee-in-kind rows as dispositions of the fee currency only", {
  data <- data.frame(
    date = as.POSIXct(c(
      "2021-01-01 00:00:00",
      "2021-01-02 00:00:00",
      "2021-01-02 00:00:00"
    ), tz = "UTC"),
    currency = c("CRO", "ETH", "CRO"),
    quantity = c(10, 1, 0.5),
    total.price = c(100, 200, 5),
    spot.rate = c(10, 200, 10),
    transaction = c("buy", "buy", "sell"),
    description = c("seed cro", "buy eth", "trading fee paid with CRO"),
    exchange = "manual",
    rate.source = "manual",
    stringsAsFactors = FALSE
  )

  result <- as.data.frame(format_ACB(data, sup.loss = FALSE, verbose = FALSE))

  cro <- result[result$currency == "CRO", ]
  eth <- result[result$currency == "ETH", ]

  expect_equal(cro$total.quantity, c(10, 9.5))
  expect_equal(cro$ACB, c(100, 95))
  expect_equal(cro$ACB.share, c(10, 10))
  expect_equal(cro$gains, c(NA, 0))

  expect_equal(eth$total.quantity, 1)
  expect_equal(eth$ACB, 200)
  expect_equal(eth$ACB.share, 200)
  expect_true(is.na(eth$gains))
})

test_that("format_ACB carries taxable revenue into later multi-asset gains while leaving fee-in-kind in its own pool", {
  data <- data.frame(
    date = as.POSIXct(c(
      "2021-01-01 00:00:00",
      "2021-01-02 00:00:00",
      "2021-01-02 00:00:00",
      "2021-01-03 00:00:00",
      "2021-01-04 00:00:00"
    ), tz = "UTC"),
    currency = c("CRO", "ETH", "CRO", "ETH", "ETH"),
    quantity = c(10, 1, 0.5, 0.2, 1),
    total.price = c(100, 200, 5, 30, 250),
    spot.rate = c(10, 200, 10, 150, 250),
    transaction = c("buy", "buy", "sell", "revenue", "sell"),
    revenue.type = c(NA, NA, NA, "staking", NA),
    description = c("seed cro", "buy eth", "trading fee paid with CRO", "staking reward", "sell eth"),
    exchange = "manual",
    rate.source = "manual",
    stringsAsFactors = FALSE
  )

  result <- as.data.frame(format_ACB(data, sup.loss = FALSE, verbose = FALSE))

  cro <- result[result$currency == "CRO", ]
  eth <- result[result$currency == "ETH", ]

  expect_equal(cro$total.quantity, c(10, 9.5))
  expect_equal(cro$gains, c(NA, 0))

  expect_equal(eth$total.quantity, c(1, 1.2, 0.2))
  expect_equal(eth$ACB, c(200, 230, 38.33333), tolerance = 1e-5)
  expect_equal(eth$ACB.share, c(200, 191.66667, 191.66667), tolerance = 1e-5)
  expect_equal(eth$gains, c(NA, NA, 58.33333), tolerance = 1e-5)
})

test_that("format_ACB keeps non-taxable revenue out of later multi-asset gains while leaving fee-in-kind in its own pool", {
  data <- data.frame(
    date = as.POSIXct(c(
      "2021-01-01 00:00:00",
      "2021-01-02 00:00:00",
      "2021-01-02 00:00:00",
      "2021-01-03 00:00:00",
      "2021-01-04 00:00:00"
    ), tz = "UTC"),
    currency = c("CRO", "ETH", "CRO", "ETH", "ETH"),
    quantity = c(10, 1, 0.5, 0.2, 1),
    total.price = c(100, 200, 5, 30, 250),
    spot.rate = c(10, 200, 10, 150, 250),
    transaction = c("buy", "buy", "sell", "revenue", "sell"),
    revenue.type = c(NA, NA, NA, "promos", NA),
    description = c("seed cro", "buy eth", "trading fee paid with CRO", "promo reward", "sell eth"),
    exchange = "manual",
    rate.source = "manual",
    stringsAsFactors = FALSE
  )

  result <- as.data.frame(format_ACB(data, sup.loss = FALSE, verbose = FALSE))

  cro <- result[result$currency == "CRO", ]
  eth <- result[result$currency == "ETH", ]

  expect_equal(cro$total.quantity, c(10, 9.5))
  expect_equal(cro$gains, c(NA, 0))

  expect_equal(eth$total.quantity, c(1, 1.2, 0.2))
  expect_equal(eth$ACB, c(200, 200, 33.33333), tolerance = 1e-5)
  expect_equal(eth$ACB.share, c(200, 166.66667, 166.66667), tolerance = 1e-5)
  expect_equal(eth$gains, c(NA, NA, 83.33333), tolerance = 1e-5)
})

test_that("format_ACB handles superficial-loss adjustments independently inside a mixed multi-asset history", {
  data <- data.frame(
    date = as.POSIXct(c(
      "2021-01-01 00:00:00",
      "2021-01-03 00:00:00",
      "2021-01-10 00:00:00",
      "2021-01-20 00:00:00",
      "2021-01-25 00:00:00",
      "2021-01-26 00:00:00"
    ), tz = "UTC"),
    currency = c("BTC", "ETH", "BTC", "BTC", "ETH", "ETH"),
    quantity = c(10, 1, 10, 4, 1, 0.5),
    total.price = c(100, 200, 50, 24, 240, 120),
    spot.rate = c(10, 200, 5, 6, 240, 240),
    transaction = c("buy", "buy", "sell", "buy", "sell", "revenue"),
    revenue.type = c(NA, NA, NA, NA, NA, "staking"),
    description = c(
      "buy btc",
      "buy eth",
      "sell btc at loss",
      "reacquire btc",
      "sell eth at gain",
      "eth staking"
    ),
    exchange = "manual",
    rate.source = "manual",
    stringsAsFactors = FALSE
  )

  result <- as.data.frame(format_ACB(data, sup.loss = TRUE, verbose = FALSE))

  btc <- result[result$currency == "BTC", ]
  eth <- result[result$currency == "ETH", ]

  expect_equal(btc$sup.loss, c(FALSE, TRUE, FALSE))
  expect_equal(btc$gains.uncorrected, c(0, -50, 0))
  expect_true(is.na(btc$gains.sup[1]))
  expect_equal(btc$gains.sup[2], -20)
  expect_true(is.na(btc$gains.sup[3]))
  expect_equal(btc$gains.excess[2], -30)
  expect_equal(btc$gains[2], -30)
  expect_equal(btc$ACB, c(100, 0, 44))
  expect_equal(btc$ACB.share, c(10, 0, 11))

  expect_equal(eth$sup.loss, c(FALSE, FALSE, FALSE))
  expect_equal(eth$gains, c(NA, 40, NA))
  expect_equal(eth$ACB, c(200, 0, 120))
  expect_equal(eth$ACB.share, c(200, 0, 240))
})

test_that("format_ACB keeps fee-adjusted superficial-loss math isolated within the affected currency pool", {
  data <- data.frame(
    date = as.POSIXct(c(
      "2021-01-01 00:00:00",
      "2021-01-03 00:00:00",
      "2021-01-10 00:00:00",
      "2021-01-20 00:00:00",
      "2021-01-25 00:00:00",
      "2021-01-26 00:00:00"
    ), tz = "UTC"),
    currency = c("BTC", "ETH", "BTC", "BTC", "ETH", "ETH"),
    quantity = c(10, 1, 10, 4, 1, 0.5),
    total.price = c(100, 200, 50, 24, 240, 120),
    spot.rate = c(10, 200, 5, 6, 240, 240),
    fees = c(5, 0, 2, 1, 0, 0),
    transaction = c("buy", "buy", "sell", "buy", "sell", "revenue"),
    revenue.type = c(NA, NA, NA, NA, NA, "staking"),
    description = c(
      "buy btc",
      "buy eth",
      "sell btc at loss",
      "reacquire btc",
      "sell eth at gain",
      "eth staking"
    ),
    exchange = "manual",
    rate.source = "manual",
    stringsAsFactors = FALSE
  )

  result <- as.data.frame(format_ACB(data, sup.loss = TRUE, verbose = FALSE))

  btc <- result[result$currency == "BTC", ]
  eth <- result[result$currency == "ETH", ]

  expect_equal(btc$sup.loss, c(FALSE, TRUE, FALSE))
  expect_equal(btc$gains.uncorrected, c(0, -57, 0))
  expect_equal(btc$gains.sup[2], -22.8, tolerance = 1e-6)
  expect_equal(btc$gains.excess[2], -34.2, tolerance = 1e-6)
  expect_equal(btc$gains[2], -34.2, tolerance = 1e-6)
  expect_equal(btc$ACB, c(105, 0, 47.8), tolerance = 1e-6)
  expect_equal(btc$ACB.share, c(10.5, 0, 11.95), tolerance = 1e-6)

  expect_equal(eth$sup.loss, c(FALSE, FALSE, FALSE))
  expect_equal(eth$gains, c(NA, 40, NA))
  expect_equal(eth$ACB, c(200, 0, 120))
  expect_equal(eth$ACB.share, c(200, 0, 240))
})

test_that("format_ACB limits day-30 superficial-loss denial to replacement shares still held while other pools keep their own gains", {
  data <- data.frame(
    date = as.POSIXct(c(
      "2021-01-01 00:00:00",
      "2021-01-03 00:00:00",
      "2021-01-10 00:00:00",
      "2021-02-09 00:00:00",
      "2021-02-12 00:00:00",
      "2021-02-15 00:00:00"
    ), tz = "UTC"),
    currency = c("BTC", "ETH", "BTC", "BTC", "ETH", "BTC"),
    quantity = c(10, 1, 10, 4, 1, 4),
    total.price = c(100, 200, 50, 24, 240, 28),
    spot.rate = c(10, 200, 5, 6, 240, 7),
    transaction = c("buy", "buy", "sell", "buy", "sell", "sell"),
    revenue.type = c(NA, NA, NA, NA, NA, NA),
    description = c(
      "buy btc",
      "buy eth",
      "sell btc at loss",
      "reacquire btc on day 30",
      "sell eth at gain",
      "sell replacement btc"
    ),
    exchange = "manual",
    rate.source = "manual",
    stringsAsFactors = FALSE
  )

  result <- as.data.frame(format_ACB(data, sup.loss = TRUE, verbose = FALSE))

  btc <- result[result$currency == "BTC", ]
  eth <- result[result$currency == "ETH", ]

  expect_equal(btc$sup.loss, c(FALSE, TRUE, FALSE, FALSE))
  expect_equal(btc$gains.uncorrected[c(2, 4)], c(-50, -16))
  expect_equal(btc$gains.sup[2], -20)
  expect_equal(btc$gains.excess[2], -30)
  expect_equal(btc$gains[c(2, 4)], c(-30, -16))
  expect_equal(btc$ACB, c(100, 0, 44, 0))
  expect_equal(btc$ACB.share, c(10, 0, 11, 0))

  expect_equal(eth$sup.loss, c(FALSE, FALSE))
  expect_equal(eth$gains, c(NA, 40))
  expect_equal(eth$ACB, c(200, 0))
  expect_equal(eth$ACB.share, c(200, 0))
})

test_that("format_ACB limits superficial-loss denial to replacement shares still held after partial replacement disposals", {
  data <- data.frame(
    date = as.POSIXct(c(
      "2021-01-01 00:00:00",
      "2021-01-03 00:00:00",
      "2021-01-10 00:00:00",
      "2021-01-20 00:00:00",
      "2021-01-25 00:00:00",
      "2021-01-26 00:00:00"
    ), tz = "UTC"),
    currency = c("BTC", "ETH", "BTC", "BTC", "BTC", "ETH"),
    quantity = c(10, 1, 10, 6, 4, 1),
    total.price = c(100, 200, 50, 36, 40, 240),
    spot.rate = c(10, 200, 5, 6, 10, 240),
    transaction = c("buy", "buy", "sell", "buy", "sell", "sell"),
    revenue.type = c(NA, NA, NA, NA, NA, NA),
    description = c(
      "buy btc",
      "buy eth",
      "sell btc at loss",
      "reacquire btc",
      "sell some replacement btc",
      "sell eth at gain"
    ),
    exchange = "manual",
    rate.source = "manual",
    stringsAsFactors = FALSE
  )

  result <- as.data.frame(format_ACB(data, sup.loss = TRUE, verbose = FALSE))

  btc <- result[result$currency == "BTC", ]
  eth <- result[result$currency == "ETH", ]

  expect_equal(btc$sup.loss, c(FALSE, TRUE, FALSE, FALSE))
  expect_equal(btc$gains.uncorrected[c(2, 4)], c(-50, 9.333333), tolerance = 1e-6)
  expect_equal(btc$gains.sup[2], -10)
  expect_equal(btc$gains.excess[2], -40)
  expect_equal(btc$gains[c(2, 4)], c(-40, 9.333333), tolerance = 1e-6)
  expect_equal(btc$ACB, c(100, 0, 46, 15.333333), tolerance = 1e-6)
  expect_equal(btc$ACB.share, c(10, 0, 7.666667, 7.666667), tolerance = 1e-6)

  expect_equal(eth$sup.loss, c(FALSE, FALSE))
  expect_equal(eth$gains, c(NA, 40))
  expect_equal(eth$ACB, c(200, 0))
  expect_equal(eth$ACB.share, c(200, 0))
})

test_that("format_ACB does not double-count denied losses when a pool keeps pre-existing replacement shares before a later buy", {
  data <- data.frame(
    date = as.POSIXct(c(
      "2021-01-01 00:00:00",
      "2021-01-03 00:00:00",
      "2021-01-05 00:00:00",
      "2021-01-10 00:00:00",
      "2021-01-20 00:00:00",
      "2021-01-25 00:00:00"
    ), tz = "UTC"),
    currency = c("BTC", "ETH", "BTC", "BTC", "BTC", "ETH"),
    quantity = c(10, 1, 5, 10, 2, 1),
    total.price = c(100, 200, 50, 50, 12, 240),
    spot.rate = c(10, 200, 10, 5, 6, 240),
    transaction = c("buy", "buy", "buy", "sell", "buy", "sell"),
    revenue.type = c(NA, NA, NA, NA, NA, NA),
    description = c(
      "buy btc lot 1",
      "buy eth",
      "buy btc lot 2",
      "sell btc at loss",
      "buy more btc after denied loss already attached to remaining pool",
      "sell eth at gain"
    ),
    exchange = "manual",
    rate.source = "manual",
    stringsAsFactors = FALSE
  )

  result <- as.data.frame(format_ACB(data, sup.loss = TRUE, verbose = FALSE))

  btc <- result[result$currency == "BTC", ]
  eth <- result[result$currency == "ETH", ]

  expect_equal(btc$total.quantity, c(10, 15, 5, 7))
  expect_equal(btc$sup.loss, c(FALSE, FALSE, TRUE, FALSE))
  expect_equal(btc$gains.uncorrected[3], -50)
  expect_equal(btc$gains.sup[3], -35)
  expect_equal(btc$gains.excess[3], -15)
  expect_equal(btc$gains[3], -15)
  expect_equal(btc$ACB, c(100, 150, 85, 97))
  expect_equal(btc$ACB.share, c(10, 10, 17, 13.857143), tolerance = 1e-6)

  expect_equal(eth$sup.loss, c(FALSE, FALSE))
  expect_equal(eth$gains, c(NA, 40))
  expect_equal(eth$ACB, c(200, 0))
  expect_equal(eth$ACB.share, c(200, 0))
})

test_that("format_ACB can apply repeated superficial-loss treatment to multiple partial BTC sales while another pool keeps its own gain", {
  data <- data.frame(
    date = as.POSIXct(c(
      "2021-01-01 00:00:00",
      "2021-01-03 00:00:00",
      "2021-01-10 00:00:00",
      "2021-01-20 00:00:00",
      "2021-01-25 00:00:00"
    ), tz = "UTC"),
    currency = c("BTC", "ETH", "BTC", "ETH", "BTC"),
    quantity = c(20, 1, 8, 1, 4),
    total.price = c(200, 200, 40, 240, 28),
    spot.rate = c(10, 200, 5, 240, 7),
    transaction = c("buy", "buy", "sell", "sell", "sell"),
    revenue.type = c(NA, NA, NA, NA, NA),
    description = c(
      "buy btc",
      "buy eth",
      "first btc loss sale",
      "eth gain sale",
      "second btc loss sale while replacement shares still remain"
    ),
    exchange = "manual",
    rate.source = "manual",
    stringsAsFactors = FALSE
  )

  result <- as.data.frame(format_ACB(data, sup.loss = TRUE, verbose = FALSE))

  btc <- result[result$currency == "BTC", ]
  eth <- result[result$currency == "ETH", ]

  expect_equal(btc$total.quantity, c(20, 12, 8))
  expect_equal(btc$sup.loss, c(FALSE, TRUE, TRUE))
  expect_equal(btc$gains.uncorrected[c(2, 3)], c(-40, -25.333333), tolerance = 1e-6)
  expect_equal(btc$gains.sup[c(2, 3)], c(-40, -25.333333), tolerance = 1e-6)
  expect_true(all(is.na(btc$gains.excess[c(2, 3)])))
  expect_true(all(is.na(btc$gains[c(2, 3)])))
  expect_equal(btc$ACB, c(200, 160, 132), tolerance = 1e-6)
  expect_equal(btc$ACB.share, c(10, 13.333333, 16.5), tolerance = 1e-6)

  expect_equal(eth$sup.loss, c(FALSE, FALSE))
  expect_equal(eth$gains, c(NA, 40))
  expect_equal(eth$ACB, c(200, 0))
  expect_equal(eth$ACB.share, c(200, 0))
})

test_that("format_ACB returns BTC losses to deductible treatment once the replacement pool is exhausted while ETH keeps its own gain", {
  data <- data.frame(
    date = as.POSIXct(c(
      "2021-01-01 00:00:00",
      "2021-01-03 00:00:00",
      "2021-01-10 00:00:00",
      "2021-01-20 00:00:00",
      "2021-01-25 00:00:00",
      "2021-02-15 00:00:00"
    ), tz = "UTC"),
    currency = c("BTC", "ETH", "BTC", "ETH", "BTC", "BTC"),
    quantity = c(20, 1, 8, 1, 4, 8),
    total.price = c(200, 200, 40, 240, 28, 48),
    spot.rate = c(10, 200, 5, 240, 7, 6),
    transaction = c("buy", "buy", "sell", "sell", "sell", "sell"),
    revenue.type = c(NA, NA, NA, NA, NA, NA),
    description = c(
      "buy btc",
      "buy eth",
      "first btc loss sale",
      "eth gain sale",
      "second btc sale after replacement pool has shrunk",
      "final btc sale after replacement pool is exhausted"
    ),
    exchange = "manual",
    rate.source = "manual",
    stringsAsFactors = FALSE
  )

  result <- as.data.frame(format_ACB(data, sup.loss = TRUE, verbose = FALSE))

  btc <- result[result$currency == "BTC", ]
  eth <- result[result$currency == "ETH", ]

  expect_equal(btc$total.quantity, c(20, 12, 8, 0))
  expect_equal(btc$sup.loss, c(FALSE, TRUE, FALSE, FALSE))
  expect_equal(btc$gains.uncorrected[c(2, 3, 4)], c(-40, -25.333333, -58.666667), tolerance = 1e-6)
  expect_equal(btc$gains.sup[2], -40)
  expect_true(all(is.na(btc$gains.sup[c(3, 4)])))
  expect_true(all(is.na(btc$gains.excess[c(2, 3, 4)])))
  expect_true(is.na(btc$gains[2]))
  expect_equal(btc$gains[c(3, 4)], c(-25.333333, -58.666667), tolerance = 1e-6)
  expect_equal(btc$ACB, c(200, 160, 106.666667, 0), tolerance = 1e-6)
  expect_equal(btc$ACB.share, c(10, 13.333333, 13.333333, 0), tolerance = 1e-6)

  expect_equal(eth$sup.loss, c(FALSE, FALSE))
  expect_equal(eth$gains, c(NA, 40))
  expect_equal(eth$ACB, c(200, 0))
  expect_equal(eth$ACB.share, c(200, 0))
})

test_that("format_ACB never applies superficial-loss treatment to a gain just because replacement shares are later acquired", {
  data <- data.frame(
    date = as.POSIXct(c(
      "2021-01-01 00:00:00",
      "2021-01-03 00:00:00",
      "2021-01-10 00:00:00",
      "2021-01-20 00:00:00",
      "2021-01-25 00:00:00"
    ), tz = "UTC"),
    currency = c("BTC", "ETH", "BTC", "BTC", "ETH"),
    quantity = c(10, 1, 10, 4, 1),
    total.price = c(100, 200, 150, 48, 240),
    spot.rate = c(10, 200, 15, 12, 240),
    transaction = c("buy", "buy", "sell", "buy", "sell"),
    revenue.type = c(NA, NA, NA, NA, NA),
    description = c(
      "buy btc",
      "buy eth",
      "sell btc at gain",
      "reacquire btc after gain",
      "sell eth at gain"
    ),
    exchange = "manual",
    rate.source = "manual",
    stringsAsFactors = FALSE
  )

  result <- as.data.frame(format_ACB(data, sup.loss = TRUE, verbose = FALSE))

  btc <- result[result$currency == "BTC", ]
  eth <- result[result$currency == "ETH", ]

  expect_equal(btc$sup.loss, c(FALSE, FALSE, FALSE))
  expect_true(all(is.na(btc$gains.sup)))
  expect_true(all(is.na(btc$gains.excess)))
  expect_equal(btc$gains, c(NA, 50, NA))
  expect_equal(btc$ACB, c(100, 0, 48))
  expect_equal(btc$ACB.share, c(10, 0, 12))

  expect_equal(eth$sup.loss, c(FALSE, FALSE))
  expect_equal(eth$gains, c(NA, 40))
  expect_equal(eth$ACB, c(200, 0))
  expect_equal(eth$ACB.share, c(200, 0))
})

