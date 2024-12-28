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
#'   \item{Book.Cost}{value of transaction (CAD)}
#'   \item{Book.Cost.Currency}{currency of Book.Cost (CAD)}
#'   \item{Type}{transaction type}
#'   \item{Description}{Buy, Sell, Send, or Reward}
#'   \item{Mid.Market.Rate}{market rate}
#'   \item{Spot.Rate}{transaction spot rate on Shakepay}
#' }
#' @source \url{https://shakepay.com/}
"data_shakepay"
