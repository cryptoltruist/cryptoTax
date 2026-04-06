.proceeds_metrics_row <- function(proceeds, type) {
  if (!"type" %in% names(proceeds)) {
    index <- switch(type,
      Gains = 1,
      Losses = 2
    )

    if (is.na(index) || nrow(proceeds) < index) {
      return(list(proceeds = 0, ACB.total = 0))
    }

    row <- proceeds[index, , drop = FALSE]
  } else {
    row <- proceeds[proceeds$type == type, , drop = FALSE]
  }

  if (nrow(row) == 0) {
    return(list(proceeds = 0, ACB.total = 0))
  }

  list(
    proceeds = row$proceeds[[1]],
    ACB.total = row$ACB.total[[1]]
  )
}

.tax_box_metrics <- function(report.summary, sup.losses, table.revenues, proceeds) {
  losses <- report.summary$Amount[3]
  sup.losses.total <- .sup_losses_total(sup.losses)
  total.income.numeric <- dplyr::last(table.revenues$staking) +
    dplyr::last(table.revenues$interests)

  gains.row <- .proceeds_metrics_row(proceeds, "Gains")
  losses.row <- .proceeds_metrics_row(proceeds, "Losses")

  list(
    gains.proceeds = gains.row$proceeds,
    gains.acb = gains.row$ACB.total,
    gains.amount = gains.row$proceeds - gains.row$ACB.total,
    gains.taxable = (gains.row$proceeds - gains.row$ACB.total) / 2,
    losses.proceeds = losses.row$proceeds,
    losses.acb = losses.row$ACB.total,
    losses.amount = losses.row$proceeds - losses.row$ACB.total,
    losses.taxable = (losses.row$proceeds - losses.row$ACB.total) / 2,
    total.income.numeric = total.income.numeric,
    foreign.gains.losses = (gains.row$proceeds - gains.row$ACB.total) +
      (losses.row$proceeds - losses.row$ACB.total),
    sup.losses.total = sup.losses.total,
    total.losses = as.numeric(losses) - sup.losses.total
  )
}

.tax_box_rows <- function(metrics) {
  data.frame(
    Description = c(
      "Gains proceeds",
      "Gains ACB",
      "Gains",
      "50% of gains",
      "Outlays of gains",
      "Losses proceeds",
      "Losses ACB",
      "Losses",
      "50% of losses",
      "Outlays of losses",
      "Foreign income",
      "Foreign gains (losses)"
    ),
    Amount = c(
      metrics$gains.proceeds,
      metrics$gains.acb,
      metrics$gains.amount,
      metrics$gains.taxable,
      0,
      metrics$losses.proceeds,
      metrics$losses.acb,
      metrics$losses.amount,
      metrics$losses.taxable,
      0,
      metrics$total.income.numeric,
      metrics$foreign.gains.losses
    ),
    Comment = c(
      "Proceeds of sold coins (gains)",
      "ACB of sold coins (gains)",
      "Proceeds - ACB (gains)",
      "Half of gains",
      "Expenses and trading fees (gains). Normally already integrated in the ACB",
      "Proceeds of sold coins (losses)",
      "ACB of sold coins (losses)",
      "Proceeds - ACB (losses)",
      "Half of losses",
      "Expenses and trading fees (losses). Normally already integrated in the ACB",
      "Income from crypto interest or staking is considered foreign income",
      "Capital gains from crypto is considered foreign capital gains"
    ),
    Line = c(
      "Schedule 3, line 15199 column 2",
      "Schedule 3, line 15199 column 3",
      "Schedule 3, lines 15199 column 5 & 15300",
      "T1, line 12700; Schedule 3, line 15300, 19900",
      "Tax software",
      "Schedule 3, line 15199 column 2",
      "Schedule 3, line 15199 column 3",
      "Schedule 3, lines 15199 column 5 & 15300",
      "T1, line 12700; Schedule 3, line 15300, 19900",
      "Tax software",
      "T1, line 13000, T1135",
      "T1135"
    ),
    stringsAsFactors = FALSE
  )
}

#' @title Get a simple table of relevant tax information
#'
#' @description Output a simple table with all the relevant tax information and tax form line numbers.
#' @param report.summary report.summary
#' @param sup.losses sup.losses
#' @param table.revenues table.revenues
#' @param proceeds proceeds
#' @return A data frame, with the following columns: Description, Amount,
#' Comment, Line
#' @export
#' @examples
#' my.list.prices <- list_prices_example
#' all.data <- format_shakepay(data_shakepay)
#' formatted.ACB <- format_ACB(all.data, verbose = FALSE)
#' report.summary <- report_summary(formatted.ACB, today.data = TRUE, list.prices = my.list.prices)
#' sup.losses <- get_sup_losses(formatted.ACB, 2021)
#' table.revenues <- report_revenues(formatted.ACB, 2021)
#' proceeds <- get_proceeds(formatted.ACB, 2021)
#' tax_box(report.summary, sup.losses, table.revenues, proceeds)
tax_box <- function(report.summary, sup.losses, table.revenues, proceeds) {
  metrics <- .tax_box_metrics(report.summary, sup.losses, table.revenues, proceeds)
  .tax_box_rows(metrics)
}
