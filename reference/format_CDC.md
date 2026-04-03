# Format Crypto.com App file

Format a .csv transaction history file from Crypto.com for later ACB
processing.

## Usage

``` r
format_CDC(data)
```

## Arguments

- data:

  The dataframe

## Value

A data frame of exchange transactions, formatted for further processing.

## Details

Be aware that CDC unfortunately does not include the withdrawal fees in
their exported transaction files (please lobby to include this feature).
This function attempts to guess some known withdrawal fees at some point
in time but depending on when the withdrawals were made, the withdrawal
fees are most certainly inaccurate. You will have to make a manual
correction for the withdrawal fees after using `format_CDC`, on the
resulting dataframe.

## Examples

``` r
format_CDC(data_CDC)
#> Object 'USD2CAD.table' already exists. Reusing 'USD2CAD.table'. To force a fresh download, use argument 'force = TRUE'.
#> Could not fetch exchange rates from coinmarketcap.
#> NULL
```
