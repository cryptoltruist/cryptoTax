# Sample data set of a fictive Crypto.com transaction history file

A fictive Crypto.com data set to demonstrate
[`format_CDC()`](https://cryptoltruist.github.io/cryptoTax/reference/format_CDC.md).

## Usage

``` r
data_CDC
```

## Format

A data frame with 19 rows and 11 variables:

- Timestamp..UTC.:

  the date

- Transaction.Description:

  transaction description

- Currency:

  the currency

- Amount:

  quantity

- To.Currency:

  currency of the other traded coin

- To.Amount:

  quantity of the other traded coin

- Native.Currency:

  usually CAD

- Native.Amount:

  equivalent value in CAD

- Native.Amount..in.USD.:

  equivalent value in USD

- Transaction.Kind:

  Specific transaction identifier

- Transaction.Hash:

  blockchain address when withdrawing

## Source

<https://crypto.com/>
