options(scipen = 999)

# Prepare list of coins ####
my.coins <- c("BTC", "ETH", "ADA", "CRO", "LTC", "USDC", 
              "BUSD", "CEL", "PRE", "ETHW")
list.prices <- prepare_list_prices(coins = my.coins, start.date = "2021-01-01")

# Tests start here ####

test_that("shakepay", {
  x <- format_shakepay(data_shakepay)
  formatted.shakepay <- suppressWarnings(as.data.frame(format_ACB(x)))
  expect_snapshot(formatted.shakepay)
})

test_that("CDC", {
  x <- format_CDC(data_CDC)
  formatted.CDC <- suppressWarnings(suppressMessages(as.data.frame(format_ACB(x))))
  expect_snapshot(formatted.CDC)
})

test_that("blockfi", {
  x <- format_blockfi(data_blockfi, list.prices = list.prices)
  formatted.blockfi <- suppressWarnings(as.data.frame(format_ACB(x)))
  expect_snapshot(formatted.blockfi)
})

test_that("celsius", {
  x <- format_celsius(data_celsius)
  formatted.celsius <- suppressWarnings(as.data.frame(format_ACB(x)))
  expect_snapshot(formatted.celsius)
})

test_that("adalite", {
  x <- format_adalite(data_adalite, list.prices = list.prices)
  formatted.adalite <- suppressWarnings(as.data.frame(format_ACB(x)))
  expect_snapshot(formatted.adalite)
})

test_that("coinsmart", {
  x <- format_coinsmart(data_coinsmart, list.prices = list.prices)
  formatted.coinsmart <- suppressWarnings(as.data.frame(format_ACB(x)))
  expect_snapshot(formatted.coinsmart)
})

test_that("presearch", {
  x <- format_presearch(data_presearch, list.prices = list.prices)
  formatted.presearch <- suppressWarnings(as.data.frame(format_ACB(x)))
  expect_snapshot(formatted.presearch)
})

test_that("newton", {
  x <- format_newton(data_newton)
  formatted.newton <- suppressWarnings(as.data.frame(format_ACB(x)))
  expect_snapshot(formatted.newton)
})

# Message: The first transaction for this currency cannot be a sale. 
# Please make sure you are not missing any transactions.
# Can't fix: verified (because it is withdrawals, it cannot
# have purchase transactions before.
# test_that("exodus", {
#   x <- format_exodus(data_exodus)
#   formatted.exodus <- suppressWarnings(as.data.frame(format_ACB(x)))
#   expect_snapshot(formatted.exodus)
# })

# Message: The first transaction for this currency cannot be a sale. 
# Please make sure you are not missing any transactions.
# Can't fix: verified (because it's a trading pair, there will always be 
# coin that cannot be a purchase before.
# test_that("binance", {
#   formatted.binance <- format_binance(data_binance, list.prices = list.prices)
#   expect_snapshot(format_ACB(formatted.binance))
# })

# Message: The first transaction for this currency cannot be a sale. 
# Please make sure you are not missing any transactions.
# Can't fix: verified (because it is withdrawals, it cannot
# have purchase transactions before.
# test_that("binance withdrawals", {
#   formatted.binance.withdrawals <- format_binance_withdrawals(
#     data_binance_withdrawals, list.prices = list.prices)
#   expect_snapshot(format_ACB(formatted.binance.withdrawals))
# })

test_that("CDC exchange rewards", {
  x <- format_CDC_exchange_rewards(data_CDC_exchange_rewards, list.prices = list.prices)
  formatted.binance.rewards <- suppressWarnings(as.data.frame(format_ACB(x)))
  expect_snapshot(formatted.binance.rewards)
})

# Message: The first transaction for this currency cannot be a sale. 
# Please make sure you are not missing any transactions.
# Can't fix: verified (because it's a trading pair, there will always be 
# coin that cannot be a purchase before.
# test_that("CDC exchange trades", {
#   x <- format_CDC_exchange_trades(data_CDC_exchange_trades, list.prices = list.prices)
#   formatted.binance.trades <- suppressWarnings(as.data.frame(format_ACB(x)))
#   expect_snapshot(formatted.binance.trades)
# })

test_that("CDC wallet", {
  x <- format_CDC_wallet(data_CDC_wallet, list.prices = list.prices)
  formatted.CDC.wallet <- suppressWarnings(as.data.frame(format_ACB(x)))
  expect_snapshot(formatted.CDC.wallet)
})
