test_that("tax_table repeat.header handles single-row tables", {
  skip_if_not_installed("flextable")

  one_row <- data.frame(
    exchange = "total",
    date.last = as.Date(NA),
    total = 10,
    stringsAsFactors = FALSE
  )

  expect_no_error(
    tax_table(one_row, repeat.header = TRUE)
  )
})

test_that("tax_table rejects unsupported table types", {
  skip_if_not_installed("flextable")

  expect_error(
    tax_table(data.frame(x = 1), type = 99),
    "`type` must be one of 1, 2, or 3."
  )
})
