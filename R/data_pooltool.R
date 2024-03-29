#' Sample data set of a fictive Cardano PoolTool transaction history file
#'
#' A fictive Cardano PoolTool data set to demonstrate [format_pooltool()].
#'
#' @docType data
#' @format A data frame with 10 rows and 12 variables:
#' \describe{
#'   \item{date}{the date}
#'   \item{epoch}{the epoch}
#'   \item{stake}{total staked}
#'   \item{pool}{staking pool}
#'   \item{operator_rewards}{rewards for operator}
#'   \item{stake_rewards}{rewards for staking}
#'   \item{total_rewards}{rewards for operator + staking}
#'   \item{rate}{(usually) CAD rate}
#'   \item{currency}{(usually) CAD}
#'   \item{operator_rewards_value}{(usually) CAD value for operator rewards}
#'   \item{stake_rewards_value}{(usually) CAD value for staking rewards}
#'   \item{value}{(usually) CAD value for operator + staking rewards}
#'   ...
#' }
#' @source \url{https://pooltool.io/}
"data_pooltool"