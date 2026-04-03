#' Offline example `list.prices` fixture
#'
#' A built-in `list.prices` dataset for examples, tests, and offline
#' experimentation. It contains deterministic daily CAD-denominated price rows
#' across 2021-2023 for the main coin set used by the package's report and
#' integration-test workflows.
#'
#' @format A data frame with 13140 rows and 11 variables:
#' \describe{
#'   \item{timestamp}{POSIXct timestamp for the fixture row.}
#'   \item{slug}{Coin slug used by CoinMarketCap-style lookups.}
#'   \item{name}{Display name of the asset.}
#'   \item{currency}{Ticker symbol, such as `BTC` or `USD`.}
#'   \item{open}{Opening price used for the fixture row.}
#'   \item{close}{Closing price used for the fixture row.}
#'   \item{spot.rate_USD}{USD-denominated spot rate when relevant.}
#'   \item{CAD.rate}{USD-to-CAD conversion used for the fixture row when relevant.}
#'   \item{spot.rate2}{Final CAD-denominated spot rate used by `match_prices()`.}
#'   \item{date}{Date column retained for compatibility with `list.prices` outputs.}
#'   \item{date2}{Date used by `match_prices()` joins.}
#' }
#' @source Deterministic offline fixture generated for package examples and tests.
"list_prices_example"

