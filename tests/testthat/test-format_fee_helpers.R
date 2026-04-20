test_that("format_fee_sell_rows converts fee amounts into sell rows", {
  input <- data.frame(
    description = c("Sent", "Received"),
    `Fee.amount` = c(0.2, 0),
    currency = c("ADA", "ADA"),
    stringsAsFactors = FALSE
  )

  result <- cryptoTax:::.format_fee_sell_rows(
    input,
    filter_expr = .data$description == "Sent",
    fee_col = "Fee.amount",
    comment_value = "Withdrawal Fee"
  )

  expect_equal(nrow(result), 1)
  expect_equal(result$transaction, "sell")
  expect_equal(result$quantity, 0.2)
  expect_equal(result$comment, "Withdrawal Fee")
})

test_that("format_fee_sell_rows can override description and total price", {
  input <- data.frame(
    description = "deposit",
    FEEAMOUNT = -2,
    currency = "ADA",
    stringsAsFactors = FALSE
  )

  result <- cryptoTax:::.format_fee_sell_rows(
    input,
    filter_expr = .data$description == "deposit" & .data$FEEAMOUNT < 0,
    fee_col = "FEEAMOUNT",
    description_value = "Initial staking fee",
    total_price_value = 0
  )

  expect_equal(result$transaction, "sell")
  expect_equal(result$quantity, 2)
  expect_equal(result$description, "Initial staking fee")
  expect_equal(result$total.price, 0)
})

test_that("finalize_formatted_exchange uses canonical output columns by default", {
  input <- data.frame(
    date = as.POSIXct("2021-01-01 00:00:00", tz = "UTC"),
    currency = "BTC",
    quantity = 1,
    total.price = 100,
    spot.rate = 100,
    transaction = "buy",
    description = "Trade",
    revenue.type = NA_character_,
    stringsAsFactors = FALSE
  )

  result <- cryptoTax:::.finalize_formatted_exchange(
    input,
    exchange = "newton",
    rate_source = "exchange"
  )

  expect_equal(result$exchange, "newton")
  expect_equal(result$rate.source, "exchange")
  expect_equal(
    names(result),
    c(
      "date", "currency", "quantity", "total.price", "spot.rate",
      "transaction", "description", "revenue.type", "exchange", "rate.source"
    )
  )
})

test_that("finalize_formatted_exchange orders canonical existing columns and skips absent optionals", {
  input <- data.frame(
    transaction = "buy",
    total.price = 100,
    date = as.POSIXct("2021-01-01 00:00:00", tz = "UTC"),
    quantity = 1,
    currency = "BTC",
    spot.rate = 100,
    stringsAsFactors = FALSE
  )

  result <- cryptoTax:::.finalize_formatted_exchange(
    input,
    exchange = "newton"
  )

  expect_equal(
    names(result),
    c("date", "currency", "quantity", "total.price", "spot.rate", "transaction", "exchange")
  )
})

test_that("arrange_formatted_transactions applies default ordering with optional tie breakers", {
  input <- data.frame(
    date = as.POSIXct(c(
      "2021-01-01 00:00:00",
      "2021-01-01 00:00:00",
      "2021-01-02 00:00:00"
    ), tz = "UTC"),
    total.price = c(10, 20, 5),
    transaction = c("sell", "buy", "buy"),
    stringsAsFactors = FALSE
  )

  result <- cryptoTax:::.arrange_formatted_transactions(input, tie_breakers = "transaction")

  expect_equal(result$total.price, c(20, 10, 5))
  expect_equal(result$transaction, c("buy", "sell", "buy"))
})
