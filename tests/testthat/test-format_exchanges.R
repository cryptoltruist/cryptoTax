testthat::skip_on_cran()

options(scipen = 999)

list.prices <- list_prices_example

list2env(
  stats::setNames(.test_exchange_data(), paste0("data_", .test_exchange_names)),
  envir = environment()
)

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
    )
  )
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

test_that("newton", {
  expect_snapshot(format_newton(data_newton))
})

test_that("pooltool", {
  expect_snapshot(format_pooltool(data_pooltool))
})

test_that("CDC", {
  expect_snapshot(suppressMessages(format_CDC(data_CDC)))
})

test_that("celsius", {
  expect_snapshot(format_celsius(data_celsius))
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

test_that("CDC exchange all-transactions export matches fee rows without creating NA placeholders", {
  # These adjacent integer IDs collapse to the same double precision value in R,
  # which used to make TRADE_FEE rows drift away from their matching BUY rows.
  trade_ids <- as.numeric(c("9007199254740992", "9007199254740993"))

  raw <- data.frame(
    Journal.ID = c(1, 2, 3, 4, 5, 6),
    Time..UTC. = c(
      "2024-12-30 20:19:54.721",
      "2024-12-30 20:19:54.721",
      "2024-12-30 20:19:54.721",
      "2024-12-30 20:19:55.470",
      "2024-12-30 20:19:55.470",
      "2024-12-30 20:19:55.470"
    ),
    Event.Date = c(
      "2024-12-30",
      "2024-12-30",
      "2024-12-30",
      "2024-12-30",
      "2024-12-30",
      "2024-12-30"
    ),
    Journal.Type = c("TRADING", "TRADING", "TRADE_FEE", "TRADING", "TRADING", "TRADE_FEE"),
    Instrument = c("USD_Stable_Coin", "BTC", "USD_Stable_Coin", "USD_Stable_Coin", "BTC", "USD_Stable_Coin"),
    Taker.Side = c(NA, NA, NA, NA, NA, NA),
    Side = c("BUY", "SELL", "NULL_VAL", "BUY", "SELL", "NULL_VAL"),
    Transaction.Quantity = c(3357.9189688, -0.03541, -5.0368784532, 1441.4111360, -0.0152, -2.1621167040),
    Transaction.Cost = c(3357.9189688, -0.03541, -5.0368784532, 1441.4111360, -0.0152, -2.1621167040),
    Realized.PNL = c(0, 0, 0, 0, 0, 0),
    Order.ID = c(1, 1, 1, 2, 2, 2),
    Trade.ID = c(trade_ids[[1]], trade_ids[[1]], trade_ids[[1]], trade_ids[[2]], trade_ids[[2]], trade_ids[[2]]),
    Trade.Match.ID = c(11, 11, 11, 12, 12, 12),
    Client.Order.Id = c("a", "a", "a", "b", "b", "b"),
    check.names = TRUE,
    stringsAsFactors = FALSE
  )

  formatted <- format_CDC_exchange(raw, list.prices = list.prices)
  fee.rows <- formatted[!is.na(formatted$fees.quantity), , drop = FALSE]

  expect_equal(nrow(formatted), 4L)
  expect_false(any(is.na(formatted$date)))
  expect_false(any(is.na(formatted$currency)))
  expect_false(any(is.na(formatted$quantity)))
  expect_false(any(is.na(formatted$transaction)))
  expect_equal(nrow(fee.rows), 2L)
  expect_true(all(fee.rows$transaction == "buy"))
})

test_that("CDC wallet", {
  expect_snapshot(format_CDC_wallet(data_CDC_wallet, list.prices = list.prices))
})

test_that("coinsmart", {
  expect_snapshot(format_coinsmart(data_coinsmart, list.prices = list.prices))
})

test_that("exodus", {
  expect_snapshot(format_exodus(data_exodus, list.prices = list.prices))
})

test_that("presearch", {
  expect_snapshot(format_presearch(data_presearch, list.prices = list.prices))
})

test_that("gemini", {
  expect_snapshot(format_gemini(data_gemini, list.prices = list.prices))
})

test_that("uphold", {
  expect_snapshot(format_uphold(data_uphold, list.prices = list.prices))
})

# Test format_detect() ####

test_that("format_detect single", {
  expect_snapshot(format_detect(data_shakepay))
  expect_snapshot(format_detect(data_newton))
  expect_snapshot(format_detect(data_pooltool))
  expect_snapshot(format_detect(data_CDC))
  expect_snapshot(format_detect(data_celsius))
  expect_snapshot(format_detect(data_adalite, list.prices = list.prices))
  expect_snapshot(format_detect(data_binance, list.prices = list.prices))
  expect_snapshot(format_detect(data_binance_withdrawals, list.prices = list.prices))
  expect_snapshot(format_detect(data_blockfi, list.prices = list.prices))
  expect_snapshot(format_detect(data_CDC_exchange_rewards, list.prices = list.prices))
  expect_snapshot(format_detect(data_CDC_exchange_trades, list.prices = list.prices))
  expect_snapshot(format_detect(data_CDC_wallet, list.prices = list.prices))
  expect_snapshot(format_detect(data_coinsmart, list.prices = list.prices))
  expect_snapshot(format_detect(data_exodus, list.prices = list.prices))
  expect_snapshot(format_detect(data_presearch, list.prices = list.prices))
  expect_snapshot(format_detect(data_gemini, list.prices = list.prices))
  expect_snapshot(format_detect(data_uphold, list.prices = list.prices))
})

test_that("format_detect list", {
  expect_snapshot(format_detect(list(data_shakepay, data_newton, data_adalite),
    list.prices = list.prices
  ))
})

test_that("format_exchanges public wrapper", {
  expect_snapshot(format_exchanges(list(data_shakepay, data_newton, data_adalite),
    list.prices = list.prices
  ))
})

test_that("format_exchanges public wrapper with multiple arguments", {
  expect_snapshot(format_exchanges(
    data_shakepay,
    data_newton,
    data_adalite,
    list.prices = list.prices
  ))
})

test_that("format_exchanges mixed public wrapper", {
  expect_snapshot(format_exchanges(list(
    format_shakepay(data_shakepay),
    data_newton,
    data_adalite[0, ]
  ),
  list.prices = list.prices
  ))
})

test_that("format_exchanges surfaces malformed explicit prices without relabeling them as API failures", {
  messages <- testthat::capture_messages(
    result <- format_exchanges(
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

test_that("format_exchanges does not silently return partial results for malformed prices in mixed inputs", {
  messages <- testthat::capture_messages(
    result <- format_exchanges(
      data_shakepay,
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
})

test_that("format_exchanges rejects malformed already formatted inputs with a schema error", {
  invalid_formatted <- data.frame(
    date = as.POSIXct("2021-01-01 00:00:00", tz = "UTC"),
    currency = "BTC",
    quantity = 1,
    transaction = "buy",
    total.price = 100,
    stringsAsFactors = FALSE
  )

  expect_error(
    format_exchanges(list(invalid_formatted, data_newton)),
    "Invalid formatted transaction input. Missing required columns: spot.rate, exchange."
  )
})

# Add test: timezone!

