# View rows with negative total balances

View rows with negative total balances to help identify missing
transactions.

## Usage

``` r
check_missing_transactions(formatted.ACB)
```

## Arguments

- formatted.ACB:

  The formatted.ACB file

## Value

A data frame, filtered with the rows containing a total quantity smaller
than zero.

## Examples

``` r
all.data <- format_shakepay(data_shakepay)
formatted.ACB <- format_ACB(all.data, verbose = FALSE)
check_missing_transactions(formatted.ACB)
#> # A tibble: 0 × 26
#> # Groups:   currency [1]
#> # ℹ 26 variables: date <dttm>, currency <chr>, quantity <dbl>,
#> #   total.price <dbl>, spot.rate <dbl>, transaction <chr>, fees <dbl>,
#> #   description <chr>, comment <chr>, revenue.type <chr>, value <dbl>,
#> #   exchange <chr>, rate.source <chr>, currency2 <chr>, total.quantity <dbl>,
#> #   suploss.range <Interval>, quantity.60days <dbl>, share.left60 <dbl>,
#> #   sup.loss.quantity <dbl>, sup.loss <lgl>, gains.uncorrected <dbl>,
#> #   gains.sup <lgl>, gains.excess <lgl>, gains <dbl>, ACB <dbl>, …
```
