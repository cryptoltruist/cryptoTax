# Sample data set of a fictive Shakepay transaction history file

A fictive Shakepay data set to demonstrate
[`format_shakepay()`](https://cryptoltruist.github.io/cryptoTax/reference/format_shakepay.md).

## Usage

``` r
data_shakepay
```

## Format

A data frame with 8 rows and 11 variables:

- Date:

  the date

- Amount.Debited:

  amount debited

- Asset.Debited:

  currency debited

- Amount.Credited:

  amount credited

- Asset.Credited:

  currency credited

- Market.Value:

  market value

- Market.Value.Currency:

  market value currency

- Book.Cost:

  value of transaction (CAD)

- Book.Cost.Currency:

  currency of Book.Cost (CAD)

- Type:

  transaction type

- Spot.Rate:

  transaction spot rate on Shakepay

- Buy...Sell.Rate:

  Buy / sell rate

- Description:

  Buy, Sell, Send, or Reward

## Source

<https://shakepay.com/>
