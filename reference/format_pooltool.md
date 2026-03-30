# Format ADA rewards from blockchain CSV

Format a .csv transaction history file from the Cardano PoolTool for
later ACB processing. Instructions: Use https://pooltool.io/ click on
"rewards data for taxes", search your ADA address, scroll to the bottom
of the page, and use the export tool to export all transactions. Make
sure to use the "Generic(CSV)" format.

## Usage

``` r
format_pooltool(data, exchange = "exodus")
```

## Arguments

- data:

  The dataframe

- exchange:

  The name of the exchange to indicate in the resulting data frame.

## Value

A data frame of exchange transactions, formatted for further processing.

## Details

This is necessary e.g., if you used the Exodus wallet which does not
report ADA rewards in its transaction history file. The benefit of this
tool is that it provides rewards. However, it does not provide staking
costs, which are also taxable events.

## Examples

``` r
format_pooltool(data_pooltool)
#>                   date currency  quantity total.price spot.rate transaction
#> 1  2021-04-22 22:03:22      ADA 1.0827498    1.974017      1.82     revenue
#> 2  2021-04-27 22:22:14      ADA 0.8579850    1.565881      1.83     revenue
#> 3  2021-05-02 22:03:54      ADA 1.0193882    1.979399      1.94     revenue
#> 4  2021-05-07 22:54:38      ADA 1.0548971    1.790303      1.70     revenue
#> 5  2021-05-12 22:12:49      ADA 0.9443321    1.514525      1.60     revenue
#> 6  2021-05-17 22:47:25      ADA 1.0198183    1.426898      1.40     revenue
#> 7  2021-05-23 03:43:38      ADA 1.1605830    1.806024      1.56     revenue
#> 8  2021-05-27 22:07:57      ADA 1.0197753    1.589004      1.56     revenue
#> 9  2021-06-01 22:13:58      ADA 0.8392135    1.538300      1.83     revenue
#> 10 2021-06-06 22:14:11      ADA 1.1115378    2.072874      1.86     revenue
#>    description     comment revenue.type exchange rate.source
#> 1  epoch = 228 pool = REKT      staking   exodus    pooltool
#> 2  epoch = 229 pool = REKT      staking   exodus    pooltool
#> 3  epoch = 230 pool = REKT      staking   exodus    pooltool
#> 4  epoch = 231 pool = REKT      staking   exodus    pooltool
#> 5  epoch = 232 pool = REKT      staking   exodus    pooltool
#> 6  epoch = 233 pool = REKT      staking   exodus    pooltool
#> 7  epoch = 234 pool = REKT      staking   exodus    pooltool
#> 8  epoch = 235 pool = REKT      staking   exodus    pooltool
#> 9  epoch = 236 pool = REKT      staking   exodus    pooltool
#> 10 epoch = 237 pool = REKT      staking   exodus    pooltool
```
