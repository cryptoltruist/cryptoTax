#' Sample data sets provided by cryptotaxcalculator.io
#'
#' Data sets from cryptotaxcalculator.io to demonstrate adjusted cost base as 
#' well as capital gains/losses. Used as demo for our own [ACB()] function.
#'
#' @docType data
#' @format A data frame with 4 rows and 4 variables:
#' \describe{
#'   \item{date}{the date}
#'   \item{trade}{type of transaction}
#'   \item{currency}{the coin}
#'   \item{price}{the spot rate, in dollars}
#'   \item{quantity}{how much of the stock/coin}
#'   ...
#' }
#' @source \url{https://coinpanda.io/blog/crypto-taxes-canada-adjusted-cost-base/}
"cryptotaxcalculator.io1"

#' @rdname cryptotaxcalculator.io1
"cryptotaxcalculator.io2"
