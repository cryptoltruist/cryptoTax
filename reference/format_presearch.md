# Format Presearch wallet file

Format a .csv transaction history file from Presearch for later ACB
processing.

## Usage

``` r
format_presearch(data, list.prices = NULL, force = FALSE)
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

  The way to download this file is to go to
  <https://account.presearch.com/tokens/pre-wallet> and click on the
  orange "Export to CSV" button at the bottom right of the screen.

  As of 2024-12-27, it seems like this file does not include search
  rewards anymore. One explanation is found on a [Reddit
  post](https://www.reddit.com/r/Presearch/comments/urqf34/comment/i8zj98s/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button):
  "you have to keep in mind that the tokens are considered the user's
  only when they hit the claim button." From a tax perspective, it makes
  sense that airdrops and rewards are only taxable once they become
  under the user's control. With Presearch, they are not under the
  user's control until the minimum withdrawal amount (1000) is reached.
  Therefore, moving forward, we will use this new strategy.

## Value

A data frame of exchange transactions, formatted for further processing.

## Examples

``` r
format_presearch(data_presearch)
#> Using deprecated legacy '.GlobalEnv' cache for 'list.prices'. This compatibility path may be removed in a future release; prefer `pricing_cache()` or pass `list.prices` explicitly. To force a fresh download, use argument 'force = TRUE'.
#>                  date currency quantity total.price  spot.rate transaction
#> 1 2021-01-02 19:08:59      PRE     1000   17.286345 0.01728634     revenue
#> 2 2021-04-27 19:12:15      PRE     1000   93.074345 0.09307434     revenue
#> 3 2021-05-07 05:55:33      PRE     1000   78.969090 0.07896909         buy
#> 4 2021-12-09 06:24:22      PRE       10    3.195957 0.31959575     revenue
#>                                       description revenue.type  exchange
#> 1                        Transferred from Rewards     airdrops presearch
#> 2                        Transferred from Rewards     airdrops presearch
#> 3 Transferred from Presearch Portal (PO#: 412893)         <NA> presearch
#> 4        Presearch 2021 Airdrop (Increased Stake)     airdrops presearch
#>     rate.source
#> 1 coinmarketcap
#> 2 coinmarketcap
#> 3 coinmarketcap
#> 4 coinmarketcap
```
