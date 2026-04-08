# Get a simple table of relevant tax information

Output a simple table with all the relevant tax information and tax form
line numbers.

## Usage

``` r
tax_box(report.summary, sup.losses, table.revenues, proceeds)
```

## Arguments

- report.summary:

  report.summary

- sup.losses:

  sup.losses

- table.revenues:

  table.revenues

- proceeds:

  proceeds

## Value

A data frame, with the following columns: Description, Amount, Comment,
Line

## Examples

``` r
my.list.prices <- list_prices_example
all.data <- format_exchanges(data_shakepay)
#> Exchange detected: shakepay
formatted.ACB <- format_ACB(all.data, verbose = FALSE)
report.summary <- report_summary(formatted.ACB, today.data = TRUE, list.prices = my.list.prices)
#> Date of current prices: 2023-12-31
sup.losses <- get_sup_losses(formatted.ACB, 2021)
#> Note: superficial losses have been filtered for tax year 2021
table.revenues <- report_revenues(formatted.ACB, 2021)
#> Note: revenues have been filtered for tax year 2021
proceeds <- get_proceeds(formatted.ACB, 2021)
#> Note: proceeds have been filtered for tax year 2021
tax_box(report.summary, sup.losses, table.revenues, proceeds)
#>               Description    Amount
#> 1          Gains proceeds 31.268470
#> 2               Gains ACB 25.454088
#> 3                   Gains  5.814382
#> 4            50% of gains  2.907191
#> 5        Outlays of gains  0.000000
#> 6         Losses proceeds  0.000000
#> 7              Losses ACB  0.000000
#> 8                  Losses  0.000000
#> 9           50% of losses  0.000000
#> 10      Outlays of losses  0.000000
#> 11         Foreign income  0.000000
#> 12 Foreign gains (losses)  5.814382
#>                                                                       Comment
#> 1                                              Proceeds of sold coins (gains)
#> 2                                                   ACB of sold coins (gains)
#> 3                                                      Proceeds - ACB (gains)
#> 4                                                               Half of gains
#> 5   Expenses and trading fees (gains). Normally already integrated in the ACB
#> 6                                             Proceeds of sold coins (losses)
#> 7                                                  ACB of sold coins (losses)
#> 8                                                     Proceeds - ACB (losses)
#> 9                                                              Half of losses
#> 10 Expenses and trading fees (losses). Normally already integrated in the ACB
#> 11        Income from crypto interest or staking is considered foreign income
#> 12              Capital gains from crypto is considered foreign capital gains
#>                                             Line
#> 1                Schedule 3, line 15199 column 2
#> 2                Schedule 3, line 15199 column 3
#> 3       Schedule 3, lines 15199 column 5 & 15300
#> 4  T1, line 12700; Schedule 3, line 15300, 19900
#> 5                                   Tax software
#> 6                Schedule 3, line 15199 column 2
#> 7                Schedule 3, line 15199 column 3
#> 8       Schedule 3, lines 15199 column 5 & 15300
#> 9  T1, line 12700; Schedule 3, line 15300, 19900
#> 10                                  Tax software
#> 11                         T1, line 13000, T1135
#> 12                                         T1135
```
