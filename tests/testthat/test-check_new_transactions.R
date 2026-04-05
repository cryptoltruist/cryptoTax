test_that("check_new_transactions warns with new transaction names and descriptions", {
  data <- data.frame(
    kind = c("known", "new_type", "new_type"),
    description = c("old", "desc one", "desc two"),
    stringsAsFactors = FALSE
  )

  expect_warning(
    check_new_transactions(
      data,
      known.transactions = "known",
      transactions.col = "kind",
      description.col = "description"
    ),
    "New transaction types detected! These may be unaccounted for: new_type. Associated descriptions: desc one, desc two"
  )
})

test_that("check_new_transactions is silent when all transaction types are known", {
  data <- data.frame(kind = c("known", "known"), stringsAsFactors = FALSE)

  expect_no_warning(
    check_new_transactions(
      data,
      known.transactions = "known",
      transactions.col = "kind"
    )
  )
})

test_that("check_new_transactions validates requested columns", {
  data <- data.frame(kind = "known", stringsAsFactors = FALSE)

  expect_error(
    check_new_transactions(
      data,
      known.transactions = "known",
      transactions.col = "missing"
    ),
    "Column 'missing' not found in data frame."
  )

  expect_error(
    check_new_transactions(
      data,
      known.transactions = "known",
      transactions.col = "kind",
      description.col = "missing"
    ),
    "Column 'missing' not found in data frame."
  )
})

test_that("new transaction helpers return sorted unique names and descriptions", {
  data <- data.frame(
    kind = c("known", "z_type", "a_type", "z_type"),
    description = c("old", "z desc", "a desc", "z desc"),
    stringsAsFactors = FALSE
  )

  expect_equal(
    cryptoTax:::.new_transaction_names(data, "known", "kind"),
    c("a_type", "z_type")
  )

  expect_equal(
    cryptoTax:::.new_transaction_descriptions(
      data,
      known.transactions = "known",
      transactions.col = "kind",
      description.col = "description"
    ),
    c("a desc", "z desc")
  )
})

test_that("format_new_transaction_warning omits descriptions when absent", {
  expect_equal(
    cryptoTax:::.format_new_transaction_warning("new_type"),
    "New transaction types detected! These may be unaccounted for: new_type"
  )
})
