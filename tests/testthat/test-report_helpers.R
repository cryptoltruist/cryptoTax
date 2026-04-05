test_that("get_proceeds and get_sup_losses filter consistently by tax year", {
  formatted.ACB <- data.frame(
    date = as.POSIXct(
      c("2020-12-31 12:00:00", "2021-01-10 12:00:00", "2021-02-10 12:00:00"),
      tz = "UTC"
    ),
    gains = c(7, 10, -5),
    total.price = c(70, 100, 50),
    fees = c(0, 0, 0),
    gains.sup = c(1, 2, 3)
  )

  expect_message(
    proceeds <- get_proceeds(formatted.ACB, tax.year = 2021, local.timezone = "UTC"),
    "proceeds have been filtered for tax year 2021"
  )
  expect_equal(proceeds$proceeds, c(100, 50))
  expect_equal(proceeds$ACB.total, c(90, 55))
  expect_equal(proceeds$gains, c(10, -5))

  expect_message(
    sup.losses <- get_sup_losses(formatted.ACB, tax.year = 2021, local.timezone = "UTC"),
    "superficial losses have been filtered for tax year 2021"
  )
  expect_equal(sup.losses$currency, "Total")
  expect_equal(sup.losses$sup.loss, 5)
})

test_that("crypto_pie validates the `by` argument", {
  expect_error(
    crypto_pie(data.frame(), by = "invalid"),
    "`by` must be either 'exchange' or 'revenue.type'."
  )
})

test_that("resolve_report_today_data reuses explicit prices offline", {
  testthat::local_mocked_bindings(
    .package = "cryptoTax",
    prepare_list_prices_slugs = function(...) stop("should not prepare prices")
  )

  price.state <- cryptoTax:::.resolve_report_today_data(
    formatted.ACB = data.frame(currency = "BTC"),
    today.data = TRUE,
    list.prices = list(date2 = as.Date("2021-01-01")),
    slug = NULL,
    start.date = NULL,
    force = FALSE,
    verbose = TRUE
  )

  expect_true(price.state$today.data)
  expect_equal(price.state$list.prices$date2, as.Date("2021-01-01"))
})

test_that("resolve_report_today_data disables today.data when offline with no prices", {
  testthat::local_mocked_bindings(
    .package = "curl",
    has_internet = function() FALSE
  )

  expect_message(
    price.state <- cryptoTax:::.resolve_report_today_data(
      formatted.ACB = data.frame(currency = "BTC"),
      today.data = TRUE,
      list.prices = NULL,
      slug = NULL,
      start.date = NULL,
      force = FALSE,
      verbose = TRUE
    ),
    "today.data argument has been set to `FALSE` automatically."
  )

  expect_false(price.state$today.data)
  expect_null(price.state$list.prices)
})

test_that("prepare_report_current_rates emits the requested signal style", {
  ACB.list <- data.frame(
    date = as.Date(c("2021-01-01", "2021-01-01")),
    currency = c("GB", "BTC"),
    total.quantity = c(1, 1),
    ACB = c(10, 20)
  )
  list.prices <- list(date2 = as.Date("2021-01-02"))

  testthat::local_mocked_bindings(
    .package = "cryptoTax",
    match_prices = function(x, ...) transform(x, spot.rate = 42)
  )

  expect_warning(
    rates <- cryptoTax:::.prepare_report_current_rates(
      ACB.list = ACB.list,
      list.prices = list.prices,
      force = FALSE,
      verbose = TRUE,
      signal = "warning"
    ),
    "GB transactions are excluded"
  )

  expect_equal(rates$currency, "BTC")
  expect_equal(rates$spot.rate, 42)
  expect_equal(rates$date, as.Date("2021-01-02"))
})
