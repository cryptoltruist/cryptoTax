#' @title View rows with negative total balances
#'
#' @description View rows with negative total balances to help identify missing transactions.
#' @param formatted.ACB The formatted.ACB file
#' @export
#' @examples
#' all.data <- format_shakepay(data_shakepay)
#' formatted.ACB <- format_ACB(all.data)
#' check_missing_transactions(formatted.ACB)
#' @importFrom dplyr %>% rename mutate select filter bind_rows group_by slice_tail
#' @importFrom rlang .data

check_missing_transactions <- function(formatted.ACB) {
  formatted.ACB %>% 
    filter(.data$total.quantity < 0)
}
