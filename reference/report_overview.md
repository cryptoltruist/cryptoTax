# Summary of ACB

Provides a summary of Adjusted Cost Base (ACB) per share, as well as
realized and unrealized gains/losses (plus net value), per coin.

## Usage

``` r
report_overview(
  formatted.ACB,
  today.data = TRUE,
  tax.year = "all",
  local.timezone = Sys.timezone(),
  list.prices = NULL,
  slug = NULL,
  start.date = NULL,
  force = FALSE,
  verbose = TRUE
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

A summary data frame, containing at least the following columns:
date.last, currency, total.quantity, cost.share, total.cost, gains,
losses, net, currency.

## Examples

``` r
all.data <- format_shakepay(data_shakepay)
formatted.ACB <- format_ACB(all.data, verbose = FALSE)
report_overview(formatted.ACB, today.data = FALSE)
#>             date.last currency total.quantity cost.share total.cost gains
#> 1 2021-07-10 00:52:19      BTC     0.00057491   48034.74      27.62  5.81
#> 2 2021-07-10 00:52:19    Total             NA         NA      27.62  5.81
#>   losses  net currency2
#> 1      0 5.81       BTC
#> 2      0 5.81     Total
```
