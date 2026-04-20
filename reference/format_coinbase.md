# Format Coinbase file

Format a .csv transaction history file from Coinbase for later ACB
processing.

## Usage

``` r
format_coinbase(data)
```

## Arguments

- data:

  The dataframe

## Value

A data frame of exchange transactions, formatted for further processing.

## Examples

``` r
format_coinbase(data_coinbase)
#>                  date currency    quantity total.price    spot.rate transaction
#> 1 2024-02-02 17:18:24      BTC  0.00042515       28.62 4.722199e+04     revenue
#> 2 2024-02-02 17:18:24      ETH  0.00844271       22.12 2.355250e+03     revenue
#> 3 2024-04-02 11:02:12      BTC  0.00042515       41.56 9.035295e+04        sell
#> 4 2024-04-02 11:02:12      ADA 49.57464000       41.56 8.383319e-01         buy
#> 5 2024-04-02 11:03:55      ETH  0.00844271       32.59 4.752220e+03        sell
#> 6 2024-04-02 11:03:55      ADA 40.71252100       32.59 8.004908e-01         buy
#> 7 2024-04-02 14:07:05      ADA  0.00000000        0.00 7.600000e-01        sell
#>   fees             description
#> 1    0 bankruptcy distribution
#> 2    0 bankruptcy distribution
#> 3    0                 Convert
#> 4    0                 Convert
#> 5    0                 Convert
#> 6    0                 Convert
#> 7    0                    Send
#>                                                         comment revenue.type
#> 1 Received 0.00042515 BTC from Celsius Network LLC Crypto Di...     interest
#> 2 Received 0.00844271 ETH from Celsius Network LLC Crypto Di...     interest
#> 3                      Converted 0.00042515 BTC to 49.57464 ADA         <NA>
#> 4                      Converted 0.00042515 BTC to 49.57464 ADA         <NA>
#> 5                     Converted 0.00844271 ETH to 40.712521 ADA         <NA>
#> 6                     Converted 0.00844271 ETH to 40.712521 ADA         <NA>
#> 7              Sent 90.287162 ADA to abcdefghijklmnopqrstuvwxyz         <NA>
#>   exchange rate.source
#> 1 coinbase    exchange
#> 2 coinbase    exchange
#> 3 coinbase    exchange
#> 4 coinbase    exchange
#> 5 coinbase    exchange
#> 6 coinbase    exchange
#> 7 coinbase    exchange
```
