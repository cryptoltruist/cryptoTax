# Format Celsius file

Format a .csv transaction history file from Celsius for later ACB
processing.

## Usage

``` r
format_celsius(data, USD2CAD.table = NULL)
```

## Arguments

- data:

  The dataframe

- USD2CAD.table:

  Optional explicit USD/CAD rate table to use instead of relying on
  session cache or network access for USD conversions.

## Value

A data frame of exchange transactions, formatted for further processing.

## Examples

``` r
format_celsius(data_celsius)
#>                  date currency     quantity total.price  spot.rate transaction
#> 1 2021-03-03 21:11:00      BTC 7.075989e-04  50.5240000  71402.031     revenue
#> 2 2021-03-07 05:00:00      BTC 2.523788e-05   0.1366256   5413.514     revenue
#> 3 2021-03-19 05:00:00      BTC 8.156121e-05   0.7267146   8910.052     revenue
#> 4 2021-03-28 05:00:00      BTC 3.683063e-06   0.5977123 162286.762     revenue
#> 5 2021-04-05 05:00:00      BTC 4.694039e-05   0.5849814  12462.217     revenue
#> 6 2021-04-08 05:00:00      BTC 5.177562e-05   0.6447880  12453.505     revenue
#> 7 2021-04-08 22:18:00      BTC 7.330825e-04  50.3160000  68636.209     revenue
#> 8 2021-05-06 10:32:00      BTC 1.409023e-03  61.0000000  43292.395     revenue
#> 9 2021-05-23 05:00:00      BTC 6.372669e-05   0.4162554   6531.885     revenue
#>         description revenue.type exchange               rate.source
#> 1 Promo Code Reward       promos  celsius exchange (USD conversion)
#> 2            Reward    interests  celsius exchange (USD conversion)
#> 3            Reward    interests  celsius exchange (USD conversion)
#> 4            Reward    interests  celsius exchange (USD conversion)
#> 5            Reward    interests  celsius exchange (USD conversion)
#> 6            Reward    interests  celsius exchange (USD conversion)
#> 7    Referred Award    referrals  celsius exchange (USD conversion)
#> 8 Promo Code Reward       promos  celsius exchange (USD conversion)
#> 9            Reward    interests  celsius exchange (USD conversion)
```
