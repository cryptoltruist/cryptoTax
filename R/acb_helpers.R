.latest_rows_by_group <- function(x, group, date_col = "date") {
  group_sym <- if (is.character(group)) rlang::sym(group) else rlang::ensym(group)
  date_sym <- if (is.character(date_col)) rlang::sym(date_col) else rlang::ensym(date_col)

  x %>%
    dplyr::group_by(!!group_sym) %>%
    dplyr::filter(!!date_sym == max(!!date_sym)) %>%
    dplyr::slice_tail()
}

.negative_balance_rows <- function(formatted.ACB) {
  formatted.ACB %>%
    dplyr::filter(.data$total.quantity < 0)
}
