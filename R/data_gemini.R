#' Sample data set of a fictive Gemini transaction history file
#'
#' A fictive Gemini data set to demonstrate [format_gemini()].
#'
#' @docType data
#' @format A data frame with 14 rows and 27 variables:
#' \describe{
#'   \item{Date}{the date}
#'   \item{Time (UTC)}{date in UTC}
#'   \item{Type}{transaction type}
#'   \item{Symbol}{currency or currency pair}
#'   \item{Specification}{description}
#'   \item{Liquidity Indicator}{maker or taker}
#'   \item{Trading Fee Rate (bps)}{trading fee rate}
#'   \item{BTC Amount BTC}{BTC quantity}
#'   \item{Fee (BTC) BTC}{BTC transaction fees}
#'   \item{BTC Balance BTC}{BTC balance}
#'   \item{LTC Amount LTC}{LTC quantity}
#'   \item{Fee (LTC) LTC}{LTC transaction fees}
#'   \item{LTC Balance LTC}{LTC balance}
#'   \item{BAT Amount BAT}{BAT quantity}
#'   \item{Fee (BAT) BAT}{BAT transaction fees}
#'   \item{BAT Balance BAT}{BAT balance}
#'   \item{Trade ID}{trade ID}
#'   \item{Order ID}{order ID}
#'   \item{Order Date}{order date}
#'   \item{Order Time}{order time}
#'   \item{Client Order ID}{client order ID}
#'   \item{API Session}{API session}
#'   \item{Tx Hash}{transaction hash}
#'   \item{Deposit Destination}{deposit destination address}
#'   \item{Deposit Tx Output}{deposit transaction output}
#'   \item{Withdrawal Destination}{withdrawal destination address}
#'   \item{Withdrawal Tx Output}{withdrawal transaction output}
#'   ...
#' }
#' @source \url{https://www.gemini.com/}
"data_gemini"