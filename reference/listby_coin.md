# List transactions by coin

Provides a list of transactions, separated by coin.

## Usage

``` r
listby_coin(formatted.ACB)
```

## Arguments

- formatted.ACB:

  The dataframe

## Value

A list of formatted data frames, by coin.

## Examples

``` r
all.data <- format_exchanges(data_shakepay)
#> Exchange detected: shakepay
formatted.ACB <- format_ACB(all.data, verbose = FALSE)
listby_coin(formatted.ACB)
#> $BTC
#>                  date currency   quantity total.price spot.rate transaction
#> 1 2021-05-07 14:50:41      BTC 0.00103982    53.06974  51037.43         buy
#> 2 2021-05-08 12:12:57      BTC 0.00001100     0.00000  52582.03     revenue
#> 3 2021-05-09 12:22:07      BTC 0.00001200     0.00000  50287.01     revenue
#> 4 2021-05-21 12:47:14      BTC 0.00001300     0.00000  56527.62     revenue
#> 5 2021-06-11 12:03:31      BTC 0.00001400     0.00000  59978.05     revenue
#> 6 2021-06-23 12:21:49      BTC 0.00001500     0.00000  59017.16     revenue
#> 7 2021-07-10 00:52:19      BTC 0.00052991    31.26847  59017.19        sell
#>   fees description               comment revenue.type      value exchange
#> 1    0         Buy Bought @ CA$51,002.43         <NA> 53.0697400 shakepay
#> 2    0      Reward           ShakingSats     airdrops  0.5784024 shakepay
#> 3    0      Reward           ShakingSats     airdrops  0.6034441 shakepay
#> 4    0      Reward           ShakingSats     airdrops  0.7348590 shakepay
#> 5    0      Reward           ShakingSats     airdrops  0.8396927 shakepay
#> 6    0      Reward           ShakingSats     airdrops  0.8852574 shakepay
#> 7    0        Sell Bought @ CA$59,007.14         <NA> 31.2684700 shakepay
#>   rate.source currency2 total.quantity
#> 1    exchange       BTC     0.00103982
#> 2    exchange       BTC     0.00105082
#> 3    exchange       BTC     0.00106282
#> 4    exchange       BTC     0.00107582
#> 5    exchange       BTC     0.00108982
#> 6    exchange       BTC     0.00110482
#> 7    exchange       BTC     0.00057491
#>                                      suploss.range quantity.60days share.left60
#> 1 2021-04-07 14:50:41 UTC--2021-06-06 14:50:41 UTC      0.00103982   0.00107582
#> 2 2021-04-08 12:12:57 UTC--2021-06-07 12:12:57 UTC      0.00103982   0.00107582
#> 3 2021-04-09 12:22:07 UTC--2021-06-08 12:22:07 UTC      0.00103982   0.00107582
#> 4 2021-04-21 12:47:14 UTC--2021-06-20 12:47:14 UTC      0.00103982   0.00108982
#> 5 2021-05-12 12:03:31 UTC--2021-07-11 12:03:31 UTC      0.00000000   0.00057491
#> 6 2021-05-24 12:21:49 UTC--2021-07-23 12:21:49 UTC      0.00000000   0.00057491
#> 7 2021-06-10 00:52:19 UTC--2021-08-09 00:52:19 UTC      0.00000000   0.00057491
#>   sup.loss.quantity sup.loss gains.uncorrected gains.sup gains.excess    gains
#> 1                 0    FALSE          0.000000        NA           NA       NA
#> 2                 0    FALSE          0.000000        NA           NA       NA
#> 3                 0    FALSE          0.000000        NA           NA       NA
#> 4                 0    FALSE          0.000000        NA           NA       NA
#> 5                 0    FALSE          0.000000        NA           NA       NA
#> 6                 0    FALSE          0.000000        NA           NA       NA
#> 7                 0    FALSE          5.814382        NA           NA 5.814382
#>        ACB ACB.share
#> 1 53.06974  51037.43
#> 2 53.06974  50503.17
#> 3 53.06974  49932.95
#> 4 53.06974  49329.57
#> 5 53.06974  48695.88
#> 6 53.06974  48034.74
#> 7 27.61565  48034.74
#> 
```
