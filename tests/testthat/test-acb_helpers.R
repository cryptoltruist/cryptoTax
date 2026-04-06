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

test_that("latest_transaction_dates matches get_latest_transactions", {
  formatted.ACB <- data.frame(
    exchange = c("A", "A", "B"),
    date = as.POSIXct(c(
      "2021-01-01 00:00:00",
      "2021-01-03 00:00:00",
      "2021-01-02 00:00:00"
    ), tz = "UTC")
  )

  expect_identical(
    cryptoTax:::.latest_transaction_dates(formatted.ACB),
    get_latest_transactions(formatted.ACB)
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

test_that("split_formatted_acb_by_group splits into data-frame groups", {
  formatted.ACB <- data.frame(
    currency = c("ETH", "BTC", "ETH"),
    value = c(2, 1, 3),
    stringsAsFactors = FALSE
  )

  result <- cryptoTax:::.split_formatted_acb_by_group(formatted.ACB, "currency")

  expect_type(result, "list")
  expect_length(result, 2)
  expect_s3_class(result[[1]], "data.frame")
})

test_that("total_sup_loss_table returns empty output when total is zero", {
  formatted.ACB.year <- data.frame(gains.sup = c(NA, 0))

  result <- cryptoTax:::.total_sup_loss_table(formatted.ACB.year)

  expect_equal(nrow(result), 0)
  expect_equal(names(result), c("currency", "sup.loss"))
})

test_that("total_sup_loss_table returns a rounded total row when losses exist", {
  formatted.ACB.year <- data.frame(gains.sup = c(-1.234, NA, -0.335))

  result <- cryptoTax:::.total_sup_loss_table(formatted.ACB.year)

  expect_equal(result$currency, "Total")
  expect_equal(result$sup.loss, -1.57)
})

test_that("ensure_acb_total_price derives totals from spot rates when missing", {
  data <- data.frame(quantity = c(2, 3), spot.rate = c(10, 20))

  result <- cryptoTax:::.ensure_acb_total_price(
    data,
    total.price = "total.price",
    spot.rate = "spot.rate",
    quantity = "quantity"
  )

  expect_equal(result$total.price, c(20, 60))
})

test_that("ensure_acb_fees adds and normalizes fees", {
  data <- data.frame(total.price = c(10, 20))

  result <- cryptoTax:::.ensure_acb_fees(data, total.price = "total.price")

  expect_equal(result$fees, c(0, 0))
})

test_that("update_acb_add_row handles first and later rows", {
  data <- data.frame(
    quantity = c(2, 3),
    total.price = c(10, 20),
    fees = c(1, 2),
    total.quantity = c(NA, NA),
    ACB = c(NA, NA)
  )

  data <- cryptoTax:::.initialize_acb_quantity(data, 1, quantity = "quantity")
  data <- cryptoTax:::.update_acb_add_row(data, 1, quantity = "quantity", total.price = "total.price")

  expect_equal(data[1, "total.quantity"], 2)
  expect_equal(data[1, "ACB"], 11)

  data[2, "total.quantity"] <- data[1, "total.quantity"]
  data[2, "ACB"] <- data[1, "ACB"]
  data <- cryptoTax:::.update_acb_add_row(data, 2, quantity = "quantity", total.price = "total.price")

  expect_equal(data[2, "total.quantity"], 5)
  expect_equal(data[2, "ACB"], 33)
})

test_that("update_acb_sell_row and gains use prior ACB share", {
  data <- data.frame(
    quantity = c(2, 1),
    total.price = c(10, 8),
    fees = c(1, 1),
    total.quantity = c(2, NA),
    ACB = c(11, NA),
    ACB.share = c(5.5, NA),
    gains = c(NA, NA)
  )

  data <- cryptoTax:::.update_acb_sell_row(data, 2, quantity = "quantity")
  data <- cryptoTax:::.update_acb_share(data, 2)
  data <- cryptoTax:::.update_acb_gains(data, 2, total.price = "total.price", quantity = "quantity")

  expect_equal(data[2, "total.quantity"], 1)
  expect_equal(data[2, "ACB"], 5.5)
  expect_equal(data[2, "ACB.share"], 5.5)
  expect_equal(data[2, "gains"], 1.5)
})

test_that("prepare_format_acb_input sorts by date and carries currency2", {
  data <- data.frame(
    date = as.POSIXct(c("2021-01-02 00:00:00", "2021-01-01 00:00:00"), tz = "UTC"),
    currency = c("ETH", "BTC")
  )

  result <- cryptoTax:::.prepare_format_acb_input(data)

  expect_equal(result$currency2, c("BTC", "ETH"))
  expect_equal(
    result$date,
    as.POSIXct(c("2021-01-01 00:00:00", "2021-01-02 00:00:00"), tz = "UTC")
  )
})

test_that("finalize_format_acb_output reorders date and fees columns", {
  data <- data.frame(
    currency = "BTC",
    fees = 0,
    description = "buy",
    date = as.POSIXct("2021-01-01 00:00:00", tz = "UTC")
  )

  result <- cryptoTax:::.finalize_format_acb_output(data)

  expect_equal(names(result), c("date", "currency", "fees", "description"))
})
