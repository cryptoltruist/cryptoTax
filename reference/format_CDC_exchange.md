# Format CDC exchange file (FOR TRADES ONLY)

Format a .csv transaction history file from the Crypto.com exchange for
later ACB processing. Processes all transactions, including trades,
rewards, withdrawal fees, etc., but only for transactions of prior to
the 3.0 version Exchange upgrade of November 1st, 2022. (see
`format_CDC_exchange_rewards` and `format_CDC_exchange_trades` for older
transactions).

## Usage

``` r
format_CDC_exchange(data, list.prices = NULL, force = FALSE)
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

The necessary file for this function can be accessed by logging to the
exchange clicking on "Orders", then select the "Transactions" tab, then
for the "Transaction Type" selector, select "All", and choose your
desired 180-day period. The correct file will be named
"OEX_TRANSACTION.csv", make sure you have the right one.

In newer versions of this transaction history file, CDC has added three
disclaimer character lines at the top of the file, which is messing with
the headers. Thus, when reading the file with
[`read.csv()`](https://rdrr.io/r/utils/read.table.html), add the
argument `skip = 3`. You will then be able to read the file normally.

Also note that the USD bundle ("USD_Stable_Coin") is treated as USDC for
our purposes since it can be withdrawn as USDC and it is easier to
calculate prices with CoinMarketCap and later capital gains and so on.

## Examples

``` r
if (FALSE) { # \dontrun{
# Requires a Crypto.com Exchange "OEX_TRANSACTION.csv" export
# in the newer all-transactions format described above.
format_CDC_exchange(my_cdc_exchange_transactions)
} # }
```
