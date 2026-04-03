# Format Adalite wallet file

Format a .csv transaction history file from the Adalite wallet for later
ACB processing.

## Usage

``` r
format_adalite(data, list.prices = NULL, force = FALSE)
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
data <- data_adalite
format_adalite(data)
#> Could not reach the CoinMarketCap API at this time
#> Could not reach the CoinMarketCap API at this time
#> Could not reach the CoinMarketCap API at this time
#> NULL
```
