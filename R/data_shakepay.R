#' Sample data set of a fictive Shakepay transaction history file
#'
#' A fictive Shakepay data set to demonstrate [format_shakepay()].
#'
#' @docType data
#' @format A data frame with 8 rows and 11 variables:
#' \describe{
#'   \item{Date}{the date}
#'   \item{Amount.Debited}{amount debited}
#'   \item{Asset.Debited}{currency debited}
#'   \item{Amount.Credited}{amount credited}
#'   \item{Asset.Credited}{currency credited}
#'   \item{Market.Value}{market value}
#'   \item{Market.Value.Currency}{market value currency}
#'   \item{Book.Cost}{value of transaction (CAD)}
#'   \item{Book.Cost.Currency}{currency of Book.Cost (CAD)}
#'   \item{Type}{transaction type}
#'   \item{Spot.Rate}{transaction spot rate on Shakepay}
#'   \item{Buy...Sell.Rate}{Buy / sell rate}
#'   \item{Description}{Buy, Sell, Send, or Reward}
#' }
#' @source \url{https://shakepay.com/}
"data_shakepay"
