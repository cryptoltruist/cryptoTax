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

