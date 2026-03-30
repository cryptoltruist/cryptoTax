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

  A `list.prices` object from which to fetch coin prices.

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
list.prices <- prepare_list_prices(slug = "bitcoin", start.date = "2021-01-01")
#> Object 'list.prices' already exists. Reusing 'list.prices'. To force a fresh download, use argument 'force = TRUE'.
all.data <- format_shakepay(data_shakepay)
formatted.ACB <- format_ACB(all.data, verbose = FALSE)
x <- prepare_report(formatted.ACB, list.prices = list.prices)
#> Date of current prices: 2026-03-29
#> Date of current prices: 2026-03-29
x$proceeds
#>     type proceeds ACB.total    gains
#> 1  Gains 31.26847  25.45409 5.814382
#> 2 Losses  0.00000   0.00000 0.000000
```
