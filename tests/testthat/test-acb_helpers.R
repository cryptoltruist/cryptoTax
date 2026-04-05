test_that("check_missing_transactions returns only negative balances", {
  formatted.ACB <- data.frame(
    currency = c("BTC", "ETH", "ADA"),
    total.quantity = c(1, -0.2, -3),
    stringsAsFactors = FALSE
  )

  result <- check_missing_transactions(formatted.ACB)

  expect_equal(result$currency, c("ETH", "ADA"))
  expect_true(all(result$total.quantity < 0))
})

test_that("negative_balance_rows matches the missing-transactions filter", {
  formatted.ACB <- data.frame(
    currency = c("BTC", "ETH"),
    total.quantity = c(0.1, -0.1),
    stringsAsFactors = FALSE
  )

  expect_identical(
    cryptoTax:::.negative_balance_rows(formatted.ACB),
    check_missing_transactions(formatted.ACB)
  )
})

test_that("get_latest_transactions keeps the latest row per exchange", {
  formatted.ACB <- data.frame(
    exchange = c("A", "A", "B", "B"),
    date = as.POSIXct(c(
      "2021-01-01 00:00:00",
      "2021-01-02 00:00:00",
      "2021-01-01 00:00:00",
      "2021-01-01 12:00:00"
    ), tz = "UTC")
  )

  result <- get_latest_transactions(formatted.ACB)

  expect_equal(result$exchange, c("A", "B"))
  expect_equal(
    result$date,
    as.POSIXct(c("2021-01-02 00:00:00", "2021-01-01 12:00:00"), tz = "UTC")
  )
})

test_that("listby_coin returns coin-named data-frame list", {
  formatted.ACB <- data.frame(
    currency = c("ETH", "BTC", "ETH"),
    value = c(2, 1, 3),
    stringsAsFactors = FALSE
  )

  result <- listby_coin(formatted.ACB)

  expect_type(result, "list")
  expect_equal(names(result), c("BTC", "ETH"))
  expect_s3_class(result$BTC, "data.frame")
  expect_equal(result$BTC$currency, "BTC")
  expect_equal(result$ETH$value, c(2, 3))
})
