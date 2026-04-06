test_that("format_exodus_prepare_input fills missing incoming currency", {
  input <- data.frame(
    INAMOUNT = 0,
    INCURRENCY = "",
    TYPE = "withdrawal",
    DATE = "2021-01-01 00:00:00",
    OUTCURRENCY = "ADA",
    stringsAsFactors = FALSE
  )

  result <- cryptoTax:::.format_exodus_prepare_input(
    input,
    known.transactions = c("deposit", "withdrawal")
  )

  expect_equal(result$currency, "ADA")
  expect_s3_class(result$date, "POSIXct")
})

test_that("format_exodus_staking_fees creates zero-value sell rows", {
  input <- data.frame(
    date = as.POSIXct("2021-01-01 00:00:00", tz = "UTC"),
    quantity = 0,
    currency = "ADA",
    description = "deposit",
    FEEAMOUNT = -2,
    stringsAsFactors = FALSE
  )

  result <- cryptoTax:::.format_exodus_staking_fees(input)

  expect_equal(result$transaction, "sell")
  expect_equal(result$description, "Initial staking fee")
  expect_equal(result$total.price, 0)
  expect_equal(result$quantity, 2)
})

test_that("format_exodus_finalize annotates merged output", {
  outputs <- list(
    earn = data.frame(
      date = as.POSIXct("2021-01-01 00:00:00", tz = "UTC"),
      quantity = 1,
      currency = "XNO",
      transaction = "revenue",
      revenue.type = "airdrops",
      description = "deposit",
      stringsAsFactors = FALSE
    ),
    withdrawals = NULL,
    staking.fees = NULL
  )

  result <- cryptoTax:::.format_exodus_finalize(outputs)

  expect_equal(result$exchange, "exodus")
})
