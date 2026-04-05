# Get Fair Market Value (FMV) of transactions

Matches prices obtained through the
[`prepare_list_prices()`](https://cryptoltruist.github.io/cryptoTax/reference/prepare_list_prices.md)
function with the transaction data frame. For deterministic or offline
use, you can supply explicit `list.prices`, `coins.list`, `coin_hist`,
or `USD2CAD.table` inputs.

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
match_prices(data, list.prices = list_prices_example)
#>                  date currency spot.rate total.price   rate.source
#> 1 2021-05-07 14:50:41      BTC     49410          NA coinmarketcap
#> 2 2021-05-08 12:12:57      BTC     49445          NA coinmarketcap
#> 3 2021-05-09 12:22:07      BTC     49480          NA coinmarketcap
#> 4 2021-05-21 12:47:14      BTC     49900          NA coinmarketcap
#> 5 2021-06-11 12:03:31      BTC     50635          NA coinmarketcap
#> 6 2021-06-23 12:21:49      BTC     51055          NA coinmarketcap
#> 7 2021-07-10 00:52:19      BTC     51650          NA coinmarketcap
```
