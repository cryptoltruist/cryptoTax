
<!-- README.md is generated from README.Rmd. Please edit that file -->

# cryptoTax: Crypto taxes in R (Canada only) <img src='man/figures/logo.png' align="right" height="140" style="float:right; height:200px;" />

*Disclaimer: This is not financial advice. Use at your own risks. There
are no guarantees whatsoever in relation to the use of this package.
Please consult a tax professional as necessary*.

Helps calculate crypto taxes in R.

1.  First, by allowing you to format .CSV files from various exchanges
    to one large dataframe of organized transactions.
2.  Second, by allowing you to calculate your Adjusted Cost Base (ACB),
    ACB per share, and realized and unrealized capital gains/losses.
3.  Third, by calculating revenues gained from staking, interest,
    airdrops, etc.
4.  Fourth, by calculating superficial losses as well, if desired.

This is a work in progress. If you notice bugs, please report them:
<https://github.com/cryptoltruist/cryptoTax/issues>.

# Installation

To install, use:

``` r
remotes::install_github("cryptoltruist/cryptoTax")
```

# ACB demo

``` r
library(cryptoTax)
data <- adjustedcostbase.ca1
data
```

| date       | transaction | quantity | price | fees |
|:-----------|:------------|---------:|------:|-----:|
| 2014-03-03 | buy         |      100 |    50 |   10 |
| 2014-05-01 | sell        |       50 |   120 |   10 |
| 2014-07-18 | buy         |       50 |   130 |   10 |
| 2014-09-25 | sell        |       40 |    90 |   10 |

``` r
ACB(data, spot.rate = "price", sup.loss = FALSE)
```

| date       | transaction | quantity | price | fees | total.price | total.quantity |  ACB | ACB.share | gains |
|:-----------|:------------|---------:|------:|-----:|------------:|---------------:|-----:|----------:|------:|
| 2014-03-03 | buy         |      100 |    50 |   10 |        5000 |            100 | 5010 |     50.10 |    NA |
| 2014-05-01 | sell        |       50 |   120 |   10 |        6000 |             50 | 2505 |     50.10 |  3485 |
| 2014-07-18 | buy         |       50 |   130 |   10 |        6500 |            100 | 9015 |     90.15 |    NA |
| 2014-09-25 | sell        |       40 |    90 |   10 |        3600 |             60 | 5409 |     90.15 |   -16 |

For more on calculating the ACB, as well as superficial losses, see the
[corresponding vignette](cryptoTaxarticles/ACB.html).

# Supported exchanges

Currently, the following exchanges are supported with the `format_*`
functions:

1.  Adalite
2.  Binance
3.  BlockFi
4.  Crypto.com (app, exchange, wallet)
5.  Celsius
6.  CoinSmart
7.  Exodus wallet
8.  Gemini
9.  Newton
10. Pooltool (ADA)
11. Presearch
12. Shakepay

To support another exchange not listed here, please open an issue. You
can also prepare your own file according to the style of one of those
exchanges and use the corresponding function.

# Workflow demo

``` r
# Prepare list of coins
my.coins <- c("BTC", "CRO", "ETH", "ETHW")
list.prices <- prepare_list_prices(coins = my.coins, start.date = "2021-01-01")
#> ❯ Scraping historical crypto data
#> ❯ Processing historical crypto data
# Note that for some exchanges this step may be unnecessary

# Load data and format shakepay file
data(data_shakepay)
formatted.shakepay <- format_shakepay(data_shakepay)

# Load data and format CDC file
data(data_CDC)
formatted.CDC <- format_CDC(data_CDC)

# Merge data from the different exchanges
all.data <- merge_exchanges(formatted.shakepay, formatted.CDC)

# Format data with ACB
formatted.ACB <- format_ACB(all.data)
#> Process started at 2023-01-06 17:04:34. Please be patient as the transactions process.
#> [Formatting ACB (progress bar repeats for each coin)...]
#> Process ended at 2023-01-06 17:04:36. Total time elapsed: 1.55 minutes

# Let's get a preview of the output
as.data.frame(formatted.ACB[c(1, 4, 8, 10, 19, 20), c(1:6, 7:14, 24:26)])
```

| date                | currency |  quantity | total.price |    spot.rate | transaction | fees | description                     | comment             | revenue.type |    value | exchange | rate.source | currency2 |    gains |       ACB |    ACB.share |
|:--------------------|:---------|----------:|------------:|-------------:|:------------|-----:|:--------------------------------|:--------------------|:-------------|---------:|:---------|:------------|:----------|---------:|----------:|-------------:|
| 2021-05-03 22:05:50 | BTC      | 0.0007334 |    51.25000 | 6.988278e+04 | buy         |    0 | crypto_purchase                 | Buy BTC             | NA           | 51.25000 | CDC      | exchange    | BTC       |       NA |  51.25000 | 6.988278e+04 |
| 2021-05-07 23:06:50 | ETH      | 0.0205920 |    54.21000 | 2.632575e+03 | buy         |    0 | crypto_purchase                 | Buy ETH             | NA           | 54.21000 | CDC      | exchange    | ETH       |       NA |  54.21000 | 2.632575e+03 |
| 2021-05-21 12:47:14 | BTC      | 0.0001300 |     0.00000 | 5.652762e+04 | revenue     |    0 | shakingsats                     | credit              | airdrops     |  7.34859 | shakepay | exchange    | BTC       |       NA | 104.28335 | 4.888608e+04 |
| 2021-05-29 23:10:59 | CRO      | 6.4039545 |     0.00000 | 1.764535e-01 | revenue     |    0 | referral_card_cashback          | Card Cashback       | rebates      |  1.13000 | CDC      | exchange    | CRO       |       NA |  53.42000 | 1.741274e-01 |
| 2021-07-06 22:18:40 | CRO      | 0.3207992 |     0.26000 | 8.104758e-01 | revenue     |    0 | crypto_earn_extra_interest_paid | Crypto Earn (Extra) | interests    |  0.26000 | CDC      | exchange    | CRO       |       NA |  53.68000 | 1.083560e-01 |
| 2021-07-10 00:52:19 | BTC      | 0.0005299 |    31.26848 | 5.900715e+04 | sell        |    0 | purchase/sale                   | sale                | NA           | 31.26848 | shakepay | exchange    | BTC       | 8.463513 |  81.47838 | 4.303555e+04 |

### Summary info

``` r
# Get latest ACB.share for each coin (ACB)
report_overview(formatted.ACB,
  today.data = TRUE, tax.year = "2021",
  local.timezone = "America/Toronto"
)
```

| date.last           | currency | total.quantity | cost.share | total.cost | gains | losses |  net | rate.today | value.today | unrealized.gains | unrealized.losses | unrealized.net | currency2 |
|:--------------------|:---------|---------------:|-----------:|-----------:|------:|-------:|-----:|-----------:|------------:|-----------------:|------------------:|---------------:|:----------|
| 2021-07-10 00:52:19 | BTC      |      0.0018933 |   43035.55 |      81.48 |  8.46 |      0 | 8.46 |   22789.00 |       43.15 |               NA |            -38.33 |         -38.33 | BTC       |
| 2021-07-23 17:21:19 | CRO      |    535.0406356 |       0.11 |      60.66 |  0.00 |      0 | 0.00 |       0.08 |       42.72 |               NA |            -17.94 |         -17.94 | CRO       |
| 2021-06-27 21:17:50 | ETH      |      0.0213553 |    2684.58 |      57.33 |  0.00 |      0 | 0.00 |    1695.24 |       36.20 |               NA |            -21.13 |         -21.13 | ETH       |
| 2021-07-23 17:21:19 | Total    |             NA |         NA |     199.47 |  8.46 |      0 | 8.46 |         NA |      122.07 |                0 |            -77.40 |         -77.40 | Total     |

``` r

# Get summary of realized capital gains and losses
report_summary(formatted.ACB,
  today.data = TRUE, tax.year = "2021",
  local.timezone = "America/Toronto"
)
```

| Type              | Amount  | currency |
|:------------------|:--------|:---------|
| tax.year          | 2021    | CAD      |
| gains             | 8.46    | CAD      |
| losses            | 0.00    | CAD      |
| net               | 8.46    | CAD      |
| total.cost        | 199.47  | CAD      |
| value.today       | 122.07  | CAD      |
| unrealized.gains  | 0.00    | CAD      |
| unrealized.losses | -77.40  | CAD      |
| unrealized.net    | -77.40  | CAD      |
| percentage.up     | -38.80% | CAD      |
| all.time.up       | -34.56% | CAD      |

### Revenue estimation

``` r
table.revenues <- report_revenues(formatted.ACB, tax.year = "2021")
#> Adding missing grouping variables: `exchange`
table.revenues
```

| exchange | date.last           | total.revenues | airdrops | referrals | staking | promos | interests | rebates | rewards | currency |
|:---------|:--------------------|---------------:|---------:|----------:|--------:|-------:|----------:|--------:|--------:|:---------|
| CDC      | 2021-07-23 17:21:19 |          92.90 |  0.00000 |  30.19035 |       0 |      0 |     10.36 |   51.15 |     1.2 | CAD      |
| shakepay | 2021-06-23 12:21:49 |          66.28 | 36.27886 |  30.00000 |       0 |      0 |      0.00 |    0.00 |     0.0 | CAD      |
| total    | 2021-07-23 17:21:19 |         159.18 | 36.27886 |  60.19035 |       0 |      0 |     10.36 |   51.15 |     1.2 | CAD      |

``` r

# Plot revenues by exchange
crypto_pie(table.revenues)
```

![](man/figures/README-revenues-1.png)<!-- -->

``` r

# Plot revenues by reward type
crypto_pie(table.revenues, by = "revenue.type")
```

![](man/figures/README-revenues-2.png)<!-- -->

*Disclaimer: This is not financial advice. Use at your own risks. There
are no guarantees whatsoever in relation to the use of this package.
Please consult a tax professional as necessary*.
