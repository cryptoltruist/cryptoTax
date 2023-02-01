options(scipen = 999)

# Prepare list of coins ####
my.coins <- c("BTC", "ETH", "ADA", "CRO", "LTC", "USDC", 
              "BUSD", "CEL", "PRE", "ETHW")
list.prices <- prepare_list_prices(coins = my.coins, start.date = "2021-01-01")

# Generics ####

test_that("generic1 - capitals", {
  expect_snapshot(format_generic(data_generic1))
})

test_that("generic2 - different names", {
  expect_snapshot(
    format_generic(
      data_generic2,
      date = "Date.Transaction",
      currency = "Coin",
      quantity = "Amount",
      total.price = "Price",
      transaction = "Type",
      fees = "Fee",
      exchange = "Platform"
    ))
})

test_that("generic3 - calculate total.price", {
  expect_snapshot(format_generic(data_generic3))
})

test_that("generic4 - fetch spot.rate", {
  expect_snapshot(format_generic(data_generic4, list.prices = list.prices))
})

# Other exchanges ####

test_that("shakepay", {
  expect_snapshot(format_shakepay(data_shakepay))
})

test_that("CDC", {
  expect_snapshot(suppressMessages(format_CDC(data_CDC)))
})

test_that("adalite", {
  expect_snapshot(format_adalite(data_adalite, list.prices = list.prices))
})

test_that("binance", {
  expect_snapshot(format_binance(data_binance, list.prices = list.prices))
})

test_that("binance withdrawals", {
  expect_snapshot(format_binance_withdrawals(data_binance_withdrawals, list.prices = list.prices))
})

test_that("blockfi", {
  expect_snapshot(format_blockfi(data_blockfi, list.prices = list.prices))
})

test_that("CDC exchange rewards", {
  expect_snapshot(format_CDC_exchange_rewards(data_CDC_exchange_rewards, list.prices = list.prices))
})

test_that("CDC exchange trades", {
  expect_snapshot(format_CDC_exchange_trades(data_CDC_exchange_trades, list.prices = list.prices))
})

test_that("CDC wallet", {
  expect_snapshot(format_CDC_wallet(data_CDC_wallet, list.prices = list.prices))
})

test_that("celsius", {
  expect_snapshot(format_celsius(data_celsius))
})

test_that("coinsmart", {
  expect_snapshot(format_coinsmart(data_coinsmart, list.prices = list.prices))
})

test_that("exodus", {
  expect_snapshot(format_exodus(data_exodus, list.prices = list.prices))
})

test_that("exodus", {
  expect_snapshot(format_presearch(data_presearch, list.prices = list.prices))
})

test_that("newton", {
  expect_snapshot(format_newton(data_newton))
})

# Add test: timezone!