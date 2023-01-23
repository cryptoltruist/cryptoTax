options(scipen = 999)

test_that("shakepay", {
  expect_snapshot(format_shakepay(data_shakepay))
})

test_that("CDC", {
  expect_snapshot(format_CDC(data_CDC))
})

test_that("adalite", {
  expect_snapshot(format_adalite(data_adalite, force = TRUE))
})

# GENERICS! ####

test_that("generic1 - capitals", {
  expect_snapshot(format_generic(data_generic1))
})

test_that("generic2 - different names", {
  expect_snapshot(
    format_generic(
      data_generic2,
      date = "Date.Transaction",
      currency = "Coin",
      quantity = "Amount",
      total.price = "Price",
      transaction = "Type",
      fees = "Fee",
      exchange = "Platform"
    )
  )
})

test_that("generic3 - calculate total.price", {
  expect_snapshot(format_generic(data_generic3))
})

test_that("generic4 - fetch spot.rate", {
  expect_snapshot(format_generic(data_generic4, force = TRUE))
})

# Add test: timezone!
