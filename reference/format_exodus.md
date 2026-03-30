# Format Exodus wallet file

Format a .csv transaction history file from the Exodus wallet for later
ACB processing.

## Usage

``` r
format_exodus(data, list.prices = NULL, force = FALSE)
```

## Arguments

- data:

  The dataframe

- list.prices:

  A `list.prices` object from which to fetch coin prices.

- force:

  Whether to force recreating `list.prices` even though it already
  exists (e.g., if you added new coins or new dates).

## Value

A data frame of exchange transactions, formatted for further processing.

## Examples

``` r
# \donttest{
format_exodus(data_exodus)
#> Object 'list.prices' already exists. Reusing 'list.prices'. To force a fresh download, use argument 'force = TRUE'.
#>                  date currency  quantity total.price    spot.rate transaction
#> 1 2021-05-25 22:06:11      LTC 0.0014430   0.3205936   222.171556        sell
#> 2 2021-05-25 23:08:12      ADA 0.1782410   0.3337199     1.872296        sell
#> 3 2021-06-12 12:15:28      BTC 0.0000503   2.2270326 44275.001680        sell
#> 4 2021-06-12 22:31:35      ETH 0.0014500   4.1634192  2871.323554        sell
#>   description revenue.type exchange   rate.source
#> 1  withdrawal         <NA>   exodus coinmarketcap
#> 2  withdrawal         <NA>   exodus coinmarketcap
#> 3  withdrawal         <NA>   exodus coinmarketcap
#> 4  withdrawal         <NA>   exodus coinmarketcap
# }
```
