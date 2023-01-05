#' @title List transactions by coin
#'
#' @description Provides a list of transactions, separated by coin..
#' @param data The dataframe
#' @export
#' @examples
#' \dontrun{
#' listby_coin(formatted.ACB)
#' }
#' @importFrom dplyr group_by group_map
#' @importFrom rlang .data

listby_coin <- function(data) {
  gains.group <- data %>%
    group_by(.data$currency) %>%
    group_map(~ as.data.frame(.x), .keep = TRUE) %>%
    stats::setNames(unique(sort(data$currency)))
  gains.group
}
