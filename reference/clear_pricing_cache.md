# Clear the cryptoTax pricing cache

Clear one or more cached pricing-related objects stored by `cryptoTax`
during the current R session.

This clears the package-owned cache only; it does not remove similarly
named objects from `.GlobalEnv`.

Clearing the package cache is the safest way to force fresh pricing/FX
resolution without mutating user workspace objects.

## Usage

``` r
clear_pricing_cache(name = NULL)
```

## Arguments

- name:

  Optional single cache entry to clear. One of `"list.prices"`,
  `"coins.list"`, or `"USD2CAD.table"`. If omitted, all package-owned
  pricing-cache entries are cleared.

## Value

Invisibly returns `TRUE`.

## Examples

``` r
clear_pricing_cache()
clear_pricing_cache("list.prices")
```
