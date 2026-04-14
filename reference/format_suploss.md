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
#>         date transaction quantity price fees total.quantity
#> 1 2014-03-03         buy      100    50   10            100
#> 2 2014-05-01        sell       50   120   10             50
#> 3 2014-07-18         buy       50   130   10            100
#> 4 2014-09-25        sell       40    90   10             60
#>                    suploss.range quantity.60days share.left60 sup.loss
#> 1 2014-02-01 UTC--2014-04-02 UTC             100          100    FALSE
#> 2 2014-04-01 UTC--2014-05-31 UTC               0           50    FALSE
#> 3 2014-06-18 UTC--2014-08-17 UTC              50          100    FALSE
#> 4 2014-08-26 UTC--2014-10-25 UTC               0           60    FALSE
#>   sup.loss.quantity
#> 1                 0
#> 2                 0
#> 3                 0
#> 4                 0
```
