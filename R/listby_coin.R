.listby_coin_names <- function(formatted.ACB) {
  unique(sort(formatted.ACB$currency))
}

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
#' @importFrom dplyr group_by group_map
#' @importFrom rlang .data
listby_coin <- function(formatted.ACB) {
  formatted.ACB %>%
    group_by(.data$currency) %>%
    group_map(~ as.data.frame(.x), .keep = TRUE) %>%
    stats::setNames(.listby_coin_names(formatted.ACB))
}
