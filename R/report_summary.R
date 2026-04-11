.report_summary_amount_total <- function(formatted.ACB.year, predicate = NULL, column = "gains") {
  data <- formatted.ACB.year

  if (!is.null(predicate)) {
    data <- dplyr::filter(data, !!predicate)
  }

  sum(data[[column]], na.rm = TRUE)
}

.report_summary_static_metrics <- function(formatted.ACB.year, ACB.list) {
  list(
    gains = .report_summary_amount_total(
      formatted.ACB.year,
      predicate = rlang::quo(.data$gains > 0)
    ),
    losses = .report_summary_amount_total(
      formatted.ACB.year,
      predicate = rlang::quo(.data$gains < 0)
    ),
    net = sum(formatted.ACB.year$gains, na.rm = TRUE),
    total.cost = sum(ACB.list$ACB, na.rm = TRUE),
    revenue = .report_summary_amount_total(
      formatted.ACB.year,
      predicate = rlang::quo(.data$transaction == "revenue"),
      column = "value"
    )
  )
}

.report_summary_today_metrics <- function(rates, ACB.list, static.metrics) {
  value.today <- sum(rates$value.today, na.rm = TRUE)
  unrealized.gains <- sum(rates$unrealized.gains, na.rm = TRUE)
  unrealized.losses <- sum(rates$unrealized.losses, na.rm = TRUE)
  unrealized.net <- sum(rates$unrealized.net, na.rm = TRUE)
  percentage.up <- (value.today / sum(ACB.list$ACB, na.rm = TRUE) - 1) * 100
  all.time.up.CAD <- value.today + static.metrics$net
  all.time.up <- (all.time.up.CAD / sum(ACB.list$ACB, na.rm = TRUE) - 1) * 100
  all.time.up.revenue.CAD <- all.time.up.CAD + static.metrics$revenue
  all.time.up.revenue <- (all.time.up.revenue.CAD / sum(ACB.list$ACB, na.rm = TRUE) - 1) * 100

  list(
    value.today = value.today,
    unrealized.gains = unrealized.gains,
    unrealized.losses = unrealized.losses,
    unrealized.net = unrealized.net,
    percentage.up = percentage.up,
    all.time.up = all.time.up,
    all.time.up.revenue = all.time.up.revenue
  )
}

.report_summary_table <- function(metrics, tax.year) {
  format_metric <- function(name, value) {
    if (name %in% c("percentage.up", "all.time.up", "all.time.up.revenue")) {
      return(paste0(formatC_2(value), "%"))
    }

    formatC_2(value)
  }

  metric.order <- names(metrics)
  amounts <- vapply(metric.order, function(name) format_metric(name, metrics[[name]]), character(1))

  data.frame(
    Type = c("tax.year", metric.order),
    Amount = c(as.character(tax.year), amounts),
    currency = "CAD",
    stringsAsFactors = FALSE
  )
}

.report_summary_filter_year <- function(formatted.ACB, tax.year, local.timezone) {
  if (identical(tax.year, "all")) {
    return(formatted.ACB)
  }

  formatted.ACB %>%
    mutate(datetime.local = lubridate::with_tz(.data$date, tz = local.timezone)) %>%
    filter(lubridate::year(.data$datetime.local) == tax.year)
}

.report_summary_latest_acb <- function(formatted.ACB) {
  formatted.ACB %>%
    group_by(.data$currency) %>%
    filter(.data$date == max(.data$date)) %>%
    slice_tail() %>%
    select("date", "currency", "total.quantity", "ACB.share", "ACB")
}

#' @title Summary of gains and losses
#'
#' @description Provides a summary of realized capital gains and losses (and total).
#' @param formatted.ACB The formatted ACB data.
#' @param today.data whether to fetch today's data.
#' @param tax.year Which tax year(s) to include.
#' @param local.timezone Which time zone to use for the date of the report.
#' @param list.prices A `list.prices` object from which to fetch coin prices.
#' For `today.data = TRUE`, it must contain at least `currency`,
#' `spot.rate2`, and `date2`.
#' @param slug Optional explicit slug vector used when preparing prices.
#' @param start.date Optional explicit start date used when preparing prices.
#' @param force Whether to force recreating `list.prices` even though
#' it already exists (e.g., if you added new coins or new dates).
#' @return A summary data frame, containing at least the following columns:
#' Type, Amount, currency.
#' @export
#' @examples
#' all.data <- format_exchanges(data_shakepay)
#' formatted.ACB <- format_ACB(all.data, verbose = FALSE)
#' report_summary(formatted.ACB, today.data = FALSE)
#' @importFrom dplyr %>% filter mutate group_by ungroup select summarize
#' slice_tail arrange add_row rename
#' @importFrom rlang .data
report_summary <- function(formatted.ACB,
                           today.data = TRUE,
                           tax.year = "all",
                           local.timezone = Sys.timezone(),
                           list.prices = NULL,
                           slug = NULL,
                           start.date = NULL,
                           force = FALSE) {
  formatted.ACB <- formatted.ACB %>%
    filter(.data$currency != "CAD")

  ACB.list <- .report_summary_latest_acb(formatted.ACB)

  if (tax.year != "all") {
    formatted.ACB.year <- .report_summary_filter_year(formatted.ACB, tax.year, local.timezone)
    message(
      "gains, losses, and net have been filtered for tax year ",
      tax.year, " (time zone = ", local.timezone, ")"
    )
  } else {
    formatted.ACB.year <- formatted.ACB
  }

  static.metrics <- .report_summary_static_metrics(formatted.ACB.year, ACB.list)

  price.state <- .resolve_report_today_data(
    formatted.ACB = formatted.ACB,
    today.data = today.data,
    list.prices = list.prices,
    slug = slug,
    start.date = start.date,
    force = force,
    verbose = TRUE
  )
  today.data <- price.state$today.data
  list.prices <- price.state$list.prices

  if (isTRUE(today.data)) {
    rates <- .prepare_report_current_rates(
      ACB.list = ACB.list,
      list.prices = list.prices,
      force = force,
      signal = "message"
    )

    rates <- rates %>%
      mutate(
        rate.today = .data$spot.rate,
        value.today = round(.data$total.quantity * .data$rate.today, 2),
        unrealized.net = round(.data$value.today - .data$ACB, 2),
        unrealized.gains = ifelse(.data$unrealized.net > 0,
          .data$unrealized.net,
          NA
        ),
        unrealized.losses = ifelse(.data$unrealized.net < 0,
          .data$unrealized.net,
          NA
        )
      ) %>%
      select(
        "currency", "rate.today", "value.today", "unrealized.gains",
        "unrealized.losses", "unrealized.net"
      )

    today.metrics <- .report_summary_today_metrics(rates, ACB.list, static.metrics)

    metrics <- c(
      static.metrics[setdiff(names(static.metrics), "revenue")],
      today.metrics,
      revenue = static.metrics$revenue
    )
  }

  if (isFALSE(today.data)) {
    metrics <- static.metrics
  }

  .report_summary_table(metrics, tax.year)
}

formatC_2 <- function(x) {formatC(unlist(unlist(x)), format = "f", big.mark = ",", digits = 2)}

