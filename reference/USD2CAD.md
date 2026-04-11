# Convert USD to CAD (Bank of Canada rates)

This function allows you to convert USD to CAD. The data is extracted
from the CSV available for download at
<https://www.bankofcanada.ca/rates/exchange/daily-exchange-rates/> The
Bank of Canada only provides data for business days. On days which data
is not available, the last known value is used instead. You can also
supply an explicit `USD2CAD.table` to make the conversion deterministic
and independent from session cache or network access.

## Usage

``` r
USD2CAD(data, conversion = "USD", force = FALSE, USD2CAD.table = NULL)

cur2CAD_table()
```

## Arguments

- data:

  The data

- conversion:

  What to convert to

- force:

  Whether to force recreating `list.prices` even though it already
  exists (e.g., if you added new coins or new dates).

- USD2CAD.table:

  Optional explicit exchange-rate table to use instead of relying on the
  current session cache.

## Value

A data frame, with the following columns: date, CAD.rate.

## Examples

``` r
formatted.dates <- format_exchanges(data_shakepay)[1]
#> Exchange detected: shakepay
example_fx <- data.frame(
  date = as.Date("2021-01-01"),
  USD = 1.25,
  CAD = 1
)
USD2CAD(formatted.dates, USD2CAD.table = example_fx)
#> [1] date     CAD.rate
#> <0 rows> (or 0-length row.names)
x <- cur2CAD_table()
head(x)
#>         date    AUD    BRL    CNY    EUR    HKD     INR     IDR     JPY    MYR
#> 1 2017-01-03 0.9702 0.4121 0.1930 1.3973 0.1732 0.01965 1.0e-04 0.01140 0.2991
#> 2 2017-01-04 0.9678 0.4129 0.1920 1.3930 0.1717 0.01959 9.9e-05 0.01134 0.2961
#> 3 2017-01-05 0.9708 0.4133 0.1922 1.4008 0.1708 0.01954 9.9e-05 0.01145 0.2953
#> 4 2017-01-06 0.9668 0.4116 0.1911 1.3953 0.1706 0.01942 9.9e-05 0.01133 0.2957
#> 5 2017-01-07 0.9668 0.4116 0.1911 1.3953 0.1706 0.01942 9.9e-05 0.01133 0.2957
#> 6 2017-01-08 0.9668 0.4116 0.1911 1.3953 0.1706 0.01942 9.9e-05 0.01133 0.2957
#>       MXN    NZD    NOK    PEN     RUB    SAR    SGD     ZAR      KRW    SEK
#> 1 0.06439 0.9295 0.1551 0.3976 0.02210 0.3582 0.9264 0.09740 0.001112 0.1465
#> 2 0.06242 0.9251 0.1546 0.3930 0.02200 0.3550 0.9240 0.09767 0.001111 0.1460
#> 3 0.06195 0.9285 0.1555 0.3930 0.02225 0.3531 0.9260 0.09743 0.001118 0.1468
#> 4 0.06213 0.9230 0.1551 0.3921 0.02222 0.3526 0.9202 0.09647 0.001103 0.1461
#> 5 0.06213 0.9230 0.1551 0.3921 0.02222 0.3526 0.9202 0.09647 0.001103 0.1461
#> 6 0.06213 0.9230 0.1551 0.3921 0.02222 0.3526 0.9202 0.09647 0.001103 0.1461
#>      CHF     TWD     THB    TRY    GBP    USD     VND CAD
#> 1 1.3064 0.04150 0.03739 0.3744 1.6459 1.3435 5.9e-05   1
#> 2 1.3005 0.04141 0.03717 0.3722 1.6377 1.3315 5.9e-05   1
#> 3 1.3083 0.04161 0.03709 0.3674 1.6400 1.3244 5.8e-05   1
#> 4 1.3020 0.04131 0.03704 0.3640 1.6275 1.3214 5.9e-05   1
#> 5 1.3020 0.04131 0.03704 0.3640 1.6275 1.3214 5.9e-05   1
#> 6 1.3020 0.04131 0.03704 0.3640 1.6275 1.3214 5.9e-05   1
```
