# Prepare info for full crypto tax report

Prepare all required information for a full crypto tax report.

## Usage

``` r
prepare_report(
  formatted.ACB,
  list.prices = NULL,
  tax.year = "all",
  local.timezone = Sys.timezone()
)
```

## Arguments

- formatted.ACB:

  The `formatted.ACB` object.

- list.prices:

  A `list.prices` object from which to fetch coin prices. For
  `today.data` reporting paths, it must contain at least `currency`,
  `spot.rate2`, and `date2`.

- tax.year:

  The tax year desired.

- local.timezone:

  Which time zone to use for the date of the report.

## Value

A list, containing the following objects: report.overview,
report.summary, proceeds, sup.losses, table.revenues, tax.box,
pie_exchange, pie_revenue.

## Examples

``` r
list.prices <- list_prices_example
all.data <- format_exchanges(data_shakepay)
#> Exchange detected: shakepay
formatted.ACB <- format_ACB(all.data, verbose = FALSE)
if (is.data.frame(list.prices)) {
  x <- prepare_report(formatted.ACB, list.prices = list.prices)
  x$proceeds
}
#> Date of current prices: 2023-12-31
#>     type proceeds ACB.total    gains
#> 1  Gains 31.26847  25.45409 5.814382
#> 2 Losses  0.00000   0.00000 0.000000
```
