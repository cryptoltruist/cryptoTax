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

test_that("ACB matches the worked full superficial-loss example after reacquiring the full position", {
  result <- ACB(
    data_adjustedcostbase2,
    spot.rate = "price",
    sup.loss = TRUE,
    verbose = FALSE
  )

  expect_equal(result$sup.loss, c(FALSE, TRUE, FALSE, FALSE))
  expect_equal(result$gains.uncorrected[2], -2000)
  expect_equal(result$gains.sup[2], -2000)
  expect_true(is.na(result$gains.excess[2]))
  expect_true(is.na(result$gains[2]))
  expect_equal(result$ACB[3], 5000)
  expect_equal(result$ACB.share[3], 50)
  expect_equal(result$gains[4], 3000)
})

test_that("ACB matches the worked full superficial-loss example when replacement shares were already held", {
  result <- ACB(
    data_adjustedcostbase3,
    spot.rate = "price",
    sup.loss = TRUE,
    verbose = FALSE
  )

  expect_equal(result$total.quantity, c(100, 200, 100, 0))
  expect_equal(result$sup.loss, c(FALSE, FALSE, TRUE, FALSE))
  expect_equal(result$gains.uncorrected[3], -1000)
  expect_equal(result$gains.sup[3], -1000)
  expect_true(is.na(result$gains.excess[3]))
  expect_true(is.na(result$gains[3]))
  expect_equal(result$ACB[3], 5000)
  expect_equal(result$ACB.share[3], 50)
  expect_equal(result$gains[4], 3000)
})

test_that("ACB matches the worked partial superficial-loss example with only some shares reacquired", {
  result <- ACB(
    data_adjustedcostbase4,
    spot.rate = "price",
    sup.loss = TRUE,
    verbose = FALSE
  )

  expect_equal(result$sup.loss, c(FALSE, TRUE, FALSE))
  expect_equal(result$gains.uncorrected[2], -100)
  expect_equal(result$gains.sup[2], -25)
  expect_equal(result$gains.excess[2], -75)
  expect_equal(result$gains[2], -75)
  expect_equal(result$ACB[2], 0)
  expect_equal(result$ACB[3], 80)
  expect_equal(result$ACB.share[3], 3.2)
})

test_that("ACB matches the worked chained superficial-loss example with a final partially deductible loss", {
  result <- ACB(
    data_adjustedcostbase6,
    spot.rate = "price",
    sup.loss = TRUE,
    verbose = FALSE
  )

  expect_equal(result$sup.loss, c(FALSE, TRUE, FALSE, TRUE, TRUE))
  expect_equal(result$gains.uncorrected[c(2, 4, 5)], c(-20, -11.11111, -94.11765), tolerance = 1e-5)
  expect_equal(result$gains.sup[c(2, 4, 5)], c(-20, -11.11111, -58.82353), tolerance = 1e-5)
  expect_true(all(is.na(result$gains.excess[c(2, 4)])))
  expect_equal(result$gains.excess[5], -35.29412, tolerance = 1e-5)
  expect_true(all(is.na(result$gains[c(2, 4)])))
  expect_equal(result$gains[5], -35.29412, tolerance = 1e-5)
  expect_equal(result$ACB[c(2, 3, 4, 5)], c(410, 560, 540, 344.70588), tolerance = 1e-5)
  expect_equal(result$ACB.share[c(2, 3, 4, 5)], c(3.153846, 3.111111, 3.176471, 3.830065), tolerance = 1e-6)
})

test_that("ACB does not deny a loss when no shares are reacquired or left after the superficial-loss window", {
  data <- data.frame(
    date = as.POSIXct(c("2021-01-01 00:00:00", "2021-01-10 00:00:00"), tz = "UTC"),
    transaction = c("buy", "sell"),
    quantity = c(10, 10),
    total.price = c(100, 50),
    spot.rate = c(10, 5),
    fees = c(0, 0)
  )

  result <- ACB(data, sup.loss = TRUE, verbose = FALSE)

  expect_equal(result$sup.loss, c(FALSE, FALSE))
  expect_true(all(is.na(result$gains.sup)))
  expect_true(all(is.na(result$gains.excess)))
  expect_equal(result$gains[2], -50)
  expect_equal(result$ACB[2], 0)
})

test_that("ACB does not deny a loss when the reacquisition happens after the 30-day window", {
  data <- data.frame(
    date = as.POSIXct(c(
      "2021-01-01 00:00:00",
      "2021-01-10 00:00:00",
      "2021-02-15 00:00:00"
    ), tz = "UTC"),
    transaction = c("buy", "sell", "buy"),
    quantity = c(10, 10, 10),
    total.price = c(100, 50, 70),
    spot.rate = c(10, 5, 7),
    fees = c(0, 0, 0)
  )

  result <- ACB(data, sup.loss = TRUE, verbose = FALSE)

  expect_equal(result$sup.loss, c(FALSE, FALSE, FALSE))
  expect_true(all(is.na(result$gains.sup)))
  expect_true(all(is.na(result$gains.excess)))
  expect_equal(result$gains[2], -50)
  expect_equal(result$ACB[3], 70)
  expect_equal(result$ACB.share[3], 7)
})

test_that("ACB treats a reacquisition exactly 30 days later as inside the superficial-loss window", {
  data <- data.frame(
    date = as.POSIXct(c(
      "2021-01-01 00:00:00",
      "2021-01-10 00:00:00",
      "2021-02-09 00:00:00"
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
  expect_equal(result$ACB[3], 44)
  expect_equal(result$ACB.share[3], 11)
})

test_that("ACB can deny a superficial loss based on pre-existing replacement shares that remain after the sale", {
  data <- data.frame(
    date = as.POSIXct(c(
      "2021-01-01 00:00:00",
      "2021-01-05 00:00:00",
      "2021-01-10 00:00:00"
    ), tz = "UTC"),
    transaction = c("buy", "buy", "sell"),
    quantity = c(10, 5, 10),
    total.price = c(100, 60, 50),
    spot.rate = c(10, 12, 5),
    fees = c(0, 0, 0)
  )

  result <- ACB(data, sup.loss = TRUE, verbose = FALSE)

  expect_equal(result$total.quantity, c(10, 15, 5))
  expect_equal(result$sup.loss, c(FALSE, FALSE, TRUE))
  expect_equal(result$gains.uncorrected[3], -56.66667, tolerance = 1e-5)
  expect_equal(result$gains.sup[3], -28.33333, tolerance = 1e-5)
  expect_equal(result$gains.excess[3], -28.33333, tolerance = 1e-5)
  expect_equal(result$gains[3], -28.33333, tolerance = 1e-5)
  expect_equal(result$ACB[3], 81.66667, tolerance = 1e-5)
  expect_equal(result$ACB.share[3], 16.33333, tolerance = 1e-5)
})

test_that("ACB can fully deny a partial-sale loss when pre-sale replacement shares are still held after the window", {
  data <- data.frame(
    date = as.POSIXct(c(
      "2021-01-01 00:00:00",
      "2021-01-10 00:00:00"
    ), tz = "UTC"),
    transaction = c("buy", "sell"),
    quantity = c(20, 8),
    total.price = c(200, 40),
    spot.rate = c(10, 5),
    fees = c(0, 0)
  )

  result <- ACB(data, sup.loss = TRUE, verbose = FALSE)

  expect_equal(result$total.quantity, c(20, 12))
  expect_equal(result$sup.loss, c(FALSE, TRUE))
  expect_equal(result$gains.uncorrected[2], -40)
  expect_equal(result$gains.sup[2], -40)
  expect_true(is.na(result$gains.excess[2]))
  expect_true(is.na(result$gains[2]))
  expect_equal(result$ACB[2], 160)
  expect_equal(result$ACB.share[2], 13.333333, tolerance = 1e-6)
})

test_that("ACB does not double-count a denied loss when later buys follow a superficial-loss sale with remaining replacement shares", {
  data <- data.frame(
    date = as.POSIXct(c(
      "2021-01-01 00:00:00",
      "2021-01-05 00:00:00",
      "2021-01-10 00:00:00",
      "2021-01-20 00:00:00"
    ), tz = "UTC"),
    transaction = c("buy", "buy", "sell", "buy"),
    quantity = c(10, 5, 10, 2),
    total.price = c(100, 50, 50, 12),
    spot.rate = c(10, 10, 5, 6),
    fees = c(0, 0, 0, 0)
  )

  result <- ACB(data, sup.loss = TRUE, verbose = FALSE)

  expect_equal(result$total.quantity, c(10, 15, 5, 7))
  expect_equal(result$sup.loss, c(FALSE, FALSE, TRUE, FALSE))
  expect_equal(result$gains.uncorrected[3], -50)
  expect_equal(result$gains.sup[3], -35)
  expect_equal(result$gains.excess[3], -15)
  expect_equal(result$gains[3], -15)
  expect_equal(result$ACB[3], 85)
  expect_equal(result$ACB.share[3], 17)
  expect_equal(result$ACB[4], 97)
  expect_equal(result$ACB.share[4], 13.857143, tolerance = 1e-6)
})

test_that("ACB can apply repeated superficial-loss treatment across multiple partial sales while replacement shares remain in the pool", {
  data <- data.frame(
    date = as.POSIXct(c(
      "2021-01-01 00:00:00",
      "2021-01-10 00:00:00",
      "2021-01-25 00:00:00"
    ), tz = "UTC"),
    transaction = c("buy", "sell", "sell"),
    quantity = c(20, 8, 4),
    total.price = c(200, 40, 28),
    spot.rate = c(10, 5, 7),
    fees = c(0, 0, 0)
  )

  result <- ACB(data, sup.loss = TRUE, verbose = FALSE)

  expect_equal(result$total.quantity, c(20, 12, 8))
  expect_equal(result$sup.loss, c(FALSE, TRUE, TRUE))
  expect_equal(result$gains.uncorrected[c(2, 3)], c(-40, -25.333333), tolerance = 1e-6)
  expect_equal(result$gains.sup[c(2, 3)], c(-40, -25.333333), tolerance = 1e-6)
  expect_true(all(is.na(result$gains.excess[c(2, 3)])))
  expect_true(all(is.na(result$gains[c(2, 3)])))
  expect_equal(result$ACB, c(200, 160, 132), tolerance = 1e-6)
  expect_equal(result$ACB.share, c(10, 13.333333, 16.5), tolerance = 1e-6)
})

test_that("ACB returns to deductible losses once no replacement shares remain at the end of a later sale window", {
  data <- data.frame(
    date = as.POSIXct(c(
      "2021-01-01 00:00:00",
      "2021-01-10 00:00:00",
      "2021-01-25 00:00:00",
      "2021-02-15 00:00:00"
    ), tz = "UTC"),
    transaction = c("buy", "sell", "sell", "sell"),
    quantity = c(20, 8, 4, 8),
    total.price = c(200, 40, 28, 48),
    spot.rate = c(10, 5, 7, 6),
    fees = c(0, 0, 0, 0)
  )

  result <- ACB(data, sup.loss = TRUE, verbose = FALSE)

  expect_equal(result$total.quantity, c(20, 12, 8, 0))
  expect_equal(result$sup.loss, c(FALSE, TRUE, FALSE, FALSE))
  expect_equal(result$gains.uncorrected[c(2, 3, 4)], c(-40, -25.333333, -58.666667), tolerance = 1e-6)
  expect_equal(result$gains.sup[2], -40)
  expect_true(all(is.na(result$gains.sup[c(3, 4)])))
  expect_true(all(is.na(result$gains.excess[c(2, 3, 4)])))
  expect_equal(result$gains[c(3, 4)], c(-25.333333, -58.666667), tolerance = 1e-6)
  expect_true(is.na(result$gains[2]))
  expect_equal(result$ACB, c(200, 160, 106.666667, 0), tolerance = 1e-6)
  expect_equal(result$ACB.share, c(10, 13.333333, 13.333333, 0), tolerance = 1e-6)
})

test_that("ACB does not deny a loss when reacquired replacement shares are fully disposed before the window ends", {
  data <- data.frame(
    date = as.POSIXct(c(
      "2021-01-01 00:00:00",
      "2021-01-10 00:00:00",
      "2021-01-20 00:00:00",
      "2021-01-25 00:00:00"
    ), tz = "UTC"),
    transaction = c("buy", "sell", "buy", "sell"),
    quantity = c(10, 10, 10, 10),
    total.price = c(100, 50, 60, 70),
    spot.rate = c(10, 5, 6, 7),
    fees = c(0, 0, 0, 0)
  )

  result <- ACB(data, sup.loss = TRUE, verbose = FALSE)

  expect_equal(result$sup.loss, c(FALSE, FALSE, FALSE, FALSE))
  expect_true(all(is.na(result$gains.sup)))
  expect_true(all(is.na(result$gains.excess)))
  expect_equal(result$gains.uncorrected[c(2, 4)], c(-50, 10))
  expect_equal(result$gains[c(2, 4)], c(-50, 10))
  expect_equal(result$ACB, c(100, 0, 60, 0))
  expect_equal(result$ACB.share, c(10, 0, 6, 0))
})

test_that("ACB limits a superficial-loss denial to the replacement shares still held after partial replacement disposals", {
  data <- data.frame(
    date = as.POSIXct(c(
      "2021-01-01 00:00:00",
      "2021-01-10 00:00:00",
      "2021-01-20 00:00:00",
      "2021-01-25 00:00:00"
    ), tz = "UTC"),
    transaction = c("buy", "sell", "buy", "sell"),
    quantity = c(10, 10, 6, 4),
    total.price = c(100, 50, 36, 40),
    spot.rate = c(10, 5, 6, 10),
    fees = c(0, 0, 0, 0)
  )

  result <- ACB(data, sup.loss = TRUE, verbose = FALSE)

  expect_equal(result$sup.loss, c(FALSE, TRUE, FALSE, FALSE))
  expect_equal(result$gains.uncorrected[c(2, 4)], c(-50, 9.333333), tolerance = 1e-6)
  expect_equal(result$gains.sup[2], -10)
  expect_equal(result$gains.excess[2], -40)
  expect_equal(result$gains[c(2, 4)], c(-40, 9.333333), tolerance = 1e-6)
  expect_equal(result$ACB, c(100, 0, 46, 15.333333), tolerance = 1e-6)
  expect_equal(result$ACB.share, c(10, 0, 7.666667, 7.666667), tolerance = 1e-6)
})

test_that("ACB allows a first-row non-taxable revenue lot with zero opening cost base", {
  data <- data.frame(
    date = as.POSIXct(c(
      "2021-01-01 00:00:00",
      "2021-01-10 00:00:00"
    ), tz = "UTC"),
    transaction = c("revenue", "sell"),
    quantity = c(2, 1),
    total.price = c(20, 15),
    spot.rate = c(10, 15),
    revenue.type = c("promos", NA),
    fees = c(0, 0)
  )

  result <- ACB(data, sup.loss = FALSE, verbose = FALSE)

  expect_equal(result$value, c(20, 15))
  expect_equal(result$total.price, c(0, 15))
  expect_equal(result$total.quantity, c(2, 1))
  expect_equal(result$ACB, c(0, 0))
  expect_equal(result$ACB.share, c(0, 0))
  expect_equal(result$gains, c(NA, 15))
})

test_that("ACB allows a first-row taxable revenue lot as the opening cost base", {
  data <- data.frame(
    date = as.POSIXct(c(
      "2021-01-01 00:00:00",
      "2021-01-10 00:00:00"
    ), tz = "UTC"),
    transaction = c("revenue", "sell"),
    quantity = c(2, 1),
    total.price = c(20, 15),
    spot.rate = c(10, 15),
    revenue.type = c("staking", NA),
    fees = c(0, 0)
  )

  result <- ACB(data, sup.loss = FALSE, verbose = FALSE)

  expect_equal(result$value, c(20, 15))
  expect_equal(result$total.price, c(20, 15))
  expect_equal(result$total.quantity, c(2, 1))
  expect_equal(result$ACB, c(20, 10))
  expect_equal(result$ACB.share, c(10, 10))
  expect_equal(result$gains, c(NA, 5))
})

test_that("ACB keeps non-taxable crypto revenue out of cost base while still increasing quantity", {
  data <- data.frame(
    date = as.POSIXct(c(
      "2021-01-01 00:00:00",
      "2021-01-05 00:00:00",
      "2021-01-10 00:00:00"
    ), tz = "UTC"),
    transaction = c("buy", "revenue", "sell"),
    quantity = c(10, 2, 10),
    total.price = c(100, 20, 120),
    spot.rate = c(10, 10, 12),
    revenue.type = c(NA, "promos", NA),
    fees = c(0, 0, 0)
  )

  result <- ACB(data, sup.loss = FALSE, verbose = FALSE)

  expect_equal(result$value, c(100, 20, 120))
  expect_equal(result$total.price, c(100, 0, 120))
  expect_equal(result$total.quantity, c(10, 12, 2))
  expect_equal(result$ACB, c(100, 100, 16.66667), tolerance = 1e-5)
  expect_equal(result$ACB.share, c(10, 8.333333, 8.333333), tolerance = 1e-6)
  expect_equal(result$gains[3], 36.66667, tolerance = 1e-5)
})

test_that("ACB includes staking revenue in cost base by default", {
  data <- data.frame(
    date = as.POSIXct(c(
      "2021-01-01 00:00:00",
      "2021-01-05 00:00:00",
      "2021-01-10 00:00:00"
    ), tz = "UTC"),
    transaction = c("buy", "revenue", "sell"),
    quantity = c(10, 2, 10),
    total.price = c(100, 20, 120),
    spot.rate = c(10, 10, 12),
    revenue.type = c(NA, "staking", NA),
    fees = c(0, 0, 0)
  )

  result <- ACB(data, sup.loss = FALSE, verbose = FALSE)

  expect_equal(result$total.price, c(100, 20, 120))
  expect_equal(result$total.quantity, c(10, 12, 2))
  expect_equal(result$ACB, c(100, 120, 20))
  expect_equal(result$ACB.share, c(10, 10, 10))
  expect_equal(result$gains[3], 20)
})

test_that("ACB lets callers exclude staking from cost base through as.revenue", {
  data <- data.frame(
    date = as.POSIXct(c(
      "2021-01-01 00:00:00",
      "2021-01-05 00:00:00",
      "2021-01-10 00:00:00"
    ), tz = "UTC"),
    transaction = c("buy", "revenue", "sell"),
    quantity = c(10, 2, 10),
    total.price = c(100, 20, 120),
    spot.rate = c(10, 10, 12),
    revenue.type = c(NA, "staking", NA),
    fees = c(0, 0, 0)
  )

  result <- ACB(
    data,
    as.revenue = c("interests", "mining"),
    sup.loss = FALSE,
    verbose = FALSE
  )

  expect_equal(result$total.price, c(100, 0, 120))
  expect_equal(result$ACB, c(100, 100, 16.66667), tolerance = 1e-5)
  expect_equal(result$ACB.share, c(10, 8.333333, 8.333333), tolerance = 1e-6)
  expect_equal(result$gains[3], 36.66667, tolerance = 1e-5)
})

test_that("ACB incorporates buy and sell fees into cost base and realized gains", {
  data <- data.frame(
    date = as.POSIXct(c("2021-01-01 00:00:00", "2021-01-10 00:00:00"), tz = "UTC"),
    transaction = c("buy", "sell"),
    quantity = c(10, 10),
    total.price = c(100, 120),
    spot.rate = c(10, 12),
    fees = c(5, 2)
  )

  result <- ACB(data, sup.loss = FALSE, verbose = FALSE)

  expect_equal(result$ACB[1], 105)
  expect_equal(result$ACB.share[1], 10.5)
  expect_equal(result$gains[2], 13)
  expect_equal(result$ACB[2], 0)
})

test_that("ACB accepts fee-inclusive acquisition totals when fees are already zeroed", {
  data <- data.frame(
    date = as.POSIXct(c("2021-01-01 00:00:00", "2021-01-10 00:00:00"), tz = "UTC"),
    transaction = c("buy", "sell"),
    quantity = c(10, 10),
    total.price = c(105, 120),
    spot.rate = c(10.5, 12),
    fees = c(0, 2)
  )

  result <- ACB(data, sup.loss = FALSE, verbose = FALSE)

  expect_equal(result$ACB[1], 105)
  expect_equal(result$ACB.share[1], 10.5)
  expect_equal(result$gains[2], 13)
  expect_equal(result$ACB[2], 0)
})

test_that("ACB never applies superficial-loss treatment to a sale that realizes a gain", {
  data <- data.frame(
    date = as.POSIXct(c(
      "2021-01-01 00:00:00",
      "2021-01-10 00:00:00",
      "2021-01-20 00:00:00"
    ), tz = "UTC"),
    transaction = c("buy", "sell", "buy"),
    quantity = c(10, 10, 4),
    total.price = c(100, 150, 48),
    spot.rate = c(10, 15, 12),
    fees = c(0, 0, 0)
  )

  result <- ACB(data, sup.loss = TRUE, verbose = FALSE)

  expect_equal(result$sup.loss, c(FALSE, FALSE, FALSE))
  expect_true(all(is.na(result$gains.sup)))
  expect_true(all(is.na(result$gains.excess)))
  expect_equal(result$gains[2], 50)
  expect_equal(result$ACB, c(100, 0, 48))
  expect_equal(result$ACB.share, c(10, 0, 12))
})

test_that("ACB applies partial superficial losses using fee-adjusted gains and reacquisition cost base", {
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
    fees = c(5, 2, 1)
  )

  result <- ACB(data, sup.loss = TRUE, verbose = FALSE)

  expect_equal(result$sup.loss, c(FALSE, TRUE, FALSE))
  expect_equal(result$gains.uncorrected[2], -57)
  expect_equal(result$gains.sup[2], -22.8, tolerance = 1e-6)
  expect_equal(result$gains.excess[2], -34.2, tolerance = 1e-6)
  expect_equal(result$gains[2], -34.2, tolerance = 1e-6)
  expect_equal(result$ACB, c(105, 0, 47.8), tolerance = 1e-6)
  expect_equal(result$ACB.share, c(10.5, 0, 11.95), tolerance = 1e-6)
})

test_that("ACB limits a day-30 superficial-loss denial to replacement shares still held at the end of the window", {
  data <- data.frame(
    date = as.POSIXct(c(
      "2021-01-01 00:00:00",
      "2021-01-10 00:00:00",
      "2021-02-09 00:00:00",
      "2021-02-15 00:00:00"
    ), tz = "UTC"),
    transaction = c("buy", "sell", "buy", "sell"),
    quantity = c(10, 10, 4, 4),
    total.price = c(100, 50, 24, 28),
    spot.rate = c(10, 5, 6, 7),
    fees = c(0, 0, 0, 0)
  )

  result <- ACB(data, sup.loss = TRUE, verbose = FALSE)

  expect_equal(result$sup.loss, c(FALSE, TRUE, FALSE, FALSE))
  expect_equal(result$gains.uncorrected[c(2, 4)], c(-50, -16))
  expect_equal(result$gains.sup[2], -20)
  expect_equal(result$gains.excess[2], -30)
  expect_equal(result$gains[c(2, 4)], c(-30, -16))
  expect_equal(result$ACB, c(100, 0, 44, 0))
  expect_equal(result$ACB.share, c(10, 0, 11, 0))
})

test_that("ACB does not treat post-sale revenue alone as a superficial-loss acquisition", {
  data <- data.frame(
    date = as.POSIXct(c(
      "2020-11-01 00:00:00",
      "2021-01-10 00:00:00",
      "2021-01-20 00:00:00"
    ), tz = "UTC"),
    transaction = c("buy", "sell", "revenue"),
    quantity = c(10, 10, 4),
    total.price = c(100, 50, 24),
    spot.rate = c(10, 5, 6),
    revenue.type = c(NA, NA, "staking"),
    fees = c(0, 0, 0)
  )

  result <- ACB(data, sup.loss = TRUE, verbose = FALSE)

  expect_equal(result$sup.loss, c(FALSE, FALSE, FALSE))
  expect_true(all(is.na(result$gains.sup)))
  expect_true(all(is.na(result$gains.excess)))
  expect_equal(result$gains[2], -50)
  expect_equal(result$ACB, c(100, 0, 24))
  expect_equal(result$ACB.share, c(10, 0, 6))
})

test_that("ACB does not treat pre-sale revenue alone as a superficial-loss acquisition", {
  data <- data.frame(
    date = as.POSIXct(c(
      "2020-11-01 00:00:00",
      "2021-01-05 00:00:00",
      "2021-01-10 00:00:00"
    ), tz = "UTC"),
    transaction = c("buy", "revenue", "sell"),
    quantity = c(10, 5, 10),
    total.price = c(100, 60, 50),
    spot.rate = c(10, 12, 5),
    revenue.type = c(NA, "staking", NA),
    fees = c(0, 0, 0)
  )

  result <- ACB(data, sup.loss = TRUE, verbose = FALSE)

  expect_equal(result$total.quantity, c(10, 15, 5))
  expect_equal(result$sup.loss, c(FALSE, FALSE, FALSE))
  expect_true(all(is.na(result$gains.sup)))
  expect_true(all(is.na(result$gains.excess)))
  expect_equal(result$gains[3], -56.66667, tolerance = 1e-5)
  expect_equal(result$ACB[3], 53.33333, tolerance = 1e-5)
  expect_equal(result$ACB.share[3], 10.66667, tolerance = 1e-5)
})

test_that("ACB can still deny a loss when a qualifying buy exists in the window and revenue units remain owned at the end", {
  data <- data.frame(
    date = as.POSIXct(c(
      "2021-01-01 00:00:00",
      "2021-01-10 00:00:00",
      "2021-01-20 00:00:00"
    ), tz = "UTC"),
    transaction = c("buy", "sell", "revenue"),
    quantity = c(10, 10, 4),
    total.price = c(100, 50, 24),
    spot.rate = c(10, 5, 6),
    revenue.type = c(NA, NA, "staking"),
    fees = c(0, 0, 0)
  )

  result <- ACB(data, sup.loss = TRUE, verbose = FALSE)

  expect_equal(result$sup.loss, c(FALSE, TRUE, FALSE))
  expect_equal(result$gains.uncorrected[2], -50)
  expect_equal(result$gains.sup[2], -20)
  expect_equal(result$gains.excess[2], -30)
  expect_equal(result$gains[2], -30)
  expect_equal(result$ACB, c(100, 0, 44))
  expect_equal(result$ACB.share, c(10, 0, 11))
})

test_that("ACB does not treat rebates alone as a superficial-loss acquisition", {
  data <- data.frame(
    date = as.POSIXct(c(
      "2020-11-01 00:00:00",
      "2021-01-05 00:00:00",
      "2021-01-10 00:00:00"
    ), tz = "UTC"),
    transaction = c("buy", "rebates", "sell"),
    quantity = c(10, 5, 10),
    total.price = c(100, 60, 50),
    spot.rate = c(10, 12, 5),
    fees = c(0, 0, 0)
  )

  result <- ACB(data, sup.loss = TRUE, verbose = FALSE)

  expect_equal(result$total.quantity, c(10, 15, 5))
  expect_equal(result$sup.loss, c(FALSE, FALSE, FALSE))
  expect_true(all(is.na(result$gains.sup)))
  expect_true(all(is.na(result$gains.excess)))
  expect_equal(result$gains[3], -56.66667, tolerance = 1e-5)
  expect_equal(result$ACB[3], 53.33333, tolerance = 1e-5)
  expect_equal(result$ACB.share[3], 10.66667, tolerance = 1e-5)
})

test_that("ACB can still deny a loss when a qualifying buy exists in the window and rebates remain owned at the end", {
  data <- data.frame(
    date = as.POSIXct(c(
      "2021-01-01 00:00:00",
      "2021-01-10 00:00:00",
      "2021-01-20 00:00:00"
    ), tz = "UTC"),
    transaction = c("buy", "sell", "rebates"),
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
  expect_equal(result$ACB, c(100, 0, 44))
  expect_equal(result$ACB.share, c(10, 0, 11))
})
