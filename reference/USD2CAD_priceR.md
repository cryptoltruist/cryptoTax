# Convert USD to CAD (using `priceR`)

This function allows you to convert USD to CAD. `priceR` now requires an
API key from https://exchangerate.host/... See all details on the
package author README here: https://github.com/stevecondylios/priceR
"Set up only takes a minute and is free for 100 requests per account per
calendar month." "Go to https://exchangerate.host/, create a free
account, and replace 7e5e3140140bd8e4f4650cc41fc772c0 with your API key
in the following, and run once per R session."

## Usage

``` r
USD2CAD_priceR(
  data,
  conversion = "USD",
  currency = "CAD",
  USD2CAD.table = NULL
)
```

## Arguments

- data:

  The data

- conversion:

  What to convert to

- currency:

  What to convert from

- USD2CAD.table:

  Optional explicit exchange-rate table to use instead of relying on
  cache or network fetches.

## Value

A data frame, with the following columns: date, CAD.rate.
