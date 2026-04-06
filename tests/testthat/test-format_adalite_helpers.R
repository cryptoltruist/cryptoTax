test_that("format_adalite_prepare_input fills missing received currency", {
  input <- data.frame(
    Received.amount = 1,
    Received.currency = "",
    Type = "Sent",
    Date = "01/01/2021 12:00",
    Sent.currency = "ADA",
    stringsAsFactors = FALSE
  )

  result <- cryptoTax:::.format_adalite_prepare_input(
    input,
    known.transactions = c("Reward awarded", "Received", "Sent")
  )

  expect_equal(result$currency, "ADA")
  expect_s3_class(result$date, "POSIXct")
})

test_that("format_adalite_earn creates staking revenue rows", {
  input <- data.frame(
    date = as.POSIXct("2021-01-01 00:00:00", tz = "UTC"),
    quantity = 2,
    currency = "ADA",
    description = "Reward awarded",
    stringsAsFactors = FALSE
  )

  result <- cryptoTax:::.format_adalite_earn(input)

  expect_equal(result$transaction, "revenue")
  expect_equal(result$revenue.type, "staking")
})

test_that("format_adalite_finalize annotates merged output", {
  outputs <- list(
    earn = data.frame(
      date = as.POSIXct("2021-01-01 00:00:00", tz = "UTC"),
      quantity = 2,
      currency = "ADA",
      transaction = "revenue",
      revenue.type = "staking",
      description = "Reward awarded",
      stringsAsFactors = FALSE
    ),
    withdrawals = NULL
  )

  result <- cryptoTax:::.format_adalite_finalize(outputs)

  expect_equal(result$exchange, "adalite")
})
