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
#> Could not reach the CoinMarketCap API at this time
#> Could not reach the CoinMarketCap API at this time
#> Could not reach the CoinMarketCap API at this time
#> NULL
# }
```
