#' @title List transactions by coin
#'
#' @description Provides a list of transactions, separated by coin..
#' @param ... To pass the other exchanges to be merged.
#' @export
#' @examples
#' shakepay <- format_shakepay(data_shakepay)
#' newton <- format_newton(data_newton)
#' merge_exchanges(shakepay, newton)
#' @importFrom dplyr %>% bind_rows arrange

merge_exchanges <- function(...) {
  list <- list(...)
  bind_rows(list) %>% arrange(date)
}
