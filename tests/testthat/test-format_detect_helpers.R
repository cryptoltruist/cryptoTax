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

test_that("format_detect example-data helper returns bundled example datasets", {
  result <- cryptoTax:::.format_detect_example_data("shakepay")

  expect_s3_class(result, "data.frame")
  expect_equal(names(result), names(data_shakepay))
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

test_that("resolve_format_detect_condition errors cleanly when multiple exchanges match", {
  expect_error(
    cryptoTax:::.resolve_format_detect_condition(c("one", "two"), data.frame()),
    "Matches multiple exchange names."
  )
})

test_that("format_detect_registry_row returns the matching registry entry", {
  result <- cryptoTax:::.format_detect_registry_row("shakepay")

  expect_equal(result$formatter, "format_shakepay")
  expect_false(result$uses_prices)
})

test_that("format_detect registry helpers expose formatter names and price usage", {
  expect_equal(
    cryptoTax:::.format_detect_formatter_name("shakepay"),
    "format_shakepay"
  )
  expect_false(cryptoTax:::.format_detect_uses_prices("shakepay"))
  expect_true(cryptoTax:::.format_detect_uses_prices("exodus"))
})

test_that("format_detect registry validation errors cleanly for unknown exchanges", {
  expect_false(cryptoTax:::.has_format_detect_registry_row("not_real"))
  expect_error(
    cryptoTax:::.validate_format_detect_exchange("not_real"),
    "Unknown exchange in format-detect registry"
  )
})

test_that("format_detect_many formats and merges a list of exchanges", {
  explicit_list_prices <- data.frame(
    currency = "ADA",
    date2 = as.Date("2021-01-01"),
    spot.rate2 = 1
  )

  result <- cryptoTax:::.format_detect_many(
    list(data_shakepay, data_newton),
    list.prices = explicit_list_prices
  )

  expect_s3_class(result, "data.frame")
  expect_true(nrow(result) > 0)
})

test_that("format_detect description helper matches any configured pattern", {
  data <- data.frame(Description = c("APR reward", "something else"), stringsAsFactors = FALSE)

  expect_true(
    cryptoTax:::.format_detect_description_matches(data, c("Supercharger", "APR"))
  )
  expect_false(
    cryptoTax:::.format_detect_description_matches(data, c("Validator", "Auto Withdraw"))
  )
})

test_that("format_detect description helper is false when Description column is missing", {
  data <- data.frame(note = "APR reward", stringsAsFactors = FALSE)

  expect_false(
    cryptoTax:::.format_detect_description_matches(data, c("APR"))
  )
})

test_that("format_detect description helpers ignore NA descriptions safely", {
  data <- data.frame(
    Description = c(NA, "APR reward"),
    stringsAsFactors = FALSE
  )

  expect_equal(
    cryptoTax:::.format_detect_description_values(data),
    "APR reward"
  )
  expect_true(
    cryptoTax:::.format_detect_description_matches(data, c("APR"))
  )
})

test_that("format_detect description helpers ignore blank descriptions safely", {
  data <- data.frame(
    Description = c("", "APR reward"),
    stringsAsFactors = FALSE
  )

  expect_equal(
    cryptoTax:::.format_detect_description_values(data),
    "APR reward"
  )
  expect_true(
    cryptoTax:::.format_detect_description_matches(data, c("APR"))
  )
})

test_that("format_detect description helpers ignore whitespace-only descriptions safely", {
  data <- data.frame(
    Description = c("   ", " APR reward "),
    stringsAsFactors = FALSE
  )

  expect_equal(
    cryptoTax:::.format_detect_description_values(data),
    "APR reward"
  )
  expect_true(
    cryptoTax:::.format_detect_description_matches(data, c("APR"))
  )
})

test_that("format_detect description values coerce factors to characters", {
  data <- data.frame(
    Description = factor(c("APR reward", "Validator"))
  )

  expect_equal(
    cryptoTax:::.format_detect_description_values(data),
    c("APR reward", "Validator")
  )
})

test_that("format_detect description helper is false when all descriptions are NA", {
  data <- data.frame(Description = NA_character_, stringsAsFactors = FALSE)

  expect_false(
    cryptoTax:::.format_detect_description_matches(data, c("APR"))
  )
})

test_that("has_format_detect_condition reflects whether a candidate match exists", {
  expect_false(cryptoTax:::.has_format_detect_condition(character()))
  expect_true(cryptoTax:::.has_format_detect_condition("shakepay"))
})

test_that("format_detect_has_multiple_conditions reflects ambiguous matches", {
  expect_false(cryptoTax:::.format_detect_has_multiple_conditions(character()))
  expect_false(cryptoTax:::.format_detect_has_multiple_conditions("shakepay"))
  expect_true(cryptoTax:::.format_detect_has_multiple_conditions(c("one", "two")))
})

test_that("format_detect signature helpers derive dataset signatures deterministically", {
  registry <- cryptoTax:::.format_detect_registry()

  expect_equal(
    cryptoTax:::.format_detect_signature(data_shakepay),
    toString(names(data_shakepay))
  )

  signatures <- cryptoTax:::.format_detect_registry_signatures(registry)
  expect_equal(length(signatures), nrow(registry))
  expect_true("shakepay" %in% registry$exchange)
})

test_that("format_detect_formatted_list formats each input before merge", {
  explicit_list_prices <- data.frame(
    currency = "ADA",
    date2 = as.Date("2021-01-01"),
    spot.rate2 = 1
  )

  result <- cryptoTax:::.format_detect_formatted_list(
    list(data_shakepay, data_newton),
    list.prices = explicit_list_prices
  )

  expect_length(result, 2)
  expect_true(all(vapply(result, is.data.frame, logical(1))))
})

test_that("format_detect_exchange resolves the final exchange name", {
  expect_equal(
    cryptoTax:::.format_detect_exchange(data_shakepay),
    "shakepay"
  )
})

test_that("format_detect list-input validator accepts data frames and NULL only", {
  expect_equal(
    cryptoTax:::.validate_format_detect_list_input(list(NULL, data_shakepay)),
    list(NULL, data_shakepay)
  )

  expect_error(
    cryptoTax:::.validate_format_detect_list_input(list(data_shakepay, "nope")),
    "nested lists of data frames"
  )
})

test_that("format_detect list-input validator accepts nested lists recursively", {
  nested <- list(NULL, list(data_shakepay, list(data_newton)))

  expect_equal(
    cryptoTax:::.validate_format_detect_list_input(nested),
    nested
  )

  expect_true(cryptoTax:::.format_detect_is_valid_input_list(nested))
})

test_that("format_detect list-input validator rejects invalid nested list entries", {
  expect_false(cryptoTax:::.format_detect_is_valid_input_list(list(data_shakepay, "nope")))

  expect_error(
    cryptoTax:::.validate_format_detect_list_input(list(data_shakepay, list("nope"))),
    "nested lists of data frames"
  )
})

test_that("format_detect helpers identify and drop empty data-frame inputs", {
  empty <- data_shakepay[0, ]
  nested <- list(empty, list(NULL, data_newton[0, ], data_shakepay))

  expect_true(cryptoTax:::.format_detect_is_empty_input(empty))

  dropped <- cryptoTax:::.drop_empty_format_detect_inputs(nested)

  expect_length(dropped, 1)
  expect_true(is.list(dropped[[1]]))
  expect_s3_class(dropped[[1]][[1]], "data.frame")
  expect_equal(names(dropped[[1]][[1]]), names(data_shakepay))
})

test_that("format_detect_formatted_list ignores NULL entries", {
  explicit_list_prices <- data.frame(
    currency = "ADA",
    date2 = as.Date("2021-01-01"),
    spot.rate2 = 1
  )

  result <- cryptoTax:::.format_detect_formatted_list(
    list(NULL, data_shakepay),
    list.prices = explicit_list_prices
  )

  expect_length(result, 1)
  expect_true(is.data.frame(result[[1]]))
})

test_that("format_detect_formatted_list ignores empty data-frame entries", {
  explicit_list_prices <- data.frame(
    currency = "ADA",
    date2 = as.Date("2021-01-01"),
    spot.rate2 = 1
  )

  result <- cryptoTax:::.format_detect_formatted_list(
    list(data_shakepay[0, ], data_shakepay),
    list.prices = explicit_list_prices
  )

  expect_length(result, 1)
  expect_true(is.data.frame(result[[1]]))
})

test_that("format_detect_many returns an empty data frame for empty/NULL-only lists", {
  result <- cryptoTax:::.format_detect_many(list(NULL))

  expect_s3_class(result, "data.frame")
  expect_equal(nrow(result), 0)
})

test_that("format_detect_many returns an empty data frame for empty/NULL-only nested lists", {
  result <- cryptoTax:::.format_detect_many(list(NULL, list(data_shakepay[0, ])))

  expect_s3_class(result, "data.frame")
  expect_equal(nrow(result), 0)
})

test_that("format_detect.list skips empty data-frame inputs in the public path", {
  explicit_list_prices <- data.frame(
    currency = "ADA",
    date2 = as.Date("2021-01-01"),
    spot.rate2 = 1
  )

  result <- format_detect(
    list(data_shakepay[0, ], list(data_shakepay, data_newton)),
    list.prices = explicit_list_prices
  )

  expect_s3_class(result, "data.frame")
  expect_true(nrow(result) > 0)
  expect_true(all(c("shakepay", "newton") %in% result$exchange))
})

test_that("format_detect_many handles nested lists of exchange files", {
  explicit_list_prices <- data.frame(
    currency = "ADA",
    date2 = as.Date("2021-01-01"),
    spot.rate2 = 1
  )

  result <- cryptoTax:::.format_detect_many(
    list(data_shakepay, list(NULL, data_newton)),
    list.prices = explicit_list_prices
  )

  expect_s3_class(result, "data.frame")
  expect_true(nrow(result) > 0)
})

test_that("format_detect helpers detect when nested inputs require prices", {
  expect_false(cryptoTax:::.format_detect_requires_prices_input(data_shakepay))
  expect_true(cryptoTax:::.format_detect_requires_prices_input(data_coinsmart))
  expect_true(cryptoTax:::.format_detect_requires_prices_input(list(data_shakepay, data_coinsmart)))
})

test_that("format_detect_many rejects malformed explicit prices when any input requires pricing", {
  expect_message(
    result <- cryptoTax:::.format_detect_many(
      list(data_shakepay, data_coinsmart),
      list.prices = data.frame(date2 = as.Date("2021-01-01"))
    ),
    "Could not use 'list.prices' because it must contain 'currency', 'spot.rate2', and 'date2'."
  )

  expect_null(result)
})

test_that("format_detect.data.frame rejects malformed explicit prices for exchanges that require pricing", {
  expect_message(
    result <- format_detect(
      data_coinsmart,
      list.prices = data.frame(date2 = as.Date("2021-01-01"))
    ),
    "Could not use 'list.prices' because it must contain 'currency', 'spot.rate2', and 'date2'."
  )

  expect_null(result)
})

test_that("format_detect_many still allows malformed explicit prices for exchanges that do not need pricing", {
  result <- suppressMessages(
    cryptoTax:::.format_detect_many(
      list(data_shakepay, data_newton),
      list.prices = data.frame(date2 = as.Date("2021-01-01"))
    )
  )

  expect_s3_class(result, "data.frame")
  expect_true(all(c("shakepay", "newton") %in% result$exchange))
})

test_that("format_detect helpers recognize already formatted transaction data", {
  formatted <- data.frame(
    date = as.POSIXct("2021-01-01 00:00:00", tz = "UTC"),
    currency = "BTC",
    quantity = 1,
    total.price = 100,
    spot.rate = 100,
    transaction = "buy",
    exchange = "manual",
    rate.source = "exchange",
    stringsAsFactors = FALSE
  )

  raw_like <- data.frame(
    date = as.POSIXct("2021-01-01 00:00:00", tz = "UTC"),
    currency = "BTC",
    quantity = 1,
    transaction = "buy",
    stringsAsFactors = FALSE
  )

  expect_true(cryptoTax:::.format_detect_is_formatted_input(formatted))
  expect_false(cryptoTax:::.format_detect_is_formatted_input(raw_like))
})

test_that("format_detect.list preserves already formatted entries in mixed lists", {
  formatted <- data.frame(
    date = as.POSIXct("2021-01-01 12:00:00", tz = "UTC"),
    currency = "BTC",
    quantity = 1,
    total.price = 100,
    spot.rate = 100,
    transaction = "buy",
    exchange = "manual",
    rate.source = "exchange",
    stringsAsFactors = FALSE
  )

  result <- format_detect(
    list(
      formatted,
      data_shakepay[1:2, ]
    )
  )

  expect_s3_class(result, "data.frame")
  expect_true(any(result$exchange == "manual"))
  expect_true(any(result$exchange == "shakepay"))
})

test_that("format_exchanges delegates to format_detect for mixed public inputs", {
  formatted <- format_shakepay(data_shakepay)

  result <- format_exchanges(list(formatted, data_newton))

  expect_s3_class(result, "data.frame")
  expect_true(all(c("shakepay", "newton") %in% result$exchange))
})

test_that("format_exchanges accepts multiple exchange inputs directly", {
  result <- format_exchanges(data_shakepay, data_newton)

  expect_s3_class(result, "data.frame")
  expect_true(all(c("shakepay", "newton") %in% result$exchange))
})
