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

  An optional explicit `list.prices` object from which to fetch coin
  prices. For exchanges that require external pricing, it must contain
  at least `currency`, `spot.rate2`, and `date2`.

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
#> Object 'list.prices' already exists. Reusing 'list.prices'. To force a fresh download, use argument 'force = TRUE'.
#>                  date currency quantity total.price spot.rate transaction
#> 1 2021-04-28 17:13:50      LTC  1.0e-03   0.3202293  320.2293        sell
#> 2 2021-04-28 18:15:14      ETH  7.1e-05   0.2373691 3343.2269        sell
#> 3 2021-05-06 19:55:52      ETH  6.2e-05   0.2653380 4279.6449        sell
#>       description exchange   rate.source
#> 1 Withdrawal fees  binance coinmarketcap
#> 2 Withdrawal fees  binance coinmarketcap
#> 3 Withdrawal fees  binance coinmarketcap
```
