.print_report_tax_year_label <- function(tax.year) {
  if (identical(tax.year, "all")) {
    return("all years")
  }

  tax.year
}

.build_print_report_env <- function(report.info, list.prices, render.context) {
  list2env(
    c(
      list(
        report.info = report.info,
        list.prices = list.prices
      ),
      render.context
    ),
    parent = asNamespace("cryptoTax")
  )
}

.prepare_print_report_context <- function(report.info, tax.year, name) {
  person.name <- paste("Name:", name)
  total.income.numeric <- sum(
    dplyr::last(report.info$table.revenues$staking),
    dplyr::last(report.info$table.revenues$interests),
    na.rm = TRUE
  )
  total.income <- format_dollars(total.income.numeric)
  total.cost <- report.info$report.summary$Amount[5]
  gains <- report.info$report.summary$Amount[2]
  gains.numeric <- format_dollars(gains, "numeric")
  gains.50 <- format_dollars(gains.numeric * 0.5)
  losses <- report.info$report.summary$Amount[3]
  net <- report.info$report.summary$Amount[4]
  net.numeric <- format_dollars(net, "numeric")
  net.50 <- format_dollars(net.numeric * 0.5)
  total.tax <- format_dollars(net.numeric * 0.5 + total.income.numeric)
  sup.losses.total <- report.info$sup.losses[nrow(report.info$sup.losses), "sup.loss"]
  tot.losses <- format_dollars(as.numeric(losses) - sup.losses.total)
  tot.sup.loss <- as.numeric(tot.losses) + sup.losses.total
  tax.year <- .print_report_tax_year_label(tax.year)
  out.name <- paste0("full_report_", tax.year, ".html")

  dplyr::lst(
    person.name,
    total.income.numeric,
    total.income,
    total.cost,
    gains,
    gains.numeric,
    gains.50,
    losses,
    net,
    net.numeric,
    net.50,
    total.tax,
    sup.losses.total,
    tot.losses,
    tot.sup.loss,
    tax.year,
    out.name
  )
}

.render_print_report <- function(render.env, out.name) {
  rmarkdown::render(system.file("full_report.Rmd", package = "cryptoTax"),
    output_file = out.name,
    output_dir = getwd(),
    envir = render.env
  )
  if (interactive()) {
    rstudioapi::viewer(out.name)
  }
}

#' @title Print full crypto tax report
#'
#' @description Will output a full crypto tax report in HTML format, which can then be printed or saved as PDF.
#' @param formatted.ACB The `formatted.ACB` object.
#' @param list.prices A `list.prices` object from which to fetch coin prices.
#' @return A list, containing the following objects: report.overview,
#' report.summary, proceeds, sup.losses, table.revenues, tax.box,
#' pie_exchange, pie_revenue.
#' @param tax.year The tax year desired.
#' @param local.timezone Which time zone to use for the date of the report.
#' @param name Name of the individual for the report.
#' @return An HTML page containing a crypto tax report.
#' @export
#' @examples
#' \donttest{
#' list.prices <- list_prices_example
#' all.data <- format_shakepay(data_shakepay)
#' formatted.ACB <- format_ACB(all.data, verbose = FALSE)
#' if (!is.null(list.prices) && !is.null(list.prices$date2)) {
#'   print_report(formatted.ACB,
#'     list.prices = list.prices,
#'     tax.year = 2021, name = "Mr. Cryptoltruist"
#'   )
#' }
#' }
#' \dontshow{
#' if (file.exists("full_report_2021.html")) unlink("full_report_2021.html")
#' }
print_report <- function(formatted.ACB,
                         list.prices,
                         tax.year = "all",
                         local.timezone = "America/Montreal",
                         name) {
  rlang::check_installed(c("flextable", "rmarkdown"),
    reason = "for this function."
  )
  report.info <- prepare_report(formatted.ACB,
    list.prices,
    tax.year = tax.year,
    local.timezone = local.timezone
  )
  render.context <- .prepare_print_report_context(
    report.info = report.info,
    tax.year = tax.year,
    name = name
  )
  render.env <- .build_print_report_env(
    report.info = report.info,
    list.prices = list.prices,
    render.context = render.context
  )
  .render_print_report(render.env, render.context$out.name)
}


