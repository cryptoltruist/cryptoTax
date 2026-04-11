# Inspect the cryptoTax pricing cache

Inspect cached pricing-related objects stored by `cryptoTax` during the
current R session. This cache is package-owned, so it avoids cluttering
the user workspace while still keeping the shared-price workflow easy to
inspect.

For compatibility with older workflows, `include.legacy = TRUE` will
also report matching objects that still live in `.GlobalEnv`. Those
legacy workspace objects are supported as a compatibility fallback, but
they are no longer the primary cache path and may be removed in a future
release.

## Usage

``` r
pricing_cache(name = NULL, include.legacy = FALSE)
```

## Arguments

- name:

  Optional single cache entry to inspect. One of `"list.prices"`,
  `"coins.list"`, or `"USD2CAD.table"`.

- include.legacy:

  Logical; whether to also include legacy cache objects found in
  `.GlobalEnv`.

## Value

If `name` is `NULL`, a named list of cache entries. Otherwise, the
requested cached object or `NULL` if not present.

## Examples

``` r
pricing_cache()
#> $list.prices
#> NULL
#> 
#> $coins.list
#> NULL
#> 
#> $USD2CAD.table
#> NULL
#> 
pricing_cache("list.prices")
#> NULL
```
