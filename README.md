
<!-- README.md is generated from README.Rmd. Please edit that file -->
<!-- badges: start -->

[![R-CMD-check](https://github.com/cryptoltruist/cryptoTax/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/cryptoltruist/cryptoTax/actions/workflows/R-CMD-check.yaml)
[![Codecov test
coverage](https://codecov.io/gh/cryptoltruist/cryptoTax/branch/main/graph/badge.svg)](https://app.codecov.io/gh/cryptoltruist/cryptoTax?branch=main)
<!-- badges: end -->

# cryptoTax: Crypto taxes in R (Canada only) <img src='man/figures/logo.png' align="right" height="140" style="float:right; height:200px;" />

*Disclaimer: This is not financial advice. Use at your own risks. There
are no guarantees whatsoever in relation to the use of this package.
Please consult a tax professional as necessary*.

------------------------------------------------------------------------

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

## Recommended workflow

For most users, the modern happy path is:

1.  Format one or more exchange exports with `format_exchanges()`
2.  Match or supply prices explicitly with bundled or cached
    `list.prices`
3.  Run `format_ACB()` on the normalized transaction table
4.  Generate summaries and reports from the formatted ACB output

The package now works best when you pass explicit price inputs for
offline and reproducible workflows.

The built-in pricing cache is now best understood as a convenience for
the current R session, not as the primary source of truth for
reproducible work. Normal implicit reuse only comes from the
package-owned cache, while explicit inputs remain the preferred path for
scripts, tests, and offline reporting.

That cache is especially useful when you format exchange files one by
one and need to make manual corrections between calls: you can prepare
shared pricing once, then let the relevant `format_*()` functions reuse
the package cache instead of figuring out by hand which exchange export
needs `list.prices` or `USD2CAD.table`.

If you are doing real taxes and want a maximally audit-friendly
workflow, it is still perfectly reasonable to prefer explicit
`format_*()` calls one by one so you can inspect each formatted output
before merging everything together. In that workflow, explicit saved
price objects on disk remain the safest source of truth, while the
package cache is just a same-session convenience layer.

## Saved prices across sessions

The package-owned pricing cache is **session only**. If you restart R,
that cache is gone. For multi-day tax work, the most practical workflow
is:

1.  Save your `list.prices` object to disk with `saveRDS()` or `save()`
2.  Reload it in a later session
3.  Optionally seed the package cache with `add_to_cache()` so
    formatters can reuse it implicitly during that session

``` r
library(cryptoTax)

if (file.exists("list.prices.rds")) {
  list.prices <- readRDS("list.prices.rds")
} else {
  list.prices <- prepare_list_prices(
    my.coins,
    start.date = "2021-02-01"
  )
  saveRDS(list.prices, "list.prices.rds")
}

# Optional: seed the package-owned cache for this R session
add_to_cache(list.prices = list.prices)

# Inspect what is cached this session
pricing_cache("list.prices")
```

If you prefer, you can keep passing `list.prices = list.prices`
explicitly to every formatter call instead of relying on the cache. That
remains the most explicit and reproducible path.

## Scope note

`cryptoTax` currently implements capital-account style ACB, capital
gain/loss, and superficial-loss mechanics.

It does **not** decide whether your facts should instead be reported as
business income, and it does not automatically decide difficult
“identical property” questions across distinct crypto instruments such
as wrapped, bridged, liquid-staked, or exchange-specific variants.

By default, different `currency` values stay in different pools. That is
an implementation policy for safety and reproducibility, not a legal
conclusion that two crypto variants can never be identical property
under Canadian tax law.

Those cases still need judgment outside the raw transaction math. For a
fuller discussion of the package’s current superficial-loss and
identical-property scope, see the vignettes at
<https://cryptoltruist.github.io/cryptoTax/articles/ACB.html> and
<https://cryptoltruist.github.io/cryptoTax/articles/references.html>.

# Why use `cryptoTax`?

What are the benefits of using an R package to do your crypto taxes as
opposed to an online commercial software?

1.  Full transparency on algorithms (open code)
2.  You stay in control of your data (no need to upload it on another
    platform)
3.  You can reuse your script (no need to start from scratch every year)
4.  No limit on the number of transactions
5.  Easy to automatically recategorize transactions as desired
6.  Unlimited flexibility thanks to the power of R
7.  The community can contribute for continuous improvement and feature
    requests
8.  Easy to export a csv or excel file from all formatted transactions
9.  It is free

# Installation

To install, use:

``` r
remotes::install_github("cryptoltruist/cryptoTax")
```

# ACB demo

``` r
library(cryptoTax)
data <- data_adjustedcostbase1
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
#> Warning: `as.hms()` was deprecated in hms 1.2.0.
#> ℹ Please use `as_hms()` instead.
#> ℹ The deprecated feature was likely used in the progress package.
#>   Please report the issue at <https://github.com/r-lib/progress/issues>.
#> This warning is displayed once per session.
#> Call `lifecycle::last_lifecycle_warnings()` to see where this warning was
#> generated.
#>  [------------------------------------------------] 0/4 (  0%) [Elapsed: 00:00:00 || Remaining:  ?s] [===========>------------------------------------] 1/4 ( 25%) [Elapsed: 00:00:00 || Remaining:  0s] [=======================>------------------------] 2/4 ( 50%) [Elapsed: 00:00:00 || Remaining:  0s] [===================================>------------] 3/4 ( 75%) [Elapsed: 00:00:00 || Remaining:  0s] [================================================] 4/4 (100%) [Elapsed: 00:00:00 || Remaining:  0s]
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
[corresponding
vignette](https://cryptoltruist.github.io/cryptoTax/articles/ACB.html).

# Supported exchanges

Currently, the following exchanges are supported with the `format_*`
functions, and can also be auto-detected through `format_exchanges()`:

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
13. Uphold

To support another exchange not listed here, please open an issue. You
can also prepare your own file according to the style of one of those
exchanges and use the corresponding function.

# Workflow demo

``` r
# Use bundled example prices for an offline, reproducible demo
data(list_prices_example)
list.prices <- list_prices_example

# Load data
data(data_shakepay)
data(data_CDC)

# Format one or more exchange files
all.data <- format_exchanges(list(data_shakepay, data_CDC),
  list.prices = list.prices
)

# Format data with ACB
formatted.ACB <- format_ACB(all.data, verbose = FALSE)

# Let's get a preview of the output
as.data.frame(formatted.ACB[c(1, 4, 8, 10, 19, 20), c(1:6, 7:14, 24:26)])
```

<div class="kable-table">

| date                | currency |    quantity | total.price |     spot.rate | transaction | fees | description                     | comment                | revenue.type |      value | exchange | rate.source               | currency2 |    gains |       ACB |     ACB.share |
|:--------------------|:---------|------------:|------------:|--------------:|:------------|-----:|:--------------------------------|:-----------------------|:-------------|-----------:|:---------|:--------------------------|:----------|---------:|----------:|--------------:|
| 2021-05-03 22:05:50 | BTC      |   0.0007334 |    51.25000 | 69882.7777778 | buy         |    0 | crypto_purchase                 | Buy BTC                | NA           | 51.2500000 | CDC      | exchange                  | BTC       |       NA |  51.25000 | 69882.7777778 |
| 2021-05-08 12:12:57 | BTC      |   0.0000110 |     0.00000 | 52582.0324000 | revenue     |    0 | Reward                          | ShakingSats            | airdrops     |  0.5784024 | shakepay | exchange                  | BTC       |       NA | 104.31974 | 58468.9319661 |
| 2021-05-23 22:09:39 | CRO      | 117.9468230 |     0.00000 |     0.2556449 | revenue     |    0 | referral_gift                   | Sign-up Bonus Unlocked | referrals    | 30.1525000 | CDC      | exchange (USD conversion) | CRO       |       NA |  53.42000 |     0.1778397 |
| 2021-06-02 19:11:52 | CRO      |  53.6136688 |     0.00000 |     0.2049850 | revenue     |    0 | reimbursement                   | Card Rebate: Spotify   | rebates      | 10.9900000 | CDC      | exchange                  | CRO       |       NA |  53.42000 |     0.1482240 |
| 2021-07-06 22:18:40 | CRO      |   0.3207992 |     0.26000 |     0.8104758 | revenue     |    0 | crypto_earn_extra_interest_paid | Crypto Earn (Extra)    | interests    |  0.2600000 | CDC      | exchange                  | CRO       |       NA |  53.68000 |     0.1083560 |
| 2021-07-10 00:52:19 | BTC      |   0.0005299 |    31.26847 | 59017.1922000 | sell        |    0 | Sell                            | Bought @ CA\$59,007.14 | NA           | 31.2684700 | shakepay | exchange                  | BTC       | 1.195385 |  74.24665 | 56751.3071977 |

</div>

### Audit-friendly explicit workflow

For real tax work, many users may prefer formatting files one by one so
the intermediate output can be checked before everything is merged
together:

``` r
library(cryptoTax)

list.prices <- readRDS("list.prices.rds")

x.shakepay <- format_shakepay(data_shakepay)
x.cdc <- format_CDC(data_CDC)
x.binance <- format_binance(data_binance, list.prices = list.prices)

all.data <- merge_exchanges(x.shakepay, x.cdc, x.binance)
formatted.ACB <- format_ACB(all.data, verbose = FALSE)
```

If you want the same workflow but with less repeated `list.prices = ...`
plumbing during the current R session, load your saved object once and
seed the cache:

``` r
list.prices <- readRDS("list.prices.rds")
add_to_cache(list.prices = list.prices)

x.binance <- format_binance(data_binance)
x.gemini <- format_gemini(data_gemini)
```

### Summary info

``` r
# Get latest ACB.share for each coin (ACB)
report_overview(formatted.ACB,
  today.data = TRUE, tax.year = "2021",
  local.timezone = "America/Toronto",
  list.prices = list.prices
)
#> gains, losses, and net have been filtered for tax year 2021
#> Date of current prices: 2023-12-31
```

<div class="kable-table">

| date.last           | currency | total.quantity | cost.share | total.cost |   net | gains | losses | rate.today | value.today | unrealized.gains | unrealized.losses | unrealized.net | currency2 |
|:--------------------|:---------|---------------:|-----------:|-----------:|------:|------:|-------:|-----------:|------------:|-----------------:|------------------:|---------------:|:----------|
| 2021-07-23 17:21:19 | CRO      |    535.0406356 |       0.11 |      60.66 |  0.00 |  0.00 |      0 |       0.70 |      372.92 |           312.26 |                NA |         312.26 | CRO       |
| 2021-07-25 18:22:02 | BTC      |      0.0007762 |   56751.31 |      44.05 |  6.00 |  6.00 |      0 |   83290.00 |       64.65 |            20.60 |                NA |          20.60 | BTC       |
| 2021-07-28 23:23:04 | ETH      |      0.0114054 |    2685.19 |      30.63 |  8.25 |  8.25 |      0 |    5629.00 |       64.20 |            33.57 |                NA |          33.57 | ETH       |
| 2021-07-11 20:19:55 | ETHW     |      0.3558067 |       8.99 |       3.20 |  0.00 |  0.00 |      0 |      33.88 |       12.05 |             8.85 |                NA |           8.85 | ETHW      |
| 2021-07-28 23:23:04 | Total    |             NA |         NA |     138.54 | 14.25 | 14.25 |      0 |         NA |      513.82 |           375.28 |                 0 |         375.28 | Total     |

</div>

``` r

# Get summary of realized capital gains and losses
report_summary(formatted.ACB,
  today.data = TRUE, tax.year = "2021",
  local.timezone = "America/Toronto",
  list.prices = list.prices
)
#> gains, losses, and net have been filtered for tax year 2021 (time zone = America/Toronto)
#> Date of current prices: 2023-12-31
```

<div class="kable-table">

|                     | Type                | Amount  | currency |
|:--------------------|:--------------------|:--------|:---------|
|                     | tax.year            | 2021    | CAD      |
| gains               | gains               | 14.25   | CAD      |
| losses              | losses              | 0.00    | CAD      |
| net                 | net                 | 14.25   | CAD      |
| total.cost          | total.cost          | 138.54  | CAD      |
| value.today         | value.today         | 513.82  | CAD      |
| unrealized.gains    | unrealized.gains    | 375.28  | CAD      |
| unrealized.losses   | unrealized.losses   | 0.00    | CAD      |
| unrealized.net      | unrealized.net      | 375.28  | CAD      |
| percentage.up       | percentage.up       | 270.89% | CAD      |
| all.time.up         | all.time.up         | 281.17% | CAD      |
| all.time.up.revenue | all.time.up.revenue | 353.18% | CAD      |
| revenue             | revenue             | 99.75   | CAD      |

</div>

### Revenue estimation

``` r
table.revenues <- report_revenues(formatted.ACB, tax.year = "2021")
#> Note: revenues have been filtered for tax year 2021
table.revenues
```

<div class="kable-table">

| exchange | date.last           | total.revenues | interests | rebates | staking | promos | airdrops | referrals | rewards | forks | mining | currency |
|:---------|:--------------------|---------------:|----------:|--------:|--------:|-------:|---------:|----------:|--------:|------:|-------:|:---------|
| CDC      | 2021-07-23 17:21:19 |          96.11 |     10.41 |   51.15 |       0 |      0 |     0.00 |     30.15 |     1.2 |   3.2 |      0 | CAD      |
| shakepay | 2021-06-23 12:21:49 |           3.64 |      0.00 |    0.00 |       0 |      0 |     3.64 |      0.00 |     0.0 |   0.0 |      0 | CAD      |
| total    | 2021-07-23 17:21:19 |          99.75 |     10.41 |   51.15 |       0 |      0 |     3.64 |     30.15 |     1.2 |   3.2 |      0 | CAD      |

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

------------------------------------------------------------------------

*Disclaimer: This is not financial advice. Use at your own risks. There
are no guarantees whatsoever in relation to the use of this package.
Please consult a tax professional as necessary*.
