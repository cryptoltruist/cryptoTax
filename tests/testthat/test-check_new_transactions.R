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

test_that("check_new_transactions validates column-name arguments", {
  data <- data.frame(kind = "known", stringsAsFactors = FALSE)

  expect_error(
    check_new_transactions(
      data,
      known.transactions = "known",
      transactions.col = character()
    ),
    "transactions.col"
  )

  expect_error(
    check_new_transactions(
      data,
      known.transactions = "known",
      transactions.col = "kind",
      description.col = ""
    ),
    "description.col"
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

test_that("has_new_transactions reflects whether any unknown types exist", {
  expect_false(cryptoTax:::.has_new_transactions(character()))
  expect_true(cryptoTax:::.has_new_transactions("new_type"))
})

test_that("unknown_transaction_rows flags only non-missing unknown transaction rows", {
  data <- data.frame(
    kind = c("known", NA, "new_type"),
    stringsAsFactors = FALSE
  )

  expect_equal(
    cryptoTax:::.unknown_transaction_rows(data, "known", "kind"),
    c(FALSE, FALSE, TRUE)
  )
})

test_that("new transaction helpers work with factor columns", {
  data <- data.frame(
    kind = factor(c("known", "new_type")),
    description = factor(c("old", "desc one"))
  )

  expect_equal(
    cryptoTax:::.new_transaction_names(data, "known", "kind"),
    "new_type"
  )

  expect_equal(
    cryptoTax:::.new_transaction_descriptions(
      data,
      known.transactions = "known",
      transactions.col = "kind",
      description.col = "description"
    ),
    "desc one"
  )
})

test_that("new transaction helpers work with factor known.transactions", {
  data <- data.frame(
    kind = c("known", "new_type"),
    description = c("old", "desc one"),
    stringsAsFactors = FALSE
  )

  expect_equal(
    cryptoTax:::.new_transaction_names(data, factor("known"), "kind"),
    "new_type"
  )
})

test_that("new transaction helpers ignore NA transaction names and descriptions", {
  data <- data.frame(
    kind = c("known", NA, "new_type"),
    description = c(NA, "ignored", "kept"),
    stringsAsFactors = FALSE
  )

  expect_equal(
    cryptoTax:::.new_transaction_names(data, "known", "kind"),
    "new_type"
  )

  expect_equal(
    cryptoTax:::.new_transaction_descriptions(
      data,
      known.transactions = "known",
      transactions.col = "kind",
      description.col = "description"
    ),
    "kept"
  )
})

test_that("new transaction descriptions ignore blank strings", {
  data <- data.frame(
    kind = c("new_type", "new_type"),
    description = c("", "kept"),
    stringsAsFactors = FALSE
  )

  expect_equal(
    cryptoTax:::.new_transaction_descriptions(
      data,
      known.transactions = "known",
      transactions.col = "kind",
      description.col = "description"
    ),
    "kept"
  )
})
