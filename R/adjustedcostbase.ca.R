#' Sample data sets provided by adjustedcostbase.ca
#'
#' Data sets from adjustedcostbase.ca to demonstrate adjusted cost base as well as
#' capital gains/losses. Used as demo for our own [ACB()] function.
#'
#' @docType data
#' @format Data frames with 4 variables:
#' \describe{
#'   \item{date}{the date}
#'   \item{transaction}{buy or sell}
#'   \item{quantity}{how much of the stock/coin}
#'   \item{price}{the spot rate, in dollars}
#'   \item{fees}{any transaction fees}
#'   ...
#' }
#' @source \url{https://www.adjustedcostbase.ca/blog/how-to-calculate-adjusted-cost-base-acb-and-capital-gains/, https://www.adjustedcostbase.ca/blog/what-is-the-superficial-loss-rule/}
"adjustedcostbase.ca1"

#' @rdname adjustedcostbase.ca1
"adjustedcostbase.ca2"

#' @rdname adjustedcostbase.ca1
"adjustedcostbase.ca3"

#' @rdname adjustedcostbase.ca1
"adjustedcostbase.ca4"

#' @rdname adjustedcostbase.ca1
"adjustedcostbase.ca5"

#' @rdname adjustedcostbase.ca1
"adjustedcostbase.ca6"
