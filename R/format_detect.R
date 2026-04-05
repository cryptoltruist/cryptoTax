.format_detect_condition <- function(data) {
  data.names <- toString(names(data))
  registry <- .format_detect_registry()
  exchanges.cols <- vapply(registry$exchange, .format_detect_example_names, character(1))
  registry$exchange[data.names == exchanges.cols]
}

.format_detect_registry_row <- function(exchange) {
  registry <- .format_detect_registry()
  registry[registry$exchange == exchange, , drop = FALSE]
}

#' @title Detect transaction file exchange and format it
#'
#' @description Detect the exchange of a given transaction file and format
#' it with the proper function for later ACB processing.
#' @param data The dataframe
#' @param list.prices A `list.prices` object from which to fetch coin prices.
#' @param force Whether to force recreating `list.prices` even though
#' it already exists (e.g., if you added new coins or new dates).
#' @param ... Used for other methods.
#' @return A data frame of exchange transactions, formatted for further processing.
#' @examples
#' format_detect(data_shakepay)
#' format_detect(data_newton)
#' format_detect(list(data_shakepay, data_newton))
#' @importFrom dplyr %>% rename mutate select filter bind_rows
#' @importFrom rlang .data

#' @export
format_detect <- function(data, ...) {
  UseMethod("format_detect", data)
}

.format_detect_registry <- function() {
  data.frame(
    exchange = c(
      "adalite",
      "binance",
      "binance_withdrawals",
      "blockfi",
      "CDC",
      "CDC_exchange_rewards",
      "CDC_exchange_trades",
      "CDC_wallet",
      "celsius",
      "coinsmart",
      "exodus",
      "gemini",
      "newton",
      "pooltool",
      "presearch",
      "shakepay",
      "uphold"
    ),
    formatter = c(
      "format_adalite",
      "format_binance",
      "format_binance_withdrawals",
      "format_blockfi",
      "format_CDC",
      "format_CDC_exchange_rewards",
      "format_CDC_exchange_trades",
      "format_CDC_wallet",
      "format_celsius",
      "format_coinsmart",
      "format_exodus",
      "format_gemini",
      "format_newton",
      "format_pooltool",
      "format_presearch",
      "format_shakepay",
      "format_uphold"
    ),
    uses_prices = c(
      TRUE,
      TRUE,
      TRUE,
      TRUE,
      FALSE,
      TRUE,
      TRUE,
      TRUE,
      FALSE,
      TRUE,
      TRUE,
      TRUE,
      FALSE,
      FALSE,
      TRUE,
      FALSE,
      TRUE
    ),
    stringsAsFactors = FALSE
  )
}

.format_detect_example_names <- function(exchange) {
  ns <- asNamespace(utils::packageName())
  toString(names(get(paste0("data_", exchange), envir = ns)))
}

.resolve_format_detect_condition <- function(condition, data) {
  if (identical(condition, c("CDC_exchange_rewards", "CDC_wallet"))) {
    if (any(unlist(lapply(c("Supercharger", "Interest", "APR", "Rebate"), grepl, data$Description)))) {
      return("CDC_exchange_rewards")
    }

    if (any(unlist(lapply(c("Validator", "Auto Withdraw"), grepl, data$Description)))) {
      return("CDC_wallet")
    }
  }

  if (length(condition) == 0) {
    stop(
      "Could not identify the correct exchange automatically. ",
      "Please use the appropriate function or 'format_generic()'."
    )
  }

  if (length(condition) > 1) {
    stop("Matches multiple exchange names. Please report this bug so it can be fixed.")
  }

  condition
}

.run_format_detect_formatter <- function(exchange, data, list.prices = NULL, force = FALSE) {
  row <- .format_detect_registry_row(exchange)
  formatter <- get(row$formatter, mode = "function")

  if (isTRUE(row$uses_prices)) {
    return(formatter(data, list.prices = list.prices, force = force))
  }

  formatter(data)
}

#' @rdname format_detect
#' @export
format_detect.data.frame <- function(data, list.prices = NULL, force = FALSE, ...) {
  condition <- .format_detect_condition(data)
  condition <- .resolve_format_detect_condition(condition, data)

  formatted.data <- .run_format_detect_formatter(
    exchange = condition,
    data = data,
    list.prices = list.prices,
    force = force
  )

  message("Exchange detected: ", condition)

  formatted.data
}

#' @rdname format_detect
#' @export
format_detect.list <- function(data, list.prices = NULL, force = FALSE, ...) {
  formatted.data <- lapply(data, format_detect, list.prices = list.prices, force = force)
  formatted.data <- merge_exchanges(formatted.data)
  formatted.data
}
