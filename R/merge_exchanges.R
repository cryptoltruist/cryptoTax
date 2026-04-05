.flatten_merge_inputs <- function(inputs) {
  flattened <- lapply(inputs, function(x) {
    if (is.null(x) || is.data.frame(x)) {
      return(list(x))
    }

    if (is.list(x)) {
      return(.flatten_merge_inputs(x))
    }

    list(x)
  })

  unlist(flattened, recursive = FALSE)
}

.normalize_merge_inputs <- function(inputs) {
  inputs <- .flatten_merge_inputs(inputs)
  Filter(function(x) is.data.frame(x), inputs)
}

.sort_merged_exchanges <- function(data) {
  if (!("date" %in% names(data))) {
    return(data)
  }

  arrange(data, .data$date)
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
#' @importFrom rlang .data
merge_exchanges <- function(...) {
  inputs <- .normalize_merge_inputs(list(...))

  if (length(inputs) == 0) {
    return(data.frame())
  }

  bind_rows(inputs) %>% .sort_merged_exchanges()
}
