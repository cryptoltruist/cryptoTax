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

## Details

The current superficial-loss implementation is scoped to the transaction
history supplied for a single taxpayer-facing asset pool. It is intended
to handle same-pool replacement-property timing and ACB adjustments.
Different `currency` values are treated as different property pools by
default. The function does not independently model affiliated-person
acquisitions or make legal judgments about whether two different crypto
instruments should be treated as "identical property". Cases involving
spouses, corporations, trusts, wrapped assets, liquid staking
derivatives, bridge assets, exchange-specific wrappers, or other
substitute-property edge cases should still be reviewed carefully. More
broadly, `ACB()` implements a capital-account style cost-base and
disposition workflow; it does not decide whether a user's facts should
instead be reported on income account as business income. In particular,
a result based on one supplied ledger should not be read as proof that
no affiliated-person superficial-loss issue exists; the function only
evaluates the transaction history you provide.

Fee handling assumes one of three normalized contracts:

- acquisition/disposition rows with a separate `fees` column, where
  `total.price` excludes those fees;

- fee-inclusive acquisition totals, where the formatter has already
  zeroed the separate `fees` field to avoid double-counting; or

- fee-in-kind / withdrawal fees represented as their own disposition
  rows instead of a `fees` column attached to another transaction.

If a raw import mixes fee-inclusive `total.price` values with non-zero
attached `fees` on the same acquisition row, that ambiguity should be
resolved in the formatter/import step before calling `ACB()`.

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
