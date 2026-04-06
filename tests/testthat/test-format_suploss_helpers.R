test_that("prepare_suploss_ranges adds a range column", {
  data <- data.frame(
    date = as.POSIXct("2021-01-01 00:00:00", tz = "UTC")
  )

  result <- cryptoTax:::.prepare_suploss_ranges(data)

  expect_true("suploss.range" %in% names(result))
  expect_s4_class(result$suploss.range, "Interval")
})

test_that("summarize_suploss helpers keep template rows when ranges are empty", {
  template <- data.frame(date = as.POSIXct("2021-01-01 00:00:00", tz = "UTC"))

  quantity.60days <- cryptoTax:::.summarize_suploss_buy_quantities(
    list(),
    template = template
  )
  share.left60 <- cryptoTax:::.summarize_suploss_share_left(
    list(),
    template = template
  )

  expect_equal(nrow(quantity.60days), 1)
  expect_equal(nrow(share.left60), 1)
  expect_true(is.na(quantity.60days$quantity.60days))
  expect_true(is.na(share.left60$share.left60))
})

test_that("mark_superficial_losses only flags sell rows inside a buy window", {
  data.range <- data.frame(
    date = as.POSIXct(c(
      "2021-01-01 00:00:00",
      "2021-01-10 00:00:00",
      "2021-03-15 00:00:00"
    ), tz = "UTC"),
    transaction = c("buy", "sell", "sell"),
    quantity = c(2, 1, 1),
    total.quantity = c(2, 1, 0)
  )
  data.range$suploss.range <- cryptoTax:::suploss_range(data.range$date)

  result <- cryptoTax:::.mark_superficial_losses(data.range)

  expect_equal(result$sup.loss, c(FALSE, TRUE, FALSE))
  expect_equal(result$sup.loss.quantity, c(0, 1, 0))
})
