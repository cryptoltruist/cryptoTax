% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/prepare_report.R
\name{prepare_report}
\alias{prepare_report}
\title{Prepare info for full crypto tax report}
\usage{
prepare_report(
  formatted.ACB,
  list.prices = NULL,
  tax.year = "all",
  local.timezone = Sys.timezone()
)
}
\arguments{
\item{formatted.ACB}{The \code{formatted.ACB} object.}

\item{list.prices}{A \code{list.prices} object from which to fetch coin prices.}

\item{tax.year}{The tax year desired.}

\item{local.timezone}{Which time zone to use for the date of the report.}
}
\value{
A list, containing the following objects: report.overview,
report.summary, proceeds, sup.losses, table.revenues, tax.box,
pie_exchange, pie_revenue.
}
\description{
Prepare all required information for a full crypto tax report.
}
\examples{
list.prices <- prepare_list_prices(coins = "BTC", start.date = "2021-01-01")
all.data <- format_shakepay(data_shakepay)
formatted.ACB <- format_ACB(all.data, verbose = FALSE)
x <- prepare_report(formatted.ACB, list.prices = list.prices)
x$proceeds
}
