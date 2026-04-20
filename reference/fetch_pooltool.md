# Download Cardano staking rewards in PoolTool-compatible format

Downloads Cardano staking reward history for a stake or payment address
using the public Koios API and returns a data frame shaped like the
PoolTool generic CSV export. This can be passed directly to
[`format_pooltool()`](https://cryptoltruist.github.io/cryptoTax/reference/format_pooltool.md)
or saved locally as a CSV file.

This helper intentionally does not scrape PoolTool. PoolTool's web UI
can be stale or change without notice, while the reward history itself
is available from chain indexer APIs. The returned columns follow the
PoolTool export layout closely enough for
[`format_pooltool()`](https://cryptoltruist.github.io/cryptoTax/reference/format_pooltool.md)
to consume them unchanged.

## Usage

``` r
fetch_pooltool(
  address,
  currency = "CAD",
  save.path = NULL,
  format = FALSE,
  exchange = "exodus",
  perform = TRUE,
  list.prices = NULL,
  force = FALSE,
  verbose = TRUE
)
```

## Arguments

- address:

  A Cardano stake address (`stake1...`) or payment/base address
  (`addr1...`).

- currency:

  Local fiat currency for reward values. Currently only `CAD` is
  supported. Defaults to `"CAD"`.

- save.path:

  Optional file path. When provided, the returned data frame is also
  written to disk as a CSV file.

- format:

  Logical; if `TRUE`, return
  [`format_pooltool()`](https://cryptoltruist.github.io/cryptoTax/reference/format_pooltool.md)
  output instead of the raw PoolTool-compatible table.

- exchange:

  Exchange label passed to
  [`format_pooltool()`](https://cryptoltruist.github.io/cryptoTax/reference/format_pooltool.md)
  when `format = TRUE`. Defaults to `"exodus"` to preserve current
  package behavior.

- perform:

  Whether to execute the API requests (if `TRUE`), or just return the
  request objects that would be used (if `FALSE`).

- list.prices:

  Optional `list.prices` object to use for pricing reward dates.
  Supplying this keeps the workflow deterministic and avoids implicit
  online pricing lookups.

- force:

  Passed through to
  [`match_prices()`](https://cryptoltruist.github.io/cryptoTax/reference/match_prices.md)
  when price data must be resolved.

- verbose:

  Logical; whether to print progress messages.

## Value

A data frame in PoolTool generic-CSV shape, or formatted exchange
transactions when `format = TRUE`.

## Examples

``` r
fetch_pooltool(
  "stake1u88nvynpjl3lsj6wf8k7p9pxj6ta58rx2jfttqqpkumrlpsf6zeud",
  perform = FALSE
)
#> $account_rewards
#> <httr2_request>
#> POST https://api.koios.rest/api/v1/account_rewards
#> Headers:
#> * accept      : "application/json"
#> * content-type: "application/json"
#> Body: JSON data
#> 
```
