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
})

test_that("prepare_report passes local.timezone to report_revenues", {
  testthat::local_mocked_bindings(
    report_overview = function(...) data.frame(ok = TRUE),
    report_summary = function(...) data.frame(ok = TRUE),
    get_proceeds = function(...) data.frame(ok = TRUE),
    get_sup_losses = function(...) data.frame(sup.loss = 0),
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
  expect_equal(report.info$local.timezone, "America/Toronto")
})
