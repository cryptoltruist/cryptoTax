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

  A `list.prices` object from which to fetch coin prices.

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
#> Could not reach the CoinMarketCap API at this time
#> Could not reach the CoinMarketCap API at this time
#> Could not reach the CoinMarketCap API at this time
#> NULL
```
