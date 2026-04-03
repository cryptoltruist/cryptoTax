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

  A `list.prices` object from which to fetch coin prices.

- force:

  Whether to force recreating `list.prices` even though it already
  exists (e.g., if you added new coins or new dates).

## Value

A data frame of exchange transactions, formatted for further processing.

## Examples

``` r
format_CDC_exchange_rewards(data_CDC_exchange_rewards)
#> Could not reach the CoinMarketCap API at this time
#> Could not reach the CoinMarketCap API at this time
#> Could not reach the CoinMarketCap API at this time
#> NULL
```
