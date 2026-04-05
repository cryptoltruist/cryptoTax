.normalize_merge_inputs <- function(inputs) {
  Filter(Negate(is.null), inputs)
}

#' @title Merge formatted exchange transactions
#'
#' @description Merge formatted exchange transactions into one data frame.
#' @param ... To pass the other exchanges to be merged.
#' @return A data frame, with rows binded and arranged, of the provided
#' data frames.
#' @export
#' @examples
#' shakepay <- format_shakepay(data_shakepay)
#' newton <- format_newton(data_newton)
#' merge_exchanges(shakepay, newton)
#' @importFrom dplyr %>% bind_rows arrange
merge_exchanges <- function(...) {
  inputs <- .normalize_merge_inputs(list(...))

  if (length(inputs) == 0) {
    return(data.frame())
  }

  bind_rows(inputs) %>% arrange(date)
}
