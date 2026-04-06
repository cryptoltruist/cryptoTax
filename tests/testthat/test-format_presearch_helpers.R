test_that("format_presearch_prepare_input parses comma quantities", {
  input <- data.frame(
    amount = "1,234.56",
    stringsAsFactors = FALSE
  )

  result <- cryptoTax:::.format_presearch_prepare_input(input)

  expect_equal(result$quantity, 1234.56)
})

test_that("format_presearch_filter_irrelevant removes staking bookkeeping rows", {
  input <- data.frame(
    description = c(
      "Search Reward",
      "Staked to keyword: foo",
      "Removed from keyword: bar"
    ),
    stringsAsFactors = FALSE
  )

  patterns <- list(
    transferred.from = character(),
    staked.to = "Staked to keyword: foo",
    removed.from = "Removed from keyword: bar",
    search.against = character(),
    airdrop = character()
  )

  result <- cryptoTax:::.format_presearch_filter_irrelevant(input, patterns)

  expect_equal(result$description, "Search Reward")
})

test_that("format_presearch_classify marks rewards as airdrop revenue", {
  input <- data.frame(
    description = "Search Reward",
    date = "2021-01-01 00:00:00",
    quantity = 10,
    stringsAsFactors = FALSE
  )

  result <- cryptoTax:::.format_presearch_classify(
    input,
    rewards.names = c("Search Reward")
  )

  expect_equal(result$currency, "PRE")
  expect_equal(result$transaction, "revenue")
  expect_equal(result$revenue.type, "airdrops")
})

test_that("format_presearch_finalize annotates merged output", {
  input <- data.frame(
    date = as.POSIXct("2021-01-01 00:00:00", tz = "UTC"),
    currency = "PRE",
    quantity = 10,
    total.price = 100,
    spot.rate = 10,
    transaction = "revenue",
    description = "Search Reward",
    revenue.type = "airdrops",
    rate.source = "coinmarketcap",
    stringsAsFactors = FALSE
  )

  result <- cryptoTax:::.format_presearch_finalize(input)

  expect_equal(result$exchange, "presearch")
})
