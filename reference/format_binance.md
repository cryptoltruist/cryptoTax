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

  A `list.prices` object from which to fetch coin prices.

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
#> Object 'list.prices' already exists. Reusing 'list.prices'. To force a fresh download, use argument 'force = TRUE'.
#>                   date currency   quantity  total.price   spot.rate transaction
#> 1  2021-05-29 17:07:20      LTC 2.53200000 5.220450e+02  206.178896         buy
#> 2  2021-05-29 17:07:20      ETH 0.19521000 5.220450e+02 2674.273677        sell
#> 3  2021-05-29 17:07:20      LTC 2.41210000 4.973241e+02  206.178896         buy
#> 4  2021-05-29 17:07:20      ETH 0.14123140 4.973241e+02 3521.342385        sell
#> 5  2021-05-29 17:07:20      LTC 1.45120000 2.992068e+02  206.178896         buy
#> 6  2021-05-29 17:07:20      ETH 0.11240000 2.992068e+02 2661.982329        sell
#> 7  2021-05-29 17:07:20      LTC 1.42100000 2.929802e+02  206.178896         buy
#> 8  2021-05-29 17:07:20      ETH 0.10512900 2.929802e+02 2786.863864        sell
#> 9  2021-05-29 17:07:20      LTC 0.30000000 6.185367e+01  206.178896         buy
#> 10 2021-05-29 17:07:20      ETH 0.00899120 6.185367e+01 6879.356346        sell
#> 11 2021-05-29 17:07:20      LTC 0.27000000 5.566830e+01  206.178896         buy
#> 12 2021-05-29 17:07:20      ETH 0.00612410 5.566830e+01 9090.038030        sell
#> 13 2021-05-29 17:07:20      LTC 0.00202500 4.175123e-01  206.178896     revenue
#> 14 2021-05-29 17:07:20      LTC 0.00127520 2.629193e-01  206.178896     revenue
#> 15 2021-05-29 17:07:20      LTC 0.00113100 2.331883e-01  206.178896     revenue
#> 16 2021-05-29 17:07:20      LTC 0.00049230 1.015019e-01  206.178896     revenue
#> 17 2021-05-29 17:07:20      LTC 0.00007000 1.443252e-02  206.178896     revenue
#> 18 2021-05-29 17:07:20      LTC 0.00005000 1.030894e-02  206.178896     revenue
#> 19 2021-05-29 18:12:55      ETH 0.44124211 1.251509e+03 2836.331215         buy
#> 20 2021-05-29 18:12:55      LTC 1.60000000 1.251509e+03  782.192981        sell
#> 21 2021-05-29 18:12:55      ETH 0.42124000 1.194776e+03 2836.331215         buy
#> 22 2021-05-29 18:12:55      LTC 1.23000000 1.194776e+03  971.362733        sell
#> 23 2021-05-29 18:12:55      ETH 0.00021470 6.089603e-01 2836.331215     revenue
#> 24 2021-05-29 18:12:55      ETH 0.00009251 2.623890e-01 2836.331215     revenue
#> 25 2021-11-05 04:32:23     BUSD 0.10512330 1.309410e-01    1.245594     revenue
#> 26 2022-11-17 11:54:25     ETHW 0.00012050 6.093518e-04    5.056861     revenue
#> 27 2022-11-27 08:05:35     USDC 5.77124200 7.721372e+00    1.337905        sell
#> 28 2022-11-27 08:05:35     BUSD 5.77124200 7.721205e+00    1.337876         buy
#>          fees fees.quantity fees.currency                   description comment
#> 1  1.53005359   0.007421000           LTC                           Buy    Spot
#> 2          NA            NA          <NA>                           Buy    Spot
#> 3  1.19831174   0.005812000           LTC                           Buy    Spot
#> 4          NA            NA          <NA>                           Buy    Spot
#> 5  1.11769579   0.005421000           LTC                           Buy    Spot
#> 6          NA            NA          <NA>                           Buy    Spot
#> 7  0.64389669   0.003123000           LTC                           Buy    Spot
#> 8          NA            NA          <NA>                           Buy    Spot
#> 9  0.06185367   0.000300000           LTC                           Buy    Spot
#> 10         NA            NA          <NA>                           Buy    Spot
#> 11 0.04329757   0.000210000           LTC                           Buy    Spot
#> 12         NA            NA          <NA>                           Buy    Spot
#> 13         NA            NA          <NA>             Referral Kickback    Spot
#> 14         NA            NA          <NA>             Referral Kickback    Spot
#> 15         NA            NA          <NA>             Referral Kickback    Spot
#> 16         NA            NA          <NA>             Referral Kickback    Spot
#> 17         NA            NA          <NA>             Referral Kickback    Spot
#> 18         NA            NA          <NA>             Referral Kickback    Spot
#> 19 6.02188288   0.002123124           ETH                          Sell    Spot
#> 20         NA            NA          <NA>                          Sell    Spot
#> 21 1.73696924   0.000612400           ETH                          Sell    Spot
#> 22         NA            NA          <NA>                          Sell    Spot
#> 23         NA            NA          <NA>             Referral Kickback    Spot
#> 24         NA            NA          <NA>             Referral Kickback    Spot
#> 25         NA            NA          <NA> Simple Earn Flexible Interest    Earn
#> 26         NA            NA          <NA>                  Distribution    Spot
#> 27         NA            NA          <NA>   Stablecoins Auto-Conversion    Spot
#> 28         NA            NA          <NA>   Stablecoins Auto-Conversion    Spot
#>    revenue.type exchange               rate.source
#> 1          <NA>  binance             coinmarketcap
#> 2          <NA>  binance coinmarketcap (buy price)
#> 3          <NA>  binance             coinmarketcap
#> 4          <NA>  binance coinmarketcap (buy price)
#> 5          <NA>  binance             coinmarketcap
#> 6          <NA>  binance coinmarketcap (buy price)
#> 7          <NA>  binance             coinmarketcap
#> 8          <NA>  binance coinmarketcap (buy price)
#> 9          <NA>  binance             coinmarketcap
#> 10         <NA>  binance coinmarketcap (buy price)
#> 11         <NA>  binance             coinmarketcap
#> 12         <NA>  binance coinmarketcap (buy price)
#> 13      rebates  binance             coinmarketcap
#> 14      rebates  binance             coinmarketcap
#> 15      rebates  binance             coinmarketcap
#> 16      rebates  binance             coinmarketcap
#> 17      rebates  binance             coinmarketcap
#> 18      rebates  binance             coinmarketcap
#> 19         <NA>  binance             coinmarketcap
#> 20         <NA>  binance coinmarketcap (buy price)
#> 21         <NA>  binance             coinmarketcap
#> 22         <NA>  binance coinmarketcap (buy price)
#> 23      rebates  binance             coinmarketcap
#> 24      rebates  binance             coinmarketcap
#> 25    interests  binance             coinmarketcap
#> 26        forks  binance             coinmarketcap
#> 27         <NA>  binance             coinmarketcap
#> 28         <NA>  binance             coinmarketcap
# }
```
