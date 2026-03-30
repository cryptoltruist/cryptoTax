# Sample data sets provided by coinpanda.io

Data sets from coinpanda.io to demonstrate adjusted cost base as well as
capital gains/losses. Used as demo for our own
[`ACB()`](https://cryptoltruist.github.io/cryptoTax/reference/ACB.md)
function.

## Usage

``` r
data_coinpanda1

data_coinpanda2
```

## Format

A data frame with 4 rows and 6 variables:

- type:

  type of transaction

- date:

  the date

- currency:

  the coin

- amount:

  quantity

- price:

  the total.price

- fees:

  any transaction fees

An object of class `data.frame` with 4 rows and 6 columns.

## Source

<https://coinpanda.io/blog/crypto-taxes-canada-adjusted-cost-base/>
