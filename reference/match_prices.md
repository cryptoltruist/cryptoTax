# Get Fair Market Value (FMV) of transactions

Matches prices obtained through the
[`prepare_list_prices()`](https://cryptoltruist.github.io/cryptoTax/reference/prepare_list_prices.md)
function with the transaction data frame.

## Usage

``` r
match_prices(
  data,
  slug = NULL,
  start.date = "2021-01-01",
  list.prices = NULL,
  force = FALSE,
  verbose = TRUE,
  coins.list = NULL,
  coin_hist = NULL,
  USD2CAD.table = NULL
)
```

## Arguments

- data:

  The dataframe

- slug:

  Your coins to match. You must use the long name, the "slug", not the
  ticker, see
  [`prepare_list_prices()`](https://cryptoltruist.github.io/cryptoTax/reference/prepare_list_prices.md)
  for more details.

- start.date:

  What date to start reporting prices for.

- list.prices:

  A `list.prices` object from which to fetch coin prices.

- force:

  Whether to force recreating `list.prices` even though it already
  exists (e.g., if you added new coins or new dates).

- verbose:

  Logical; whether to print progress messages.

- coins.list:

  Optional explicit output from
  [`crypto2::crypto_list()`](https://www.sebastianstoeckl.com/crypto2/reference/crypto_list.html).

- coin_hist:

  Optional explicit historical price data to transform into a
  `list.prices` object.

- USD2CAD.table:

  Optional explicit USD/CAD rate table to use when converting
  USD-denominated history to CAD.

## Value

A data frame, with the following added columns: spot.rate.

## Examples

``` r
data <- format_shakepay(data_shakepay)[c(1:2)]
match_prices(data)
#> Could not reach the CoinMarketCap API at this time
#> Could not reach the CoinMarketCap API at this time
#> NULL
```
