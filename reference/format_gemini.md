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
#> Using cached 'list.prices'. To force a fresh download, use argument 'force = TRUE'.
#> Warning: Could not calculate spot rate. Use `force = TRUE`.
#> Using cached 'list.prices'. To force a fresh download, use argument 'force = TRUE'.
#>                   date currency     quantity total.price  spot.rate transaction
#> 1  2021-04-09 22:50:55      BTC 9.662784e-04  70.6481728 73113.6866         buy
#> 2  2021-04-09 22:50:55      LTC 2.466906e-01  70.6481728   286.3837        sell
#> 3  2021-04-09 22:53:57      BTC 6.051912e-06   0.4424776 73113.6866         buy
#> 4  2021-04-09 22:53:57      LTC 1.640820e-03   0.4424776   269.6686        sell
#> 5  2021-04-09 23:20:53      BAT 4.871952e+01          NA         NA         buy
#> 6  2021-04-09 23:20:53      BTC 9.507300e-04          NA         NA        sell
#> 7  2021-04-10 23:22:04      BTC 2.850256e-04  21.1030333 74039.0861     revenue
#> 8  2021-05-08 16:14:54      BAT 2.833935e+00          NA         NA     revenue
#> 9  2021-05-16 12:55:02      BAT 3.085288e+00          NA         NA     revenue
#> 10 2021-05-16 13:35:19      BAT 5.007481e+00          NA         NA     revenue
#> 11 2021-06-18 01:38:54      BAT 6.834323e+00          NA         NA     revenue
#>           fees fees.quantity fees.currency description               comment
#> 1  0.168410698  2.303409e-06           BTC      LTCBTC                Market
#> 2           NA            NA           LTC      LTCBTC                Market
#> 3  0.002669973  3.651810e-08           BTC      LTCBTC                 Limit
#> 4           NA            NA           LTC      LTCBTC                 Limit
#> 5           NA            NA           BAT      BATBTC                 Limit
#> 6  0.132645853  1.814241e-06           BTC      BATBTC                 Limit
#> 7           NA            NA          <NA>      Credit Administrative Credit
#> 8           NA            NA          <NA>      Credit Administrative Credit
#> 9           NA            NA          <NA>      Credit               Deposit
#> 10          NA            NA          <NA>      Credit               Deposit
#> 11          NA            NA          <NA>      Credit               Deposit
#>    revenue.type exchange               rate.source
#> 1          <NA>   gemini             coinmarketcap
#> 2          <NA>   gemini coinmarketcap (buy price)
#> 3          <NA>   gemini             coinmarketcap
#> 4          <NA>   gemini coinmarketcap (buy price)
#> 5          <NA>   gemini             coinmarketcap
#> 6          <NA>   gemini coinmarketcap (buy price)
#> 7     referrals   gemini             coinmarketcap
#> 8     referrals   gemini             coinmarketcap
#> 9      airdrops   gemini             coinmarketcap
#> 10     airdrops   gemini             coinmarketcap
#> 11     airdrops   gemini             coinmarketcap
```
