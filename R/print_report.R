#' @title Print full crypto tax report
#'
#' @description Will output a full crypto tax report in HTML format, which can then be printed or saved as PDF.
#' @param tax.year The tax year desired.
#' @param name Name of the individual for the report.
#' @param table.revenues The table of revenues.
#' @param report.summary The report summary.
#' @param sup.losses The calculated superficial losses.
#' @export
#' @examples
#' \dontrun{
#' print_report()
#' }
#'
print_report <- function(tax.year, name, table.revenues, report.summary, sup.losses) {
  rlang::check_installed(c("flextable", "rmarkdown"),
    reason = "for this function."
  )
  format.money <- function(x) {
    paste0("", formatC(x, format = "f", big.mark = ",", digits = 2))
  }
  person.name <- paste("Name:", name)
  # table.revenues <- get("table.revenues", envir = .GlobalEnv)
  total.income.numeric <- dplyr::last(table.revenues$staking) +
    dplyr::last(table.revenues$interests)
  total.income.numeric <<- total.income.numeric
  total.income <- format.money(total.income.numeric)
  total.income <<- total.income
  total.cost <- report.summary$Amount[5]
  total.cost <<- total.cost
  gains <- report.summary$Amount[2]
  gains <<- gains
  gains.numeric <- as.numeric(gsub(",", "", gains))
  gains.50 <- format.money(gains.numeric * 0.5)
  gains.50 <<- gains.50
  losses <- report.summary$Amount[3]
  losses <<- losses
  net <- report.summary$Amount[4]
  net <<- net
  net.numeric <- as.numeric(gsub(",", "", net))
  net.50 <- format.money(net.numeric * 0.5)
  net.50 <<- net.50
  total.tax <- format.money(net.numeric * 0.5 + total.income.numeric)
  total.tax <<- total.tax
  sup.losses.total <- sup.losses[nrow(sup.losses), "sup.loss"]
  sup.losses.total <<- sup.losses.total
  tot.losses <- format.money(as.numeric(losses) - sup.losses.total)
  tot.losses <<- tot.losses
  tot.sup.loss <- as.numeric(tot.losses) + sup.losses.total
  if (tax.year == "all") {
    tax.year <- "all years"
  } else {
    tax.year <- tax.year
  }
  rmarkdown::render(system.file("full_report.Rmd", package = "cryptoTax"),
    output_dir = getwd()
  )
  rstudioapi::viewer("full_report.html")
}
