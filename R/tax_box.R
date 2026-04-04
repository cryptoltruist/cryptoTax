.tax_box_metrics <- function(report.summary, sup.losses, table.revenues, proceeds) {
  losses <- report.summary$Amount[3]
  sup.losses.total <- sup.losses[nrow(sup.losses), "sup.loss"]
  total.income.numeric <- dplyr::last(table.revenues$staking) +
    dplyr::last(table.revenues$interests)

  gains.proceeds <- proceeds$proceeds[1]
  gains.acb <- proceeds$ACB.total[1]
  losses.proceeds <- proceeds$proceeds[2]
  losses.acb <- proceeds$ACB.total[2]

  list(
    gains.proceeds = gains.proceeds,
    gains.acb = gains.acb,
    gains.amount = gains.proceeds - gains.acb,
    gains.taxable = (gains.proceeds - gains.acb) / 2,
    losses.proceeds = losses.proceeds,
    losses.acb = losses.acb,
    losses.amount = losses.proceeds - losses.acb,
    losses.taxable = (losses.proceeds - losses.acb) / 2,
    total.income.numeric = total.income.numeric,
    foreign.gains.losses = (gains.proceeds - gains.acb) + (losses.proceeds - losses.acb),
    sup.losses.total = sup.losses.total,
    total.losses = as.numeric(losses) - sup.losses.total
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

  out <- data.frame(
    Description = c(
      "Gains proceeds", # 1
      "Gains ACB", # 2
      "Gains", # 3
      "50% of gains", # 4
      "Outlays of gains", # 5
      "Losses proceeds", # 6
      "Losses ACB", # 7
      "Losses", # 8
      "50% of losses", # 9
      "Outlays of losses", # 10
      "Foreign income" # 11
    ),
    Amount = c(
      metrics$gains.proceeds, # 1
      metrics$gains.acb, # 2
      metrics$gains.amount, # 3
      metrics$gains.taxable, # 4
      0, # 5
      metrics$losses.proceeds, # 6
      metrics$losses.acb, # 7
      metrics$losses.amount, # 8
      metrics$losses.taxable, # 9
      0, # 10
      metrics$total.income.numeric # 11
    ),
    Comment = c(
      "Proceeds of sold coins (gains)", # 1
      "ACB of sold coins (gains)", # 2
      "Proceeds - ACB (gains)", # 3
      "Half of gains", # 4
      "Expenses and trading fees (gains). Normally already integrated in the ACB", # 5
      "Proceeds of sold coins (losses)", # 6
      "ACB of sold coins (losses)", # 7
      "Proceeds - ACB (losses)", # 8
      "Half of losses", # 9
      "Expenses and trading fees (losses). Normally already integrated in the ACB", # 10
      "Income from crypto interest or staking is considered foreign income" # 11
    ),
    Line = c(
      "Schedule 3, line 15199 column 2", # 1
      "Schedule 3, line 15199 column 3", # 2
      "Schedule 3, lines 15199 column 5 & 15300", # 3
      "T1, line 12700; Schedule 3, line 15300, 19900", # 4
      "Tax software", # 5
      "Schedule 3, line 15199 column 2", # 6
      "Schedule 3, line 15199 column 3", # 7
      "Schedule 3, lines 15199 column 5 & 15300", # 8
      "T1, line 12700; Schedule 3, line 15300, 19900", # 9
      "Tax software", # 10
      "T1, line 13000, T1135" # 11
    )
  )
  new.row <- data.frame(
    Description = "Foreign gains (losses)",
    Amount = metrics$foreign.gains.losses,
    Comment = "Capital gains from crypto is considered foreign capital gains",
    Line = "T1135"
  )
  out <- rbind(out, new.row)
  out
}
