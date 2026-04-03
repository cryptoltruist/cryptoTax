test_that("report_revenues handles missing dates and values", {
  formatted.ACB <- data.frame(
    transaction = c("revenue", "revenue"),
    exchange = c("shakepay", "shakepay"),
    date = as.POSIXct(c(NA, NA), origin = "1970-01-01", tz = "UTC"),
    value = c(10, NA_real_),
    revenue.type = c("staking", "interests"),
    stringsAsFactors = FALSE
  )

  table.revenues <- expect_no_warning(
    report_revenues(formatted.ACB, tax.year = "all", local.timezone = "America/Toronto")
  )

  expect_true(all(is.na(table.revenues$date.last)))
  expect_equal(
    table.revenues$total.revenues[table.revenues$exchange == "shakepay"],
    10
  )
  expect_equal(
    table.revenues$interests[table.revenues$exchange == "shakepay"],
    0
  )
  expect_equal(
    table.revenues$total.revenues[table.revenues$exchange == "total"],
    10
  )
})

test_that("report_summary does not prepare prices when today.data is FALSE", {
  testthat::local_mocked_bindings(
    prepare_list_prices_slugs = function(...) stop("should not be called"),
    .package = "cryptoTax"
  )

  formatted.ACB <- data.frame(
    date = as.POSIXct(c("2021-01-01 00:00:00", "2021-01-02 00:00:00"), tz = "UTC"),
    currency = c("BTC", "BTC"),
    total.quantity = c(1, 1),
    ACB.share = c(100, 100),
    ACB = c(100, 100),
    gains = c(NA_real_, 25),
    transaction = c("buy", "sell"),
    value = c(0, 0)
  )

  summary_table <- expect_no_message(
    report_summary(formatted.ACB, today.data = FALSE)
  )

  expect_equal(summary_table$Amount[summary_table$Type == "net"], "25.00")
  expect_equal(summary_table$Amount[summary_table$Type == "total.cost"], "100.00")
})

test_that("report_summary uses explicit list.prices even without internet", {
  testthat::local_mocked_bindings(
    has_internet = function() FALSE,
    .package = "curl"
  )

  formatted.ACB <- data.frame(
    date = as.POSIXct(c("2021-01-01 00:00:00", "2021-01-02 00:00:00"), tz = "UTC"),
    currency = c("BTC", "BTC"),
    total.quantity = c(1, 1),
    ACB.share = c(100, 100),
    ACB = c(100, 100),
    gains = c(NA_real_, 25),
    transaction = c("buy", "sell"),
    value = c(0, 0)
  )

  explicit_list_prices <- data.frame(
    currency = "BTC",
    spot.rate2 = 150,
    date2 = as.Date("2021-01-05")
  )

  expect_message(
    report_summary(
      formatted.ACB,
      today.data = TRUE,
      list.prices = explicit_list_prices
    ),
    "Date of current prices: 2021-01-05"
  )

  summary_table <- suppressMessages(
    report_summary(
      formatted.ACB,
      today.data = TRUE,
      list.prices = explicit_list_prices
    )
  )

  expect_equal(summary_table$Amount[summary_table$Type == "value.today"], "150.00")
  expect_equal(summary_table$Amount[summary_table$Type == "unrealized.net"], "50.00")
})
