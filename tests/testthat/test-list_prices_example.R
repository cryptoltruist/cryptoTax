test_that("list_prices_example supports an offline reporting workflow", {
  data(list_prices_example, package = "cryptoTax")

  all.data <- format_shakepay(data_shakepay)
  formatted.ACB <- format_ACB(all.data, verbose = FALSE)

  report.info <- suppressMessages(
    prepare_report(
      formatted.ACB,
      list.prices = list_prices_example,
      tax.year = 2021,
      local.timezone = "America/Toronto"
    )
  )

  expect_true(is.list(report.info))
  expect_true(all(c("report.overview", "report.summary", "tax.box") %in% names(report.info)))
  expect_s3_class(report.info$report.overview, "data.frame")
  expect_s3_class(report.info$report.summary, "data.frame")
  expect_equal(report.info$current.price.date, max(list_prices_example$date2))
})

test_that("prepare_report passes local.timezone to report outputs", {
  testthat::local_mocked_bindings(
    .prepare_report_price_state = function(formatted.ACB, list.prices) {
      list(today.data = FALSE, list.prices = list_prices_example)
    },
    .prepare_report_current_rates_state = function(formatted.ACB, price.state) NULL,
    .report_overview_from_price_state = function(...) data.frame(ok = TRUE),
    .report_summary_from_price_state = function(...) data.frame(ok = TRUE),
    get_proceeds = function(formatted.ACB, tax.year = "all", local.timezone = Sys.timezone()) {
      data.frame(type = "Gains", proceeds = 0, ACB.total = 0, tz = local.timezone)
    },
    get_sup_losses = function(formatted.ACB, tax.year = "all", local.timezone = Sys.timezone()) {
      data.frame(currency = local.timezone, sup.loss = 0)
    },
    report_revenues = function(formatted.ACB, tax.year = "all", local.timezone = Sys.timezone()) {
      data.frame(exchange = "total", date.last = as.POSIXct(NA), total.revenues = 0, interests = 0,
        rebates = 0, staking = 0, promos = 0, airdrops = 0, referrals = 0,
        rewards = 0, forks = 0, mining = 0, currency = local.timezone)
    },
    tax_box = function(...) data.frame(ok = TRUE),
    crypto_pie = function(...) structure(list(), class = "ggplot"),
    .package = "cryptoTax"
  )

  report.info <- prepare_report(
    formatted.ACB = data.frame(dummy = 1),
    list.prices = list_prices_example,
    local.timezone = "America/Toronto"
  )

  expect_equal(report.info$table.revenues$currency[[1]], "America/Toronto")
  expect_equal(report.info$proceeds$tz[[1]], "America/Toronto")
  expect_equal(report.info$sup.losses$currency[[1]], "America/Toronto")
  expect_equal(report.info$local.timezone, "America/Toronto")
})

test_that("prepare_report resolves shared report pricing state once before downstream builders", {
  resolved_list_prices <- data.frame(
    currency = "BTC",
    spot.rate2 = 150,
    date2 = as.Date("2021-01-05")
  )
  resolved_rates <- data.frame(
    currency = "BTC",
    total.quantity = 1,
    ACB = 100,
    spot.rate = 150
  )
  price_state_calls <- 0
  current_rates_calls <- 0
  overview_args <- NULL
  summary_args <- NULL

  testthat::local_mocked_bindings(
    .package = "cryptoTax",
    .prepare_report_price_state = function(formatted.ACB, list.prices) {
      price_state_calls <<- price_state_calls + 1
      list(today.data = TRUE, list.prices = resolved_list_prices)
    },
    .prepare_report_current_rates_state = function(formatted.ACB, price.state) {
      current_rates_calls <<- current_rates_calls + 1
      expect_true(price.state$today.data)
      expect_identical(price.state$list.prices, resolved_list_prices)
      resolved_rates
    },
    .report_overview_from_price_state = function(formatted.ACB,
                                                 today.data,
                                                 tax.year,
                                                 local.timezone,
                                                 list.prices,
                                                 rates = NULL,
                                                 force = FALSE,
                                                 verbose = TRUE) {
      overview_args <<- list(today.data = today.data, list.prices = list.prices, rates = rates)
      data.frame(ok = TRUE)
    },
    .report_summary_from_price_state = function(formatted.ACB,
                                                today.data,
                                                tax.year,
                                                local.timezone,
                                                list.prices,
                                                rates = NULL,
                                                force = FALSE,
                                                verbose = TRUE) {
      summary_args <<- list(today.data = today.data, list.prices = list.prices, rates = rates)
      data.frame(ok = TRUE)
    },
    get_proceeds = function(...) data.frame(type = "Gains", proceeds = 0, ACB.total = 0),
    get_sup_losses = function(...) data.frame(currency = "Total", sup.loss = 0),
    report_revenues = function(...) {
      data.frame(
        exchange = "total",
        date.last = as.POSIXct(NA),
        total.revenues = 0,
        interests = 0,
        rebates = 0,
        staking = 0,
        promos = 0,
        airdrops = 0,
        referrals = 0,
        rewards = 0,
        forks = 0,
        mining = 0,
        currency = "CAD"
      )
    },
    tax_box = function(...) data.frame(ok = TRUE),
    crypto_pie = function(...) structure(list(), class = "ggplot")
  )

  report.info <- prepare_report(
    formatted.ACB = data.frame(dummy = 1),
    list.prices = NULL,
    local.timezone = "America/Toronto"
  )

  expect_equal(price_state_calls, 1)
  expect_equal(current_rates_calls, 1)
  expect_true(overview_args$today.data)
  expect_true(summary_args$today.data)
  expect_identical(overview_args$list.prices, resolved_list_prices)
  expect_identical(summary_args$list.prices, resolved_list_prices)
  expect_identical(overview_args$rates, resolved_rates)
  expect_identical(summary_args$rates, resolved_rates)
  expect_identical(report.info$current.price.date, as.Date("2021-01-05"))
})
