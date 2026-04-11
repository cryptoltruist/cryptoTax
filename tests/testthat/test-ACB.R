# https://www.data_adjustedcostbase/blog/what-is-the-superficial-loss-rule/
# https://www.data_adjustedcostbase/blog/applying-the-superficial-loss-rule-for-a-partial-disposition-of-shares/

test_that("Example #0 - ACB", {
  expect_snapshot(ACB(data_adjustedcostbase1, spot.rate = "price", sup.loss = FALSE))
})

test_that("Example #1 - ACB", {
  expect_snapshot(ACB(data_adjustedcostbase2, spot.rate = "price", sup.loss = FALSE))
  expect_snapshot(ACB(data_adjustedcostbase2, spot.rate = "price"))
})

test_that("Example #2 - ACB", {
  expect_snapshot(ACB(data_adjustedcostbase3, spot.rate = "price", sup.loss = FALSE))
  expect_snapshot(ACB(data_adjustedcostbase3, spot.rate = "price"))
})

test_that("Example #3 - ACB", {
  expect_snapshot(ACB(data_adjustedcostbase4, spot.rate = "price", sup.loss = FALSE))
  expect_snapshot(ACB(data_adjustedcostbase4, spot.rate = "price"))
})

test_that("Example #4 - ACB", {
  expect_snapshot(ACB(data_adjustedcostbase5, spot.rate = "price", sup.loss = FALSE))
  expect_snapshot(ACB(data_adjustedcostbase5, spot.rate = "price"))
})

test_that("Example #5 - ACB", {
  expect_snapshot(ACB(data_adjustedcostbase6, spot.rate = "price", sup.loss = FALSE))
  expect_snapshot(ACB(data_adjustedcostbase6, spot.rate = "price"))
})

test_that("Example #6 - CryptoTaxCalculator", {
  expect_snapshot(ACB(data_cryptotaxcalculator1,
    transaction = "trade",
    spot.rate = "price", sup.loss = FALSE
  ))
  expect_snapshot(ACB(data_cryptotaxcalculator1,
    transaction = "trade",
    spot.rate = "price"
  ))
})

test_that("Example #7 - CryptoTaxCalculator", {
  expect_snapshot(ACB(data_cryptotaxcalculator2,
    transaction = "trade",
    spot.rate = "price", sup.loss = FALSE
  ))
  expect_snapshot(ACB(data_cryptotaxcalculator2,
    transaction = "trade",
    spot.rate = "price"
  ))
})

test_that("Example #8 - Coinpanda", {
  expect_snapshot(ACB(data_coinpanda1,
    transaction = "type", quantity = "amount",
    total.price = "price", sup.loss = FALSE
  ))
})

test_that("Example #9 - Coinpanda", {
  expect_snapshot(ACB(data_coinpanda2,
    transaction = "type", quantity = "amount",
    total.price = "price", sup.loss = FALSE
  ))
  expect_snapshot(ACB(data_coinpanda2,
    transaction = "type", quantity = "amount",
    total.price = "price"
  ))
})

test_that("Example #10 - Koinly", {
  expect_snapshot(ACB(data_koinly, sup.loss = FALSE))
  expect_snapshot(ACB(data_koinly))
})

test_that("ACB rejects a first-row sale", {
  data <- data.frame(
    date = as.POSIXct("2021-01-01 00:00:00", tz = "UTC"),
    transaction = "sell",
    quantity = 1,
    total.price = 10,
    spot.rate = 10
  )

  expect_error(
    ACB(data, sup.loss = FALSE, verbose = FALSE),
    "The first transaction for this currency cannot be a sale."
  )
})

test_that("ACB resets ACB and ACB.share to zero after a full disposition", {
  data <- data.frame(
    date = as.POSIXct(c("2021-01-01 00:00:00", "2021-01-10 00:00:00"), tz = "UTC"),
    transaction = c("buy", "sell"),
    quantity = c(1, 1),
    total.price = c(100, 120),
    spot.rate = c(100, 120),
    fees = c(0, 0)
  )

  result <- ACB(data, sup.loss = FALSE, verbose = FALSE)

  expect_equal(result$total.quantity, c(1, 0))
  expect_equal(result$ACB, c(100, 0))
  expect_equal(result$ACB.share, c(100, 0))
  expect_equal(result$gains, c(NA, 20))
})

test_that("ACB applies partial superficial losses proportionally when only some shares are reacquired", {
  data <- data.frame(
    date = as.POSIXct(c(
      "2021-01-01 00:00:00",
      "2021-01-10 00:00:00",
      "2021-01-20 00:00:00"
    ), tz = "UTC"),
    transaction = c("buy", "sell", "buy"),
    quantity = c(10, 10, 4),
    total.price = c(100, 50, 24),
    spot.rate = c(10, 5, 6),
    fees = c(0, 0, 0)
  )

  result <- ACB(data, sup.loss = TRUE, verbose = FALSE)

  expect_equal(result$sup.loss, c(FALSE, TRUE, FALSE))
  expect_equal(result$gains.uncorrected[2], -50)
  expect_equal(result$gains.sup[2], -20)
  expect_equal(result$gains.excess[2], -30)
  expect_equal(result$gains[2], -30)
  expect_equal(result$ACB[2], 0)
  expect_equal(result$ACB[3], 44)
  expect_equal(result$ACB.share[3], 11)
})
