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

.resolve_report_today_data <- function(formatted.ACB,
                                       today.data,
                                       list.prices,
                                       slug,
                                       start.date,
                                       force,
                                       verbose = TRUE) {
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

  if (isTRUE(today.data) && (is.null(list.prices) || is.null(list.prices$date2))) {
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

  rates <- .report_current_price_assets(ACB.list) %>%
    dplyr::mutate(
      date.temp = .data$date,
      date = dplyr::last(list.prices$date2)
    )

  rates <- cryptoTax::match_prices(
    rates,
    list.prices = list.prices,
    force = force,
    verbose = verbose
  )

  if (isTRUE(verbose)) {
    message("Date of current prices: ", dplyr::last(list.prices$date2))
  }

  rates
}

.sup_losses_total <- function(sup.losses) {
  if (is.null(sup.losses) || nrow(sup.losses) == 0 || !"sup.loss" %in% names(sup.losses)) {
    return(0)
  }

  as.numeric(utils::tail(sup.losses[["sup.loss"]], 1))
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
