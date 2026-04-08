.is_mergeable_exchange_input <- function(x) {
  is.data.frame(x) || is.null(x)
}

.flatten_merge_inputs <- function(inputs) {
  flattened <- lapply(inputs, function(x) {
    if (.is_mergeable_exchange_input(x)) {
      return(list(x))
    }

    if (is.list(x)) {
      return(.flatten_merge_inputs(x))
    }

    list(x)
  })

  unlist(flattened, recursive = FALSE)
}

.is_nonempty_merge_input <- function(x) {
  is.data.frame(x) && nrow(x) > 0
}

.normalize_merge_inputs <- function(inputs) {
  inputs <- .flatten_merge_inputs(inputs)
  Filter(is.data.frame, inputs)
}

.merge_exchanges_has_date <- function(data) {
  "date" %in% names(data)
}

.merge_exchanges_date_order <- function(data) {
  if (!.merge_exchanges_has_date(data)) {
    return(seq_len(nrow(data)))
  }

  order(is.na(data$date), data$date)
}

.sort_merged_exchanges <- function(data) {
  if (!.merge_exchanges_has_date(data)) {
    return(data)
  }

  data %>%
    dplyr::mutate(.missing.date = is.na(.data$date)) %>%
    dplyr::arrange(.data$.missing.date, .data$date) %>%
    dplyr::select(-".missing.date") %>%
    as.data.frame()
}

#' @title Merge formatted exchange transactions
#'
#' @description Merge formatted exchange transactions into one data frame.
#' Nested lists are flattened, `NULL` inputs are ignored, and rows with missing
#' dates are placed after dated rows.
#'
#' This is mainly a lower-level combiner for already formatted transaction
#' tables. For the common workflow of starting from raw exchange exports, use
#' [format_exchanges()] instead.
#' @param ... To pass the other exchanges to be merged.
#' @return A data frame, with rows binded and arranged, of the provided
#' data frames.
#' @export
#' @examples
#' shakepay <- format_shakepay(data_shakepay)
#' newton <- format_newton(data_newton)
#' merge_exchanges(shakepay, newton)
#' merge_exchanges(list(shakepay, list(NULL, newton)))
#' @seealso [format_exchanges()] for the higher-level public workflow wrapper.
#' @importFrom dplyr %>% bind_rows arrange
#' @importFrom rlang .data
merge_exchanges <- function(...) {
  inputs <- .normalize_merge_inputs(list(...))

  if (length(inputs) == 0) {
    return(data.frame())
  }

  bind_rows(inputs) %>% .sort_merged_exchanges()
}
