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
