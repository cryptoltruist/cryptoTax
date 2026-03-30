# Get superficial loss amounts

Get superficial loss amounts

## Usage

``` r
get_sup_losses(
  formatted.ACB,
  tax.year = "all",
  local.timezone = Sys.timezone()
)
```

## Arguments

- formatted.ACB:

  The dataframe `formatted.ACB`,

- tax.year:

  which year

- local.timezone:

  which time zone

## Value

A data frame, with the following columns: currency, sup.loss.

## Examples

``` r
all.data <- format_shakepay(data_shakepay)
formatted.ACB <- format_ACB(all.data, verbose = FALSE)
get_sup_losses(formatted.ACB, 2021)
#> Note: superficial losses have been filtered for tax year 2021
#>   currency sup.loss
#> 1    Total        0
```
