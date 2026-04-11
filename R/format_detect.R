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

  descriptions <- trimws(as.character(data$Description))
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
  is.null(x) || is.data.frame(x) || .format_detect_is_valid_input_list(x)
}

.format_detect_is_empty_input <- function(x) {
  is.data.frame(x) && nrow(x) == 0
}

.format_detect_is_formatted_input <- function(x) {
  if (!is.data.frame(x)) {
    return(FALSE)
  }

  required_columns <- c("date", "currency", "quantity", "transaction")
  has_required_columns <- all(required_columns %in% names(x))
  has_price_columns <- any(c("total.price", "spot.rate") %in% names(x))
  has_origin_columns <- any(c("exchange", "rate.source") %in% names(x))

  has_required_columns && has_price_columns && has_origin_columns
}

.format_detect_is_valid_input_list <- function(x) {
  if (!is.list(x)) {
    return(FALSE)
  }

  all(vapply(x, .format_detect_is_valid_input, logical(1)))
}

.format_detect_requires_prices_input <- function(x) {
  if (is.null(x) || .format_detect_is_empty_input(x)) {
    return(FALSE)
  }

  if (.format_detect_is_formatted_input(x)) {
    return(FALSE)
  }

  if (is.data.frame(x)) {
    return(.format_detect_uses_prices(.format_detect_exchange(x)))
  }

  if (is.list(x)) {
    return(any(vapply(x, .format_detect_requires_prices_input, logical(1))))
  }

  FALSE
}

.validate_format_detect_list_prices <- function(data, list.prices = NULL) {
  if (is.null(list.prices) || .is_valid_list_prices_table(list.prices)) {
    return(TRUE)
  }

  if (!.format_detect_requires_prices_input(data)) {
    return(TRUE)
  }

  message(
    "Could not use 'list.prices' because it must contain ",
    "'currency', 'spot.rate2', and 'date2'."
  )
  FALSE
}

.validate_format_detect_prices_for_exchange <- function(exchange, list.prices = NULL) {
  if (is.null(list.prices) || .is_valid_list_prices_table(list.prices)) {
    return(TRUE)
  }

  if (!.format_detect_uses_prices(exchange)) {
    return(TRUE)
  }

  message(
    "Could not use 'list.prices' because it must contain ",
    "'currency', 'spot.rate2', and 'date2'."
  )
  FALSE
}

.drop_empty_format_detect_inputs <- function(data) {
  out <- lapply(data, function(x) {
    if (is.null(x) || .format_detect_is_empty_input(x)) {
      return(NULL)
    }

    if (is.data.frame(x)) {
      return(x)
    }

    if (is.list(x)) {
      nested <- .drop_empty_format_detect_inputs(x)
      if (length(nested) == 0) {
        return(NULL)
      }
      return(nested)
    }

    x
  })

  Filter(Negate(is.null), out)
}

.validate_format_detect_list_input <- function(data) {
  invalid <- !vapply(data, .format_detect_is_valid_input, logical(1))

  if (any(invalid)) {
    stop(
      "All elements supplied to format_detect.list() must be data frames, nested lists of data frames, or NULL."
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
#' it with the proper function for later ACB processing. This is the
#' lower-level auto-detection engine used by [format_exchanges()], which is
#' usually the clearer public entry point for end-to-end workflows.
#'
#' Lists may contain raw exchange files, already formatted transaction
#' tables, nested lists, and empty data frames; empty inputs are skipped and
#' already formatted tables are passed through unchanged.
#' @param data The dataframe
#' @param list.prices A `list.prices` object from which to fetch coin prices.
#' When supplied explicitly, it must contain at least `currency`,
#' `spot.rate2`, and `date2` for exchanges that require external pricing.
#' @param force Whether to force recreating `list.prices` even though
#' it already exists (e.g., if you added new coins or new dates).
#' @param ... Used for other methods.
#' @return A data frame of exchange transactions, formatted for further processing.
#' @examples
#' format_detect(data_shakepay)
#' format_detect(data_newton)
#' format_detect(list(data_shakepay, data_newton))
#' format_detect(list(data_shakepay[0, ], list(data_shakepay, data_newton)))
#' format_detect(list(format_shakepay(data_shakepay), data_newton))
#' @seealso [format_exchanges()] for the higher-level public workflow wrapper.
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

  if (!.validate_format_detect_prices_for_exchange(exchange, list.prices = list.prices)) {
    return(NULL)
  }

  if (.format_detect_uses_prices(exchange)) {
    return(formatter(data, list.prices = list.prices, force = force))
  }

  formatter(data)
}

.format_detect_formatted_list <- function(data, list.prices = NULL, force = FALSE) {
  data <- .validate_format_detect_list_input(data)
  data <- .drop_empty_format_detect_inputs(data)

  if (length(data) == 0) {
    return(list())
  }

  lapply(data, function(x) {
    if (is.data.frame(x) && .format_detect_is_formatted_input(x)) {
      return(x)
    }

    format_detect(x, list.prices = list.prices, force = force)
  })
}

.format_detect_many <- function(data, list.prices = NULL, force = FALSE) {
  if (!.validate_format_detect_list_prices(data, list.prices = list.prices)) {
    return(NULL)
  }

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
