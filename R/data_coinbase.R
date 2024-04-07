#' Sample data set of a fictive Coinbase transaction history file
#'
#' A fictive Coinbase data set to demonstrate [format_coinbase()].
#'
#' @docType data
#' @format A data frame with 5 rows and 10 variables:
#' \describe{
#'   \item{Timestamp}{the date}
#'   \item{Transaction.Type}{transaction type}
#'   \item{Asset}{coin}
#'   \item{Quantity.Transacted}{quantity}
#'   \item{Spot.Price.Currency}{currency of spot price}
#'   \item{Spot.Price.at.Transaction}{spot price}
#'   \item{Subtotal}{subtotal}
#'   \item{Total..inclusive.of.fees.and.or.spread.}{Grand total}
#'   \item{Fees.and.or.Spread}{fees}
#'   \item{Notes}{comments}
#'   ...
#' }
#' @source \url{https://www.coinbase.com/}
"data_coinbase"