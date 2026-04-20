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
#> Using cached 'list.prices'. To force a fresh download, use argument 'force = TRUE'.
#> Warning: Could not calculate spot rate. Use `force = TRUE`.
#>                   date currency     quantity total.price spot.rate transaction
#> 1  2021-05-29 21:43:44      BTC  0.000018512   0.7864347  42482.43     revenue
#> 2  2021-05-29 21:43:44      LTC  0.022451200          NA        NA     revenue
#> 3  2021-06-13 21:43:44      BTC  0.000184120   8.3488528  45344.63     revenue
#> 4  2021-06-30 21:43:44      BTC  0.000047234   2.0767484  43967.23     revenue
#> 5  2021-06-30 21:43:44      LTC  0.010125120          NA        NA     revenue
#> 6  2021-07-29 21:43:44     USDC  0.038241000          NA        NA     revenue
#> 7  2021-08-05 18:34:06      BTC  0.000250000  12.5929252  50371.70        sell
#> 8  2021-08-07 21:43:44      BTC  0.000441230  24.1954404  54836.34     revenue
#> 9  2021-10-24 04:29:23     USDC 55.000000000          NA        NA         buy
#> 10 2021-10-24 04:29:23      LTC  0.165122140          NA        NA        sell
#>         description revenue.type exchange               rate.source
#> 1  Interest Payment    interests  blockfi             coinmarketcap
#> 2  Interest Payment    interests  blockfi             coinmarketcap
#> 3    Referral Bonus    referrals  blockfi             coinmarketcap
#> 4  Interest Payment    interests  blockfi             coinmarketcap
#> 5  Interest Payment    interests  blockfi             coinmarketcap
#> 6  Interest Payment    interests  blockfi             coinmarketcap
#> 7    Withdrawal Fee         <NA>  blockfi             coinmarketcap
#> 8     Bonus Payment       promos  blockfi             coinmarketcap
#> 9             Trade         <NA>  blockfi             coinmarketcap
#> 10            Trade         <NA>  blockfi coinmarketcap (buy price)
```
