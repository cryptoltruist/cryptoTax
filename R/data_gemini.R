#' Sample data set of a fictive Gemini transaction history file
#'
#' A fictive Gemini data set to demonstrate [format_gemini()].
#'
#' @docType data
#' @format A data frame with 8 rows and 17 variables:
#' \describe{
#'   \item{DATE}{the date}
#'   \item{TYPE}{transaction type}
#'   \item{FROMPORTFOLIO}{from where}
#'   \item{TOPORTFOLIO}{to where}
#'   \item{OUTAMOUNT}{quantity sent}
#'   \item{OUTCURRENCY}{currency sent}
#'   \item{FEEAMOUNT}{the fees}
#'   \item{FEECURRENCY}{fee currency}
#'   \item{TOADDRESS}{address sent to}
#'   \item{OUTTXID}{transaction ID for out transactions}
#'   \item{OUTTXURL}{transaction URL for out transactions}
#'   \item{INAMOUNT}{quantity received}
#'   \item{INCURRENCY}{currency received}
#'   \item{INTXID}{transaction ID for in transactions}
#'   \item{INTXURL}{transaction URL for in transactions}
#'   \item{ORDERID}{order ID}
#'   \item{PERSONALNOTE}{personal notes}
#'   ...
#' }
#' @source \url{https://www.gemini.com/}
"data_gemini"