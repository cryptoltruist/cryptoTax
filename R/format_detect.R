.format_detect_signature <- function(data) {
  toString(names(data))
}

.format_detect_registry_signatures <- function(registry) {
  vapply(registry$exchange, .format_detect_example_names, character(1))
}

.format_detect_description_values <- function(data) {
  if (!("Description" %in% names(data))) {
    return(character())
  }

  descriptions <- as.character(data$Description)
  descriptions[!is.na(descriptions) & nzchar(descriptions)]
}

.format_detect_description_matches <- function(data, patterns) {
  descriptions <- .format_detect_description_values(data)

  if (!length(descriptions)) {
    return(FALSE)
  }

  any(unlist(lapply(patterns, grepl, descriptions)), na.rm = TRUE)
}

.format_detect_condition <- function(data) {
  registry <- .format_detect_registry()
  exchanges.cols <- .format_detect_registry_signatures(registry)
  registry$exchange[.format_detect_signature(data) == exchanges.cols]
}

.format_detect_registry_row <- function(exchange) {
  registry <- .format_detect_registry()
  registry[registry$exchange == exchange, , drop = FALSE]
}

.has_format_detect_registry_row <- function(exchange) {
  nrow(.format_detect_registry_row(exchange)) > 0
}

.validate_format_detect_exchange <- function(exchange) {
  if (!.has_format_detect_registry_row(exchange)) {
    stop("Unknown exchange in format-detect registry: ", exchange)
  }

  exchange
}

.format_detect_formatter_name <- function(exchange) {
  exchange <- .validate_format_detect_exchange(exchange)
  .format_detect_registry_row(exchange)$formatter[[1]]
}

.format_detect_uses_prices <- function(exchange) {
  exchange <- .validate_format_detect_exchange(exchange)
  isTRUE(.format_detect_registry_row(exchange)$uses_prices[[1]])
}

.format_detect_is_valid_input <- function(x) {
  is.null(x) || is.data.frame(x)
}

.validate_format_detect_list_input <- function(data) {
  invalid <- !vapply(data, .format_detect_is_valid_input, logical(1))

  if (any(invalid)) {
    stop(
      "All elements supplied to format_detect.list() must be data frames or NULL."
    )
  }

  data
}

.has_format_detect_condition <- function(condition) {
  length(condition) > 0
}

.format_detect_has_multiple_conditions <- function(condition) {
  length(condition) > 1
}

.format_detect_exchange <- function(data) {
  condition <- .format_detect_condition(data)
  .resolve_format_detect_condition(condition, data)
}

.format_detect_message <- function(exchange) {
  message("Exchange detected: ", exchange)
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

.format_detect_example_data <- function(exchange) {
  ns <- asNamespace(utils::packageName())
  get(paste0("data_", exchange), envir = ns)
}

.format_detect_example_names <- function(exchange) {
  toString(names(.format_detect_example_data(exchange)))
}

.resolve_format_detect_condition <- function(condition, data) {
  if (identical(condition, c("CDC_exchange_rewards", "CDC_wallet"))) {
    if (.format_detect_description_matches(data, c("Supercharger", "Interest", "APR", "Rebate"))) {
      return("CDC_exchange_rewards")
    }

    if (.format_detect_description_matches(data, c("Validator", "Auto Withdraw"))) {
      return("CDC_wallet")
    }
  }

  if (!.has_format_detect_condition(condition)) {
    stop(
      "Could not identify the correct exchange automatically. ",
      "Please use the appropriate function or 'format_generic()'."
    )
  }

  if (.format_detect_has_multiple_conditions(condition)) {
    stop("Matches multiple exchange names. Please report this bug so it can be fixed.")
  }

  condition
}

.run_format_detect_formatter <- function(exchange, data, list.prices = NULL, force = FALSE) {
  formatter <- get(.format_detect_formatter_name(exchange), mode = "function")

  if (.format_detect_uses_prices(exchange)) {
    return(formatter(data, list.prices = list.prices, force = force))
  }

  formatter(data)
}

.format_detect_formatted_list <- function(data, list.prices = NULL, force = FALSE) {
  data <- .validate_format_detect_list_input(data)
  data <- Filter(Negate(is.null), data)

  if (length(data) == 0) {
    return(list())
  }

  lapply(data, format_detect, list.prices = list.prices, force = force)
}

.format_detect_many <- function(data, list.prices = NULL, force = FALSE) {
  formatted.data <- .format_detect_formatted_list(
    data,
    list.prices = list.prices,
    force = force
  )
  merge_exchanges(formatted.data)
}

#' @rdname format_detect
#' @export
format_detect.data.frame <- function(data, list.prices = NULL, force = FALSE, ...) {
  condition <- .format_detect_exchange(data)

  formatted.data <- .run_format_detect_formatter(
    exchange = condition,
    data = data,
    list.prices = list.prices,
    force = force
  )

  .format_detect_message(condition)

  formatted.data
}

#' @rdname format_detect
#' @export
format_detect.list <- function(data, list.prices = NULL, force = FALSE, ...) {
  .format_detect_many(data, list.prices = list.prices, force = force)
}
