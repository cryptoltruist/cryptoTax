# Format Shakepay file

Format a .csv transaction history file from Shakepay for later ACB
processing.

In 2024, the Shakepay transaction history file has changed. Shakepay now
provides two files: `crypto_transactions_summary.csv` and
`cash_transactions_summary.csv`. The new correct file with all
transactions is the first one, `crypto_transactions_summary.csv`.

Furthermore, this file does not report referral rewards anymore, which
need to be added manually or through the `referral` argument (using a
list if multiple referrals).

## Usage

``` r
format_shakepay(data, referral)
```

## Arguments

- data:

  The dataframe

- referral:

  Feature to include referral rewards manually (e.g., as a list with
  dates and credit amounts) since Shakepay stopped including these in
  their transaction history files.

## Value

A data frame of exchange transactions, formatted for further processing.

## Examples

``` r
formatted.shakepay <- format_shakepay(data_shakepay)
head(formatted.shakepay)
#>                  date currency   quantity total.price spot.rate transaction
#> 1 2021-05-07 14:50:41      BTC 0.00103982  53.0697400  51037.43         buy
#> 2 2021-05-08 12:12:57      BTC 0.00001100   0.5784024  52582.03     revenue
#> 3 2021-05-09 12:22:07      BTC 0.00001200   0.6034441  50287.01     revenue
#> 4 2021-05-21 12:47:14      BTC 0.00001300   0.7348590  56527.62     revenue
#> 5 2021-06-11 12:03:31      BTC 0.00001400   0.8396927  59978.05     revenue
#> 6 2021-06-23 12:21:49      BTC 0.00001500   0.8852574  59017.16     revenue
#>   description               comment revenue.type exchange rate.source
#> 1         Buy Bought @ CA$51,002.43         <NA> shakepay    exchange
#> 2      Reward           ShakingSats     airdrops shakepay    exchange
#> 3      Reward           ShakingSats     airdrops shakepay    exchange
#> 4      Reward           ShakingSats     airdrops shakepay    exchange
#> 5      Reward           ShakingSats     airdrops shakepay    exchange
#> 6      Reward           ShakingSats     airdrops shakepay    exchange
formatted.shakepay <- format_shakepay(data_shakepay,
  referral = list(
    Date = c(
      "2021-05-07 21:25:36",
      "2021-05-17 21:25:36"
    ),
    Credit = c(30, 10)
  )
)
head(formatted.shakepay)
#>                  date currency    quantity total.price spot.rate transaction
#> 1 2021-05-07 14:50:41      BTC  0.00103982  53.0697400  51037.43         buy
#> 2 2021-05-07 21:25:36      CAD 30.00000000  30.0000000      1.00     revenue
#> 3 2021-05-08 12:12:57      BTC  0.00001100   0.5784024  52582.03     revenue
#> 4 2021-05-09 12:22:07      BTC  0.00001200   0.6034441  50287.01     revenue
#> 5 2021-05-17 21:25:36      CAD 10.00000000  10.0000000      1.00     revenue
#> 6 2021-05-21 12:47:14      BTC  0.00001300   0.7348590  56527.62     revenue
#>   description               comment revenue.type exchange rate.source
#> 1         Buy Bought @ CA$51,002.43         <NA> shakepay    exchange
#> 2      Reward       Referral reward    referrals shakepay    exchange
#> 3      Reward           ShakingSats     airdrops shakepay    exchange
#> 4      Reward           ShakingSats     airdrops shakepay    exchange
#> 5      Reward       Referral reward    referrals shakepay    exchange
#> 6      Reward           ShakingSats     airdrops shakepay    exchange
```
