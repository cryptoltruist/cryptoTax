# Download transaction data from the Cronos POS chain

Downloads transaction data from the Cronos Proof-of-Stake chain / the
Crypto.com DeFi wallet, through the API.

## Usage

``` r
fetch_cronos_pos(address, limit = 100, perform = TRUE, verbose = TRUE)
```

## Arguments

- address:

  The Cronos POS wallet address (starts with "cro1...")

- limit:

  Query number of transactions results per page returned (default 100)

- perform:

  Whether to execute the API request (if `TRUE`), or just return how the
  request would be formatted (if `FALSE`).

- verbose:

  Logical, if `FALSE`, does not print warnings to console.

## Value

A data frame of exchange transactions, formatted for further processing.

## Examples

``` r
fetch_cronos_pos(
  limit = 10, perform = FALSE,
  "cro1dec64zlzracgz7fs4thzx45q7a48s22d4ll8m6"
)
#> <httr2_request>
#> GET https://cronos-pos.org/explorer/api/v1/accounts/cro1dec64zlzracgz7fs4thzx45q7a48s22d4ll8m6/transactions?limit=10
#> Body: empty
```
