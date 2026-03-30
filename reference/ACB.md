# Calculate capital gains from realized gain transactions

Calculate realized and unrealized capital gains/losses

## Usage

``` r
ACB(
  data,
  transaction = "transaction",
  price = "price",
  quantity = "quantity",
  fees = "fees",
  total.price = "total.price",
  spot.rate = "spot.rate",
  as.revenue = c("staking", "interests", "mining"),
  sup.loss = TRUE,
  cl = NULL,
  verbose = TRUE
)
```

## Arguments

- data:

  The dataframe

- transaction:

  Name of transaction column

- price:

  Name of price column

- quantity:

  Name of quantity column

- fees:

  Name of fees column

- total.price:

  Name of total.price column

- spot.rate:

  Name of spot.rate column

- as.revenue:

  Name of as.revenue column

- sup.loss:

  Logical, whether to calculate superficial losses

- cl:

  Number of cores to use for parallel processing.

- verbose:

  Logical: if `FALSE`, does not print progress bar or warnings to
  console.

## Value

A data frame, with the following columns: date, transaction, quantity,
price, fees, total.price, total.quantity, ACB, ACB.share, gains

## Examples

``` r
data <- data_adjustedcostbase1
ACB(data, spot.rate = "price", sup.loss = FALSE)
#>         date transaction quantity price fees total.price total.quantity  ACB
#> 1 2014-03-03         buy      100    50   10        5000            100 5010
#> 2 2014-05-01        sell       50   120   10        6000             50 2505
#> 3 2014-07-18         buy       50   130   10        6500            100 9015
#> 4 2014-09-25        sell       40    90   10        3600             60 5409
#>   ACB.share gains
#> 1     50.10    NA
#> 2     50.10  3485
#> 3     90.15    NA
#> 4     90.15   -16
ACB(data, spot.rate = "price")
#>         date transaction quantity price fees total.price total.quantity
#> 1 2014-03-03         buy      100    50   10        5000            100
#> 2 2014-05-01        sell       50   120   10        6000             50
#> 3 2014-07-18         buy       50   130   10        6500            100
#> 4 2014-09-25        sell       40    90   10        3600             60
#>                    suploss.range quantity.60days share.left60 sup.loss.quantity
#> 1 2014-02-01 UTC--2014-04-02 UTC             100          100                 0
#> 2 2014-04-01 UTC--2014-05-31 UTC               0           50                 0
#> 3 2014-06-18 UTC--2014-08-17 UTC              50          100                 0
#> 4 2014-08-26 UTC--2014-10-25 UTC               0           60                 0
#>   sup.loss gains.uncorrected gains.sup gains.excess gains  ACB ACB.share
#> 1    FALSE                 0        NA           NA    NA 5010     50.10
#> 2    FALSE              3485        NA           NA  3485 2505     50.10
#> 3    FALSE                 0        NA           NA    NA 9015     90.15
#> 4    FALSE               -16        NA           NA   -16 5409     90.15
```
