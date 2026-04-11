# Format BlockFi file

Format a .csv transaction history file from BlockFi for later ACB
processing.

## Usage

``` r
format_blockfi(data, list.prices = NULL, force = FALSE)
```

## Arguments

- data:

  The dataframe

- list.prices:

  An optional explicit `list.prices` object from which to fetch coin
  prices. For exchanges that require external pricing, it must contain
  at least `currency`, `spot.rate2`, and `date2`.

- force:

  Whether to force recreating `list.prices` even though it already
  exists (e.g., if you added new coins or new dates).

## Value

A data frame of exchange transactions, formatted for further processing.

## Examples

``` r
format_blockfi(data_blockfi)
#> Object 'list.prices' already exists. Reusing 'list.prices'. To force a fresh download, use argument 'force = TRUE'.
#>                   date currency     quantity total.price    spot.rate
#> 1  2021-05-29 21:43:44      LTC  0.022451200  4.62896363   206.178896
#> 2  2021-05-29 21:43:44      BTC  0.000018512  0.78643467 42482.425898
#> 3  2021-06-13 21:43:44      BTC  0.000184120  8.34885284 45344.627640
#> 4  2021-06-30 21:43:44      BTC  0.000047234  2.07674837 43967.234920
#> 5  2021-06-30 21:43:44      LTC  0.010125120  1.80823545   178.589038
#> 6  2021-07-29 21:43:44     USDC  0.038241000  0.04761184     1.245047
#> 7  2021-08-05 18:34:06      BTC  0.000250000 12.59292517 50371.700691
#> 8  2021-08-07 21:43:44      BTC  0.000441230 24.19544042 54836.344810
#> 9  2021-10-24 04:29:23     USDC 55.000000000 68.01411135     1.236620
#> 10 2021-10-24 04:29:23      LTC  0.165122140 68.01411135   411.901828
#>    transaction      description revenue.type exchange               rate.source
#> 1      revenue Interest Payment    interests  blockfi             coinmarketcap
#> 2      revenue Interest Payment    interests  blockfi             coinmarketcap
#> 3      revenue   Referral Bonus    referrals  blockfi             coinmarketcap
#> 4      revenue Interest Payment    interests  blockfi             coinmarketcap
#> 5      revenue Interest Payment    interests  blockfi             coinmarketcap
#> 6      revenue Interest Payment    interests  blockfi             coinmarketcap
#> 7         sell   Withdrawal Fee         <NA>  blockfi             coinmarketcap
#> 8      revenue    Bonus Payment       promos  blockfi             coinmarketcap
#> 9          buy            Trade         <NA>  blockfi             coinmarketcap
#> 10        sell            Trade         <NA>  blockfi coinmarketcap (buy price)
```
