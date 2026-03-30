# Format Newton file

Format a .csv transaction history file from Newton for later ACB
processing. When downloading from Newton, please choose the yearly
reports format (the "CoinTracker Version" and "Koinly Version" are not
supported at this time). If you have multiple years, that means you
might have to merge the two datasets.

## Usage

``` r
format_newton(data, filetype = "yearly")
```

## Arguments

- data:

  The dataframe

- filetype:

  Which Newton file format to use, one of c("yearly", "cointracker", or
  "koinly"). Only "yearly" (default) supported at this time.

## Value

A data frame of exchange transactions, formatted for further processing.

## Examples

``` r
format_newton(data_newton)
#>                  date currency   quantity  total.price  spot.rate transaction
#> 1 2021-04-04 22:50:12      LTC  0.1048291   23.4912731   224.0911         buy
#> 2 2021-04-04 22:53:46      CAD 25.0000000   25.0000000     1.0000     revenue
#> 3 2021-04-04 22:55:55      ETH  2.7198712 3423.8221510  1258.8178         buy
#> 4 2021-04-21 19:57:26      BTC  0.0034300  153.1241354 44642.6051         buy
#> 5 2021-05-12 21:37:42      BTC  0.0000040    0.3049013 76225.3175         buy
#> 6 2021-05-12 21:52:40      BTC  0.0032130  156.1241341 48591.3894        sell
#> 7 2021-06-16 18:49:11      CAD 25.0000000   25.0000000     1.0000     revenue
#>        description revenue.type exchange rate.source
#> 1            TRADE         <NA>   newton    exchange
#> 2 Referral Program    referrals   newton    exchange
#> 3            TRADE         <NA>   newton    exchange
#> 4            TRADE         <NA>   newton    exchange
#> 5            TRADE         <NA>   newton    exchange
#> 6            TRADE         <NA>   newton    exchange
#> 7 Referral Program    referrals   newton    exchange
```
