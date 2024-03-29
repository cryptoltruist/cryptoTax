#' Sample data set of a fictive Crypto.com wallet transaction history file
#'
#' A fictive Crypto.com wallet data set to demonstrate [format_CDC_wallet()].
#'
#' @docType data
#' @format A data frame with 10 rows and 12 variables:
#' \describe{
#'   \item{Date}{the date}
#'   \item{Sent.Amount}{sent quantity}
#'   \item{Sent.Currency}{sent currency}
#'   \item{Received.Amount}{received quantity}
#'   \item{Received.Currency}{received currency}
#'   \item{Fee.Amount}{fee quantity}
#'   \item{Fee.Currency}{fee currency}
#'   \item{Net.Worth.Amount}{net worth quantity}
#'   \item{Net.Worth.Currency}{net worth currency}
#'   \item{Label}{transaction type}
#'   \item{Description}{description}
#'   \item{TxHash}{transaction hash}
#'   ...
#' }
#' @source \url{https://crypto.com/defi-wallet}
"data_CDC_wallet"
