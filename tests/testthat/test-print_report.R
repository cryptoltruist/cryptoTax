test_that("build_print_report_env stores report inputs in a package-backed env", {
  report.info <- list(ok = TRUE)
  list.prices <- list(date2 = as.Date("2021-01-01"))
  render.context <- list(
    person.name = "Name: Test",
    out.name = "full_report_2021.html"
  )

  render.env <- cryptoTax:::.build_print_report_env(
    report.info = report.info,
    list.prices = list.prices,
    render.context = render.context
  )

  expect_identical(get("report.info", envir = render.env), report.info)
  expect_identical(get("list.prices", envir = render.env), list.prices)
  expect_equal(get("person.name", envir = render.env), "Name: Test")
  expect_equal(get("out.name", envir = render.env), "full_report_2021.html")
  expect_identical(parent.env(render.env), asNamespace("cryptoTax"))
})

test_that("print_report passes an explicit render env to the renderer", {
  render.result <- NULL
  report.info <- list(ok = TRUE)
  list.prices <- list(date2 = as.Date("2021-01-01"))

  testthat::local_mocked_bindings(
    prepare_report = function(...) report.info,
    .prepare_print_report_context = function(report.info, tax.year, name) {
      list(
        person.name = paste("Name:", name),
        tax.year = tax.year,
        out.name = "full_report_2021.html"
      )
    },
    .render_print_report = function(render.env, out.name) {
      render.result <<- list(render.env = render.env, out.name = out.name)
      invisible(NULL)
    },
    .package = "cryptoTax"
  )

  print_report(
    formatted.ACB = data.frame(dummy = 1),
    list.prices = list.prices,
    tax.year = 2021,
    name = "Mr. Test"
  )

  expect_equal(render.result$out.name, "full_report_2021.html")
  expect_identical(get("report.info", envir = render.result$render.env), report.info)
  expect_identical(get("list.prices", envir = render.result$render.env), list.prices)
  expect_equal(get("person.name", envir = render.result$render.env), "Name: Mr. Test")
  expect_equal(get("tax.year", envir = render.result$render.env), 2021)
})

test_that("prepare_print_report_context handles empty superficial-loss tables", {
  report.info <- list(
    table.revenues = data.frame(staking = 10, interests = 5),
    report.summary = data.frame(
      Type = c("tax.year", "gains", "losses", "net", "total.cost"),
      Amount = c("2021", "100.00", "-20.00", "80.00", "1,000.00"),
      stringsAsFactors = FALSE
    ),
    sup.losses = data.frame(currency = character(), sup.loss = numeric())
  )

  context <- cryptoTax:::.prepare_print_report_context(
    report.info = report.info,
    tax.year = 2021,
    name = "Mr. Test"
  )

  expect_equal(context$sup.losses.total, 0)
  expect_equal(context$tot.losses, "-20.00")
  expect_equal(context$tot.sup.loss, -20)
})
