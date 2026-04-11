# Format Adalite wallet file

Format a .csv transaction history file from the Adalite wallet for later
ACB processing.

## Usage

``` r
format_adalite(data, list.prices = NULL, force = FALSE)
```

## Arguments

- data:

  The dataframe

- list.prices:

  An optional explicit `list.prices` object from which to fetch coin
  prices. For exchanges that require external pricing, it must contain
  at least `currency`, `spot.rate2`, and `date2`.

- force:

  Whether to force recreating `list.prices` even though it already
  exists (e.g., if you added new coins or new dates).

## Value

A data frame of exchange transactions, formatted for further processing.

## Examples

``` r
data <- data_adalite
format_adalite(data)
#> Object 'list.prices' already exists. Reusing 'list.prices'. To force a fresh download, use argument 'force = TRUE'.
#>                  date currency  quantity total.price spot.rate transaction
#> 1 2021-04-28 16:56:00      ADA 0.3120400   0.5092906  1.632132     revenue
#> 2 2021-05-07 16:53:00      ADA 0.3125132   0.6272258  2.007038     revenue
#> 3 2021-05-12 16:56:00      ADA 0.2212410   0.4437400  2.005686     revenue
#> 4 2021-05-17 17:16:00      ADA 0.4123210   1.0790423  2.616996     revenue
#> 5 2021-05-17 21:16:00      ADA 0.1691870   0.4427617  2.616996        sell
#> 6 2021-05-17 21:31:00      ADA 0.1912300   0.5004481  2.616996        sell
#>      description        comment revenue.type exchange   rate.source
#> 1 Reward awarded           <NA>      staking  adalite coinmarketcap
#> 2 Reward awarded           <NA>      staking  adalite coinmarketcap
#> 3 Reward awarded           <NA>      staking  adalite coinmarketcap
#> 4 Reward awarded           <NA>      staking  adalite coinmarketcap
#> 5           Sent Withdrawal Fee         <NA>  adalite coinmarketcap
#> 6           Sent Withdrawal Fee         <NA>  adalite coinmarketcap
```
