# Make a pie chart of your crypto revenues

Make a pie chart of your crypto revenues.

## Usage

``` r
crypto_pie(table.revenues, by = "exchange")
```

## Arguments

- table.revenues:

  The revenue table to plot

- by:

  To plot by which element, one of `c("exchange", "revenue.type")`.

## Value

A ggplot2 object in the form of a pie chart.

## Examples

``` r
shakepay <- format_shakepay(data_shakepay)
newton <- format_newton(data_newton)
all.data <- merge_exchanges(shakepay, newton)
formatted.ACB <- format_ACB(all.data, verbose = FALSE)
table.revenues <- report_revenues(formatted.ACB)
crypto_pie(table.revenues)

crypto_pie(table.revenues, by = "revenue.type")
```
