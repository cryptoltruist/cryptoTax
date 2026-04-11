# Format CDC exchange file (FOR REWARDS ONLY)

Format a .csv transaction history file from the Crypto.com exchange for
later ACB processing. Only processes rewards and withdrawal fees, not
trades (see `format_CDC_exchange_trades` for this).

To download the rewards/withdrawal fees data from the Crypto.com
exchange as a CSV file, copy and paste the code below and save it as a
bookmark in your browser.

`javascript:(function(){function callback(){window.cdc()}var s=document.createElement("script");s.src="https://cdn.jsdelivr.net/gh/ConorIA/cdc-csv@master/cdc.js";if(s.addEventListener){s.addEventListener("load",callback,false)}else if(s.readyState){s.onreadystatechange=callback}document.body.appendChild(s);})()`

Then log into the crypto.com exchange and click the bookmark you saved.
It will automatically download a CSV that contains Supercharger rewards,
withdrawal fees, CRO staking interest (if you have an exchange stake),
among others.

Note that this code does not include the initial referral reward in CRO
for signup or on the Crypto.com exchange. It must be added manually.

WARNING: DOES NOT DOWNLOAD TRADES, ONLY REWARDS AND WITHDRAWALS!

Update 2025: it seems that the CDC exchange now allows downloading all
transactions (up to 180 days / ~ six months) including trades and all
rewards. However, transactions before November 1st, 2022, can only be
accessed through the Archive section. For this, see
[format_CDC_exchange](https://cryptoltruist.github.io/cryptoTax/reference/format_CDC_exchange.md).

## Usage

``` r
format_CDC_exchange_rewards(data, list.prices = NULL, force = FALSE)
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
format_CDC_exchange_rewards(data_CDC_exchange_rewards)
#> Using deprecated legacy '.GlobalEnv' cache for 'list.prices'. This compatibility path may be removed in a future release; prefer `pricing_cache()` or pass `list.prices` explicitly. To force a fresh download, use argument 'force = TRUE'.
#>                   date currency   quantity  total.price    spot.rate
#> 1  2021-02-19 00:00:00      CRO 1.36512341 0.2221748898 1.627508e-01
#> 2  2021-02-21 00:00:00      CRO 1.36945123 0.2412313569 1.761518e-01
#> 3  2021-04-15 16:04:21      BTC 0.00000023 0.0182120528 7.918284e+04
#> 4  2021-04-18 00:00:00      CRO 1.36512310 0.3795803682 2.780558e-01
#> 5  2021-05-14 06:02:22      BTC 0.00000035 0.0210982556 6.028073e+04
#> 6  2021-06-12 15:21:34      BTC 0.00000630 0.2789325106 4.427500e+04
#> 7  2021-06-27 01:34:00      CRO 0.00100000 0.0001240084 1.240084e-01
#> 8  2021-07-07 00:00:00      CRO 0.01512903 0.0022880434 1.512353e-01
#> 9  2021-07-13 00:00:00      CRO 0.05351230 0.0084290717 1.575165e-01
#> 10 2021-09-07 00:00:00      CRO 0.01521310 0.0035727817 2.348490e-01
#>    transaction description                                          comment
#> 1      revenue      Reward Interest on 5000.00000000 at 10% APR (Completed)
#> 2      revenue      Reward Interest on 5000.00000000 at 10% APR (Completed)
#> 3      revenue      Reward                          BTC Supercharger reward
#> 4      revenue      Reward Interest on 5000.00000000 at 10% APR (Completed)
#> 5      revenue      Reward                          BTC Supercharger reward
#> 6      revenue      Reward                          BTC Supercharger reward
#> 7         sell  Withdrawal                                             <NA>
#> 8      revenue      Reward                  Rebate on 0.18512341 CRO at 10%
#> 9      revenue      Reward                Rebate on 0.5231512346 CRO at 10%
#> 10     revenue      Reward                 Rebate on 0.155125123 CRO at 10%
#>    revenue.type     exchange   rate.source
#> 1     interests CDC.exchange coinmarketcap
#> 2     interests CDC.exchange coinmarketcap
#> 3     interests CDC.exchange coinmarketcap
#> 4     interests CDC.exchange coinmarketcap
#> 5     interests CDC.exchange coinmarketcap
#> 6     interests CDC.exchange coinmarketcap
#> 7          <NA> CDC.exchange coinmarketcap
#> 8       rebates CDC.exchange coinmarketcap
#> 9       rebates CDC.exchange coinmarketcap
#> 10      rebates CDC.exchange coinmarketcap
```
