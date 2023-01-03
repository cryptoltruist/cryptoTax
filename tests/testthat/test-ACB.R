data <- adjustedcostbase.ca_1
data

# https://www.adjustedcostbase.ca/blog/how-to-calculate-adjusted-cost-base-acb-and-capital-gains/
test_that("adjustedcostbase.ca basic", {
  expect_equal(
    ACB(data, spot.rate = "price"),
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
