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
#> Using cached 'list.prices'. To force a fresh download, use argument 'force = TRUE'.
#> Warning: Could not calculate spot rate. Use `force = TRUE`.
#>                  date currency  quantity total.price spot.rate transaction
#> 1 2021-04-28 16:56:00      ADA 0.3120400          NA        NA     revenue
#> 2 2021-05-07 16:53:00      ADA 0.3125132          NA        NA     revenue
#> 3 2021-05-12 16:56:00      ADA 0.2212410          NA        NA     revenue
#> 4 2021-05-17 17:16:00      ADA 0.4123210          NA        NA     revenue
#> 5 2021-05-17 21:16:00      ADA 0.1691870          NA        NA        sell
#> 6 2021-05-17 21:31:00      ADA 0.1912300          NA        NA        sell
#>      description        comment revenue.type exchange   rate.source
#> 1 Reward awarded           <NA>      staking  adalite coinmarketcap
#> 2 Reward awarded           <NA>      staking  adalite coinmarketcap
#> 3 Reward awarded           <NA>      staking  adalite coinmarketcap
#> 4 Reward awarded           <NA>      staking  adalite coinmarketcap
#> 5           Sent Withdrawal Fee         <NA>  adalite coinmarketcap
#> 6           Sent Withdrawal Fee         <NA>  adalite coinmarketcap
```
