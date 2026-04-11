# Format Uphold file

Format a .csv transaction history file from Uphold for later ACB
processing.

## Usage

``` r
format_uphold(data, list.prices = NULL, force = FALSE)
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
format_uphold(data_uphold)
#> Object 'list.prices' already exists. Reusing 'list.prices'. To force a fresh download, use argument 'force = TRUE'.
#>                   date currency    quantity total.price   spot.rate transaction
#> 1  2021-01-07 02:40:31      BAT  1.59081275   0.5126760   0.3222730     revenue
#> 2  2021-02-09 14:26:49      BAT 12.69812163   6.8809223   0.5418851     revenue
#> 3  2021-03-06 21:32:36      BAT  0.37591275   0.3207390   0.8532272     revenue
#> 4  2021-03-07 21:46:57      LTC  0.24129740  57.1230888 236.7331300         buy
#> 5  2021-03-07 21:46:57      BAT 52.59871206  57.1230888   1.0860169        sell
#> 6  2021-03-07 21:54:09      LTC  0.00300000   0.7101994 236.7331300        sell
#> 7  2021-04-05 12:22:00      BAT  8.52198415  13.1950331   1.5483522     revenue
#> 8  2021-04-06 03:41:42      LTC  0.00300000   0.8652138 288.4045856        sell
#> 9  2021-04-06 04:47:00      LTC  0.03605981  10.3998152 288.4045856         buy
#> 10 2021-04-06 04:47:00      BAT  8.52198415  10.3998152   1.2203514        sell
#> 11 2021-05-11 07:12:24      BAT  0.47521985   0.7777259   1.6365602     revenue
#> 12 2021-06-09 04:52:23      BAT  0.67207415   0.5577482   0.8298909     revenue
#>    description         comment revenue.type exchange               rate.source
#> 1           in            <NA>     airdrops   uphold             coinmarketcap
#> 2           in            <NA>     airdrops   uphold             coinmarketcap
#> 3           in            <NA>     airdrops   uphold             coinmarketcap
#> 4        trade         BAT-LTC         <NA>   uphold             coinmarketcap
#> 5        trade         BAT-LTC         <NA>   uphold coinmarketcap (buy price)
#> 6          out withdrawal fees         <NA>   uphold             coinmarketcap
#> 7           in            <NA>     airdrops   uphold             coinmarketcap
#> 8          out withdrawal fees         <NA>   uphold             coinmarketcap
#> 9        trade         BAT-LTC         <NA>   uphold             coinmarketcap
#> 10       trade         BAT-LTC         <NA>   uphold coinmarketcap (buy price)
#> 11          in            <NA>     airdrops   uphold             coinmarketcap
#> 12          in            <NA>     airdrops   uphold             coinmarketcap
```
