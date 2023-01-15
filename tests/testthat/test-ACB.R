# https://www.data_adjustedcostbase/blog/what-is-the-superficial-loss-rule/
# https://www.data_adjustedcostbase/blog/applying-the-superficial-loss-rule-for-a-partial-disposition-of-shares/

test_that("Example #0 - ACB", {
  data <- data_adjustedcostbase1
  data
  expect_equal(
    ACB(data, spot.rate = "price", sup.loss = FALSE),
    structure(
      list(
        date = as.Date(c("2014-03-03", "2014-05-01", "2014-07-18", "2014-09-25")),
        transaction = c("buy", "sell", "buy", "sell"),
        quantity = c(100, 50, 50, 40),
        price = c(50, 120, 130, 90),
        fees = c(10, 10, 10, 10),
        total.price = c(5000, 6000, 6500, 3600),
        total.quantity = c(100, 50, 100, 60),
        ACB = c(5010, 2505, 9015, 5409),
        ACB.share = c(50.1, 50.1, 90.15, 90.15),
        gains = c(NA, 3485, NA, -16)
      ),
      row.names = c(NA, -4L),
      class = "data.frame"
    )
  )
})

test_that("Example #1 - ACB", {
  data <- data_adjustedcostbase2
  data

  expect_equal(
    ACB(data, spot.rate = "price", sup.loss = FALSE),
    structure(
      list(
        date = structure(c(16076, 16377, 16378, 16771), class = "Date"),
        transaction = c("buy", "sell", "buy", "sell"),
        quantity = c(100, 100, 100, 100),
        price = c(50, 30, 30, 80),
        total.price = c(5000, 3000, 3000, 8000),
        fees = c(0, 0, 0, 0),
        total.quantity = c(100, 0, 100, 0),
        ACB = c(5000, 0, 3000, 0),
        ACB.share = c(50, 0, 30, 0),
        gains = c(NA, -2000, NA, 5000)
      ),
      row.names = c(NA, -4L), class = c("data.frame")
    )
  )

  expect_equal(
    ACB(data, spot.rate = "price"),
    structure(
      list(
        date = structure(c(16076, 16377, 16378, 16771), class = "Date"),
        transaction = c("buy", "sell", "buy", "sell"),
        quantity = c(100, 100, 100, 100),
        price = c(50, 30, 30, 80),
        total.price = c(5000, 3000, 3000, 8000),
        fees = c(0, 0, 0, 0),
        total.quantity = c(100, 0, 100, 0),
        suploss.range = new(
          "Interval",
          .Data = c(5184000, 5184000, 5184000, 5184000),
          start = structure(c(1386374400, 1412380800, 1412467200, 1446422400),
            class = c("POSIXct", "POSIXt"), tzone = "UTC"
          ), tzone = "UTC"
        ),
        quantity.60days = c(100, 100, 100, 0),
        share.left60 = c(100, 100, 100, 0),
        sup.loss.quantity = c(0, 100, 0, 0),
        sup.loss = c(FALSE, TRUE, FALSE, FALSE),
        gains.uncorrected = c(0, -2000, 0, 3000),
        gains.sup = c(NA, -2000, NA, NA),
        gains.excess = c(NA, NA, NA, NA),
        gains = c(NA, NA, NA, 3000),
        ACB = c(5000, 0, 5000, 0),
        ACB.share = c(50, 0, 50, 0)
      ),
      row.names = c(NA, -4L),
      class = c("data.frame")
    )
  )
})

test_that("Example #2 - ACB", {
  data <- data_adjustedcostbase3
  data <- data

  expect_equal(
    ACB(data, spot.rate = "price", sup.loss = FALSE),
    structure(
      list(
        date = structure(c(16076, 16377, 16378, 16771), class = "Date"),
        transaction = c("buy", "buy", "sell", "sell"),
        quantity = c(100, 100, 100, 100),
        price = c(50, 30, 30, 80),
        total.price = c(5000, 3000, 3000, 8000),
        fees = c(0, 0, 0, 0),
        total.quantity = c(100, 200, 100, 0),
        ACB = c(5000, 8000, 4000, 0),
        ACB.share = c(50, 40, 40, 0),
        gains = c(NA, NA, -1000, 4000)
      ),
      row.names = c(NA, -4L), class = "data.frame"
    )
  )

  expect_equal(
    ACB(data, spot.rate = "price"),
    structure(
      list(
        date = structure(c(16076, 16377, 16378, 16771), class = "Date"),
        transaction = c("buy", "buy", "sell", "sell"),
        quantity = c(100, 100, 100, 100),
        price = c(50, 30, 30, 80),
        total.price = c(5000, 3000, 3000, 8000),
        fees = c(0, 0, 0, 0),
        total.quantity = c(100, 200, 100, 0),
        suploss.range = new(
          "Interval",
          .Data = c(5184000, 5184000, 5184000, 5184000),
          start = structure(c(1386374400, 1412380800, 1412467200, 1446422400),
            class = c("POSIXct", "POSIXt"), tzone = "UTC"
          ), tzone = "UTC"
        ),
        quantity.60days = c(100, 100, 100, 0),
        share.left60 = c(100, 100, 100, 0),
        sup.loss.quantity = c(0, 0, 100, 0),
        sup.loss = c(FALSE, FALSE, TRUE, FALSE),
        gains.uncorrected = c(0, 0, -1000, 3000),
        gains.sup = c(NA, NA, -1000, NA),
        gains.excess = c(NA, NA, NA, NA),
        gains = c(NA, NA, NA, 3000),
        ACB = c(5000, 8000, 5000, 0),
        ACB.share = c(50, 40, 50, 0)
      ),
      row.names = c(NA, -4L), class = "data.frame"
    )
  )
})

test_that("Example #3 - ACB", {
  data <- data_adjustedcostbase4
  data <- data

  expect_equal(
    ACB(data, spot.rate = "price", sup.loss = FALSE),
    structure(
      list(
        date = structure(c(16437, 16534, 16535), class = "Date"),
        transaction = c("buy", "sell", "buy"),
        quantity = c(100, 100, 25),
        price = c(3, 2, 2.2),
        total.price = c(300, 200, 55),
        fees = c(0, 0, 0),
        total.quantity = c(100, 0, 25),
        ACB = c(300, 0, 55),
        ACB.share = c(3, 0, 2.2),
        gains = c(NA, -100, NA)
      ),
      row.names = c(NA, -3L), class = "data.frame"
    )
  )

  expect_equal(
    ACB(data, spot.rate = "price"),
    structure(
      list(
        date = structure(c(16437, 16534, 16535), class = "Date"),
        transaction = c("buy", "sell", "buy"),
        quantity = c(100, 100, 25),
        price = c(3, 2, 2.2),
        total.price = c(300, 200, 55),
        fees = c(0, 0, 0),
        total.quantity = c(100, 0, 25),
        suploss.range = new(
          "Interval",
          .Data = c(5184000, 5184000, 5184000),
          start = structure(c(1417564800, 1425945600, 1426032000),
            class = c("POSIXct", "POSIXt"), tzone = "UTC"
          ),
          tzone = "UTC"
        ),
        quantity.60days = c(100, 25, 25),
        share.left60 = c(100, 25, 25),
        sup.loss.quantity = c(0, 100, 0),
        sup.loss = c(FALSE, TRUE, FALSE),
        gains.uncorrected = c(0, -100, 0),
        gains.sup = c(NA, -25, NA),
        gains.excess = c(NA, -75, NA),
        gains = c(NA, -75, NA),
        ACB = c(300, 0, 80),
        ACB.share = c(3, 0, 3.2)
      ),
      row.names = c(NA, -3L), class = "data.frame"
    )
  )
})

test_that("Example #4 - ACB", {
  data <- data_adjustedcostbase5
  data <- data

  expect_equal(
    ACB(data, spot.rate = "price", sup.loss = FALSE),
    structure(
      list(
        date = structure(c(16534, 16535), class = "Date"),
        transaction = c("buy", "sell"),
        quantity = c(100, 80),
        price = c(3, 2),
        total.price = c(300, 160),
        fees = c(0, 0),
        total.quantity = c(100, 20),
        ACB = c(300, 60),
        ACB.share = c(3, 3),
        gains = c(NA, -80)
      ),
      row.names = c(NA, -2L), class = "data.frame"
    )
  )

  expect_equal(
    ACB(data, spot.rate = "price"),
    structure(
      list(
        date = structure(c(16534, 16535), class = "Date"),
        transaction = c("buy", "sell"),
        quantity = c(100, 80),
        price = c(3, 2),
        total.price = c(300, 160),
        fees = c(0, 0),
        total.quantity = c(100, 20),
        suploss.range = new(
          "Interval",
          .Data = c(5184000, 5184000),
          start = structure(c(1425945600, 1426032000),
            class = c("POSIXct", "POSIXt"), tzone = "UTC"
          ),
          tzone = "UTC"
        ),
        quantity.60days = c(100, 100),
        share.left60 = c(20, 20),
        sup.loss.quantity = c(0, 80),
        sup.loss = c(FALSE, TRUE),
        gains.uncorrected = c(0, -80),
        gains.sup = c(NA, -20),
        gains.excess = c(NA, NA),
        gains = c(NA, NA),
        ACB = c(300, 80),
        ACB.share = c(3, 4)
      ),
      row.names = c(NA, -2L), class = "data.frame"
    )
  )
})

test_that("Example #5 - ACB", {
  data <- data_adjustedcostbase6
  data <- data

  expect_equal(
    ACB(data, spot.rate = "price", sup.loss = FALSE),
    structure(
      list(
        date = structure(c(16534, 16535, 16540, 16545, 16570), class = "Date"),
        transaction = c("buy", "sell", "buy", "sell", "sell"),
        quantity = c(150, 20, 50, 10, 80),
        price = c(3, 2, 3, 2, 2),
        total.price = c(450, 40, 150, 20, 160),
        fees = c(0, 0, 0, 0, 0),
        total.quantity = c(150, 130, 180, 170, 90),
        ACB = c(450, 390, 540, 510, 270),
        ACB.share = c(3, 3, 3, 3, 3),
        gains = c(NA, -20, NA, -10, -80)
      ),
      row.names = c(NA, -5L), class = "data.frame"
    )
  )

  expect_equal(
    ACB(data, spot.rate = "price"),
    structure(
      list(
        date = structure(c(16534, 16535, 16540, 16545, 16570), class = "Date"),
        transaction = c("buy", "sell", "buy", "sell", "sell"),
        quantity = c(150, 20, 50, 10, 80),
        price = c(3, 2, 3, 2, 2),
        total.price = c(450, 40, 150, 20, 160),
        fees = c(0, 0, 0, 0, 0),
        total.quantity = c(150, 130, 180, 170, 90),
        suploss.range = new(
          "Interval",
          .Data = c(5184000, 5184000, 5184000, 5184000, 5184000),
          start = structure(
            c(
              1425945600, 1426032000, 1426464000, 1426896000, 1429056000
            ),
            class = c("POSIXct", "POSIXt"), tzone = "UTC"
          ), tzone = "UTC"
        ),
        quantity.60days = c(200, 200, 200, 200, 50),
        share.left60 = c(170, 170, 90, 90, 90),
        sup.loss.quantity = c(0, 20, 0, 10, 80),
        sup.loss = c(FALSE, TRUE, FALSE, TRUE, TRUE),
        gains.uncorrected = c(0, -20, 0, -12.2222222222222, -103.529411764706),
        gains.sup = c(NA, -20, NA, -12.2222222222222, -64.7058823529412),
        gains.excess = c(NA, NA, NA, NA, -38.8235294117647),
        gains = c(NA, NA, NA, NA, -38.8235294117647),
        ACB = c(450, 410, 580, 560, 361.176470588235),
        ACB.share = c(
          3, 3.15384615384615, 3.22222222222222,
          3.29411764705882, 4.01307189542484
        )
      ),
      row.names = c(NA, -5L), class = "data.frame"
    )
  )
})

test_that("Example #6 - CryptoTaxCalculator", {
  data <- data_cryptotaxcalculator1
  data <- data

  expect_equal(
    ACB(data, transaction = "trade", spot.rate = "price", sup.loss = FALSE),
    structure(
      list(
        date = structure(c(18262, 18295, 18296, 18662), class = "Date"),
        trade = c("buy", "sell", "buy", "sell"),
        currency = c("BTC", "BTC", "BTC", "BTC"),
        price = c(5000, 3000, 3000, 10000),
        quantity = c(2, 2, 2, 2),
        total.price = c(10000, 6000, 6000, 20000),
        fees = c(0, 0, 0, 0),
        total.quantity = c(2, 0, 2, 0),
        ACB = c(10000, 0, 6000, 0),
        ACB.share = c(5000, 0, 3000, 0),
        gains = c(NA, -4000, NA, 14000)
      ),
      row.names = c(NA, -4L),
      class = "data.frame"
    )
  )

  expect_equal(
    ACB(data, transaction = "trade", spot.rate = "price"),
    structure(
      list(
        date = structure(c(18262, 18295, 18296, 18662), class = "Date"),
        trade = c("buy", "sell", "buy", "sell"),
        currency = c("BTC", "BTC", "BTC", "BTC"),
        price = c(5000, 3000, 3000, 10000),
        quantity = c(2, 2, 2, 2),
        total.price = c(10000, 6000, 6000, 20000),
        fees = c(0, 0, 0, 0),
        total.quantity = c(2, 0, 2, 0),
        suploss.range = new(
          "Interval",
          .Data = c(5184000, 5184000, 5184000, 5184000),
          start = structure(
            c(
              1575244800, 1578096000, 1578182400, 1609804800
            ),
            class = c("POSIXct", "POSIXt"), tzone = "UTC"
          ), tzone = "UTC"
        ),
        quantity.60days = c(2, 2, 2, 0),
        share.left60 = c(2, 2, 2, 0),
        sup.loss.quantity = c(0, 2, 0, 0),
        sup.loss = c(FALSE, TRUE, FALSE, FALSE),
        gains.uncorrected = c(0, -4000, 0, 10000),
        gains.sup = c(NA, -4000, NA, NA),
        gains.excess = c(NA, NA, NA, NA),
        gains = c(NA, NA, NA, 10000),
        ACB = c(10000, 0, 10000, 0),
        ACB.share = c(5000, 0, 5000, 0)
      ),
      row.names = c(NA, -4L),
      class = "data.frame"
    )
  )
})

test_that("Example #7 - CryptoTaxCalculator", {
  data <- data_cryptotaxcalculator2
  data <- data

  expect_equal(
    ACB(data, transaction = "trade", spot.rate = "price", sup.loss = FALSE),
    structure(
      list(
        date = structure(c(18262, 18297, 18298, 18664), class = "Date"),
        trade = c("buy", "buy", "sell", "sell"),
        currency = c("BTC", "BTC", "BTC", "BTC"),
        price = c(5000, 1000, 1000, 10000),
        quantity = c(2, 2, 2, 2),
        total.price = c(10000, 2000, 2000, 20000),
        fees = c(0, 0, 0, 0),
        total.quantity = c(2, 4, 2, 0),
        ACB = c(10000, 12000, 6000, 0),
        ACB.share = c(5000, 3000, 3000, 0),
        gains = c(NA, NA, -4000, 14000)
      ),
      row.names = c(NA, -4L),
      class = "data.frame"
    )
  )

  expect_equal(
    ACB(data, transaction = "trade", spot.rate = "price"),
    structure(
      list(
        date = structure(c(18262, 18297, 18298, 18664), class = "Date"),
        trade = c("buy", "buy", "sell", "sell"),
        currency = c("BTC", "BTC", "BTC", "BTC"),
        price = c(5000, 1000, 1000, 10000),
        quantity = c(2, 2, 2, 2),
        total.price = c(10000, 2000, 2000, 20000),
        fees = c(0, 0, 0, 0),
        total.quantity = c(2, 4, 2, 0),
        suploss.range = new(
          "Interval",
          .Data = c(5184000, 5184000, 5184000, 5184000),
          start = structure(
            c(
              1575244800, 1578268800, 1578355200, 1609977600
            ),
            class = c("POSIXct", "POSIXt"), tzone = "UTC"
          ), tzone = "UTC"
        ),
        quantity.60days = c(2, 2, 2, 0),
        share.left60 = c(2, 2, 2, 0),
        sup.loss.quantity = c(0, 0, 2, 0),
        sup.loss = c(FALSE, FALSE, TRUE, FALSE),
        gains.uncorrected = c(0, 0, -4000, 10000),
        gains.sup = c(NA, NA, -4000, NA),
        gains.excess = c(NA, NA, NA, NA),
        gains = c(NA, NA, NA, 10000),
        ACB = c(10000, 12000, 10000, 0),
        ACB.share = c(5000, 3000, 5000, 0)
      ),
      row.names = c(NA, -4L),
      class = "data.frame"
    )
  )
})

test_that("Example #8 - Coinpanda", {
  data <- data_coinpanda1
  data <- data

  expect_equal(
    ACB(data,
      transaction = "type", quantity = "amount",
      total.price = "price", sup.loss = FALSE
    ),
    structure(
      list(
        type = c("buy", "buy", "sell", "buy"),
        date = structure(c(18122, 18198, 18418, 18528), class = "Date"),
        currency = c("BTC", "BTC", "BTC", "BTC"),
        amount = c(0.2, 0.6, 0.8, 1.2),
        price = c(1800, 4300, 5700, 8200),
        fees = c(20, 20, 0, 0),
        total.quantity = c(0.2, 0.8, 0, 1.2),
        ACB = c(1820, 6140, 0, 8200),
        ACB.share = c(9100, 7675, 0, 6833.33333333333),
        gains = c(NA, NA, -440, NA)
      ),
      row.names = c(NA, -4L),
      class = "data.frame"
    )
  )
})

test_that("Example #9 - Coinpanda", {
  data <- data_coinpanda2
  data <- data

  expect_equal(
    ACB(data,
      transaction = "type", quantity = "amount",
      total.price = "price", sup.loss = FALSE
    ),
    structure(
      list(
        type = c("buy", "buy", "sell", "buy"),
        date = structure(c(18122, 18198, 18418, 18420), class = "Date"),
        currency = c("BTC", "BTC", "BTC", "BTC"),
        amount = c(0.2, 0.6, 0.8, 1.2),
        price = c(1800, 4300, 5700, 7000),
        fees = c(20, 20, 0, 0),
        total.quantity = c(0.2, 0.8, 0, 1.2),
        ACB = c(1820, 6140, 0, 7000),
        ACB.share = c(9100, 7675, 0, 5833.33333333333),
        gains = c(NA, NA, -440, NA)
      ),
      row.names = c(NA, -4L),
      class = "data.frame"
    )
  )

  expect_equal(
    ACB(data, transaction = "type", quantity = "amount", total.price = "price"),
    structure(
      list(
        type = c("buy", "buy", "sell", "buy"),
        date = structure(c(18122, 18198, 18418, 18420), class = "Date"),
        currency = c("BTC", "BTC", "BTC", "BTC"),
        amount = c(0.2, 0.6, 0.8, 1.2),
        price = c(1800, 4300, 5700, 7000),
        fees = c(20, 20, 0, 0),
        total.quantity = c(0.2, 0.8, 0, 1.2),
        suploss.range = new(
          "Interval",
          .Data = c(5184000, 5184000, 5184000, 5184000),
          start = structure(c(1563148800, 1569715200, 1588723200, 1588896000),
            class = c("POSIXct", "POSIXt"), tzone = "UTC"
          ),
          tzone = "UTC"
        ),
        quantity.60days = c(0.2, 0.6, 1.2, 1.2),
        share.left60 = c(0.2, 0.8, 1.2, 1.2),
        sup.loss.quantity = c(0, 0, 0.8, 0),
        sup.loss = c(FALSE, FALSE, TRUE, FALSE),
        gains.uncorrected = c(0, 0, -440, 0),
        gains.sup = c(NA, NA, -440, NA),
        gains.excess = c(NA, NA, NA, NA),
        gains = c(NA, NA, NA, NA),
        ACB = c(1820, 6140, 0, 7440),
        ACB.share = c(9100, 7675, 0, 6200)
      ),
      row.names = c(NA, -4L),
      class = "data.frame"
    )
  )
})

test_that("Example #10 - Koinly", {
  data <- data_koinly
  data <- data

  expect_equal(
    ACB(data, sup.loss = FALSE),
    structure(
      list(
        date = structure(c(17902, 18203, 18204), class = "Date"),
        transaction = c("buy", "sell", "buy"),
        currency = c("ETH", "ETH", "ETH"),
        quantity = c(100, 100, 100),
        spot.rate = c(50, 30, 30),
        total.price = c(5000, 3000, 3000),
        fees = c(0, 0, 0),
        total.quantity = c(100, 0, 100),
        ACB = c(5000, 0, 3000),
        ACB.share = c(50, 0, 30),
        gains = c(NA, -2000, NA)
      ),
      row.names = c(NA, -3L),
      class = "data.frame"
    )
  )

  expect_equal(
    ACB(data),
    structure(
      list(
        date = structure(c(17902, 18203, 18204), class = "Date"),
        transaction = c("buy", "sell", "buy"),
        currency = c("ETH", "ETH", "ETH"),
        quantity = c(100, 100, 100),
        spot.rate = c(50, 30, 30),
        total.price = c(5000, 3000, 3000),
        fees = c(0, 0, 0),
        total.quantity = c(100, 0, 100),
        suploss.range = new(
          "Interval",
          .Data = c(5184000, 5184000, 5184000),
          start = structure(c(1544140800, 1570147200, 1570233600),
            class = c("POSIXct", "POSIXt"), tzone = "UTC"
          ),
          tzone = "UTC"
        ),
        quantity.60days = c(100, 100, 100),
        share.left60 = c(100, 100, 100),
        sup.loss.quantity = c(0, 100, 0),
        sup.loss = c(FALSE, TRUE, FALSE),
        gains.uncorrected = c(0, -2000, 0),
        gains.sup = c(NA, -2000, NA),
        gains.excess = c(NA, NA, NA),
        gains = c(NA, NA, NA),
        ACB = c(5000, 0, 5000),
        ACB.share = c(50, 0, 50)
      ),
      row.names = c(NA, -3L),
      class = "data.frame"
    )
  )
})

