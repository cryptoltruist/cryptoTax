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

.latest_transaction_dates <- function(formatted.ACB) {
  .latest_rows_by_group(formatted.ACB, "exchange") %>%
    dplyr::select("exchange", "date")
}

.listby_coin_names <- function(formatted.ACB) {
  unique(sort(formatted.ACB$currency))
}

.split_formatted_acb_by_group <- function(formatted.ACB, group) {
  group_sym <- if (is.character(group)) rlang::sym(group) else rlang::ensym(group)

  formatted.ACB %>%
    dplyr::group_by(!!group_sym) %>%
    dplyr::group_map(~ as.data.frame(.x), .keep = TRUE)
}

.total_sup_loss_table <- function(formatted.ACB.year) {
  total.sup.loss <- formatted.ACB.year %>%
    dplyr::summarize(sup.loss = sum(.data$gains.sup, na.rm = TRUE)) %>%
    dplyr::mutate(sup.loss = round(.data$sup.loss, 2))

  if (identical(total.sup.loss$sup.loss[[1]], 0)) {
    return(data.frame(currency = character(), sup.loss = numeric()))
  }

  data.frame(
    currency = "Total",
    sup.loss = total.sup.loss$sup.loss,
    stringsAsFactors = FALSE
  )
}
