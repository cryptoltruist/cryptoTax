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
