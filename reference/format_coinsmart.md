# Format CoinSmart file

Format a .csv transaction history file from CoinSmart for later ACB
processing.

## Usage

``` r
format_coinsmart(data, list.prices = NULL, force = FALSE)
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
format_coinsmart(data_coinsmart)
#> Using cached 'list.prices'. To force a fresh download, use argument 'force = TRUE'.
#> Warning: Could not calculate spot rate. Use `force = TRUE`.
#>                  date currency  quantity total.price    spot.rate transaction
#> 1 2021-04-25 16:11:24      ADA 198.50000  237.937430     1.198677         buy
#> 2 2021-04-28 18:37:15      CAD  15.00000   15.000000     1.000000     revenue
#> 3 2021-05-15 16:42:07      BTC   0.00004    2.339839 58495.964189     revenue
#> 4 2021-06-03 02:04:49      ADA   0.30000          NA           NA        sell
#>   fees fees.quantity fees.currency description  comment revenue.type  exchange
#> 1   NA         0.197           ADA    purchase    Trade         <NA> coinsmart
#> 2   NA            NA          <NA>       Other Referral    referrals coinsmart
#> 3   NA            NA          <NA>       Other     Quiz     airdrops coinsmart
#> 4   NA            NA          <NA>         Fee Withdraw         <NA> coinsmart
#>     rate.source
#> 1      exchange
#> 2      exchange
#> 3 coinmarketcap
#> 4 coinmarketcap
```
