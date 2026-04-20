testthat::skip_on_cran()

test_that("format_CDC recognizes newer Crypto.com staking and transfer labels", {
  data <- data.frame(
    Timestamp..UTC. = as.POSIXct(
      c("2026-01-10 10:00:00", "2026-01-11 10:00:00", "2026-01-12 10:00:00",
        "2026-01-13 10:00:00", "2026-01-14 10:00:00"),
      tz = "UTC"
    ),
    Transaction.Description = c(
      "Cardholder CRO Stake",
      "Cardholder CRO Stake Reward",
      "CRO Unlock",
      "Received from Po M. I. Wong",
      "Sent to Iris Wong"
    ),
    Currency = c("CRO", "CRO", "CRO", "CRO", "CRO"),
    Amount = c(-100, 1.25, 100, 5, -5),
    To.Currency = c("", "", "", "", ""),
    To.Amount = c(NA, NA, NA, NA, NA),
    Native.Currency = c("CAD", "CAD", "CAD", "CAD", "CAD"),
    Native.Amount = c(25, 0.35, 25, 1.5, 1.5),
    Native.Amount..in.USD. = c(18, 0.25, 18, 1.1, 1.1),
    Transaction.Kind = c(
      "finance.lockup.dpos_lock.crypto_wallet",
      "finance.lockup.dpos_compound_interest.crypto_wallet",
      "lockup_unlock",
      "transfer.p2p_transfer.crypto_wallet.crypto_wallet.credit",
      "transfer.p2p_transfer.crypto_wallet.crypto_wallet.debit"
    ),
    Transaction.Hash = c("", "", "", "", ""),
    stringsAsFactors = FALSE
  )

  expect_no_warning(
    prepared <- cryptoTax:::.format_cdc_prepare_input(
      data,
      known.transactions = c(
        "finance.lockup.dpos_lock.crypto_wallet",
        "finance.lockup.dpos_compound_interest.crypto_wallet",
        "lockup_unlock",
        "transfer.p2p_transfer.crypto_wallet.crypto_wallet.credit",
        "transfer.p2p_transfer.crypto_wallet.crypto_wallet.debit"
      )
    )
  )

  prepared <- prepared %>%
    dplyr::mutate(
      CAD.rate = 1,
      rate.source = "exchange",
      total.price = .data$Native.Amount
    )

  earn <- cryptoTax:::.format_cdc_earn(prepared)

  expect_equal(nrow(earn), 1)
  expect_identical(earn$description, "finance.lockup.dpos_compound_interest.crypto_wallet")
  expect_identical(earn$revenue.type, "interests")
})

test_that("format_CDC matches newer ETH withdrawal labels", {
  comments <- c(
    "Withdraw ETH",
    "Withdraw ETH (Ethereum)",
    "Withdraw ETH (ERC20)",
    "Withdraw ETH (Ethereum (ERC20))",
    "Withdraw ETH (BSC)",
    "Withdraw ETH (BEP20)",
    "Withdraw ETH (Arbitrum)"
  )

  expect_equal(
    cryptoTax:::.detect_cdc_withdrawal_fee(comments),
    c(0.005, 0.005, 0.005, 0.005, 0.0005, 0.0005, NA_real_)
  )
})

test_that("format_CDC reports a withdrawal-fee review table when CDC withdrawals exist", {
  data <- data.frame(
    Timestamp..UTC. = as.POSIXct(
      c("2026-01-15 10:00:00", "2026-01-16 11:00:00"),
      tz = "UTC"
    ),
    Transaction.Description = c(
      "Withdraw ETH (Ethereum (ERC20))",
      "Withdraw CRO (Crypto.org)"
    ),
    Currency = c("ETH", "CRO"),
    Amount = c(-0.2, -50),
    To.Currency = c("", ""),
    To.Amount = c(NA, NA),
    Native.Currency = c("CAD", "CAD"),
    Native.Amount = c(500, 10),
    Native.Amount..in.USD. = c(360, 7.2),
    Transaction.Kind = c("crypto_withdrawal", "crypto_withdrawal"),
    Transaction.Hash = c("", ""),
    stringsAsFactors = FALSE
  )

  prepared <- cryptoTax:::.format_cdc_prepare_input(
    data,
    known.transactions = "crypto_withdrawal"
  ) %>%
    dplyr::mutate(
      CAD.rate = 1,
      rate.source = "exchange",
      total.price = .data$Native.Amount
    )

  messages <- testthat::capture_messages(
    withdrawals <- cryptoTax:::.format_cdc_withdrawals(prepared)
  )

  expect_equal(withdrawals$quantity, c(0.005, 0.001))
  expect_true(any(grepl(
    "Crypto.com App exports do not include withdrawal/network fees in the CSV",
    messages,
    fixed = TRUE
  )))
  expect_true(any(grepl(
    "review_CDC_withdrawals\\(formatted\\.CDC\\)",
    messages
  )))
})

test_that("review_CDC_withdrawals returns the compact fee-review table", {
  data <- data.frame(
    Timestamp..UTC. = as.POSIXct(
      c("2026-01-15 10:00:00", "2026-01-16 11:00:00"),
      tz = "UTC"
    ),
    Transaction.Description = c(
      "Withdraw ETH (Ethereum (ERC20))",
      "Withdraw CRO (Crypto.org)"
    ),
    Currency = c("ETH", "CRO"),
    Amount = c(-0.2, -50),
    To.Currency = c("", ""),
    To.Amount = c(NA, NA),
    Native.Currency = c("CAD", "CAD"),
    Native.Amount = c(500, 10),
    Native.Amount..in.USD. = c(360, 7.2),
    Transaction.Kind = c("crypto_withdrawal", "crypto_withdrawal"),
    Transaction.Hash = c("", ""),
    stringsAsFactors = FALSE
  )

  expect_no_message(
    review <- review_CDC_withdrawals(data)
  )

  expect_identical(
    names(review),
    c("date", "currency", "withdrawal.description", "policy.withdrawal.fee")
  )
  expect_equal(review$policy.withdrawal.fee, c(0.005, 0.001))
  expect_identical(
    review$withdrawal.description,
    c("Withdraw ETH (Ethereum (ERC20))", "Withdraw CRO (Crypto.org)")
  )
})

test_that("review_CDC_withdrawals also works on formatted CDC output", {
  formatted <- data.frame(
    date = as.POSIXct(
      c("2026-01-15 10:00:00", "2026-01-16 11:00:00", "2026-01-17 12:00:00"),
      tz = "UTC"
    ),
    currency = c("ETH", "CRO", "BTC"),
    quantity = c(0.005, 0.001, 0.25),
    total.price = c(12.5, 0.2, 10000),
    spot.rate = c(2500, 200, 40000),
    transaction = c("sell", "sell", "buy"),
    description = c("crypto_withdrawal", "crypto_withdrawal", "crypto_purchase"),
    comment = c("Withdraw ETH (Ethereum (ERC20))", "Withdraw CRO (Crypto.org)", "Buy BTC"),
    exchange = c("CDC", "CDC", "CDC"),
    rate.source = c("exchange", "exchange", "exchange"),
    stringsAsFactors = FALSE
  )

  review <- expect_no_message(review_CDC_withdrawals(formatted))

  expect_identical(
    names(review),
    c("date", "currency", "withdrawal.description", "policy.withdrawal.fee")
  )
  expect_equal(review$policy.withdrawal.fee, c(0.005, 0.001))
  expect_identical(
    review$withdrawal.description,
    c("Withdraw ETH (Ethereum (ERC20))", "Withdraw CRO (Crypto.org)")
  )
})

test_that("apply_CDC_withdrawal_overrides updates matching formatted CDC withdrawal rows", {
  formatted <- data.frame(
    date = as.POSIXct(
      c("2026-01-15 10:00:00", "2026-01-16 11:00:00", "2026-01-17 12:00:00"),
      tz = "UTC"
    ),
    currency = c("ETH", "CRO", "BTC"),
    quantity = c(0.005, 0.001, 0.25),
    total.price = c(12.5, 0.2, 10000),
    spot.rate = c(2500, 200, 40000),
    transaction = c("sell", "sell", "buy"),
    description = c("crypto_withdrawal", "crypto_withdrawal", "crypto_purchase"),
    comment = c("Withdraw ETH (Ethereum (ERC20))", "Withdraw CRO (Crypto.org)", "Buy BTC"),
    exchange = c("CDC", "CDC", "CDC"),
    rate.source = c("exchange", "exchange", "exchange"),
    stringsAsFactors = FALSE
  )

  overrides <- data.frame(
    date = as.POSIXct(c("2026-01-15 10:00:00", "2026-01-16 11:00:00"), tz = "UTC"),
    quantity = c(0.01, 2),
    stringsAsFactors = FALSE
  )

  updated <- apply_CDC_withdrawal_overrides(formatted, overrides)

  expect_equal(updated$quantity, c(0.01, 2, 0.25))
  expect_equal(updated$total.price, c(25, 400, 10000))
})

test_that("apply_CDC_withdrawal_overrides can use extra keys for matching", {
  formatted <- data.frame(
    date = as.POSIXct(
      c("2026-01-15 10:00:00", "2026-01-15 10:00:00"),
      tz = "UTC"
    ),
    currency = c("ETH", "ETH"),
    quantity = c(0.005, 0.006),
    total.price = c(12.5, 15),
    spot.rate = c(2500, 2500),
    transaction = c("sell", "sell"),
    description = c("crypto_withdrawal", "crypto_withdrawal"),
    comment = c("Withdraw ETH (Ethereum (ERC20))", "Withdraw ETH (BSC)"),
    exchange = c("CDC", "CDC"),
    rate.source = c("exchange", "exchange"),
    stringsAsFactors = FALSE
  )

  overrides <- data.frame(
    date = as.POSIXct("2026-01-15 10:00:00", tz = "UTC"),
    comment = "Withdraw ETH (Ethereum (ERC20))",
    quantity = 0.01,
    stringsAsFactors = FALSE
  )

  updated <- apply_CDC_withdrawal_overrides(formatted, overrides)

  expect_equal(updated$quantity, c(0.01, 0.006))
  expect_equal(updated$total.price, c(25, 15))
})

test_that("apply_CDC_withdrawal_overrides validates duplicate override keys", {
  formatted <- data.frame(
    date = as.POSIXct("2026-01-15 10:00:00", tz = "UTC"),
    currency = "ETH",
    quantity = 0.005,
    total.price = 12.5,
    spot.rate = 2500,
    transaction = "sell",
    description = "crypto_withdrawal",
    comment = "Withdraw ETH (Ethereum (ERC20))",
    exchange = "CDC",
    rate.source = "exchange",
    stringsAsFactors = FALSE
  )

  overrides <- data.frame(
    date = as.POSIXct(c("2026-01-15 10:00:00", "2026-01-15 10:00:00"), tz = "UTC"),
    quantity = c(0.01, 0.02),
    stringsAsFactors = FALSE
  )

  expect_error(
    apply_CDC_withdrawal_overrides(formatted, overrides),
    "duplicate match rows"
  )
})
