# Format CDC wallet file

Format a .csv transaction history file from the Crypto.com DeFi wallet
for later ACB processing.

One way to download the CRO staking rewards data from the blockchain is
to visit http://crypto.barkisoft.de/ and input your CRO address. Keep
the default export option ("Koinly"). It will output a CSV file with
your transactions. Note: the site does not use a secure connection: use
at your own risks. The file is semi-column separated; when using
`read.csv`, add the `sep = ";"` argument.

Superseded by
[`fetch_cronos_pos()`](https://cryptoltruist.github.io/cryptoTax/reference/fetch_cronos_pos.md)
and
[`format_cronos_pos()`](https://cryptoltruist.github.io/cryptoTax/reference/format_cronos_pos.md)
since http://crypto.barkisoft.de/ does not provide a valid CSV file
anymore.

## Usage

``` r
format_CDC_wallet(data, list.prices = NULL, force = FALSE)
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
format_CDC_wallet(data_CDC_wallet)
#> Using cached 'list.prices'. To force a fresh download, use argument 'force = TRUE'.
#>                  date currency quantity  total.price spot.rate transaction
#> 1 2021-04-12 18:28:50      CRO 0.512510 1.359843e-01 0.2653300     revenue
#> 2 2021-04-18 18:28:50      CRO 0.000200 5.561116e-05 0.2780558        sell
#> 3 2021-04-23 18:51:53      CRO 1.656708 3.601218e-01 0.2173720     revenue
#> 4 2021-04-25 18:51:53      CRO 0.000200 4.177234e-05 0.2088617        sell
#> 5 2021-05-21 01:19:01      CRO 0.000200 2.992587e-05 0.1496293        sell
#> 6 2021-06-25 04:11:53      CRO 0.000200 2.406829e-05 0.1203414        sell
#> 7 2021-06-26 14:51:02      CRO 6.051235 7.078748e-01 0.1169802     revenue
#>    description
#> 1       Reward
#> 2 staking cost
#> 3       Reward
#> 4 staking cost
#> 5   Withdrawal
#> 6 staking cost
#> 7       Reward
#>                                                                                                     comment
#> 1                                                                                Auto Withdraw Reward from 
#> 2                                                            Stake on Validator(abcdefghijklmnopqrstuvwxyz)
#> 3                                                                                Auto Withdraw Reward from 
#> 4                                                        Unstake from Validator(abcdefghijklmnopqrstuvwxyz)
#> 5                                                        Outgoing Transaction to abcdefghijklmnopqrstuvwxyz
#> 6 Move 530.41289045 CRO from Validator(abcdefghijklmnopqrstuvwxyz) to Validator(abcdefghijklmnopqrstuvwxyz)
#> 7                                                           Withdraw Reward from abcdefghijklmnopqrstuvwxyz
#>   revenue.type   exchange   rate.source
#> 1      staking CDC.wallet coinmarketcap
#> 2         <NA> CDC.wallet coinmarketcap
#> 3      staking CDC.wallet coinmarketcap
#> 4         <NA> CDC.wallet coinmarketcap
#> 5         <NA> CDC.wallet coinmarketcap
#> 6         <NA> CDC.wallet coinmarketcap
#> 7      staking CDC.wallet coinmarketcap
```
