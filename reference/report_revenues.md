# Report all revenues

Provides a summary of revenues from all sources.

## Usage

``` r
report_revenues(
  formatted.ACB,
  tax.year = "all",
  local.timezone = Sys.timezone()
)
```

## Arguments

- formatted.ACB:

  The formatted ACB data.

- tax.year:

  Which tax year(s) to include.

- local.timezone:

  Which time zone to use for the date of the report.

## Value

A data frame, with the following columns: exchange, date.last,
total.revenues, airdrops, referrals, staking, promos, interests,
rebates, rewards, forks, mining, currency.

## Examples

``` r
all.data <- format_exchanges(data_shakepay)
#> Exchange detected: shakepay
formatted.ACB <- format_ACB(all.data, verbose = FALSE)
report_revenues(formatted.ACB)
#>   exchange           date.last total.revenues interests rebates staking promos
#> 1 shakepay 2021-06-23 12:21:49           3.64         0       0       0      0
#> 2    total 2021-06-23 12:21:49           3.64         0       0       0      0
#>   airdrops referrals rewards forks mining currency
#> 1     3.64         0       0     0      0      CAD
#> 2     3.64         0       0     0      0      CAD
```
