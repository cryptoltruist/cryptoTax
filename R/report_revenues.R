.report_revenue_types <- c(
  "airdrops",
  "referrals",
  "staking",
  "promos",
  "interests",
  "rebates",
  "rewards",
  "forks",
  "mining"
)

.report_revenues_columns <- function() {
  c(
    "exchange", "date.last", "total.revenues", "interests",
    "rebates", "staking", "promos", "airdrops", "referrals",
    "rewards", "forks", "mining", "currency"
  )
}

.report_revenues_numeric_columns <- function(table) {
  names(table)[vapply(table, is.numeric, logical(1))]
}

.safe_datetime_max <- function(x, local.timezone) {
  if (length(x) == 0 || all(is.na(x))) {
    return(as.POSIXct(NA, tz = local.timezone))
  }

  max(x, na.rm = TRUE)
}

.summarize_revenue_type <- function(revenues, revenue.type) {
  revenue_type_value <- revenue.type

  result <- revenues %>%
    group_by(.data$exchange) %>%
    filter(.data$revenue.type == revenue_type_value) %>%
    summarize(value = sum(.data$value, na.rm = TRUE))

  names(result)[names(result) == "value"] <- revenue.type
  result
}

.revenue_type_tables <- function(revenues) {
  lapply(.report_revenue_types, function(revenue.type) {
    .summarize_revenue_type(revenues, revenue.type)
  })
}

.report_revenues_filter_year <- function(revenues, tax.year, local.timezone) {
  if (tax.year == "all") {
    return(revenues)
  }

  revenues %>%
    mutate(datetime.local = lubridate::with_tz(.data$date, tz = local.timezone)) %>%
    filter(lubridate::year(.data$datetime.local) == tax.year)
}

.report_revenues_rows <- function(formatted.ACB) {
  formatted.ACB %>%
    filter(.data$transaction == "revenue")
}

.report_revenues_has_rows <- function(revenues) {
  nrow(revenues) > 0
}

.empty_report_revenues_table <- function(local.timezone) {
  data.frame(
    exchange = "total",
    date.last = as.POSIXct(NA, tz = local.timezone),
    total.revenues = 0,
    interests = 0,
    rebates = 0,
    staking = 0,
    promos = 0,
    airdrops = 0,
    referrals = 0,
    rewards = 0,
    forks = 0,
    mining = 0,
    currency = "CAD",
    stringsAsFactors = FALSE
  )
}

.report_revenues_totals <- function(revenues) {
  revenues %>%
    group_by(.data$exchange) %>%
    select("exchange", "date", "value") %>%
    rename(last.date = "date") %>%
    summarize(total.revenues = sum(.data$value, na.rm = TRUE))
}

.report_revenues_dates <- function(revenues, local.timezone) {
  revenues %>%
    group_by(.data$exchange) %>%
    summarize(date = .safe_datetime_max(.data$date, local.timezone))
}

.report_revenues_combined_table <- function(revenues, local.timezone) {
  c(
    list(
      .report_revenues_dates(revenues, local.timezone),
      .report_revenues_totals(revenues)
    ),
    .revenue_type_tables(revenues)
  ) %>%
    Reduce(function(dtf1, dtf2) full_join(dtf1, dtf2, by = "exchange"), .)
}

.report_revenues_total_row <- function(table, local.timezone) {
  numeric.columns <- .report_revenues_numeric_columns(table)
  total.row <- as.list(stats::setNames(rep(NA, ncol(table)), names(table)))
  total.row$exchange <- "total"
  total.row$date.last <- .safe_datetime_max(table$date.last, local.timezone)

  for (column in numeric.columns) {
    total.row[[column]] <- sum(table[[column]], na.rm = TRUE)
  }

  dplyr::bind_rows(table, total.row)
}

#' @noRd
.report_revenues_finalize_table <- function(table, local.timezone) {
  table <- table %>%
    rename(date.last = "date") %>%
    arrange(desc(.data$total.revenues)) %>%
    as.data.frame()

  table <- .report_revenues_total_row(table, local.timezone) %>%
    .report_revenues_round_numeric()

  .report_revenues_select_columns(table)
}

#' @noRd
.report_revenues_round_numeric <- function(table) {
  table %>%
    mutate(
      currency = "CAD",
      across(tidyselect::where(is.numeric), \(x) round(x, 2))
    )
}

#' @noRd
.report_revenues_select_columns <- function(table) {
  table %>%
    select(all_of(.report_revenues_columns()))
}

#' @title Report all revenues
#'
#' @description Provides a summary of revenues from all sources.
#' @param formatted.ACB The formatted ACB data.
#' @param tax.year Which tax year(s) to include.
#' @param local.timezone Which time zone to use for the date of the report.
#' @return A data frame, with the following columns: exchange, date.last,
#' total.revenues, airdrops, referrals, staking, promos, interests, rebates,
#' rewards, forks, mining, currency.
#' @export
#' @examples
#' all.data <- format_exchanges(data_shakepay)
#' formatted.ACB <- format_ACB(all.data, verbose = FALSE)
#' report_revenues(formatted.ACB)
#' @importFrom dplyr %>% filter mutate group_by select summarize slice arrange
#' add_row across full_join
#' @importFrom rlang .data
report_revenues <- function(formatted.ACB, tax.year = "all",
                             local.timezone = Sys.timezone()) {
  revenues <- .report_revenues_rows(formatted.ACB)

  revenues <- .report_revenues_filter_year(
    revenues,
    tax.year = tax.year,
    local.timezone = local.timezone
  )

  if (tax.year != "all") {
    message("Note: revenues have been filtered for tax year ", tax.year)
  }

  if (!.report_revenues_has_rows(revenues)) {
    return(.empty_report_revenues_table(local.timezone))
  }

  # Combine everything together
  table <- .report_revenues_combined_table(revenues, local.timezone)

  .report_revenues_finalize_table(table, local.timezone)
}



