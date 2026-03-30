# Sample data set of a fictive Exodus wallet transaction history file

A fictive Exodus wallet data set to demonstrate
[`format_exodus()`](https://cryptoltruist.github.io/cryptoTax/reference/format_exodus.md).

## Usage

``` r
data_exodus
```

## Format

A data frame with 8 rows and 17 variables:

- DATE:

  the date

- TYPE:

  transaction type

- FROMPORTFOLIO:

  from where

- TOPORTFOLIO:

  to where

- OUTAMOUNT:

  quantity sent

- OUTCURRENCY:

  currency sent

- FEEAMOUNT:

  the fees

- FEECURRENCY:

  fee currency

- TOADDRESS:

  address sent to

- OUTTXID:

  transaction ID for out transactions

- OUTTXURL:

  transaction URL for out transactions

- INAMOUNT:

  quantity received

- INCURRENCY:

  currency received

- INTXID:

  transaction ID for in transactions

- INTXURL:

  transaction URL for in transactions

- ORDERID:

  order ID

- PERSONALNOTE:

  personal notes

## Source

<https://www.exodus.com/>
