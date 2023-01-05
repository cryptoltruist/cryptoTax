#' @title Convert a cryptocurrency value to fiat (e.g., CAD)
#'
#' @description Format a .csv file from Newton for later ACB processing.
#' @param coin The coin
#' @param date The date
#' @param currency The currency
#' @export
#' @examples
#' \dontrun{
#' crypto2fiat(data)
#' }
#'
crypto2fiat <- function(coin, date, currency = "CAD") {
  ticker <- paste0(coin, "-", currency)
  suppressWarnings(tidyquant::tq_get(
    x = ticker,
    from = date,
    to = date,
    get = "stock.prices"
  )$adjusted)
}
