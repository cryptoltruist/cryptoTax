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

test_that("report_summary_static_metrics summarizes realized and revenue totals", {
  formatted.ACB.year <- data.frame(
    gains = c(10, -5, 0),
    transaction = c("sell", "sell", "revenue"),
    value = c(0, 0, 12.5)
  )
  ACB.list <- data.frame(ACB = c(100, 25))

  metrics <- cryptoTax:::.report_summary_static_metrics(formatted.ACB.year, ACB.list)

  expect_equal(metrics$gains, 10)
  expect_equal(metrics$losses, -5)
  expect_equal(metrics$net, 5)
  expect_equal(metrics$total.cost, 125)
  expect_equal(metrics$revenue, 12.5)
})

test_that("report_summary_table formats percentages and tax year labels", {
  metrics <- list(
    gains = 10,
    losses = -5,
    net = 5,
    total.cost = 100,
    value.today = 120,
    unrealized.gains = 20,
    unrealized.losses = -2,
    unrealized.net = 18,
    percentage.up = 20,
    all.time.up = 25,
    revenue = 4,
    all.time.up.revenue = 29
  )

  result <- cryptoTax:::.report_summary_table(metrics, tax.year = 2021)

  expect_equal(result$Type[[1]], "tax.year")
  expect_equal(result$Amount[[1]], "2021")
  expect_equal(result$Amount[result$Type == "gains"], "10.00")
  expect_equal(result$Amount[result$Type == "percentage.up"], "20.00%")
  expect_equal(result$Amount[result$Type == "all.time.up.revenue"], "29.00%")
})

test_that("report_overview_group_totals summarizes gains, losses, and net by currency", {
  formatted.ACB.year <- data.frame(
    currency = c("BTC", "BTC", "ETH"),
    gains = c(10, -3, 5)
  )

  totals <- cryptoTax:::.report_overview_group_totals(formatted.ACB.year)

  expect_equal(totals$net$net, c(7, 5))
  expect_equal(totals$gains$gains, c(10, 5))
  expect_equal(totals$losses$losses, -3)
})

test_that("report_overview_total_row adds a Total row for current and historic paths", {
  historic <- data.frame(
    date.last = as.POSIXct("2021-01-01 00:00:00", tz = "UTC"),
    currency = "BTC",
    currency2 = "BTC",
    total.cost = 100,
    net = 10
  )
  current <- data.frame(
    date.last = as.POSIXct("2021-01-01 00:00:00", tz = "UTC"),
    currency = "BTC",
    currency2 = "BTC",
    total.cost = 100,
    net = 10,
    value.today = 120,
    unrealized.net = 20
  )

  historic.total <- cryptoTax:::.report_overview_total_row(historic, today.data = FALSE)
  current.total <- cryptoTax:::.report_overview_total_row(current, today.data = TRUE)

  expect_equal(utils::tail(historic.total$currency, 1), "Total")
  expect_equal(utils::tail(historic.total$net, 1), 10)
  expect_equal(utils::tail(current.total$currency, 1), "Total")
  expect_equal(utils::tail(current.total$value.today, 1), 120)
  expect_equal(utils::tail(current.total$unrealized.net, 1), 20)
})
