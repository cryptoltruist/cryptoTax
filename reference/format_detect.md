# Detect transaction file exchange and format it

Detect the exchange of a given transaction file and format it with the
proper function for later ACB processing.

## Usage

``` r
format_detect(data, ...)

# S3 method for class 'data.frame'
format_detect(data, list.prices = NULL, force = FALSE, ...)

# S3 method for class 'list'
format_detect(data, list.prices = NULL, force = FALSE, ...)
```

## Arguments

- data:

  The dataframe

- ...:

  Used for other methods.

- list.prices:

  A `list.prices` object from which to fetch coin prices.

- force:

  Whether to force recreating `list.prices` even though it already
  exists (e.g., if you added new coins or new dates).

## Value

A data frame of exchange transactions, formatted for further processing.

## Examples

``` r
format_detect(data_shakepay)
#> Exchange detected: shakepay
#>                  date currency   quantity total.price spot.rate transaction
#> 1 2021-05-07 14:50:41      BTC 0.00103982  53.0697400  51037.43         buy
#> 2 2021-05-08 12:12:57      BTC 0.00001100   0.5784024  52582.03     revenue
#> 3 2021-05-09 12:22:07      BTC 0.00001200   0.6034441  50287.01     revenue
#> 4 2021-05-21 12:47:14      BTC 0.00001300   0.7348590  56527.62     revenue
#> 5 2021-06-11 12:03:31      BTC 0.00001400   0.8396927  59978.05     revenue
#> 6 2021-06-23 12:21:49      BTC 0.00001500   0.8852574  59017.16     revenue
#> 7 2021-07-10 00:52:19      BTC 0.00052991  31.2684700  59017.19        sell
#>   description               comment revenue.type exchange rate.source
#> 1         Buy Bought @ CA$51,002.43         <NA> shakepay    exchange
#> 2      Reward           ShakingSats     airdrops shakepay    exchange
#> 3      Reward           ShakingSats     airdrops shakepay    exchange
#> 4      Reward           ShakingSats     airdrops shakepay    exchange
#> 5      Reward           ShakingSats     airdrops shakepay    exchange
#> 6      Reward           ShakingSats     airdrops shakepay    exchange
#> 7        Sell Bought @ CA$59,007.14         <NA> shakepay    exchange
format_detect(data_newton)
#> Exchange detected: newton
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
format_detect(list(data_shakepay, data_newton))
#> Exchange detected: shakepay
#> Exchange detected: newton
#>                   date currency    quantity  total.price  spot.rate transaction
#> 1  2021-04-04 22:50:12      LTC  0.10482910   23.4912731   224.0911         buy
#> 2  2021-04-04 22:53:46      CAD 25.00000000   25.0000000     1.0000     revenue
#> 3  2021-04-04 22:55:55      ETH  2.71987120 3423.8221510  1258.8178         buy
#> 4  2021-04-21 19:57:26      BTC  0.00343000  153.1241354 44642.6051         buy
#> 5  2021-05-07 14:50:41      BTC  0.00103982   53.0697400 51037.4327         buy
#> 6  2021-05-08 12:12:57      BTC  0.00001100    0.5784024 52582.0324     revenue
#> 7  2021-05-09 12:22:07      BTC  0.00001200    0.6034441 50287.0079     revenue
#> 8  2021-05-12 21:37:42      BTC  0.00000400    0.3049013 76225.3175         buy
#> 9  2021-05-12 21:52:40      BTC  0.00321300  156.1241341 48591.3894        sell
#> 10 2021-05-21 12:47:14      BTC  0.00001300    0.7348590 56527.6188     revenue
#> 11 2021-06-11 12:03:31      BTC  0.00001400    0.8396927 59978.0477     revenue
#> 12 2021-06-16 18:49:11      CAD 25.00000000   25.0000000     1.0000     revenue
#> 13 2021-06-23 12:21:49      BTC  0.00001500    0.8852574 59017.1621     revenue
#> 14 2021-07-10 00:52:19      BTC  0.00052991   31.2684700 59017.1922        sell
#>         description               comment revenue.type exchange rate.source
#> 1             TRADE                  <NA>         <NA>   newton    exchange
#> 2  Referral Program                  <NA>    referrals   newton    exchange
#> 3             TRADE                  <NA>         <NA>   newton    exchange
#> 4             TRADE                  <NA>         <NA>   newton    exchange
#> 5               Buy Bought @ CA$51,002.43         <NA> shakepay    exchange
#> 6            Reward           ShakingSats     airdrops shakepay    exchange
#> 7            Reward           ShakingSats     airdrops shakepay    exchange
#> 8             TRADE                  <NA>         <NA>   newton    exchange
#> 9             TRADE                  <NA>         <NA>   newton    exchange
#> 10           Reward           ShakingSats     airdrops shakepay    exchange
#> 11           Reward           ShakingSats     airdrops shakepay    exchange
#> 12 Referral Program                  <NA>    referrals   newton    exchange
#> 13           Reward           ShakingSats     airdrops shakepay    exchange
#> 14             Sell Bought @ CA$59,007.14         <NA> shakepay    exchange
format_detect(list(data_shakepay[0, ], list(data_shakepay, data_newton)))
#> Exchange detected: shakepay
#> Exchange detected: newton
#>                   date currency    quantity  total.price  spot.rate transaction
#> 1  2021-04-04 22:50:12      LTC  0.10482910   23.4912731   224.0911         buy
#> 2  2021-04-04 22:53:46      CAD 25.00000000   25.0000000     1.0000     revenue
#> 3  2021-04-04 22:55:55      ETH  2.71987120 3423.8221510  1258.8178         buy
#> 4  2021-04-21 19:57:26      BTC  0.00343000  153.1241354 44642.6051         buy
#> 5  2021-05-07 14:50:41      BTC  0.00103982   53.0697400 51037.4327         buy
#> 6  2021-05-08 12:12:57      BTC  0.00001100    0.5784024 52582.0324     revenue
#> 7  2021-05-09 12:22:07      BTC  0.00001200    0.6034441 50287.0079     revenue
#> 8  2021-05-12 21:37:42      BTC  0.00000400    0.3049013 76225.3175         buy
#> 9  2021-05-12 21:52:40      BTC  0.00321300  156.1241341 48591.3894        sell
#> 10 2021-05-21 12:47:14      BTC  0.00001300    0.7348590 56527.6188     revenue
#> 11 2021-06-11 12:03:31      BTC  0.00001400    0.8396927 59978.0477     revenue
#> 12 2021-06-16 18:49:11      CAD 25.00000000   25.0000000     1.0000     revenue
#> 13 2021-06-23 12:21:49      BTC  0.00001500    0.8852574 59017.1621     revenue
#> 14 2021-07-10 00:52:19      BTC  0.00052991   31.2684700 59017.1922        sell
#>         description               comment revenue.type exchange rate.source
#> 1             TRADE                  <NA>         <NA>   newton    exchange
#> 2  Referral Program                  <NA>    referrals   newton    exchange
#> 3             TRADE                  <NA>         <NA>   newton    exchange
#> 4             TRADE                  <NA>         <NA>   newton    exchange
#> 5               Buy Bought @ CA$51,002.43         <NA> shakepay    exchange
#> 6            Reward           ShakingSats     airdrops shakepay    exchange
#> 7            Reward           ShakingSats     airdrops shakepay    exchange
#> 8             TRADE                  <NA>         <NA>   newton    exchange
#> 9             TRADE                  <NA>         <NA>   newton    exchange
#> 10           Reward           ShakingSats     airdrops shakepay    exchange
#> 11           Reward           ShakingSats     airdrops shakepay    exchange
#> 12 Referral Program                  <NA>    referrals   newton    exchange
#> 13           Reward           ShakingSats     airdrops shakepay    exchange
#> 14             Sell Bought @ CA$59,007.14         <NA> shakepay    exchange
```
