.prepare_report_core <- function(formatted.ACB, list.prices, tax.year, local.timezone) {
  report.overview <- report_overview(
    formatted.ACB,
    today.data = TRUE,
    tax.year = tax.year,
    local.timezone = local.timezone,
    list.prices = list.prices
  )
  report.summary <- report_summary(
    formatted.ACB,
    today.data = TRUE,
    tax.year = tax.year,
    local.timezone = local.timezone,
    list.prices = list.prices
  )
  proceeds <- get_proceeds(
    formatted.ACB,
    tax.year = tax.year,
    local.timezone = local.timezone
  )
  sup.losses <- get_sup_losses(
    formatted.ACB,
    tax.year = tax.year,
    local.timezone = local.timezone
  )
  table.revenues <- report_revenues(
    formatted.ACB,
    tax.year = tax.year,
    local.timezone = local.timezone
  )

  dplyr::lst(report.overview, report.summary, proceeds, sup.losses, table.revenues, list.prices)
}

.prepare_report_outputs <- function(report.info, local.timezone) {
  report.info$tax.box <- tax_box(
    report.info$report.summary,
    report.info$sup.losses,
    report.info$table.revenues,
    report.info$proceeds
  )
  report.info$pie_exchange <- crypto_pie(report.info$table.revenues)
  report.info$pie_revenue <- crypto_pie(report.info$table.revenues, by = "revenue.type")
  report.info$current.price.date <- .report_current_price_date(report.info$list.prices)
  report.info$list.prices <- NULL
  report.info$local.timezone <- local.timezone
  report.info
}

#' @title Prepare info for full crypto tax report
#'
#' @description Prepare all required information for a full crypto tax report.
#' @param formatted.ACB The `formatted.ACB` object.
#' @param list.prices A `list.prices` object from which to fetch coin prices.
#' For `today.data` reporting paths, it must contain at least `currency`,
#' `spot.rate2`, and `date2`.
#' @return A list, containing the following objects: report.overview,
#' report.summary, proceeds, sup.losses, table.revenues, tax.box,
#' pie_exchange, pie_revenue.
#' @param tax.year The tax year desired.
#' @param local.timezone Which time zone to use for the date of the report.
#' @export
#' @examples
#' list.prices <- list_prices_example
#' all.data <- format_exchanges(data_shakepay)
#' formatted.ACB <- format_ACB(all.data, verbose = FALSE)
#' if (is.data.frame(list.prices)) {
#'   x <- prepare_report(formatted.ACB, list.prices = list.prices)
#'   x$proceeds
#' }
prepare_report <- function(formatted.ACB,
                           list.prices = NULL,
                           tax.year = "all",
                           local.timezone = Sys.timezone()) {
  report.info <- .prepare_report_core(
    formatted.ACB = formatted.ACB,
    list.prices = list.prices,
    tax.year = tax.year,
    local.timezone = local.timezone
  )
  .prepare_report_outputs(report.info, local.timezone = local.timezone)
}
