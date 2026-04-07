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

test_that("merge_exchanges ignores nested non-data-frame inputs", {
  one <- data.frame(
    date = as.POSIXct("2021-01-02 00:00:00", tz = "UTC"),
    exchange = "one"
  )

  result <- merge_exchanges(list(one, list("nope", NULL)))

  expect_equal(result$exchange, "one")
})

test_that("merge_exchanges keeps data without date columns unsorted", {
  one <- data.frame(exchange = "one", stringsAsFactors = FALSE)
  two <- data.frame(exchange = "two", stringsAsFactors = FALSE)

  result <- merge_exchanges(one, two)

  expect_equal(result$exchange, c("one", "two"))
})

test_that("normalize_merge_inputs keeps empty typed inputs for schema preservation", {
  empty <- data.frame(date = as.POSIXct(character()), exchange = character())
  full <- data.frame(
    date = as.POSIXct("2021-01-01 00:00:00", tz = "UTC"),
    exchange = "one"
  )

  result <- cryptoTax:::.normalize_merge_inputs(list(NULL, empty, full))

  expect_length(result, 2)
  expect_s3_class(result[[1]], "data.frame")
  expect_equal(nrow(result[[1]]), 0)
  expect_equal(nrow(result[[2]]), 1)
})

test_that("merge input helpers classify mergeable and nonempty inputs", {
  empty <- data.frame(x = numeric())
  full <- data.frame(x = 1)

  expect_true(cryptoTax:::.is_mergeable_exchange_input(NULL))
  expect_true(cryptoTax:::.is_mergeable_exchange_input(full))
  expect_false(cryptoTax:::.is_mergeable_exchange_input("nope"))

  expect_false(cryptoTax:::.is_nonempty_merge_input(empty))
  expect_true(cryptoTax:::.is_nonempty_merge_input(full))
})

test_that("merge_exchanges_has_date reflects whether sorting should use date", {
  expect_true(cryptoTax:::.merge_exchanges_has_date(data.frame(date = Sys.time())))
  expect_false(cryptoTax:::.merge_exchanges_has_date(data.frame(exchange = "x")))
})
