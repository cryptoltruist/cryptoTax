# Calculate superficial capital losses

Calculate superficial capital losses to be substracted from total
capital losses.

## Usage

``` r
format_suploss(
  data,
  transaction = "transaction",
  quantity = "quantity",
  cl = NULL
)
```

## Arguments

- data:

  The data

- transaction:

  Name of transaction column

- quantity:

  Name of quantity column

- cl:

  The number of cores to use.

## Value

A data frame of formatted transactions, with added columns with
information about superficial losses.

## Examples

``` r
data <- data_adjustedcostbase1
format_suploss(data)
#> # A tibble: 4 × 11
#>   date       transaction quantity price  fees total.quantity
#>   <date>     <chr>          <dbl> <dbl> <dbl>          <dbl>
#> 1 2014-03-03 buy              100    50    10            100
#> 2 2014-05-01 sell              50   120    10             50
#> 3 2014-07-18 buy               50   130    10            100
#> 4 2014-09-25 sell              40    90    10             60
#> # ℹ 5 more variables: suploss.range <Interval>, quantity.60days <dbl>,
#> #   share.left60 <dbl>, sup.loss <lgl>, sup.loss.quantity <dbl>
```
