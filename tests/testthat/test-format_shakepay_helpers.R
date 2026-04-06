test_that("format_shakepay_add_referral appends manual referral rows", {
  input <- data.frame(
    Date = "2021-01-01 00:00:00",
    Type = "Buy",
    Amount.Credited = 100,
    Description = "Original row",
    Asset.Credited = "BTC",
    Book.Cost = 100,
    Book.Cost.Currency = "CAD",
    Spot.Rate = 1,
    stringsAsFactors = FALSE
  )

  result <- cryptoTax:::.format_shakepay_add_referral(
    input,
    referral = list(
      Date = "2021-01-02 00:00:00",
      Credit = 30
    )
  )

  expect_equal(nrow(result), 2)
  expect_equal(result$Description[[2]], "Referral reward")
  expect_equal(result$Book.Cost[[2]], 30)
})

test_that("format_shakepay_shakes creates airdrop revenue rows", {
  input <- data.frame(
    date = as.POSIXct("2021-01-01 00:00:00", tz = "UTC"),
    comment = "ShakingSats",
    description = "Reward",
    Amount.Credited = 2,
    Asset.Credited = "BTC",
    spot.rate = 10
  )

  result <- cryptoTax:::.format_shakepay_shakes(input)

  expect_equal(result$transaction, "revenue")
  expect_equal(result$revenue.type, "airdrops")
  expect_equal(result$total.price, 20)
})

test_that("format_shakepay_referral creates referral revenue rows", {
  input <- data.frame(
    date = as.POSIXct("2021-01-01 00:00:00", tz = "UTC"),
    comment = "Referral reward",
    description = "Reward",
    Amount.Credited = 30,
    Asset.Credited = "CAD",
    Book.Cost = 30
  )

  result <- cryptoTax:::.format_shakepay_referral(input)

  expect_equal(result$transaction, "revenue")
  expect_equal(result$revenue.type, "referrals")
  expect_equal(result$spot.rate, 1)
})
