test_that("format_pooltool_rewards creates staking revenue rows", {
  input <- data.frame(
    stake_rewards = 5,
    stake_rewards_value = 10,
    rate = 2,
    date = "2021-01-01 00:00:00",
    currency = "CAD",
    epoch = 123,
    pool = "POOL1",
    stringsAsFactors = FALSE
  )

  result <- cryptoTax:::.format_pooltool_rewards(input)

  expect_equal(result$currency, "ADA")
  expect_equal(result$transaction, "revenue")
  expect_equal(result$revenue.type, "staking")
  expect_equal(result$rate.source, "pooltool")
  expect_equal(result$description, "epoch = 123")
  expect_equal(result$comment, "pool = POOL1")
})

test_that("format_pooltool_finalize annotates merged output", {
  input <- data.frame(
    date = as.POSIXct("2021-01-01 00:00:00", tz = "UTC"),
    currency = "ADA",
    quantity = 5,
    total.price = 10,
    spot.rate = 2,
    transaction = "revenue",
    description = "epoch = 123",
    comment = "pool = POOL1",
    revenue.type = "staking",
    rate.source = "pooltool",
    stringsAsFactors = FALSE
  )

  result <- cryptoTax:::.format_pooltool_finalize(input, exchange = "exodus")

  expect_equal(result$exchange, "exodus")
  expect_true(all(c("comment", "rate.source") %in% names(result)))
})
