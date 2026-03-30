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
