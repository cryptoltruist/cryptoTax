# Apply manual Crypto.com App withdrawal fee overrides

Update policy-estimated Crypto.com App withdrawal fee rows on a
formatted CDC ledger using a small override table, then recompute
`total.price` from the updated `quantity` and existing `spot.rate`.

## Usage

``` r
apply_CDC_withdrawal_overrides(data, overrides)
```

## Arguments

- data:

  The formatted output returned by
  [`format_CDC()`](https://cryptoltruist.github.io/cryptoTax/reference/format_CDC.md).

- overrides:

  A data frame containing a replacement `quantity` column and a `date`
  column, with optional additional match columns such as `currency` or
  `comment`.

## Value

The formatted CDC data frame with matching withdrawal rows updated.

## Examples

``` r
overrides <- data.frame(
  date = lubridate::as_datetime("2021-04-18 03:57:41"),
  quantity = 0.01
)
apply_CDC_withdrawal_overrides(format_CDC(data_CDC), overrides)
#>                   date currency     quantity total.price    spot.rate
#> 1  2021-05-03 22:05:50      BTC 7.333710e-04     51.2500 6.988278e+04
#> 2  2021-05-07 23:06:50      ETH 2.059201e-02     54.2100 2.632575e+03
#> 3  2021-05-15 18:07:10      CRO 1.824360e+02     53.4200 2.928150e-01
#> 4  2021-05-23 22:09:39      CRO 1.179468e+02     30.1525 2.556449e-01
#> 5  2021-05-29 23:10:59      CRO 6.403954e+00      1.1300 1.764535e-01
#> 6  2021-06-02 19:11:52      CRO 5.361367e+01     10.9900 2.049850e-01
#> 7  2021-06-10 23:12:24      CRO 8.635724e+01     16.9400 1.961619e-01
#> 8  2021-06-11 19:13:58      CRO 1.736890e+01      9.1900 5.291066e-01
#> 9  2021-06-16 20:14:29      CRO 2.250418e+01     11.6500 5.176817e-01
#> 10 2021-06-18 21:15:51      ETH 1.377500e-05      0.0500 3.629764e+03
#> 11 2021-06-19 21:16:30      CRO 8.452621e+00      1.2500 1.478831e-01
#> 12 2021-06-27 21:17:50      ETH 7.632668e-04      3.1200 4.087692e+03
#> 13 2021-07-06 22:18:40      CRO 3.207992e-01      0.2600 8.104758e-01
#> 14 2021-07-11 20:19:55     ETHW 3.558067e-01      3.2000 8.993647e+00
#> 15 2021-07-14 18:20:27      CRO 2.476190e+00      1.2000 4.846154e-01
#> 16 2021-07-23 17:21:19      CRO 3.716026e+01      6.9800 1.878351e-01
#> 17 2021-07-25 18:22:02      BTC 5.320542e-04     35.0000 6.578278e+04
#> 18 2021-07-28 23:23:04      ETH 9.963655e-03     35.0000 3.512767e+03
#>    transaction                         description                   comment
#> 1          buy                     crypto_purchase                   Buy BTC
#> 2          buy                     crypto_purchase                   Buy ETH
#> 3          buy                     crypto_purchase                   Buy CRO
#> 4      revenue                       referral_gift    Sign-up Bonus Unlocked
#> 5      revenue              referral_card_cashback             Card Cashback
#> 6      revenue                       reimbursement      Card Rebate: Spotify
#> 7      revenue                       reimbursement      Card Rebate: Netflix
#> 8      revenue                       reimbursement Card Rebate: Amazon Prime
#> 9      revenue                       reimbursement      Card Rebate: Expedia
#> 10     revenue supercharger_reward_to_app_credited       Supercharger Reward
#> 11     revenue                 pay_checkout_reward               Pay Rewards
#> 12     revenue           crypto_earn_interest_paid               Crypto Earn
#> 13     revenue     crypto_earn_extra_interest_paid       Crypto Earn (Extra)
#> 14     revenue               admin_wallet_credited       Adjustment (Credit)
#> 15     revenue   rewards_platform_deposit_credited   Mission Rewards Deposit
#> 16     revenue                    mco_stake_reward         CRO Stake Rewards
#> 17        sell               crypto_viban_exchange                BTC -> CAD
#> 18        sell               crypto_viban_exchange                ETH -> CAD
#>    revenue.type exchange               rate.source
#> 1          <NA>      CDC                  exchange
#> 2          <NA>      CDC                  exchange
#> 3          <NA>      CDC                  exchange
#> 4     referrals      CDC exchange (USD conversion)
#> 5       rebates      CDC                  exchange
#> 6       rebates      CDC                  exchange
#> 7       rebates      CDC                  exchange
#> 8       rebates      CDC                  exchange
#> 9       rebates      CDC                  exchange
#> 10    interests      CDC                  exchange
#> 11      rebates      CDC                  exchange
#> 12    interests      CDC                  exchange
#> 13    interests      CDC                  exchange
#> 14        forks      CDC                  exchange
#> 15      rewards      CDC                  exchange
#> 16    interests      CDC                  exchange
#> 17         <NA>      CDC                  exchange
#> 18         <NA>      CDC                  exchange
```
