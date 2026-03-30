# Generate a Full Tax Report

It is possible to generate a full tax report with `cryptoTax`. This
vignette shows how.

## Preparing your list of coins

First, you want to fetch the price information for all your coins.

> *Note*: Some exchanges don’t require fetching this information from
> coinmarketcap because they already give the CAD value of your trades
> or revenues. However, this is still necessary to get the current
> value, and therefore your unrealized gains and losses.

``` r
library(cryptoTax)

my.coins <- c(
  "bitcoin", "ethereum", "cardano", "cronos", "litecoin",
  "usd-coin", "binance-usd", "celsius", "presearch",
  "ethereum-pow", "basic-attention-token"
)

USD2CAD.table <- cur2CAD_table()

list.prices <- prepare_list_prices(slug = my.coins, start.date = "2021-01-01")
```

## Formatting your data

Below we use a shortcut for this vignette to format all exchanges
quickly with [`lapply()`](https://rdrr.io/r/base/lapply.html) and the
[`format_detect()`](https://cryptoltruist.github.io/cryptoTax/reference/format_detect.md)
function. However, you can use the dedicated functions should you wish
so.

``` r
exchanges <- list(
  data_adalite, data_binance, data_binance_withdrawals, data_blockfi, data_CDC,
  data_CDC_exchange_rewards, data_CDC_exchange_trades, data_CDC_wallet, data_celsius,
  data_coinsmart, data_exodus, data_gemini, data_newton, data_pooltool, data_presearch,
  data_shakepay, data_uphold
)

formatted.data <- format_detect(exchanges)
```

## Adjusted Cost Base

Next, we can begin processing that data. We start by formatting the
[Adjusted Cost Base
(ACB)](https://cryptoltruist.github.io/cryptoTax/articles/ACB.html) of
each transaction. The `formatted.ACB` is going to be our core object
with which we will be working for all future steps.

``` r
formatted.ACB <- format_ACB(formatted.data)
#> Process started at 2026-03-30 23:58:21.516213. Please be patient as the transactions process.
#> [Formatting ACB (progress bar repeats for each coin)...]
#> Note: Adjusted cost base (ACB) and capital gains have been adjusted for the superficial loss rule. To avoid this, use argument `sup.loss = FALSE`.
#> Process ended at 2026-03-30 23:58:23.805243. Total time elapsed: 0.04 minutes
```

> Per default,
> [`format_ACB()`](https://cryptoltruist.github.io/cryptoTax/reference/format_ACB.md)
> considers taxable revenue (and not aquisition at \$0 ACB) the
> following transaction types: staking, interests, and mining. If you
> want a different treatment for those transactions (or other types of
> revenues like cashback and airdrops), use the `as.revenue` argument of
> [`format_ACB()`](https://cryptoltruist.github.io/cryptoTax/reference/format_ACB.md).

We get a warning that there are negative values in some places,
therefore that we might have forgotten some transactions. The
[`check_missing_transactions()`](https://cryptoltruist.github.io/cryptoTax/reference/check_missing_transactions.md)
function makes it easy to identify which transactions (and therefore
which coin) are concerned with this.

``` r
check_missing_transactions(formatted.ACB)
#> # A tibble: 3 × 28
#> # Groups:   currency [11]
#>   date                currency quantity total.price spot.rate transaction  fees
#>   <dttm>              <chr>       <dbl>       <dbl>     <dbl> <chr>       <dbl>
#> 1 2021-03-07 21:46:57 BAT         52.6         57.1      1.09 sell            0
#> 2 2021-04-05 12:22:00 BAT          8.52         0        1.55 revenue         0
#> 3 2021-04-06 04:47:00 BAT          8.52        10.4      1.22 sell            0
#> # ℹ 21 more variables: description <chr>, comment <chr>, revenue.type <chr>,
#> #   value <dbl>, exchange <chr>, rate.source <chr>, fees.quantity <dbl>,
#> #   fees.currency <chr>, currency2 <chr>, total.quantity <dbl>,
#> #   suploss.range <Interval>, quantity.60days <dbl>, share.left60 <dbl>,
#> #   sup.loss.quantity <dbl>, sup.loss <lgl>, gains.uncorrected <dbl>,
#> #   gains.sup <dbl>, gains.excess <lgl>, gains <dbl>, ACB <dbl>,
#> #   ACB.share <dbl>
```

Next, we might want to make sure that we have downloaded the latest
files for each exchange. If you shake your phone every day for sats, or
you receive daily weekly payments from staking, you would expect the
latest date to be recent. For this we use the
[`get_latest_transactions()`](https://cryptoltruist.github.io/cryptoTax/reference/get_latest_transactions.md)
function.

``` r
get_latest_transactions(formatted.ACB)
#> # A tibble: 14 × 2
#> # Groups:   exchange [14]
#>    exchange     date               
#>    <chr>        <dttm>             
#>  1 CDC          2021-07-28 23:23:04
#>  2 CDC.exchange 2021-12-24 15:34:45
#>  3 CDC.wallet   2021-06-26 14:51:02
#>  4 adalite      2021-05-17 21:31:00
#>  5 binance      2022-11-27 08:05:35
#>  6 blockfi      2021-10-24 04:29:23
#>  7 celsius      2021-05-23 05:00:00
#>  8 coinsmart    2021-06-03 02:04:49
#>  9 exodus       2021-06-12 22:31:35
#> 10 gemini       2021-06-18 01:38:54
#> 11 newton       2021-06-16 18:49:11
#> 12 presearch    2021-12-09 06:24:22
#> 13 shakepay     2021-07-10 00:52:19
#> 14 uphold       2021-06-09 04:52:23
```

At this stage, it is possible to list transactions by coin, if you have
few transactions. The output can be very long as soon as you have many
transactions however, so we will not be showing it here, but you can
have a look at the
[`listby_coin()`](https://cryptoltruist.github.io/cryptoTax/reference/listby_coin.md)
function and its example.

## Full Tax Report

Next, we need to calculate a few extra bits of information for the final
report. Fortunately, the
[`prepare_report()`](https://cryptoltruist.github.io/cryptoTax/reference/prepare_report.md)
function makes this easy for us.

``` r
report.info <- prepare_report(formatted.ACB,
  tax.year = 2021,
  local.timezone = "America/Toronto",
  list.prices = list.prices
)
```

The `report.info` object is a list containing all the different info
(tables, figures) necessary for the final report. They can be accessed
individually too:

``` r
names(report.info)
#> [1] "report.overview" "report.summary"  "proceeds"        "sup.losses"     
#> [5] "table.revenues"  "tax.box"         "pie_exchange"    "pie_revenue"    
#> [9] "local.timezone"
```

Finally, to generate the report, we use
[`print_report()`](https://cryptoltruist.github.io/cryptoTax/reference/print_report.md)
with the relevant information:

``` r
print_report(formatted.ACB,
  list.prices = list.prices,
  tax.year = "2021",
  name = "Mr. Cryptoltruist",
  local.timezone = "America/Toronto"
)
```

------------------------------------------------------------------------

## Full Crypto Tax Report for Tax Year 2021

Name: Mr. Cryptoltruist

Date: Mon Mar 30 23:58:24 2026

#### Summary

| Type                | Amount     | currency |
|---------------------|------------|----------|
| gains               | 12,708.88  | CAD      |
| losses              | 0.00       | CAD      |
| net                 | 12,708.88  | CAD      |
| total.cost          | 16,678.00  | CAD      |
| value.today         | 3,121.44   | CAD      |
| unrealized.gains    | 384.68     | CAD      |
| unrealized.losses   | -13,941.23 | CAD      |
| unrealized.net      | -13,556.55 | CAD      |
| percentage.up       | -81.28%    | CAD      |
| all.time.up         | -5.08%     | CAD      |
| revenue             | 511.60     | CAD      |
| all.time.up.revenue | -2.02%     | CAD      |

    #> Warning: Date of value.today: 2026-03-29

#### Overview

| date.last           | currency | total.quantity | cost.share | total.cost | gains     | losses | net       | currency2 |
|---------------------|----------|----------------|------------|------------|-----------|--------|-----------|-----------|
| 2021-12-24 15:34:45 | CRO      | 19,234.2928403 | 0.77       | 14,754.19  | 0.00      | 0.00   | 0.00      | CRO       |
| 2021-12-24 15:34:45 | ETH      | 0.0761972      | 1,717.68   | 130.88     | 10,597.33 | 0.00   | 10,597.33 | ETH       |
| 2021-10-24 04:29:23 | LTC      | 5.5542096      | 207.02     | 1,149.83   | 1,906.29  | 0.00   | 1,906.29  | LTC       |
| 2021-08-07 21:43:44 | BTC      | 0.0048642      | 30,564.57  | 148.67     | 136.83    | 0.00   | 136.83    | BTC       |
| 2021-06-06 22:14:11 | ADA      | 209.0297373    | 1.23       | 257.10     | 0.90      | 0.00   | 0.90      | ADA       |
| 2021-06-18 01:38:54 | BAT      | 29.6939758     | 2.91       | 86.38      | 67.52     | 0.00   | 67.52     | BAT       |
| 2021-12-09 06:24:22 | PRE      | 3,010.00       | 0.03       | 78.97      | 0.00      | 0.00   | 0.00      | PRE       |
| 2022-11-27 08:05:35 | USDC     | 49.2669990     | 1.24       | 60.92      | 0.00      | 0.00   | 0.00      | USDC      |
| 2022-11-27 08:05:35 | BUSD     | 5.8763653      | 1.34       | 7.85       | 0.00      | 0.00   | 0.00      | BUSD      |
| 2022-11-17 11:54:25 | ETHW     | 0.3559272      | 8.99       | 3.20       | 0.00      | 0.00   | 0.00      | ETHW      |
| 2022-11-27 08:05:35 | Total    |                |            | 16,677.99  | 12,708.87 | 0.00   | 12,708.87 | Total     |

#### Current Value

| currency | cost.share | total.cost | rate.today | value.today | unrealized.gains | unrealized.losses | unrealized.net | currency2 |
|----------|------------|------------|------------|-------------|------------------|-------------------|----------------|-----------|
| CRO      | 0.77       | 14,754.19  | 0.10       | 1,893.15    |                  | -12,861.04        | -12,861.04     | CRO       |
| BTC      | 30,564.57  | 148.67     | 91,765.51  | 446.36      | 297.69           |                   | 297.69         | BTC       |
| LTC      | 207.02     | 1,149.83   | 74.33      | 412.82      |                  | -737.01           | -737.01        | LTC       |
| ETH      | 1,717.68   | 130.88     | 2,757.83   | 210.14      | 79.26            |                   | 79.26          | ETH       |
| ADA      | 1.23       | 257.10     | 0.34       | 70.37       |                  | -186.73           | -186.73        | ADA       |
| USDC     | 1.24       | 60.92      | 1.39       | 68.35       | 7.43             |                   | 7.43           | USDC      |
| PRE      | 0.03       | 78.97      | 0.00       | 8.17        |                  | -70.80            | -70.80         | PRE       |
| BUSD     | 1.34       | 7.85       | 1.39       | 8.15        | 0.30             |                   | 0.30           | BUSD      |
| BAT      | 2.91       | 86.38      | 0.13       | 3.81        |                  | -82.57            | -82.57         | BAT       |
| ETHW     | 8.99       | 3.20       | 0.35       | 0.12        |                  | -3.08             | -3.08          | ETHW      |
| Total    |            | 16,677.99  |            | 3,121.44    | 384.68           | -13,941.23        | -13,556.55     | Total     |
| currency | cost.share | total.cost | rate.today | value.today | unrealized.gains | unrealized.losses | unrealized.net | currency2 |

    #> Warning: Date of value.today: 2026-03-29

#### Superficial losses

| currency | sup.loss |
|----------|----------|
| CRO      | -0.00    |
| LTC      | -0.02    |
| Total    | -0.02    |

#### Revenues (CAD)

| exchange | date.last  | total | interests | rebates | staking | promos | airdrops | referrals | rewards | forks | mining |
|----------|------------|-------|-----------|---------|---------|--------|----------|-----------|---------|-------|--------|
| CDC      | 2021-07-23 | 96.11 | 10.41     | 51.15   | 0.00    | 0.00   | 0.00     | 30.15     | 1.20    | 3.20  | 0.00   |
| total    | 2021-07-23 | 96.11 | 10.41     | 51.15   | 0.00    | 0.00   | 0.00     | 30.15     | 1.20    | 3.20  | 0.00   |
| exchange | date.last  | total | interests | rebates | staking | promos | airdrops | referrals | rewards | forks | mining |

#### Revenue Sources by **Exchanges**

![](report_files/figure-html/pie_exchange-1.png)

#### Revenue Sources by **Types**

![](report_files/figure-html/pie_revenue-1.png)

## Important Tax Information for Your Accountant

  
  

#### Capital gains

Your **capital gains** for 2021 are **\$12,708.88**, whereas your
**capital losses** are **\$0.00** (net = **\$12,708.88**).

> Those are only taxed at 50%. Your **capital losses** are calculated as
> **total capital losses** (**\$0.02**) - **superficial losses**
> (**\$0.02**) = **actual capital losses** (**\$0**).

Your total “proceeds” *for the coins you sold at a **profit*** is:
**\$19,381.32** (aggregated for all coins). Your total ACB *for the
coins you sold at a profit* is: **\$6,672.44** (average of all coins).
The difference between the two is your capital gains: **\$12,708.88**.

Your total “proceeds” (adjusted for superficial gains) *for the coins
you sold at a **loss*** is: **\$0.00** (aggregated for all coins). Your
total ACB *for the coins you sold at a loss* is: **\$0.00** (average of
all coins). The difference between the two is your capital losses:
**\$0.00**.

#### Income

Your **total taxable income** from crypto (from interest & staking
exclusively) for 2021 is **\$10.41**, which is considered 100% taxable
income.

> *Note that per default, this amount excludes revenue from credit card
> cashback because it is considered rebate, not income, so considered
> acquired at the fair market value at the time of reception.* The
> income reported above also excludes other forms of airdrops and
> rewards (e.g., from Shakepay, Brave, Presearch), referrals, and
> promos, which are considered acquired at a cost of 0\$ (and will thus
> incur a capital gain of 100% upon selling). Note that should you wish
> to give different tax treatment to the different transaction types,
> you can do so through the ‘as.revenue’ argument of the ‘ACB’ function.
> Mining rewards needs to be labelled individually in the files before
> using
> [`format_ACB()`](https://cryptoltruist.github.io/cryptoTax/reference/format_ACB.md).

#### Total tax estimation

In general, you can expect to pay tax on 50% (**\$6,354.44**) of your
net capital gains + 100% of your taxable income (**\$10.41**), for a
total of **\$6,364.85**. This amount will be taxed based on your tax
bracket.

> Note that if your capital gains are net negative for the current year,
> any excess capital losses can be deferred to following years. However,
> capital losses have to be used in the same year first if you have
> outstanding capital gains.

#### Form T1135

If your **total acquisition cost** has been greater than **\$100,000**
at any point during 2021 (it is **\$16,678.00** at the time of this
report), you will need to fill **form T1135** (*Foreign Income
Verification Statement*). Form T1135 is [available for
download](https://www.canada.ca/en/revenue-agency/services/forms-publications/forms/t1135.html),
and more information about it can be found on the [CRA
website](https://www.canada.ca/en/revenue-agency/services/tax/international-non-residents/information-been-moved/foreign-reporting/questions-answers-about-form-t1135.html).

#### Summary table

Here is a summary of what you need to enter on which lines of your
income tax:

| Description            | Amount    | Comment                                                                    | Line                                          |
|------------------------|-----------|----------------------------------------------------------------------------|-----------------------------------------------|
| Gains proceeds         | 19,381.32 | Proceeds of sold coins (gains)                                             | Schedule 3, line 15199 column 2               |
| Gains ACB              | 6,672.44  | ACB of sold coins (gains)                                                  | Schedule 3, line 15199 column 3               |
| Gains                  | 12,708.88 | Proceeds - ACB (gains)                                                     | Schedule 3, lines 15199 column 5 & 15300      |
| 50% of gains           | 6,354.44  | Half of gains                                                              | T1, line 12700; Schedule 3, line 15300, 19900 |
| Outlays of gains       | 0.00      | Expenses and trading fees (gains). Normally already integrated in the ACB  | Tax software                                  |
| Losses proceeds        | 0.00      | Proceeds of sold coins (losses)                                            | Schedule 3, line 15199 column 2               |
| Losses ACB             | 0.00      | ACB of sold coins (losses)                                                 | Schedule 3, line 15199 column 3               |
| Losses                 | 0.00      | Proceeds - ACB (losses)                                                    | Schedule 3, lines 15199 column 5 & 15300      |
| 50% of losses          | 0.00      | Half of losses                                                             | T1, line 12700; Schedule 3, line 15300, 19900 |
| Outlays of losses      | 0.00      | Expenses and trading fees (losses). Normally already integrated in the ACB | Tax software                                  |
| Foreign income         | 10.41     | Income from crypto interest or staking is considered foreign income        | T1, line 13000, T1135                         |
| Foreign gains (losses) | 12,708.88 | Capital gains from crypto is considered foreign capital gains              | T1135                                         |

#### Other situations

If applicable, you may also need to enter the following:

> Interest expense on money borrowed to purchase investments for the
> purpose of gaining or producing income is tax-deductible. Use line
> 22100 (was line 221) of the personal income tax return, after
> completion of Schedule 4 (federal).

  
  
  
  

……………………………………………………………………………………………………………………………………………………………………………….
