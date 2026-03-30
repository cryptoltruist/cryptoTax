# Get proceeds of all sold coins

Get proceeds of sold coins, ACB of sold coins, and resulting difference
between the two, capital gains.

## Usage

``` r
get_proceeds(formatted.ACB, tax.year = "all", local.timezone = Sys.timezone())
```

## Arguments

- formatted.ACB:

  The `formatted.ACB` object,

- tax.year:

  which year

- local.timezone:

  which time zone

## Value

A data frame, with the following columns: type, proceeds, ACB.total,
gains.

## Examples

``` r
all.data <- format_shakepay(data_shakepay)
formatted.ACB <- format_ACB(all.data, verbose = FALSE)
get_proceeds(formatted.ACB, 2021)
#> Note: proceeds have been filtered for tax year 2021
#>     type proceeds ACB.total    gains
#> 1  Gains 31.26847  25.45409 5.814382
#> 2 Losses  0.00000   0.00000 0.000000
```
