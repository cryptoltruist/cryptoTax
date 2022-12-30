#' @title List transactions by coin
#'
#' @description Provides a list of transactions, separated by coin..
#' @param ... To pass the other exchanges to be merged.
#' @keywords money crypto
#' @export
#' @examples
#' \dontrun{
#' merge_exchanges(formatted.data)
#' }
#' @importFrom dplyr %>% bind_rows arrange

merge_exchanges <- function(...) {
  list <- list(...)
  bind_rows(list) %>% arrange(date)
}
