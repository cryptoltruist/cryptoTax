# Prepare the list of coins for prices

Prepare the list of coins for prices.

## Usage

``` r
prepare_list_prices(
  slug,
  start.date,
  end.date = lubridate::now("UTC"),
  force = FALSE,
  verbose = TRUE
)

add_popular_slugs(data, slug_dictionary = popular_slugs)

prepare_list_prices_slugs(
  data,
  list.prices = NULL,
  slug = NULL,
  start.date = NULL,
  verbose = TRUE
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

  What date to end reporting prices for. the `list.prices` object symbol
  for a given coin is shared by multiple coins (see details).

- force:

  Whether to force recreating `list.prices` even though it already
  exists (e.g., if you added new coins or new dates).

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

The
[crypto2::crypto_history](https://www.sebastianstoeckl.com/crypto2/reference/crypto_history.html)
API is at times a bit capricious. You might need to try a few times
before it processes correctly and without errors.

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
my.list.prices <- prepare_list_prices(slug = my.coins, start.date = "2023-01-01")
#> Object 'list.prices' already exists. Reusing 'list.prices'. To force a fresh download, use argument 'force = TRUE'.
head(my.list.prices)
#> # A tibble: 6 × 23
#>      id slug    name    symbol timestamp           ref_cur_id ref_cur_name
#>   <int> <chr>   <chr>   <chr>  <dttm>              <chr>      <chr>       
#> 1     1 bitcoin Bitcoin BTC    2021-01-01 23:59:59 2781       USD         
#> 2     1 bitcoin Bitcoin BTC    2021-01-02 23:59:59 2781       USD         
#> 3     1 bitcoin Bitcoin BTC    2021-01-03 23:59:59 2781       USD         
#> 4     1 bitcoin Bitcoin BTC    2021-01-04 23:59:59 2781       USD         
#> 5     1 bitcoin Bitcoin BTC    2021-01-05 23:59:59 2781       USD         
#> 6     1 bitcoin Bitcoin BTC    2021-01-06 23:59:59 2781       USD         
#> # ℹ 16 more variables: time_open <dttm>, time_close <dttm>, time_high <dttm>,
#> #   time_low <dttm>, open <dbl>, high <dbl>, low <dbl>, close <dbl>,
#> #   volume <dbl>, market_cap <dbl>, circulating_supply <dbl>,
#> #   spot.rate_USD <dbl>, CAD.rate <dbl>, spot.rate2 <dbl>, currency <chr>,
#> #   date2 <date>
```
