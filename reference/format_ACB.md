# Formats transactions with ACB

Formats transaction data with Adjusted Cost Base (ACB), along with ACB
per share and realized capital gains or losses.

## Usage

``` r
format_ACB(
  data,
  as.revenue = c("staking", "interests", "mining"),
  sup.loss = TRUE,
  cl = NULL,
  verbose = TRUE
)
```

## Arguments

- data:

  The dataframe

- as.revenue:

  Which should be treated as revenue, in list of
  `c("staking", "interests", "mining")`.

- sup.loss:

  Logical, whether to take superficial losses into account.

- cl:

  Number of cores to use for parallel processing.

- verbose:

  Logical: if `FALSE`, does not print progress bar or warnings to
  console.

## Value

A data frame, formatted for the Adjusted Cost Base (ACB).

## Details

This wrapper applies
[`ACB()`](https://cryptoltruist.github.io/cryptoTax/reference/ACB.md)
separately by currency pool. As a result, the same fiscal scope notes
apply here as well: the package can audit same-pool superficial-loss
timing and ACB adjustments from the supplied transaction history, but it
does not independently model affiliated-person substitutions or decide
difficult "identical property" questions across distinct crypto
instruments. Different `currency` values are therefore kept in separate
pools unless you normalize them yourself before calling `format_ACB()`.
This wrapper also does not determine whether a user's crypto activity
belongs on capital account or should instead be reported as business
income under their facts.

## Examples

``` r
all.data <- format_exchanges(data_shakepay)
#> Exchange detected: shakepay
format_ACB(all.data, verbose = FALSE)
#> # A tibble: 7 × 26
#> # Groups:   currency [1]
#>   date                currency quantity total.price spot.rate transaction  fees
#>   <dttm>              <chr>       <dbl>       <dbl>     <dbl> <chr>       <dbl>
#> 1 2021-05-07 14:50:41 BTC      0.00104         53.1    51037. buy             0
#> 2 2021-05-08 12:12:57 BTC      0.000011         0      52582. revenue         0
#> 3 2021-05-09 12:22:07 BTC      0.000012         0      50287. revenue         0
#> 4 2021-05-21 12:47:14 BTC      0.000013         0      56528. revenue         0
#> 5 2021-06-11 12:03:31 BTC      0.000014         0      59978. revenue         0
#> 6 2021-06-23 12:21:49 BTC      0.000015         0      59017. revenue         0
#> 7 2021-07-10 00:52:19 BTC      0.000530        31.3    59017. sell            0
#> # ℹ 19 more variables: description <chr>, comment <chr>, revenue.type <chr>,
#> #   value <dbl>, exchange <chr>, rate.source <chr>, currency2 <chr>,
#> #   total.quantity <dbl>, suploss.range <Interval>, quantity.60days <dbl>,
#> #   share.left60 <dbl>, sup.loss.quantity <dbl>, sup.loss <lgl>,
#> #   gains.uncorrected <dbl>, gains.sup <lgl>, gains.excess <lgl>, gains <dbl>,
#> #   ACB <dbl>, ACB.share <dbl>
```
