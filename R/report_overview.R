.report_overview_group_totals <- function(formatted.ACB.year) {
  list(
    net = formatted.ACB.year %>%
      group_by(.data$currency) %>%
      summarize(net = sum(.data$gains, na.rm = TRUE)),
    gains = formatted.ACB.year %>%
      group_by(.data$currency) %>%
      filter(.data$gains > 0) %>%
      summarize(gains = sum(.data$gains, na.rm = TRUE)),
    losses = formatted.ACB.year %>%
      group_by(.data$currency) %>%
      filter(.data$gains < 0) %>%
      summarize(losses = sum(.data$gains, na.rm = TRUE))
  )
}

.report_overview_prepare_rates <- function(rates) {
  rates %>%
    mutate(
      rate.today = .data$spot.rate,
      value.today = round(.data$total.quantity * .data$rate.today, 2),
      unrealized.net = round(.data$value.today - ACB, 2),
      unrealized.gains = ifelse(.data$unrealized.net > 0,
        .data$unrealized.net,
        NA
      ),
      unrealized.losses = ifelse(.data$unrealized.net < 0,
        .data$unrealized.net,
        NA
      ),
      currency2 = .data$currency
    ) %>%
    select(
      "currency", "rate.today", "value.today", "unrealized.gains",
      "unrealized.losses", "unrealized.net", "currency2"
    )
}

.report_overview_total_row <- function(full, today.data) {
  total.columns <- if (isTRUE(today.data)) {
    c("total.cost", "gains", "losses", "net", "value.today", "unrealized.gains", "unrealized.losses", "unrealized.net")
  } else {
    c("total.cost", "gains", "losses", "net")
  }
  total.columns <- intersect(total.columns, names(full))

  full %>%
    add_row(
      date.last = max(full$date.last),
      currency = "Total",
      currency2 = "Total",
      summarize(., across(dplyr::all_of(total.columns), \(x) sum(x, na.rm = TRUE)))
    )
}

.report_overview_full_table <- function(ACB.list, grouped.totals, rates = NULL, today.data = FALSE) {
  pieces <- c(list(ACB.list), grouped.totals, list(rates))
  pieces <- Filter(Negate(is.null), pieces)

  full <- Reduce(function(dtf1, dtf2) full_join(dtf1, dtf2, by = "currency"), pieces) %>%
    rename(
      date.last = "date",
      total.cost = "ACB",
      cost.share = "ACB.share"
    ) %>%
    group_by(.data$currency)

  if (isTRUE(today.data)) {
    full <- full %>%
      mutate(across("cost.share":"unrealized.gains", \(x) round(x, 2))) %>%
      as.data.frame()
  } else {
    full <- full %>%
      mutate(
        across("cost.share":"net", \(x) round(x, 2)),
        currency2 = .data$currency
      ) %>%
      as.data.frame()
  }

  .report_overview_total_row(full, today.data = today.data)
}

.report_overview_filter_year <- function(formatted.ACB, tax.year, local.timezone, verbose) {
  if (identical(tax.year, "all")) {
    return(formatted.ACB)
  }

  formatted.ACB.year <- formatted.ACB %>%
    mutate(datetime.local = lubridate::with_tz(.data$date, tz = local.timezone)) %>%
    filter(lubridate::year(.data$datetime.local) == tax.year)

  if (isTRUE(verbose)) {
    message("gains, losses, and net have been filtered for tax year ", tax.year)
  }

  formatted.ACB.year
}

.report_overview_finalize <- function(full) {
  last.col <- last(full)

  full %>%
    slice(1:(n() - 1)) %>%
    mutate(cost.gains = .data$total.cost + .data$gains) %>%
    arrange(
      desc(.data$cost.gains),
      desc(.data$gains),
      desc(.data$total.cost),
      desc(.data$cost.share),
      desc(.data$losses),
      desc(.data$total.quantity)
    ) %>%
    select(-"cost.gains") %>%
    bind_rows(last.col)
}

.report_overview_from_price_state <- function(formatted.ACB,
                                              today.data,
                                              tax.year,
                                              local.timezone,
                                              list.prices,
                                              rates = NULL,
                                              force = FALSE,
                                              verbose = TRUE) {
  formatted.ACB <- formatted.ACB %>%
    filter(.data$currency != "CAD")

  formatted.ACB.year <- .report_overview_filter_year(
    formatted.ACB = formatted.ACB,
    tax.year = tax.year,
    local.timezone = local.timezone,
    verbose = verbose
  )
  grouped.totals <- .report_overview_group_totals(formatted.ACB.year)
  ACB.list <- .report_latest_acb(formatted.ACB)

  if (isTRUE(today.data) && is.null(rates)) {
    rates <- .prepare_report_current_rates(
      ACB.list = ACB.list,
      list.prices = list.prices,
      force = force,
      verbose = verbose,
      signal = "warning"
    )
  }

  if (isTRUE(today.data)) {
    full <- .report_overview_full_table(
      ACB.list = ACB.list,
      grouped.totals = grouped.totals,
      rates = .report_overview_prepare_rates(rates),
      today.data = TRUE
    )
  }

  if (isFALSE(today.data)) {
    full <- .report_overview_full_table(
      ACB.list = ACB.list,
      grouped.totals = grouped.totals,
      today.data = FALSE
    )
  }

  .report_overview_finalize(full)
}

#' @title Summary of ACB
#'
#' @description Provides a summary of Adjusted Cost Base (ACB) per share, as well as realized and unrealized gains/losses (plus net value), per coin.
#' @param formatted.ACB The formatted ACB data.
#' @param today.data whether to fetch today's data.
#' @param tax.year Which tax year(s) to include.
#' @param local.timezone Which time zone to use for the date of the report.
#' @param list.prices A `list.prices` object from which to fetch coin prices.
#' For `today.data = TRUE`, it must contain at least `currency`,
#' `spot.rate2`, and `date2`.
#' @param slug Optional explicit slug vector used when preparing prices.
#' @param start.date Optional explicit start date used when preparing prices.
#' @param verbose Logical; whether to print progress messages.
#' @param force Whether to force recreating `list.prices` even though
#' it already exists (e.g., if you added new coins or new dates).
#' @return A summary data frame, containing at least the following columns:
#' date.last, currency, total.quantity, cost.share, total.cost, gains,
#' losses, net, currency.
#' @export
#' @examples
#' all.data <- format_exchanges(data_shakepay)
#' formatted.ACB <- format_ACB(all.data, verbose = FALSE)
#' report_overview(formatted.ACB, today.data = FALSE)
#' @importFrom dplyr %>% filter mutate group_by summarize slice_tail bind_rows
#' arrange add_row across full_join last n
report_overview <- function(formatted.ACB, 
                             today.data = TRUE, 
                             tax.year = "all",
                             local.timezone = Sys.timezone(),
                            list.prices = NULL,
                            slug = NULL,
                            start.date = NULL,
                            force = FALSE,
                            verbose = TRUE) {
  price.state <- .resolve_report_today_data(
    formatted.ACB = formatted.ACB,
    today.data = today.data,
    list.prices = list.prices,
    slug = slug,
    start.date = start.date,
    force = force,
    verbose = verbose
  )
  today.data <- price.state$today.data
  list.prices <- price.state$list.prices

  .report_overview_from_price_state(
    formatted.ACB = formatted.ACB,
    today.data = today.data,
    tax.year = tax.year,
    local.timezone = local.timezone,
    list.prices = list.prices,
    force = force,
    verbose = verbose
  )
}

