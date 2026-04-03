# Format transaction data from the Cronos POS chain

Format a .csv transaction history file from the Crypto.com DeFi wallet
for later ACB processing.

Use
[`fetch_cronos_pos()`](https://cryptoltruist.github.io/cryptoTax/reference/fetch_cronos_pos.md)
to first download the data.

## Usage

``` r
format_cronos_pos(data, list.prices = NULL, force = FALSE)
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
# \donttest{
data <- fetch_cronos_pos(
  limit = 30,
  "cro1juv4wda4ty2tas8dwh7jc2ea73ewhtc26eyxwt"
)
#> $total_record
#> [1] 758
#> 
#> $total_page
#> [1] 26
#> 
#> $current_page
#> [1] 1
#> 
#> $limit
#> [1] 30
#> 
#> Warning: Total number of transactions detected higher than the set limit. Adjust as needed with the 'limit' argument
format_cronos_pos(data)
#> Could not reach the CoinMarketCap API at this time
#> Could not reach the CoinMarketCap API at this time
#> Could not reach the CoinMarketCap API at this time
#> NULL
# }
```
