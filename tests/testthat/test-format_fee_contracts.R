testthat::skip_on_cran()

test_that("Coinbase convert buys treat total.price as fee-inclusive and zero buy-side fees", {
  formatted <- format_coinbase(data_coinbase)
  buy.rows <- formatted[formatted$transaction == "buy" & formatted$description == "Convert", ]

  expect_true(nrow(buy.rows) > 0)
  expect_true(all(buy.rows$fees == 0))
})

test_that("CDC exchange trade buys keep fees separate from exchange-valued total.price", {
  formatted <- format_CDC_exchange_trades(
    data_CDC_exchange_trades,
    list.prices = list_prices_example
  )
  buy.rows <- formatted[formatted$transaction == "buy", ]

  expect_true(nrow(buy.rows) > 0)
  expect_true(any(!is.na(buy.rows$fees) & buy.rows$fees > 0))
  expect_true(any(!is.na(buy.rows$fees.quantity) & buy.rows$fees.quantity > 0))
  expect_true(any(!is.na(buy.rows$fees.currency)))
})

test_that("Gemini trade rows preserve separate fees instead of forcing fee-inclusive totals", {
  formatted <- format_gemini(
    data_gemini,
    list.prices = list_prices_example
  )
  trade.rows <- formatted[formatted$description %in% c("LTCBTC", "BATBTC"), ]

  expect_true(nrow(trade.rows) > 0)
  expect_true(any(!is.na(trade.rows$fees) & trade.rows$fees > 0))
  expect_true(any(!is.na(trade.rows$fees.quantity) & trade.rows$fees.quantity > 0))
  expect_true(any(!is.na(trade.rows$fees.currency)))
})

test_that("Binance trade buys keep trading fees separate from total.price", {
  formatted <- format_binance(
    data_binance,
    list.prices = list_prices_example
  )
  buy.rows <- formatted[
    formatted$transaction == "buy" &
      formatted$description %in% c("Buy", "Stablecoins Auto-Conversion"),
  ]

  expect_true(nrow(buy.rows) > 0)
  expect_true(any(!is.na(buy.rows$fees) & buy.rows$fees > 0))
  expect_true(any(!is.na(buy.rows$fees.quantity) & buy.rows$fees.quantity > 0))
  expect_true(any(!is.na(buy.rows$fees.currency)))
})

test_that("CoinSmart trade buys keep fees separate from trade totals", {
  formatted <- format_coinsmart(
    data_coinsmart,
    list.prices = list_prices_example
  )
  buy.rows <- formatted[formatted$transaction == "buy", ]

  expect_true(nrow(buy.rows) > 0)
  expect_true(any(!is.na(buy.rows$fees) & buy.rows$fees > 0))
  expect_true(any(!is.na(buy.rows$fees.quantity) & buy.rows$fees.quantity > 0))
  expect_true(any(!is.na(buy.rows$fees.currency)))
})

test_that("CDC app output does not expose a separate fees column", {
  formatted <- suppressMessages(format_CDC(data_CDC))

  expect_false("fees" %in% names(formatted))
})

test_that("Uphold models withdrawal fees as separate sell rows instead of a fees column", {
  formatted <- format_uphold(
    data_uphold,
    list.prices = list_prices_example
  )
  fee.rows <- formatted[!is.na(formatted$comment) & formatted$comment == "withdrawal fees", ]

  expect_false("fees" %in% names(formatted))
  expect_true(nrow(fee.rows) > 0)
  expect_true(all(fee.rows$transaction == "sell"))
  expect_true(all(fee.rows$total.price >= 0))
})
