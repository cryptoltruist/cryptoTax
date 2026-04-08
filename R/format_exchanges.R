#' @title Format One or More Exchange Files
#'
#' @description Format one or more exchange transaction files into the
#' canonical transaction table used throughout `cryptoTax`.
#' This is a user-facing wrapper around [format_detect()] for the common
#' workflow of passing a single exchange file, a list of raw exchange files,
#' or a mixed list containing already formatted transaction tables.
#'
#' Empty data frames and `NULL` list entries are skipped. Already formatted
#' transaction tables are passed through unchanged.
#'
#' @param data A data frame, or a (possibly nested) list of exchange data
#' frames and/or already formatted transaction tables.
#' @param ... Additional exchange data frames or nested lists to format.
#' @param list.prices A `list.prices` object from which to fetch coin prices.
#' @param force Whether to force recreating `list.prices` even though
#' it already exists (e.g., if you added new coins or new dates).
#' @return A data frame of exchange transactions, formatted for further
#' processing.
#' @export
#' @examples
#' format_exchanges(data_shakepay)
#' format_exchanges(data_shakepay, data_newton)
#' format_exchanges(list(data_shakepay, data_newton))
#' format_exchanges(list(format_shakepay(data_shakepay), data_newton))
#' @seealso [format_detect()] for the lower-level exchange auto-detection
#' engine, and the specific `format_*()` functions for manual exchange-by-
#' exchange formatting.
format_exchanges <- function(data, ..., list.prices = NULL, force = FALSE) {
  extra_inputs <- list(...)

  if (length(extra_inputs) > 0) {
    data <- c(list(data), extra_inputs)
  }

  format_detect(data, list.prices = list.prices, force = force)
}
