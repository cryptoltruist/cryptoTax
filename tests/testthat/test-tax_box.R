test_that("tax_box handles empty superficial-loss tables", {
  report.summary <- data.frame(
    Type = c("tax.year", "gains", "losses", "net", "total.cost"),
    Amount = c("2021", "100.00", "-20.00", "80.00", "1,000.00"),
    stringsAsFactors = FALSE
  )
  sup.losses <- data.frame(currency = character(), sup.loss = numeric())
  table.revenues <- data.frame(staking = 10, interests = 5)
  proceeds <- data.frame(
    proceeds = c(100, 50),
    ACB.total = c(90, 55)
  )

  result <- tax_box(report.summary, sup.losses, table.revenues, proceeds)

  expect_s3_class(result, "data.frame")
  expect_equal(result$Description[[12]], "Foreign gains (losses)")
  expect_equal(result$Amount[[11]], 15)
  expect_equal(result$Amount[[12]], 5)
})

test_that("tax_box matches proceeds rows by type instead of row order", {
  report.summary <- data.frame(
    Type = c("tax.year", "gains", "losses", "net", "total.cost"),
    Amount = c("2021", "100.00", "-20.00", "80.00", "1,000.00"),
    stringsAsFactors = FALSE
  )
  sup.losses <- data.frame(currency = character(), sup.loss = numeric())
  table.revenues <- data.frame(staking = 10, interests = 5)
  proceeds <- data.frame(
    type = c("Losses", "Gains"),
    proceeds = c(50, 100),
    ACB.total = c(55, 90)
  )

  result <- tax_box(report.summary, sup.losses, table.revenues, proceeds)

  expect_equal(result$Amount[[1]], 100)
  expect_equal(result$Amount[[2]], 90)
  expect_equal(result$Amount[[6]], 50)
  expect_equal(result$Amount[[7]], 55)
  expect_equal(result$Amount[[12]], 5)
})

test_that("tax_box matches report.summary losses by Type instead of row order", {
  report.summary <- data.frame(
    Type = c("tax.year", "net", "losses", "gains", "total.cost"),
    Amount = c("2021", "80.00", "-20.00", "100.00", "1,000.00"),
    stringsAsFactors = FALSE
  )
  sup.losses <- data.frame(currency = character(), sup.loss = numeric())
  table.revenues <- data.frame(staking = 10, interests = 5)
  proceeds <- data.frame(
    type = c("Gains", "Losses"),
    proceeds = c(100, 50),
    ACB.total = c(90, 55)
  )

  result <- tax_box(report.summary, sup.losses, table.revenues, proceeds)

  expect_equal(result$Amount[result$Description == "Losses"], -5)
})
