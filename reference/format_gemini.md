# Format Gemini file

Format a .csv transaction history file from Gemini for later ACB
processing. Open the xlsx data file using `readxl::read_excel()`.

## Usage

``` r
format_gemini(data, list.prices = NULL, force = FALSE)
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
format_gemini(data_gemini)
#> Using deprecated legacy '.GlobalEnv' cache for 'list.prices'. This compatibility path may be removed in a future release; prefer `pricing_cache()` or pass `list.prices` explicitly. To force a fresh download, use argument 'force = TRUE'.
#> Using deprecated legacy '.GlobalEnv' cache for 'list.prices'. This compatibility path may be removed in a future release; prefer `pricing_cache()` or pass `list.prices` explicitly. To force a fresh download, use argument 'force = TRUE'.
#>                   date currency     quantity total.price    spot.rate
#> 1  2021-04-09 22:50:55      BTC 9.662784e-04  70.6481728 7.311369e+04
#> 2  2021-04-09 22:50:55      LTC 2.466906e-01  70.6481728 2.863837e+02
#> 3  2021-04-09 22:53:57      BTC 6.051912e-06   0.4424776 7.311369e+04
#> 4  2021-04-09 22:53:57      LTC 1.640820e-03   0.4424776 2.696686e+02
#> 5  2021-04-09 23:20:53      BAT 4.871952e+01  86.3813238 1.773033e+00
#> 6  2021-04-09 23:20:53      BTC 9.507300e-04  86.3813238 9.085789e+04
#> 7  2021-04-10 23:22:04      BTC 2.850256e-04  21.1030333 7.403909e+04
#> 8  2021-05-08 16:14:54      BAT 2.833935e+00   4.8662823 1.717147e+00
#> 9  2021-05-16 12:55:02      BAT 3.085288e+00   4.2575830 1.379963e+00
#> 10 2021-05-16 13:35:19      BAT 5.007481e+00   6.9101380 1.379963e+00
#> 11 2021-06-18 01:38:54      BAT 6.834323e+00   5.3946979 7.893537e-01
#>    transaction        fees fees.quantity fees.currency description
#> 1          buy 0.168410698  2.303409e-06           BTC      LTCBTC
#> 2         sell          NA            NA           LTC      LTCBTC
#> 3          buy 0.002669973  3.651810e-08           BTC      LTCBTC
#> 4         sell          NA            NA           LTC      LTCBTC
#> 5          buy          NA            NA           BAT      BATBTC
#> 6         sell 0.132645853  1.814241e-06           BTC      BATBTC
#> 7      revenue          NA            NA          <NA>      Credit
#> 8      revenue          NA            NA          <NA>      Credit
#> 9      revenue          NA            NA          <NA>      Credit
#> 10     revenue          NA            NA          <NA>      Credit
#> 11     revenue          NA            NA          <NA>      Credit
#>                  comment revenue.type exchange               rate.source
#> 1                 Market         <NA>   gemini             coinmarketcap
#> 2                 Market         <NA>   gemini coinmarketcap (buy price)
#> 3                  Limit         <NA>   gemini             coinmarketcap
#> 4                  Limit         <NA>   gemini coinmarketcap (buy price)
#> 5                  Limit         <NA>   gemini             coinmarketcap
#> 6                  Limit         <NA>   gemini coinmarketcap (buy price)
#> 7  Administrative Credit    referrals   gemini             coinmarketcap
#> 8  Administrative Credit    referrals   gemini             coinmarketcap
#> 9                Deposit     airdrops   gemini             coinmarketcap
#> 10               Deposit     airdrops   gemini             coinmarketcap
#> 11               Deposit     airdrops   gemini             coinmarketcap
```
