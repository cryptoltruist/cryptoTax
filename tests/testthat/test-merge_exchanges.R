test_that("merge_exchanges ignores NULL and empty inputs", {
  one <- data.frame(
    date = as.POSIXct("2021-01-02 00:00:00", tz = "UTC"),
    exchange = "one"
  )
  empty <- one[0, ]

  result <- merge_exchanges(NULL, empty, one)

  expect_s3_class(result, "data.frame")
  expect_equal(nrow(result), 1)
  expect_equal(result$exchange, "one")
})

test_that("merge_exchanges returns an empty data frame when nothing is mergeable", {
  empty <- data.frame(date = as.POSIXct(character()), exchange = character())

  result <- merge_exchanges(NULL, empty)

  expect_s3_class(result, "data.frame")
  expect_equal(nrow(result), 0)
})

test_that("merge_exchanges orders merged rows by date", {
  one <- data.frame(
    date = as.POSIXct(c("2021-01-03 00:00:00", "2021-01-01 00:00:00"), tz = "UTC"),
    exchange = c("one", "one")
  )
  two <- data.frame(
    date = as.POSIXct("2021-01-02 00:00:00", tz = "UTC"),
    exchange = "two"
  )

  result <- merge_exchanges(one, two)

  expect_equal(
    result$date,
    as.POSIXct(c("2021-01-01 00:00:00", "2021-01-02 00:00:00", "2021-01-03 00:00:00"), tz = "UTC")
  )
})

test_that("merge_exchanges flattens nested list inputs", {
  one <- data.frame(
    date = as.POSIXct("2021-01-02 00:00:00", tz = "UTC"),
    exchange = "one"
  )
  two <- data.frame(
    date = as.POSIXct("2021-01-01 00:00:00", tz = "UTC"),
    exchange = "two"
  )

  result <- merge_exchanges(list(one, list(NULL, two)))

  expect_equal(result$exchange, c("two", "one"))
})

test_that("merge_exchanges keeps data without date columns unsorted", {
  one <- data.frame(exchange = "one", stringsAsFactors = FALSE)
  two <- data.frame(exchange = "two", stringsAsFactors = FALSE)

  result <- merge_exchanges(one, two)

  expect_equal(result$exchange, c("one", "two"))
})
