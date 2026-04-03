# Offline example `list.prices` fixture

A built-in `list.prices` dataset for examples, tests, and offline
experimentation. It contains deterministic daily CAD-denominated price
rows across 2021-2023 for the main coin set used by the package's report
and integration-test workflows.

## Usage

``` r
list_prices_example
```

## Format

A data frame with 13140 rows and 11 variables:

- timestamp:

  POSIXct timestamp for the fixture row.

- slug:

  Coin slug used by CoinMarketCap-style lookups.

- name:

  Display name of the asset.

- currency:

  Ticker symbol, such as `BTC` or `USD`.

- open:

  Opening price used for the fixture row.

- close:

  Closing price used for the fixture row.

- spot.rate_USD:

  USD-denominated spot rate when relevant.

- CAD.rate:

  USD-to-CAD conversion used for the fixture row when relevant.

- spot.rate2:

  Final CAD-denominated spot rate used by
  [`match_prices()`](https://cryptoltruist.github.io/cryptoTax/reference/match_prices.md).

- date:

  Date column retained for compatibility with `list.prices` outputs.

- date2:

  Date used by
  [`match_prices()`](https://cryptoltruist.github.io/cryptoTax/reference/match_prices.md)
  joins.

## Source

Deterministic offline fixture generated for package examples and tests.
