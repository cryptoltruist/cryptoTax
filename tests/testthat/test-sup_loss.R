# https://www.adjustedcostbase.ca/blog/what-is-the-superficial-loss-rule/
# https://www.adjustedcostbase.ca/blog/applying-the-superficial-loss-rule-for-a-partial-disposition-of-shares/

test_that("Example #1", {
  data <- adjustedcostbase.ca_2
  data

  expect_equal(
    ACB(data, spot.rate = "price", sup.loss = FALSE),
    structure(
      list(
        date = structure(c(16076, 16377, 16378, 16771), class = "Date"),
        transaction = c("buy", "sell", "buy", "sell"),
        quantity = c(100, 100, 100, 100),
        price = c(50, 30, 30, 80),
        fees = c(0, 0, 0, 0),
        total.price = c(5000, 3000, 3000, 8000),
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
        total.price = c(5000, 3000, 3000, 8000),
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

test_that("Example #2", {
  data <- adjustedcostbase.ca_3
  data <- data

  expect_equal(
    ACB(data, spot.rate = "price", sup.loss = FALSE),
    structure(
      list(
        date = structure(c(16076, 16377, 16378, 16771), class = "Date"),
        transaction = c("buy", "buy", "sell", "sell"),
        quantity = c(100, 100, 100, 100),
        price = c(50, 30, 30, 80),
        fees = c(0, 0, 0, 0),
        total.price = c(5000, 3000, 3000, 8000),
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
        total.price = c(5000, 3000, 3000, 8000),
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

test_that("Example #3", {
  data <- adjustedcostbase.ca_4
  data <- data

  expect_equal(
    ACB(data, spot.rate = "price", sup.loss = FALSE),
    structure(
      list(
        date = structure(c(16437, 16534, 16535), class = "Date"),
        transaction = c("buy", "sell", "buy"),
        quantity = c(100, 100, 25),
        price = c(3, 2, 2.2),
        fees = c(0, 0, 0),
        total.price = c(300, 200, 55),
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
        total.price = c(300, 200, 55),
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

test_that("Example #4", {
  data <- adjustedcostbase.ca_5
  data <- data

  expect_equal(
    ACB(data, spot.rate = "price", sup.loss = FALSE),
    structure(
      list(
        date = structure(c(16534, 16535), class = "Date"),
        transaction = c("buy", "sell"),
        quantity = c(100, 80),
        price = c(3, 2),
        fees = c(0, 0),
        total.price = c(300, 160),
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
        total.price = c(300, 160),
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

test_that("Example #5", {
  data <- adjustedcostbase.ca_6
  data <- data

  expect_equal(
    ACB(data, spot.rate = "price", sup.loss = FALSE),
    structure(
      list(
        date = structure(c(16534, 16535, 16540, 16545, 16570), class = "Date"),
        transaction = c("buy", "sell", "buy", "sell", "sell"),
        quantity = c(150, 20, 50, 10, 80),
        price = c(3, 2, 3, 2, 2),
        fees = c(0, 0, 0, 0, 0),
        total.price = c(450, 40, 150, 20, 160),
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
        total.price = c(450, 40, 150, 20, 160),
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
