
- <a href="#cryptotax-crypto-taxes-in-r-canada-only-"
  id="toc-cryptotax-crypto-taxes-in-r-canada-only-">cryptoTax: Crypto
  taxes in R (Canada only)
  <img src='man/figures/logo.png' align="right" height="140" style="float:right; height:200px;" /></a>
- <a href="#installation" id="toc-installation">Installation</a>
- <a href="#acb-demo" id="toc-acb-demo">ACB demo</a>
- <a href="#supported-exchanges" id="toc-supported-exchanges">Supported
  exchanges</a>
- <a href="#workflow-demo" id="toc-workflow-demo">Workflow demo</a>
  - <a href="#summary-info" id="toc-summary-info">Summary info</a>
  - <a href="#revenue-estimation" id="toc-revenue-estimation">Revenue
    estimation</a>

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

Only supports basic or simple tax scenarios (for now).

# Installation

To install, use:

``` r
remotes::install_github("cryptoltruist/cryptoTax")
```

# ACB demo

``` r
library(cryptoTax)
data <- adjustedcostbase.ca_1
data
```

<div class="kable-table">

| date       | transaction | quantity | price | fees |
|:-----------|:------------|---------:|------:|-----:|
| 2014-03-03 | buy         |      100 |    50 |   10 |
| 2014-05-01 | sell        |       50 |   120 |   10 |
| 2014-07-18 | buy         |       50 |   130 |   10 |
| 2014-09-25 | sell        |       40 |    90 |   10 |

</div>

``` r
ACB(data, spot.rate = "price", sup.loss = FALSE)
```

<div class="kable-table">

| date       | transaction | quantity | price | fees | total.price | total.quantity |  ACB | ACB.share | gains |
|:-----------|:------------|---------:|------:|-----:|------------:|---------------:|-----:|----------:|------:|
| 2014-03-03 | buy         |      100 |    50 |   10 |        5000 |            100 | 5010 |     50.10 |    NA |
| 2014-05-01 | sell        |       50 |   120 |   10 |        6000 |             50 | 2505 |     50.10 |  3485 |
| 2014-07-18 | buy         |       50 |   130 |   10 |        6500 |            100 | 9015 |     90.15 |    NA |
| 2014-09-25 | sell        |       40 |    90 |   10 |        3600 |             60 | 5409 |     90.15 |   -16 |

</div>

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
data(shakepay)
formatted.shakepay <- format_shakepay(shakepay)

# Load data and format CDC file
data(CDC)
formatted.CDC <- format_CDC(CDC)

# Merge data from the different exchanges
all.data <- merge_exchanges(formatted.shakepay, formatted.CDC)

# Format data with ACB
formatted.ACB <- format_ACB(all.data)
#> Process started at 2023-01-05 17:56:42. Please be patient as the transactions process.
#> [Formatting ACB (progress bar repeats for each coin)...]
#> Process ended at 2023-01-05 17:56:43. Total time elapsed: 1.04 minutes

# Let's get a preview of the output
as.data.frame(formatted.ACB[c(1, 4, 8, 10, 19, 20), c(1:6, 7:14, 24:26)])
```

<div class="kable-table">

| date                | currency |    quantity | total.price |     spot.rate | transaction | fees | description                       | comment                 | revenue.type |     value | exchange | rate.source | currency2 |    gains |       ACB |     ACB.share |
|:--------------------|:---------|------------:|------------:|--------------:|:------------|-----:|:----------------------------------|:------------------------|:-------------|----------:|:---------|:------------|:----------|---------:|----------:|--------------:|
| 2021-05-03 22:05:50 | BTC      |   0.0007334 |    51.25000 | 69882.7777778 | buy         |    0 | crypto_purchase                   | Buy BTC                 | NA           | 51.250000 | CDC      | exchange    | BTC       |       NA |  51.25000 | 69882.7777778 |
| 2021-05-08 12:12:57 | BTC      |   0.0001800 |     0.00000 | 52582.0324000 | revenue     |    0 | shakingsats                       | credit                  | airdrop      |  9.464766 | shakepay | exchange    | BTC       |       NA | 104.28335 | 53391.2720277 |
| 2021-05-23 22:09:39 | CRO      | 117.9468230 |     0.00000 |     0.2559658 | revenue     |    0 | referral_gift                     | Sign-up Bonus Unlocked  | referrals    | 30.190350 | CDC      | exchange    | CRO       |       NA |  53.42000 |     0.1778397 |
| 2021-06-02 19:11:52 | CRO      |  53.6136688 |     0.00000 |     0.2049850 | revenue     |    0 | reimbursement                     | Card Rebate: Spotify    | rebate       | 10.990000 | CDC      | exchange    | CRO       |       NA |  53.42000 |     0.1482240 |
| 2021-07-10 00:52:19 | BTC      |   0.0005299 |    31.26848 | 59007.1521579 | sell        |    0 | purchase/sale                     | sale                    | NA           | 31.268480 | shakepay | exchange    | BTC       | 9.280183 |  82.29505 | 41494.3995728 |
| 2021-07-14 18:20:27 | CRO      |   0.2476190 |     0.00000 |     0.4846154 | revenue     |    0 | rewards_platform_deposit_credited | Mission Rewards Deposit | rewards      |  0.120000 | CDC      | exchange    | CRO       |       NA |  53.68000 |     0.1083018 |

</div>

### Summary info

``` r
# Get latest ACB.share for each coin (ACB)
report_overview(formatted.ACB,
  today.data = TRUE, tax.year = "2021",
  local.timezone = "America/Toronto"
)
```

<div class="kable-table">

| date.last           | currency | total.quantity | cost.share | total.cost | gains | losses |  net | rate.today | value.today | unrealized.gains | unrealized.losses | unrealized.net | currency2 |
|:--------------------|:---------|---------------:|-----------:|-----------:|------:|-------:|-----:|-----------:|------------:|-----------------:|------------------:|---------------:|:----------|
| 2021-07-10 00:52:19 | BTC      |      0.0019833 |   41494.40 |      82.30 |  9.28 |      0 | 9.28 |   22774.35 |       45.17 |               NA |            -37.13 |         -37.13 | BTC       |
| 2021-07-23 17:21:19 | CRO      |    532.8120642 |       0.11 |      60.66 |  0.00 |      0 | 0.00 |       0.08 |       42.10 |               NA |            -18.56 |         -18.56 | CRO       |
| 2021-06-27 21:17:50 | ETH      |      0.0213553 |    2684.58 |      57.33 |  0.00 |      0 | 0.00 |    1677.72 |       35.83 |               NA |            -21.50 |         -21.50 | ETH       |
| 2021-07-23 17:21:19 | Total    |             NA |         NA |     200.29 |  9.28 |      0 | 9.28 |         NA |      123.10 |                0 |            -77.19 |         -77.19 | Total     |

</div>

``` r

# Get summary of realized capital gains and losses
report_summary(formatted.ACB,
  today.data = TRUE, tax.year = "2021",
  local.timezone = "America/Toronto"
)
```

<div class="kable-table">

| Type              | Amount  | currency |
|:------------------|:--------|:---------|
| tax.year          | 2021    | CAD      |
| gains             | 9.28    | CAD      |
| losses            | 0.00    | CAD      |
| net               | 9.28    | CAD      |
| total.cost        | 200.29  | CAD      |
| value.today       | 123.10  | CAD      |
| unrealized.gains  | 0.00    | CAD      |
| unrealized.losses | -77.19  | CAD      |
| unrealized.net    | -77.19  | CAD      |
| percentage.up     | -38.54% | CAD      |
| all.time.up       | -33.90% | CAD      |

</div>

### Revenue estimation

``` r
table.revenues <- report_revenues(formatted.ACB, tax.year = "2021")
#> Adding missing grouping variables: `exchange`
table.revenues
```

<div class="kable-table">

| exchange | date.last           | total.revenues |  airdrop | referrals | staking | promo | interests | rebate | rewards | currency |
|:---------|:--------------------|---------------:|---------:|----------:|--------:|------:|----------:|-------:|--------:|:---------|
| CDC      | 2021-07-23 17:21:19 |          91.82 |  0.00000 |  30.19035 |       0 |     0 |     10.36 |  51.15 |    0.12 | CAD      |
| shakepay | 2021-06-23 12:21:49 |          41.30 | 41.29662 |   0.00000 |       0 |     0 |      0.00 |   0.00 |    0.00 | CAD      |
| total    | 2021-07-23 17:21:19 |         133.12 | 41.29662 |  30.19035 |       0 |     0 |     10.36 |  51.15 |    0.12 | CAD      |

</div>

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
