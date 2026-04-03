# Format CDC wallet file

Format a .csv transaction history file from the Crypto.com DeFi wallet
for later ACB processing.

One way to download the CRO staking rewards data from the blockchain is
to visit http://crypto.barkisoft.de/ and input your CRO address. Keep
the default export option ("Koinly"). It will output a CSV file with
your transactions. Note: the site does not use a secure connection: use
at your own risks. The file is semi-column separated; when using
`read.csv`, add the `sep = ";"` argument.

Superseded by
[`fetch_cronos_pos()`](https://cryptoltruist.github.io/cryptoTax/reference/fetch_cronos_pos.md)
and
[`format_cronos_pos()`](https://cryptoltruist.github.io/cryptoTax/reference/format_cronos_pos.md)
since http://crypto.barkisoft.de/ does not provide a valid CSV file
anymore.

## Usage

``` r
format_CDC_wallet(data, list.prices = NULL, force = FALSE)
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
format_CDC_wallet(data_CDC_wallet)
#> Could not reach the CoinMarketCap API at this time
#> Could not reach the CoinMarketCap API at this time
#> Could not reach the CoinMarketCap API at this time
#> NULL
```
