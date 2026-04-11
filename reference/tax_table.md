# Format tax table for final HTML report

Format tax tables for the final rmd/html report.

## Usage

``` r
tax_table(table, repeat.header = FALSE, type = 1)
```

## Arguments

- table:

  The table to format

- repeat.header:

  Logical, whether to repeat headers at the bottom.

- type:

  Type of table, one of 1 (default), 2, or 3.

## Value

A flextable object, with certain formatting features.

## Examples

``` r
all.data <- format_exchanges(data_shakepay)
#> Exchange detected: shakepay
formatted.ACB <- format_ACB(all.data, verbose = FALSE)
x <- get_sup_losses(formatted.ACB, 2021)
#> Note: superficial losses have been filtered for tax year 2021
tax_table(x)


.cl-4e039952{table-layout:auto;}.cl-4dfc472e{font-family:'Times New Roman';font-size:11pt;font-weight:bold;font-style:normal;text-decoration:none;color:rgba(0, 0, 0, 1.00);background-color:transparent;}.cl-4e001638{margin:0;text-align:center;border-bottom: 0 solid rgba(0, 0, 0, 1.00);border-top: 0 solid rgba(0, 0, 0, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);padding-bottom:5pt;padding-top:5pt;padding-left:5pt;padding-right:5pt;line-height: 2;background-color:transparent;}.cl-4e003834{background-color:transparent;vertical-align: middle;border-bottom: 0.75pt solid rgba(0, 0, 0, 1.00);border-top: 0.75pt solid rgba(0, 0, 0, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}

currency
```

sup.loss
