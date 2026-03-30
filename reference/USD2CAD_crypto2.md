# Convert USD to CAD (using `crypto2`)

This function allows you to convert USD to CAD. `crypto2` `crypto2` now
only return USD rates, so CAD rates are not available anymore... See:
https://github.com/sstoeckl/crypto2/blob/master/NEWS.md#crypto-200

*"`fiat_list()` has been modified and no longer delivers all available
currencies and precious metals (therefore only USD and Bitcoin are
available any more)."*

## Usage

``` r
USD2CAD_crypto2(
  data,
  start.date = "2020-01-01",
  end.date = lubridate::now("UTC"),
  conversion = "USD",
  currency = "CAD",
  force = FALSE
)
```

## Arguments

- data:

  The data

- start.date:

  What date to start reporting prices for.

- end.date:

  What date to end reporting prices for.

- conversion:

  What to convert to

- currency:

  What to convert from

- force:

  Whether to force recreating `list.prices` even though it already
  exists (e.g., if you added new coins or new dates).

## Value

A data frame, with the following columns: date, CAD.rate.
