# Prepare the list of coins for prices

The
[crypto2::crypto_history](https://www.sebastianstoeckl.com/crypto2/reference/crypto_history.html)
API is at times a bit capricious. You might need to try a few times
before it processes correctly and without errors.

## Usage

``` r
prepare_list_prices(
  slug,
  start.date,
  end.date = lubridate::now("UTC"),
  force = FALSE,
  verbose = TRUE,
  list.prices = NULL,
  coins.list = NULL,
  coin_hist = NULL,
  USD2CAD.table = NULL
)

add_popular_slugs(data, slug_dictionary = popular_slugs)

prepare_list_prices_slugs(
  data,
  list.prices = NULL,
  slug = NULL,
  start.date = NULL,
  force = FALSE,
  verbose = TRUE,
  coins.list = NULL,
  coin_hist = NULL,
  USD2CAD.table = NULL
)

popular_slugs
```

## Format

An object of class `data.frame` with 31 rows and 2 columns.

## Arguments

- slug:

  Which coins to include in the list. However, because of too many
  duplicated symbols, you must use the unique "slug" name of the coin.
  You can obtain the correct slug using
  [`crypto2::crypto_list()`](https://www.sebastianstoeckl.com/crypto2/reference/crypto_list.html)
  and then filtering for your symbol.

- start.date:

  What date to start reporting prices for.

- end.date:

  What date to end reporting prices for.

- force:

  Whether to force recreating `list.prices` even though it already
  exists (e.g., if you added new coins or new dates).

- verbose:

  Logical; whether to print progress messages.

- list.prices:

  Optional explicit `list.prices` object to reuse instead of relying on
  a cached session object.

- coins.list:

  Optional explicit output from
  [`crypto2::crypto_list()`](https://www.sebastianstoeckl.com/crypto2/reference/crypto_list.html).

- coin_hist:

  Optional explicit historical price data to transform into a
  `list.prices` object.

- USD2CAD.table:

  Optional explicit USD/CAD rate table to use when converting
  USD-denominated history to CAD.

- data:

  The data to which to convert the coin symbol / ticker to the "slug"
  (full name of the coin).

- slug_dictionary:

  A table of equivalency between the coin symbol / ticker and its slug.
  By default uses the provided `popular_slugs` object with the most
  popular coins. This is to avoid all the duplicated coin tickers that
  are returned with
  [`crypto2::crypto_list()`](https://www.sebastianstoeckl.com/crypto2/reference/crypto_list.html).

## Value

A data frame, with the following columns: timestamp, id, slug, name,
symbol, ref_cur, open, high, low, close, volume, market_cap, time_open,
time_close, time_high, time_low, spot.rate2, currency, date2.

## Details

This function can also be run deterministically by supplying explicit
`list.prices`, `coins.list`, `coin_hist`, or `USD2CAD.table` inputs.

Sometimes, `list.prices` (through coinmarketcap) will contain symbols
for a given coin (e.g., ETH) that is actually shared by multiple coins,
thus, the necessity of the `remove.coins.slug` argument. In these cases,
we can look at the slug column of `list.prices` to identify the correct
coins. ETH for example possesses two slugs: "ethereum" (the main one)
and "the-infinite-garden" (probably not the one you want). Per default,
a number of duplicate slugs are excluded, the list of which is
accessible in the `slugs_to_remove` object. However, you can provide
your own list, should you wish to.

## Examples

``` r
my.coins <- c("bitcoin", "ethereum")
my.list.prices <- prepare_list_prices(
  slug = my.coins,
  start.date = "2023-01-01",
  list.prices = list_prices_example
)
head(my.list.prices)
#>    timestamp    slug    name currency  open close spot.rate_USD CAD.rate
#> 1 2021-01-01 bitcoin Bitcoin      BTC 45000 45000            NA       NA
#> 2 2021-01-02 bitcoin Bitcoin      BTC 45035 45035            NA       NA
#> 3 2021-01-03 bitcoin Bitcoin      BTC 45070 45070            NA       NA
#> 4 2021-01-04 bitcoin Bitcoin      BTC 45105 45105            NA       NA
#> 5 2021-01-05 bitcoin Bitcoin      BTC 45140 45140            NA       NA
#> 6 2021-01-06 bitcoin Bitcoin      BTC 45175 45175            NA       NA
#>   spot.rate2       date      date2
#> 1      45000 2021-01-01 2021-01-01
#> 2      45035 2021-01-02 2021-01-02
#> 3      45070 2021-01-03 2021-01-03
#> 4      45105 2021-01-04 2021-01-04
#> 5      45140 2021-01-05 2021-01-05
#> 6      45175 2021-01-06 2021-01-06
```
