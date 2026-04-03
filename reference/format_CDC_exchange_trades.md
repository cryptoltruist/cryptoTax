# Format CDC exchange file (FOR TRADES ONLY)

Format a .csv transaction history file from the Crypto.com exchange for
later ACB processing. Only processes trades, not rewards (see
`format_CDC_exchange_rewards` for this).

## Usage

``` r
format_CDC_exchange_trades(data, list.prices = NULL, force = FALSE)
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

Original file name of the right file from the exchange is called
"SPOT_TRADE.csv", make sure you have the right one. It can usually be
accessed with the following steps: (1) connect to the CDC exchange. On
the left menu, click on "Wallet", and choose the "Transactions" tab.
Pick your desired dates. Unfortunately, the CDC exchange history export
only supports 30 days at a time. So if you have more than that, you will
need to export each file and merge them manually before you use this
function.

As of the new changes to the exchange (3.0) transactions before November
1st, 2022, one can go instead through the "Archive" button on the left
vertical menu, choose dates (max 100 days), and download trade
transactions. It will be a zip file with several transaction files
inside. Choose the "SPOT_TRADE.csv".

In newer versions of this transaction history file, CDC has added three
disclaimer character lines at the top of the file, which is messing with
the headers. Thus, when reading the file with
[`read.csv()`](https://rdrr.io/r/utils/read.table.html), add the
argument `skip = 3`. You will then be able to read the file normally.

Update 2024: the unzipped correct file is now named "OEX_TRADE.csv"
instead of "SPOT_TRADE.csv".

Also note that the USD bundle ("USD_Stable_Coin") is treated as USDC for
our purposes since it can be withdrawn as USDC and it is easier to
calculate prices with CoinMarketCap and later capital gains and so on.

## Examples

``` r
format_CDC_exchange_trades(data_CDC_exchange_trades)
#> Could not reach the CoinMarketCap API at this time
#> Could not reach the CoinMarketCap API at this time
#> Could not reach the CoinMarketCap API at this time
#> NULL
```
