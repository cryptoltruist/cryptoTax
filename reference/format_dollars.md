# Format numeric values to dollars

Format numeric values with comma for thousands separator. Can be
converted back from this format to numeric using `to = "numeric"`.

## Usage

``` r
format_dollars(x, to = "character")
```

## Arguments

- x:

  The formatted.ACB file

- to:

  What to convert to, with options `c("character", "numeric")`.

## Value

A value representing dollars, either as a formatted character string or
as a numeric value.

## Examples

``` r
x <- format_dollars(1010.92)
x
#> [1] "1,010.92"
format_dollars(x, to = "numeric")
#> [1] 1010.92
```
