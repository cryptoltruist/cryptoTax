test_that("normalize_pooltool_currency only accepts CAD", {
  expect_equal(cryptoTax:::.normalize_pooltool_currency("cad"), "CAD")
  expect_error(
    cryptoTax:::.normalize_pooltool_currency("USD"),
    "currently supports only"
  )
})

test_that("extract_pooltool_rewards returns normalized reward rows", {
  payload <- list(
    value = data.frame(
      stake_address = "stake1example",
      stringsAsFactors = FALSE
    )
  )
  payload$value$rewards <- list(data.frame(
    amount = c("5103663", "3561202"),
    pool_id = c("pool1abc", "pool1abc"),
    earned_epoch = c(622, 623),
    spendable_epoch = c(624, 625),
    stringsAsFactors = FALSE
  ))

  result <- cryptoTax:::.extract_pooltool_rewards(
    payload,
    stake_address = "stake1example"
  )

  expect_equal(result$stake_address, c("stake1example", "stake1example"))
  expect_equal(result$amount, c(5.103663, 3.561202))
  expect_equal(result$spendable_epoch, c(624L, 625L))
})

test_that("build_pooltool_rewards_table creates PoolTool-compatible columns", {
  rewards <- data.frame(
    stake_address = c("stake1example", "stake1example"),
    amount = c(5.103663, 3.561202),
    pool_id = c("pool1abc", "pool1abc"),
    earned_epoch = c(622L, 623L),
    spendable_epoch = c(624L, 625L),
    stringsAsFactors = FALSE
  )

  epoch_info <- data.frame(
    spendable_epoch = c(624L, 625L),
    start_time = c(1775771091, 1776203091),
    stringsAsFactors = FALSE
  )

  pool_lookup <- data.frame(
    pool_id = "pool1abc",
    pool = "NUFI7",
    stringsAsFactors = FALSE
  )

  list.prices <- data.frame(
    currency = "ADA",
    spot.rate2 = c(1.50, 1.60),
    date2 = as.Date(c("2026-04-09", "2026-04-14")),
    stringsAsFactors = FALSE
  )

  result <- cryptoTax:::.build_pooltool_rewards_table(
    rewards = rewards,
    epoch_info = epoch_info,
    pool_lookup = pool_lookup,
    currency = "CAD",
    list.prices = list.prices,
    verbose = FALSE
  )

  expect_named(
    result,
    c(
      "date",
      "epoch",
      "stake",
      "pool",
      "operator_rewards",
      "stake_rewards",
      "total_rewards",
      "rate",
      "currency",
      "operator_rewards_value",
      "stake_rewards_value",
      "value"
    )
  )
  expect_equal(result$pool, c("NUFI7", "NUFI7"))
  expect_equal(result$currency, c("CAD", "CAD"))
  expect_equal(result$rate, c(1.50, 1.60))
  expect_equal(
    round(result$stake_rewards_value, 6),
    round(c(5.103663 * 1.50, 3.561202 * 1.60), 6)
  )
})
