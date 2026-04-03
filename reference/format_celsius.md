# Format Celsius file

Format a .csv transaction history file from Celsius for later ACB
processing.

## Usage

``` r
format_celsius(data)
```

## Arguments

- data:

  The dataframe

## Value

A data frame of exchange transactions, formatted for further processing.

## Examples

``` r
format_celsius(data_celsius)
#> Object 'USD2CAD.table' already exists. Reusing 'USD2CAD.table'. To force a fresh download, use argument 'force = TRUE'.
#> Could not fetch exchange rates from the exchange rate API.
#> NULL
```
