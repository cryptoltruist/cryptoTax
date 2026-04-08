# Get the date from the latest transactions per exchange

Get the date from the latest transactions per exchange

## Usage

``` r
get_latest_transactions(formatted.ACB)
```

## Arguments

- formatted.ACB:

  The formatted.ACB file

## Value

A data frame with two columns: the name of the exchange as well as the
date of the latest transaction.

## Examples

``` r
all.data <- format_exchanges(data_shakepay)
#> Exchange detected: shakepay
formatted.ACB <- format_ACB(all.data, verbose = FALSE)
get_latest_transactions(formatted.ACB)
#> # A tibble: 1 × 2
#> # Groups:   exchange [1]
#>   exchange date               
#>   <chr>    <dttm>             
#> 1 shakepay 2021-07-10 00:52:19
```
