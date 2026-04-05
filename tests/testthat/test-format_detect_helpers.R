test_that("format_detect identifies example datasets by their column signature", {
  expect_equal(
    cryptoTax:::.format_detect_condition(data_shakepay),
    "shakepay"
  )
  expect_equal(
    cryptoTax:::.format_detect_condition(data_newton),
    "newton"
  )
})

test_that("resolve_format_detect_condition disambiguates CDC rewards and wallet data", {
  rewards.data <- data.frame(Description = "Supercharger", stringsAsFactors = FALSE)
  wallet.data <- data.frame(Description = "Validator", stringsAsFactors = FALSE)

  expect_equal(
    cryptoTax:::.resolve_format_detect_condition(
      c("CDC_exchange_rewards", "CDC_wallet"),
      rewards.data
    ),
    "CDC_exchange_rewards"
  )

  expect_equal(
    cryptoTax:::.resolve_format_detect_condition(
      c("CDC_exchange_rewards", "CDC_wallet"),
      wallet.data
    ),
    "CDC_wallet"
  )
})

test_that("resolve_format_detect_condition errors cleanly when no exchange matches", {
  expect_error(
    cryptoTax:::.resolve_format_detect_condition(character(), data.frame()),
    "Could not identify the correct exchange automatically."
  )
})
