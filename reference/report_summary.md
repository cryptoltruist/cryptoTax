# Summary of gains and losses

Provides a summary of realized capital gains and losses (and total).

## Usage

``` r
report_summary(
  formatted.ACB,
  today.data = TRUE,
  tax.year = "all",
  local.timezone = Sys.timezone(),
  list.prices = NULL,
  slug = NULL,
  start.date = NULL,
  force = FALSE
)
```

## Arguments

- formatted.ACB:

  The formatted ACB data.

- today.data:

  whether to fetch today's data.

- tax.year:

  Which tax year(s) to include.

- local.timezone:

  Which time zone to use for the date of the report.

- list.prices:

  A `list.prices` object from which to fetch coin prices.

- force:

  Whether to force recreating `list.prices` even though it already
  exists (e.g., if you added new coins or new dates).

## Value

A summary data frame, containing at least the following columns: Type,
Amount, currency.

## Examples

``` r
all.data <- format_shakepay(data_shakepay)
formatted.ACB <- format_ACB(all.data, verbose = FALSE)
report_summary(formatted.ACB, today.data = FALSE)
#> Object 'list.prices' already exists. Reusing 'list.prices'. To force a fresh download, use argument 'force = TRUE'.
#>         Type   Amount currency
#> 1   tax.year      all      CAD
#> 2      gains     5.81      CAD
#> 3     losses     0.00      CAD
#> 4        net     5.81      CAD
#> 5 total.cost    27.62      CAD
#> 6    revenue 3.641656      CAD
```
