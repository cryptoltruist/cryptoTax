test_that("format_newton_prepare_input converts Eastern timestamps to UTC", {
  input <- data.frame(
    Type = "TRADE",
    Date = "01/01/2021 12:00:00",
    stringsAsFactors = FALSE
  )

  result <- cryptoTax:::.format_newton_prepare_input(
    input,
    known.transactions = c("WITHDRAWN", "TRADE", "DEPOSIT")
  )

  expect_equal(format(result$date, tz = "UTC", usetz = TRUE), "2021-01-01 17:00:00 UTC")
})

test_that("format_newton_earn creates referral revenue rows", {
  input <- data.frame(
    date = as.POSIXct("2021-01-01 00:00:00", tz = "UTC"),
    description = "DEPOSIT",
    Fee.Amount = "Referral Program",
    Received.Quantity = 25,
    Received.Currency = "CAD",
    stringsAsFactors = FALSE
  )

  result <- cryptoTax:::.format_newton_earn(input)

  expect_equal(result$transaction, "revenue")
  expect_equal(result$revenue.type, "referrals")
  expect_equal(result$spot.rate, 1)
  expect_type(result$description, "character")
})

test_that("format_newton_finalize annotates merged output", {
  outputs <- list(
    buy = data.frame(
      date = as.POSIXct("2021-01-01 00:00:00", tz = "UTC"),
      currency = "BTC",
      quantity = 1,
      total.price = 100,
      spot.rate = 100,
      transaction = "buy",
      description = "TRADE",
      revenue.type = NA_character_,
      stringsAsFactors = FALSE
    ),
    sell = NULL,
    earn = NULL
  )

  result <- cryptoTax:::.format_newton_finalize(outputs)

  expect_equal(result$exchange, "newton")
  expect_equal(result$rate.source, "exchange")
})
