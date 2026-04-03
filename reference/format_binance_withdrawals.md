# Format Binance withdrawal file

Format a .xlsx withdrawal history file from Binance for later ACB
processing.

## Usage

``` r
format_binance_withdrawals(data, list.prices = NULL, force = FALSE)
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

To get this file, connect to your Binance account on desktop, click
"Wallet" (top right), "Transaction History", then in the "Type" column,
choose "Withdraw". Next, click on "Export Withdrawal History" on the
right and choose your time frame (you will probably need to choose
"Customized"). You are only allowed to choose up to 3 months, so you
might have to download more than one file and merge them before using
this function.

Warning: This does NOT process TRADES See the `format_binance_trades()`
function for this purpose.

## Examples

``` r
format_binance_withdrawals(data_binance_withdrawals)
#> Could not reach the CoinMarketCap API at this time
#> Could not reach the CoinMarketCap API at this time
#> Could not reach the CoinMarketCap API at this time
#> NULL
```
