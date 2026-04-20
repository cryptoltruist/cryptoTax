# Format a generic transaction file

Format a generic .csv transaction history file. This function requires
one transaction per row, so will not work with trades of two coins
reported on the same row. For this you will have to split the trade on
two rows and have a single currency column per row.

## Usage

``` r
format_generic(
  data,
  date = "date",
  currency = "currency",
  quantity = "quantity",
  total.price = "total.price",
  spot.rate = "spot.rate",
  transaction = "transaction",
  fees = "fees",
  description = "description",
  comment = "comment",
  revenue.type = "revenue.type",
  exchange = "exchange",
  timezone = "UTC",
  force = FALSE,
  list.prices = NULL
)
```

## Arguments

- data:

  The dataframe

- date:

  The date column

- currency:

  The currency column

- quantity:

  The quantity column

- total.price:

  The total.price column, if available

- spot.rate:

  The spot.rate column, if available

- transaction:

  The transaction column

- fees:

  The fees column, if available

- description:

  The description column, if available

- comment:

  The comment column, if available

- revenue.type:

  The revenue.type column, if available (content can be one of
  `c("airdrops", "referrals", "staking", "promos", "interests", "rebates", "rewards", "forks", "mining")`)

- exchange:

  The exchange column

- timezone:

  The time zone of the transactions

- force:

  Whether to force recreating `list.prices` even though it already
  exists (e.g., if you added new coins or new dates).

- list.prices:

  An optional explicit `list.prices` object from which to fetch coin
  prices. For exchanges that require external pricing, it must contain
  at least `currency`, `spot.rate2`, and `date2`.

## Value

A data frame of exchange transactions, formatted for further processing.

## Examples

``` r
# Detects correct names even with capitals
format_generic(data_generic1)
#>                  date currency quantity total.price  spot.rate transaction fees
#> 1 2021-03-02 10:36:06      BTC 0.001240       50.99 41120.9677         buy 0.72
#> 2 2021-03-10 12:49:04      ETH 0.063067       50.99   808.5052         buy 0.72
#> 3 2021-03-15 14:12:08      ETH 0.065048      150.99  2321.2090        sell 1.75
#>           exchange rate.source
#> 1 generic_exchange    exchange
#> 2 generic_exchange    exchange
#> 3 generic_exchange    exchange

# In other cases, names can be specified explicitly:
format_generic(
  data_generic2,
  date = "Date.Transaction",
  currency = "Coin",
  quantity = "Amount",
  total.price = "Price",
  transaction = "Type",
  fees = "Fee",
  exchange = "Platform"
)
#>                  date currency quantity total.price  spot.rate transaction fees
#> 1 2021-03-02 10:36:06      BTC 0.001240       50.99 41120.9677         buy 0.72
#> 2 2021-03-10 12:49:04      ETH 0.063067       50.99   808.5052         buy 0.72
#> 3 2021-03-15 14:12:08      ETH 0.065048      150.99  2321.2090        sell 1.75
#>           exchange rate.source
#> 1 generic_exchange    exchange
#> 2 generic_exchange    exchange
#> 3 generic_exchange    exchange

# If total.price is missing, it will calculate it based
# on the spot.rate, if available
format_generic(data_generic3)
#>                  date currency quantity total.price  spot.rate transaction fees
#> 1 2021-03-02 10:36:06      BTC 0.001240       50.99 41120.9677         buy 0.72
#> 2 2021-03-10 12:49:04      ETH 0.063067       50.99   808.5052         buy 0.72
#> 3 2021-03-15 14:12:08      ETH 0.065048      150.99  2321.2090        sell 1.75
#>           exchange
#> 1 generic_exchange
#> 2 generic_exchange
#> 3 generic_exchange

# If both total.price and spot.rate are missing, it will
# scrap the spot.rate from coinmarketcap based on the coin:
format_generic(data_generic4)
#> Using cached 'list.prices'. To force a fresh download, use argument 'force = TRUE'.
#> Warning: Could not calculate spot rate. Use `force = TRUE`.
#>                  date currency quantity total.price spot.rate transaction fees
#> 1 2021-03-02 10:36:06      BTC 0.001240    76.70861  61861.78         buy 0.72
#> 2 2021-03-10 12:49:04      ETH 0.063067          NA        NA         buy 0.72
#> 3 2021-03-15 14:12:08      ETH 0.065048          NA        NA        sell 1.75
#>           exchange   rate.source
#> 1 generic_exchange coinmarketcap
#> 2 generic_exchange coinmarketcap
#> 3 generic_exchange coinmarketcap
```
