test_that("format_coinbase_prepare_input standardizes columns and fees", {
  input <- data.frame(
    Timestamp = "2021-01-01 00:00:00",
    Asset = "BTC",
    Quantity.Transacted = 1,
    Total..inclusive.of.fees.and.or.spread. = 100,
    Spot.Price.at.Transaction = 100,
    Fees.and.or.Spread = -2,
    Transaction.Type = "Convert",
    Notes = "Converted 100 CAD to 1 BTC",
    stringsAsFactors = FALSE
  )

  result <- cryptoTax:::.format_coinbase_prepare_input(
    input,
    known.transactions = c("Send", "Convert", "Receive")
  )

  expect_equal(result$fees, 2)
  expect_equal(result$description, "Convert")
  expect_true("comment" %in% names(result))
})

test_that("format_coinbase_buy derives converted asset and spot rate", {
  input <- data.frame(
    date = as.POSIXct("2021-01-01 00:00:00", tz = "UTC"),
    currency = "CAD",
    quantity = 100,
    total.price = 100,
    spot.rate = 1,
    fees = 2,
    description = "Convert",
    comment = "Converted 100 CAD to 1 BTC",
    stringsAsFactors = FALSE
  )

  result <- cryptoTax:::.format_coinbase_buy(input)

  expect_equal(result$transaction, "buy")
  expect_equal(result$currency, "BTC")
  expect_equal(result$quantity, 1)
  expect_equal(result$spot.rate, 100)
})

test_that("format_coinbase_finalize annotates merged output", {
  outputs <- list(
    buy = data.frame(
      date = as.POSIXct("2021-01-01 00:00:00", tz = "UTC"),
      currency = "BTC",
      quantity = 1,
      total.price = 100,
      spot.rate = 100,
      transaction = "buy",
      fees = 2,
      description = "Convert",
      comment = "Converted 100 CAD to 1 BTC",
      revenue.type = NA_character_,
      stringsAsFactors = FALSE
    ),
    sell = NULL,
    earn = NULL,
    withdrawals = NULL
  )

  result <- cryptoTax:::.format_coinbase_finalize(outputs)

  expect_equal(result$exchange, "coinbase")
  expect_equal(result$rate.source, "exchange")
  expect_true(all(c("fees", "description", "comment") %in% names(result)))
})
