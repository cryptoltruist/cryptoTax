#' @title List transactions by coin
#'
#' @description Provides a list of transactions, separated by coin.
#' @param formatted.ACB The dataframe
#' @return A list of formatted data frames, by coin.
#' @export
#' @examples
#' all.data <- format_shakepay(data_shakepay)
#' formatted.ACB <- format_ACB(all.data, verbose = FALSE)
#' listby_coin(formatted.ACB)
listby_coin <- function(formatted.ACB) {
  .split_formatted_acb_by_group(formatted.ACB, "currency") %>%
    stats::setNames(.listby_coin_names(formatted.ACB))
}
