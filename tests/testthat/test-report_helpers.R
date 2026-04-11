test_that("get_proceeds and get_sup_losses filter consistently by tax year", {
  formatted.ACB <- data.frame(
    date = as.POSIXct(
      c("2020-12-31 12:00:00", "2021-01-10 12:00:00", "2021-02-10 12:00:00"),
      tz = "UTC"
    ),
    gains = c(7, 10, -5),
    total.price = c(70, 100, 50),
    fees = c(0, 0, 0),
    gains.sup = c(1, 2, 3)
  )

  expect_message(
    proceeds <- get_proceeds(formatted.ACB, tax.year = 2021, local.timezone = "UTC"),
    "proceeds have been filtered for tax year 2021"
  )
  expect_equal(proceeds$proceeds, c(100, 50))
  expect_equal(proceeds$ACB.total, c(90, 55))
  expect_equal(proceeds$gains, c(10, -5))

  expect_message(
    sup.losses <- get_sup_losses(formatted.ACB, tax.year = 2021, local.timezone = "UTC"),
    "superficial losses have been filtered for tax year 2021"
  )
  expect_equal(sup.losses$currency, "Total")
  expect_equal(sup.losses$sup.loss, 5)
})

test_that("proceeds_summary_table keeps gain and loss rows even when one side is empty", {
  only.gains <- data.frame(
    gains = c(10, 5),
    total.price = c(100, 50),
    fees = c(1, 2)
  )

  result <- cryptoTax:::.proceeds_summary_table(only.gains)

  expect_equal(result$type, c("Gains", "Losses"))
  expect_equal(result$proceeds, c(150, 0))
  expect_equal(result$ACB.total, c(135, 0))
  expect_equal(result$gains, c(15, 0))
})

test_that("split_proceeds_buckets separates gains and losses before summarizing", {
  formatted.ACB.year <- data.frame(
    gains = c(10, -5),
    total.price = c(100, 50),
    fees = c(1, 0)
  )

  buckets <- cryptoTax:::.split_proceeds_buckets(formatted.ACB.year)

  expect_equal(nrow(buckets$gains), 1)
  expect_equal(nrow(buckets$losses), 1)
  expect_equal(buckets$gains$ACB.quantity, 90)
  expect_equal(buckets$losses$ACB.quantity, 55)
})

test_that("proceeds_bucket_rows selects positive and negative gains separately", {
  formatted.ACB.year <- data.frame(gains = c(10, 0, -5))

  expect_equal(
    cryptoTax:::.proceeds_bucket_rows(formatted.ACB.year, "positive")$gains,
    10
  )
  expect_equal(
    cryptoTax:::.proceeds_bucket_rows(formatted.ACB.year, "negative")$gains,
    -5
  )
})

test_that("proceeds_summary_rows preserves gain and loss ordering before labels", {
  formatted.ACB.year <- data.frame(
    gains = c(10, -5),
    total.price = c(100, 50),
    fees = c(1, 0)
  )

  result <- cryptoTax:::.proceeds_summary_rows(formatted.ACB.year)

  expect_equal(result$proceeds, c(100, 50))
  expect_equal(result$gains, c(10, -5))
})

test_that("crypto_pie validates the `by` argument", {
  expect_error(
    crypto_pie(data.frame(), by = "invalid"),
    "`by` must be either 'exchange' or 'revenue.type'."
  )
})

test_that("resolve_report_today_data reuses explicit prices offline", {
  testthat::local_mocked_bindings(
    .package = "cryptoTax",
    prepare_list_prices_slugs = function(...) stop("should not prepare prices")
  )

  explicit_list_prices <- data.frame(
    currency = "BTC",
    spot.rate2 = 123.45,
    date2 = as.Date("2021-01-01")
  )

  price.state <- cryptoTax:::.resolve_report_today_data(
    formatted.ACB = data.frame(currency = "BTC"),
    today.data = TRUE,
    list.prices = explicit_list_prices,
    slug = NULL,
    start.date = NULL,
    force = FALSE,
    verbose = TRUE
  )

  expect_true(price.state$today.data)
  expect_identical(price.state$list.prices, explicit_list_prices)
})

test_that("resolve_report_today_data disables today.data for non-joinable explicit prices", {
  expect_message(
    price.state <- cryptoTax:::.resolve_report_today_data(
      formatted.ACB = data.frame(currency = "BTC"),
      today.data = TRUE,
      list.prices = data.frame(date2 = as.Date("2021-01-01")),
      slug = NULL,
      start.date = NULL,
      force = FALSE,
      verbose = TRUE
    ),
    "Could not use 'list.prices' for today.data because it must contain 'currency', 'spot.rate2', and 'date2'."
  )

  expect_false(price.state$today.data)
})

test_that("report_current_price_date returns the last date only for joinable prices", {
  valid_list_prices <- data.frame(
    currency = c("BTC", "ETH"),
    spot.rate2 = c(100, 200),
    date2 = as.Date(c("2021-01-01", "2021-01-02"))
  )

  expect_equal(
    cryptoTax:::.report_current_price_date(valid_list_prices),
    as.Date("2021-01-02")
  )
  expect_null(
    cryptoTax:::.report_current_price_date(data.frame(date2 = as.Date("2021-01-01")))
  )
  expect_null(cryptoTax:::.report_current_price_date(NULL))
})

test_that("prepare_report_outputs leaves current.price.date unset for malformed prices", {
  report.info <- list(
    report.summary = data.frame(Type = character(), Amount = character()),
    sup.losses = data.frame(currency = character(), sup.loss = numeric()),
    table.revenues = data.frame(exchange = character(), revenue.type = character()),
    proceeds = data.frame(type = character(), proceeds = numeric(), ACB.total = numeric(), gains = numeric()),
    list.prices = data.frame(date2 = as.Date("2021-01-01"))
  )

  testthat::local_mocked_bindings(
    tax_box = function(...) data.frame(ok = TRUE),
    crypto_pie = function(...) structure(list(), class = "ggplot"),
    .package = "cryptoTax"
  )

  result <- cryptoTax:::.prepare_report_outputs(report.info, local.timezone = "America/Toronto")

  expect_null(result$current.price.date)
  expect_false("list.prices" %in% names(result))
})

test_that("prepare_report disables current-price reporting cleanly for malformed explicit prices", {
  formatted.ACB <- format_ACB(
    suppressMessages(format_exchanges(data_shakepay)),
    verbose = FALSE
  )

  expect_message(
    result <- prepare_report(
      formatted.ACB,
      list.prices = data.frame(date2 = as.Date("2021-01-01")),
      tax.year = "all",
      local.timezone = "America/Toronto"
    ),
    "Could not use 'list.prices' for today.data because it must contain 'currency', 'spot.rate2', and 'date2'."
  )

  expect_type(result, "list")
  expect_null(result$current.price.date)
})

test_that("resolve_report_today_data disables today.data when offline with no prices", {
  testthat::local_mocked_bindings(
    .package = "curl",
    has_internet = function() FALSE
  )

  expect_message(
    price.state <- cryptoTax:::.resolve_report_today_data(
      formatted.ACB = data.frame(currency = "BTC"),
      today.data = TRUE,
      list.prices = NULL,
      slug = NULL,
      start.date = NULL,
      force = FALSE,
      verbose = TRUE
    ),
    "today.data argument has been set to `FALSE` automatically."
  )

  expect_false(price.state$today.data)
  expect_null(price.state$list.prices)
})

test_that("prepare_report_current_rates emits the requested signal style", {
  ACB.list <- data.frame(
    date = as.Date(c("2021-01-01", "2021-01-01")),
    currency = c("GB", "BTC"),
    total.quantity = c(1, 1),
    ACB = c(10, 20)
  )
  list.prices <- data.frame(
    currency = "BTC",
    spot.rate2 = 42,
    date2 = as.Date("2021-01-02")
  )

  testthat::local_mocked_bindings(
    .package = "cryptoTax",
    match_prices = function(x, ...) transform(x, spot.rate = 42)
  )

  expect_warning(
    rates <- cryptoTax:::.prepare_report_current_rates(
      ACB.list = ACB.list,
      list.prices = list.prices,
      force = FALSE,
      verbose = TRUE,
      signal = "warning"
    ),
    "GB transactions are excluded"
  )

  expect_equal(rates$currency, "BTC")
  expect_equal(rates$spot.rate, 42)
  expect_equal(rates$date, as.Date("2021-01-02"))
})

test_that("sup_losses_total returns zero for empty superficial-loss tables", {
  expect_equal(cryptoTax:::.sup_losses_total(data.frame(currency = character(), sup.loss = numeric())), 0)
  expect_equal(cryptoTax:::.sup_losses_total(NULL), 0)
})

test_that("sup_losses_total prefers the explicit Total row over row order", {
  sup.losses <- data.frame(
    currency = c("Total", "BTC"),
    sup.loss = c(5, 1),
    stringsAsFactors = FALSE
  )

  total.row <- cryptoTax:::.sup_losses_total_row(sup.losses)

  expect_equal(total.row$currency, "Total")
  expect_equal(cryptoTax:::.sup_losses_total(sup.losses), 5)
})

test_that("table_revenues income helpers handle missing tables and missing columns", {
  table.revenues <- data.frame(
    staking = c(1, 5),
    interests = c(2, 7)
  )

  expect_equal(cryptoTax:::.table_revenues_amount(table.revenues, "staking"), 5)
  expect_equal(cryptoTax:::.table_revenues_amount(table.revenues, "rebates"), 0)
  expect_equal(cryptoTax:::.table_revenues_amount(NULL, "staking"), 0)
  expect_equal(cryptoTax:::.table_revenues_income_total(table.revenues), 12)
})

test_that("table_revenues helpers prefer the explicit total row over row order", {
  table.revenues <- data.frame(
    exchange = c("total", "shakepay"),
    staking = c(5, 1),
    interests = c(7, 2),
    stringsAsFactors = FALSE
  )

  total.row <- cryptoTax:::.table_revenues_total_row(table.revenues)

  expect_equal(total.row$exchange, "total")
  expect_equal(cryptoTax:::.table_revenues_amount(table.revenues, "staking"), 5)
  expect_equal(cryptoTax:::.table_revenues_income_total(table.revenues), 12)
})

test_that("report_summary_amount matches rows by type and falls back cleanly", {
  report.summary <- data.frame(
    Type = c("losses", "gains"),
    Amount = c("-20.00", "100.00"),
    stringsAsFactors = FALSE
  )

  expect_equal(cryptoTax:::.report_summary_amount(report.summary, "gains"), "100.00")
  expect_equal(cryptoTax:::.report_summary_amount(report.summary, "net", default = "0.00"), "0.00")
})

test_that("summarize_proceeds_bucket returns zero rows for empty buckets", {
  empty <- data.frame(
    gains = numeric(),
    total.price = numeric(),
    fees = numeric(),
    ACB.quantity = numeric()
  )

  result <- cryptoTax:::.summarize_proceeds_bucket(empty)

  expect_equal(result$proceeds, 0)
  expect_equal(result$ACB.total, 0)
  expect_equal(result$gains, 0)
})

test_that("summarize_proceeds_values computes explicit proceeds totals", {
  bucket <- data.frame(
    total.price = c(100, 50),
    ACB.quantity = c(90, 40)
  )

  result <- cryptoTax:::.summarize_proceeds_values(bucket)

  expect_equal(result$proceeds, 150)
  expect_equal(result$ACB.total, 130)
  expect_equal(result$gains, 20)
})

test_that("report_revenues helper tables summarize totals and dates by exchange", {
  revenues <- data.frame(
    exchange = c("shakepay", "shakepay", "newton"),
    date = as.POSIXct(c(
      "2021-01-01 00:00:00",
      "2021-01-03 00:00:00",
      "2021-01-02 00:00:00"
    ), tz = "UTC"),
    value = c(5, 7, 3),
    revenue.type = c("staking", "airdrops", "referrals"),
    stringsAsFactors = FALSE
  )

  totals <- cryptoTax:::.report_revenues_totals(revenues)
  dates <- cryptoTax:::.report_revenues_dates(revenues, "UTC")

  expect_equal(totals$total.revenues[totals$exchange == "shakepay"], 12)
  expect_equal(
    dates$date[dates$exchange == "shakepay"],
    as.POSIXct("2021-01-03 00:00:00", tz = "UTC")
  )
})

test_that("report_revenues_filter_year keeps only rows in the requested local year", {
  revenues <- data.frame(
    exchange = "shakepay",
    date = as.POSIXct(c(
      "2020-12-31 23:30:00",
      "2021-01-01 01:00:00"
    ), tz = "UTC"),
    value = c(5, 7),
    revenue.type = c("staking", "staking"),
    stringsAsFactors = FALSE
  )

  result <- cryptoTax:::.report_revenues_filter_year(
    revenues,
    tax.year = 2020,
    local.timezone = "America/Toronto"
  )

  expect_equal(nrow(result), 2)
})

test_that("report_revenues_round_numeric rounds numeric columns and sets currency", {
  table <- data.frame(
    exchange = "shakepay",
    total.revenues = 10.126,
    staking = 5.555,
    stringsAsFactors = FALSE
  )

  result <- cryptoTax:::.report_revenues_round_numeric(table)

  expect_equal(result$total.revenues, 10.13)
  expect_equal(result$staking, 5.56)
  expect_equal(result$currency, "CAD")
})

test_that("report_revenues_total_row sums numeric columns explicitly", {
  table <- data.frame(
    exchange = c("shakepay", "newton"),
    date.last = as.POSIXct(c("2021-01-02 00:00:00", "2021-01-03 00:00:00"), tz = "UTC"),
    total.revenues = c(12.345, 4.4),
    staking = c(5, 0),
    interests = c(7.345, 3.3),
    stringsAsFactors = FALSE
  )

  result <- cryptoTax:::.report_revenues_total_row(table, "UTC")

  expect_equal(utils::tail(result$exchange, 1), "total")
  expect_equal(utils::tail(result$total.revenues, 1), 16.745)
  expect_equal(utils::tail(result$staking, 1), 5)
  expect_equal(utils::tail(result$interests, 1), 10.645)
})

test_that("report_revenues helpers return explicit empty and finalized table shapes", {
  empty <- cryptoTax:::.empty_report_revenues_table("UTC")

  expect_equal(names(empty), cryptoTax:::.report_revenues_columns())
  expect_equal(empty$exchange, "total")
  expect_equal(empty$total.revenues, 0)

  table <- data.frame(
    exchange = "shakepay",
    date = as.POSIXct("2021-01-02 00:00:00", tz = "UTC"),
    total.revenues = 12.345,
    airdrops = 2,
    referrals = 0,
    staking = 5,
    promos = 0,
    interests = 7.345,
    rebates = 0,
    rewards = 0,
    forks = 0,
    mining = 0,
    stringsAsFactors = FALSE
  )

  finalized <- cryptoTax:::.report_revenues_finalize_table(table, "UTC")

  expect_equal(names(finalized), cryptoTax:::.report_revenues_columns())
  expect_equal(utils::tail(finalized$exchange, 1), "total")
  expect_equal(utils::tail(finalized$total.revenues, 1), 12.35)
})

test_that("report_revenues_finalize_table preserves all exchanges before adding totals", {
  table <- data.frame(
    exchange = c("shakepay", "newton"),
    date = as.POSIXct(c("2021-01-02 00:00:00", "2021-01-03 00:00:00"), tz = "UTC"),
    total.revenues = c(12.345, 4.4),
    airdrops = c(2, 0),
    referrals = c(0, 1.1),
    staking = c(5, 0),
    promos = c(0, 0),
    interests = c(7.345, 3.3),
    rebates = c(0, 0),
    rewards = c(0, 0),
    forks = c(0, 0),
    mining = c(0, 0),
    stringsAsFactors = FALSE
  )

  finalized <- cryptoTax:::.report_revenues_finalize_table(table, "UTC")

  expect_equal(finalized$exchange, c("shakepay", "newton", "total"))
  expect_equal(finalized$total.revenues, c(12.35, 4.4, 16.75))
})

test_that("sup_losses_table matches total_sup_loss_table and empty helper shape", {
  formatted.ACB.year <- data.frame(gains.sup = c(2, 3))

  expect_equal(
    cryptoTax:::.sup_losses_table(formatted.ACB.year),
    cryptoTax:::.total_sup_loss_table(formatted.ACB.year)
  )

  empty <- cryptoTax:::.empty_sup_losses_table()
  expect_equal(names(empty), c("currency", "sup.loss"))
  expect_equal(nrow(empty), 0)
})

test_that("sup_losses helpers return empty output when gains.sup is missing or all NA", {
  expect_false(cryptoTax:::.sup_losses_has_values(data.frame(x = 1)))
  expect_false(cryptoTax:::.sup_losses_has_values(data.frame(gains.sup = c(NA_real_, NA_real_))))

  expect_equal(
    cryptoTax:::.sup_losses_table(data.frame(x = 1)),
    cryptoTax:::.empty_sup_losses_table()
  )
})

test_that("report_revenues_rows extracts only revenue transactions", {
  formatted.ACB <- data.frame(
    transaction = c("buy", "revenue", "sell", "revenue"),
    stringsAsFactors = FALSE
  )

  result <- cryptoTax:::.report_revenues_rows(formatted.ACB)

  expect_equal(result$transaction, c("revenue", "revenue"))
})

test_that("report_revenues_has_rows reflects whether any revenue rows remain", {
  expect_false(cryptoTax:::.report_revenues_has_rows(data.frame()))
  expect_true(cryptoTax:::.report_revenues_has_rows(data.frame(x = 1)))
})
