# Review Crypto.com App withdrawal fee assumptions

Build a compact review table of Crypto.com App withdrawal rows and the
policy-estimated network fees that
[`format_CDC()`](https://cryptoltruist.github.io/cryptoTax/reference/format_CDC.md)
would apply.

## Usage

``` r
review_CDC_withdrawals(data)
```

## Arguments

- data:

  Either the raw Crypto.com App dataframe or the formatted output
  returned by
  [`format_CDC()`](https://cryptoltruist.github.io/cryptoTax/reference/format_CDC.md).

## Value

A data frame of withdrawal rows with estimated withdrawal fees for
manual review against the app UI or the transaction email.

## Examples

``` r
review_CDC_withdrawals(data_CDC)
#> [1] date                   currency               withdrawal.description
#> [4] policy.withdrawal.fee 
#> <0 rows> (or 0-length row.names)
```
