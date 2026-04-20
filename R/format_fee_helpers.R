#' @noRd
.arrange_formatted_transactions <- function(data, tie_breakers = character()) {
  sort_columns <- c("date", "total.price", tie_breakers)
  sort_columns <- sort_columns[sort_columns %in% names(data)]

  if (!nrow(data) || !length(sort_columns)) {
    return(data)
  }

  ordering <- lapply(sort_columns, function(column) {
    values <- data[[column]]

    if (identical(column, "total.price")) {
      return(-xtfrm(values))
    }

    xtfrm(values)
  })

  out <- data[do.call(order, c(ordering, list(na.last = TRUE))), , drop = FALSE]
  rownames(out) <- NULL
  out
}

#' @noRd
.format_fee_sell_rows <- function(data,
                                  filter_expr,
                                  fee_col,
                                  description_col = "description",
                                  description_value = NULL,
                                  comment_value = NULL,
                                  total_price_value = NULL) {
  out <- data %>%
    filter({{ filter_expr }}) %>%
    mutate(
      quantity = abs(.data[[fee_col]]),
      transaction = "sell"
    )

  if (!is.null(description_value)) {
    if (!description_col %in% names(out)) {
      out[[description_col]] <- rep(NA_character_, nrow(out))
    }
  }

  if (!is.null(comment_value)) {
    if (!"comment" %in% names(out)) {
      out[["comment"]] <- rep(NA_character_, nrow(out))
    }
  }

  if (!is.null(total_price_value)) {
    if (!"total.price" %in% names(out)) {
      out[["total.price"]] <- rep(NA_real_, nrow(out))
    }
  }

  if (!is.null(description_value) && nrow(out) > 0) {
    out[[description_col]] <- description_value
  }

  if (!is.null(comment_value) && nrow(out) > 0) {
    out <- out %>%
      mutate(comment = comment_value)
  }

  if (!is.null(total_price_value) && nrow(out) > 0) {
    out <- out %>%
      mutate(total.price = total_price_value)
  }

  out
}

#' @noRd
.finalize_formatted_exchange <- function(...,
                                         exchange,
                                         rate_source = NULL,
                                         columns = NULL,
                                         arrange = TRUE,
                                         tie_breakers = character()) {
  out <- merge_exchanges(...)

  if (!is.null(exchange)) {
    out <- out %>%
      mutate(exchange = exchange)
  }

  if (!is.null(rate_source)) {
    out <- out %>%
      mutate(rate.source = rate_source)
  }

  if (isTRUE(arrange)) {
    out <- .arrange_formatted_transactions(out, tie_breakers = tie_breakers)
  }

  if (is.null(columns)) {
    columns <- .formatted_transaction_output_columns()
  }

  required_columns <- intersect(.formatted_transaction_required_columns(), columns)
  missing_required_columns <- setdiff(required_columns, names(out))

  if (length(missing_required_columns) > 0) {
    stop(
      "Cannot finalize formatted exchange output. Missing required columns: ",
      paste(missing_required_columns, collapse = ", "),
      "."
    )
  }

  out %>%
    select(any_of(columns))
}

#' @noRd
.resolve_and_fill_formatted_prices <- function(data,
                                               list.prices = NULL,
                                               force = FALSE,
                                               warn_on_missing_spot = FALSE) {
  data <- .resolve_formatted_prices(
    data,
    list.prices = list.prices,
    force = force,
    warn_on_missing_spot = warn_on_missing_spot
  )
  if (is.null(data)) {
    return(NULL)
  }

  .fill_missing_total_price_from_spot(data)
}
