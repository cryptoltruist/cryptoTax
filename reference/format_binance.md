# Format Binance earn file

Format a .csv earn history file from Binance for later ACB processing.

## Usage

``` r
format_binance(data, list.prices = NULL, force = FALSE)
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

## Details

To get this file. Download your overall transaction report (this will
include your trades, rewards, & "Referral Kickback" rewards). To get
this file, connect to your Binance account on desktop, click "Wallet"
(top right), "Transaction History", then in the top-right, "Generate all
statements". For "Time", choose "Customized" and pick your time frame.

Warning: This does NOT process WITHDRAWALS (see the
[`format_binance_withdrawals()`](https://cryptoltruist.github.io/cryptoTax/reference/format_binance_withdrawals.md)
function for this purpose).

## Examples

``` r
# \donttest{
format_binance(data_binance)
#> Using cached 'list.prices'. To force a fresh download, use argument 'force = TRUE'.
#> Warning: Could not calculate spot rate. Use `force = TRUE`.
#>                   date currency   quantity total.price spot.rate transaction
#> 1  2021-05-29 17:07:20      LTC 2.53200000          NA        NA         buy
#> 2  2021-05-29 17:07:20      LTC 0.30000000          NA        NA         buy
#> 3  2021-05-29 17:07:20      LTC 2.41210000          NA        NA         buy
#> 4  2021-05-29 17:07:20      LTC 1.45120000          NA        NA         buy
#> 5  2021-05-29 17:07:20      LTC 0.27000000          NA        NA         buy
#> 6  2021-05-29 17:07:20      LTC 1.42100000          NA        NA         buy
#> 7  2021-05-29 17:07:20      LTC 0.00005000          NA        NA     revenue
#> 8  2021-05-29 17:07:20      LTC 0.00113100          NA        NA     revenue
#> 9  2021-05-29 17:07:20      LTC 0.00049230          NA        NA     revenue
#> 10 2021-05-29 17:07:20      LTC 0.00202500          NA        NA     revenue
#> 11 2021-05-29 17:07:20      LTC 0.00007000          NA        NA     revenue
#> 12 2021-05-29 17:07:20      LTC 0.00127520          NA        NA     revenue
#> 13 2021-05-29 17:07:20      ETH 0.00612410          NA        NA        sell
#> 14 2021-05-29 17:07:20      ETH 0.14123140          NA        NA        sell
#> 15 2021-05-29 17:07:20      ETH 0.00899120          NA        NA        sell
#> 16 2021-05-29 17:07:20      ETH 0.11240000          NA        NA        sell
#> 17 2021-05-29 17:07:20      ETH 0.19521000          NA        NA        sell
#> 18 2021-05-29 17:07:20      ETH 0.10512900          NA        NA        sell
#> 19 2021-05-29 18:12:55      ETH 0.42124000          NA        NA         buy
#> 20 2021-05-29 18:12:55      ETH 0.44124211          NA        NA         buy
#> 21 2021-05-29 18:12:55      ETH 0.00021470          NA        NA     revenue
#> 22 2021-05-29 18:12:55      ETH 0.00009251          NA        NA     revenue
#> 23 2021-05-29 18:12:55      LTC 1.23000000          NA        NA        sell
#> 24 2021-05-29 18:12:55      LTC 1.60000000          NA        NA        sell
#> 25 2021-11-05 04:32:23     BUSD 0.10512330          NA        NA     revenue
#> 26 2022-11-17 11:54:25     ETHW 0.00012050          NA        NA     revenue
#> 27 2022-11-27 08:05:35     BUSD 5.77124200          NA        NA         buy
#> 28 2022-11-27 08:05:35     USDC 5.77124200          NA        NA        sell
#>    fees fees.quantity fees.currency                   description comment
#> 1    NA   0.003123000           LTC                           Buy    Spot
#> 2    NA   0.000210000           LTC                           Buy    Spot
#> 3    NA   0.005421000           LTC                           Buy    Spot
#> 4    NA   0.005812000           LTC                           Buy    Spot
#> 5    NA   0.007421000           LTC                           Buy    Spot
#> 6    NA   0.000300000           LTC                           Buy    Spot
#> 7    NA            NA          <NA>             Referral Kickback    Spot
#> 8    NA            NA          <NA>             Referral Kickback    Spot
#> 9    NA            NA          <NA>             Referral Kickback    Spot
#> 10   NA            NA          <NA>             Referral Kickback    Spot
#> 11   NA            NA          <NA>             Referral Kickback    Spot
#> 12   NA            NA          <NA>             Referral Kickback    Spot
#> 13   NA            NA          <NA>                           Buy    Spot
#> 14   NA            NA          <NA>                           Buy    Spot
#> 15   NA            NA          <NA>                           Buy    Spot
#> 16   NA            NA          <NA>                           Buy    Spot
#> 17   NA            NA          <NA>                           Buy    Spot
#> 18   NA            NA          <NA>                           Buy    Spot
#> 19   NA   0.000612400           ETH                          Sell    Spot
#> 20   NA   0.002123124           ETH                          Sell    Spot
#> 21   NA            NA          <NA>             Referral Kickback    Spot
#> 22   NA            NA          <NA>             Referral Kickback    Spot
#> 23   NA            NA          <NA>                          Sell    Spot
#> 24   NA            NA          <NA>                          Sell    Spot
#> 25   NA            NA          <NA> Simple Earn Flexible Interest    Earn
#> 26   NA            NA          <NA>                  Distribution    Spot
#> 27   NA            NA          <NA>   Stablecoins Auto-Conversion    Spot
#> 28   NA            NA          <NA>   Stablecoins Auto-Conversion    Spot
#>    revenue.type exchange               rate.source
#> 1          <NA>  binance             coinmarketcap
#> 2          <NA>  binance             coinmarketcap
#> 3          <NA>  binance             coinmarketcap
#> 4          <NA>  binance             coinmarketcap
#> 5          <NA>  binance             coinmarketcap
#> 6          <NA>  binance             coinmarketcap
#> 7       rebates  binance             coinmarketcap
#> 8       rebates  binance             coinmarketcap
#> 9       rebates  binance             coinmarketcap
#> 10      rebates  binance             coinmarketcap
#> 11      rebates  binance             coinmarketcap
#> 12      rebates  binance             coinmarketcap
#> 13         <NA>  binance coinmarketcap (buy price)
#> 14         <NA>  binance coinmarketcap (buy price)
#> 15         <NA>  binance coinmarketcap (buy price)
#> 16         <NA>  binance coinmarketcap (buy price)
#> 17         <NA>  binance coinmarketcap (buy price)
#> 18         <NA>  binance coinmarketcap (buy price)
#> 19         <NA>  binance             coinmarketcap
#> 20         <NA>  binance             coinmarketcap
#> 21      rebates  binance             coinmarketcap
#> 22      rebates  binance             coinmarketcap
#> 23         <NA>  binance coinmarketcap (buy price)
#> 24         <NA>  binance coinmarketcap (buy price)
#> 25    interests  binance             coinmarketcap
#> 26        forks  binance             coinmarketcap
#> 27         <NA>  binance             coinmarketcap
#> 28         <NA>  binance             coinmarketcap
# }
```
