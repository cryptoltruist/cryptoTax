.filter_formatted_acb_tax_year <- function(formatted.ACB, tax.year, local.timezone, label) {
  formatted.ACB.year <- formatted.ACB %>%
    dplyr::mutate(datetime.local = lubridate::with_tz(.data$date, tz = local.timezone))

  if (!identical(tax.year, "all")) {
    formatted.ACB.year <- formatted.ACB.year %>%
      dplyr::filter(lubridate::year(.data$datetime.local) == tax.year)
    message("Note: ", label, " have been filtered for tax year ", tax.year)
  }

  formatted.ACB.year
}

.can_use_report_today_prices <- function(list.prices) {
  .is_valid_list_prices_table(list.prices) &&
    !is.null(list.prices$date2)
}

.report_current_price_date <- function(list.prices) {
  if (!.can_use_report_today_prices(list.prices)) {
    return(NULL)
  }

  dplyr::last(list.prices$date2)
}

.resolve_report_cached_prices <- function(list.prices, force, verbose = TRUE) {
  if (!is.null(list.prices)) {
    return(list.prices)
  }

  .resolve_list_prices(
    force = force,
    list.prices = NULL,
    verbose = verbose
  )
}

.resolve_report_today_data <- function(formatted.ACB,
                                       today.data,
                                       list.prices,
                                       slug,
                                       start.date,
                                       force,
                                       verbose = TRUE) {
  if (isTRUE(today.data)) {
    list.prices <- .resolve_report_cached_prices(
      list.prices = list.prices,
      force = force,
      verbose = verbose
    )
  }

  if (isTRUE(today.data) && is.null(list.prices) && isFALSE(curl::has_internet())) {
    if (isTRUE(verbose)) {
      message("You need Internet access to use the `today.data == TRUE` argument. The today.data argument has been set to `FALSE` automatically.")
    }
    return(list(today.data = FALSE, list.prices = list.prices))
  }

  if (isTRUE(today.data) && is.null(list.prices)) {
    list.prices <- prepare_list_prices_slugs(
      formatted.ACB,
      list.prices = list.prices,
      slug = slug,
      start.date = start.date,
      force = force,
      verbose = verbose
    )
  }

  if (isTRUE(today.data) && !is.null(list.prices) && !.can_use_report_today_prices(list.prices)) {
    if (isTRUE(verbose)) {
      message(
        "Could not use 'list.prices' for today.data because it must contain ",
        "'currency', 'spot.rate2', and 'date2'. The today.data argument has been set to `FALSE` automatically."
      )
    }
    today.data <- FALSE
  }

  if (isTRUE(today.data) && is.null(.report_current_price_date(list.prices))) {
    if (isTRUE(verbose)) {
      message("Could not reach pricing data at this time. The today.data argument has been set to `FALSE` automatically.")
    }
    today.data <- FALSE
  }

  list(today.data = today.data, list.prices = list.prices)
}

.report_current_price_assets <- function(ACB.list) {
  ACB.list %>%
    dplyr::filter(
      .data$currency != "GB",
      !grepl("NFT", .data$currency)
    )
}

.report_current_price_notes <- function(ACB.list, signal = c("message", "warning"), verbose = TRUE) {
  signal <- match.arg(signal)

  if (!isTRUE(verbose)) {
    return(invisible(NULL))
  }

  signal_fn <- switch(signal,
    message = message,
    warning = warning
  )

  if (any(ACB.list$currency %in% "GB")) {
    signal_fn("1. GB transactions are excluded from today's data because it is not listed on CoinMarketCap.")
  }

  if (any(grepl("NFT", ACB.list$currency))) {
    signal_fn("2. NFTs are excluded from today's data because NFTs are not listed individually on CoinMarketCap.")
  }

  invisible(NULL)
}

.prepare_report_current_rates <- function(ACB.list, list.prices, force, verbose = TRUE, signal = c("message", "warning")) {
  signal <- match.arg(signal)
  .report_current_price_notes(ACB.list, signal = signal, verbose = verbose)
  current.price.date <- .report_current_price_date(list.prices)

  rates <- .report_current_price_assets(ACB.list) %>%
    dplyr::mutate(
      date.temp = .data$date,
      date = current.price.date
    )

  rates <- cryptoTax::match_prices(
    rates,
    list.prices = list.prices,
    force = force,
    verbose = verbose
  )

  if (isTRUE(verbose)) {
    message("Date of current prices: ", current.price.date)
  }

  rates
}

.report_latest_acb <- function(formatted.ACB) {
  formatted.ACB %>%
    dplyr::group_by(.data$currency) %>%
    dplyr::filter(.data$date == max(.data$date)) %>%
    dplyr::slice_tail() %>%
    dplyr::select("date", "currency", "total.quantity", "ACB.share", "ACB")
}

.sup_losses_total_row <- function(sup.losses) {
  if (is.null(sup.losses) || nrow(sup.losses) == 0) {
    return(NULL)
  }

  if ("currency" %in% names(sup.losses)) {
    total.row <- sup.losses[sup.losses$currency == "Total", , drop = FALSE]
    if (nrow(total.row) > 0) {
      return(utils::tail(total.row, 1))
    }
  }

  utils::tail(sup.losses, 1)
}

.sup_losses_total <- function(sup.losses) {
  total.row <- .sup_losses_total_row(sup.losses)

  if (is.null(total.row) || !"sup.loss" %in% names(total.row)) {
    return(0)
  }

  as.numeric(total.row[["sup.loss"]][[1]])
}

.table_revenues_total_row <- function(table.revenues) {
  if (is.null(table.revenues) || nrow(table.revenues) == 0) {
    return(NULL)
  }

  if ("exchange" %in% names(table.revenues)) {
    total.row <- table.revenues[table.revenues$exchange == "total", , drop = FALSE]
    if (nrow(total.row) > 0) {
      return(utils::tail(total.row, 1))
    }
  }

  utils::tail(table.revenues, 1)
}

.table_revenues_amount <- function(table.revenues, column) {
  total.row <- .table_revenues_total_row(table.revenues)

  if (is.null(total.row) || !column %in% names(total.row)) {
    return(0)
  }

  as.numeric(total.row[[column]][[1]])
}

.table_revenues_income_total <- function(table.revenues) {
  .table_revenues_amount(table.revenues, "staking") +
    .table_revenues_amount(table.revenues, "interests")
}

.report_summary_amount <- function(report.summary, type, default = NA_character_) {
  if (!"Type" %in% names(report.summary) || !"Amount" %in% names(report.summary)) {
    return(default)
  }

  row <- report.summary[report.summary$Type == type, , drop = FALSE]

  if (nrow(row) == 0) {
    return(default)
  }

  row$Amount[[1]]
}
