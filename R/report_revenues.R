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
#' all.data <- format_shakepay(data_shakepay)
#' formatted.ACB <- format_ACB(all.data, verbose = FALSE)
#' report_revenues(formatted.ACB)
#' @importFrom dplyr %>% filter mutate group_by select summarize slice arrange
#' add_row across full_join
#' @importFrom rlang .data
report_revenues <- function(formatted.ACB, tax.year = "all",
                             local.timezone = Sys.timezone()) {
  # Add revenues report!!
  revenues <- formatted.ACB %>%
    filter(.data$transaction == "revenue")

  if (tax.year != "all") {
    revenues <- revenues %>%
      mutate(datetime.local = lubridate::with_tz(.data$date, tz = local.timezone)) %>%
      filter(lubridate::year(.data$datetime.local) == tax.year)
    message("Note: revenues have been filtered for tax year ", tax.year)
  }

  # Get all revenues for selected year
  sum(revenues$value)

  # Get all revenues for selected year
  revenues.total <- revenues %>%
    group_by(.data$exchange) %>%
    select("exchange", "date", "value") %>%
    rename(last.date = "date") %>%
    summarize(total.revenues = sum(.data$value, na.rm = TRUE))

  revenues.dates <- revenues %>%
    group_by(.data$exchange) %>%
    summarize(date = .safe_datetime_max(.data$date, local.timezone))

  # Combine everything together
  table <- c(
    list(revenues.dates, revenues.total),
    .revenue_type_tables(revenues)
  ) %>%
    Reduce(function(dtf1, dtf2) full_join(dtf1, dtf2, by = "exchange"), .)

  table <- table %>%
    rename(date.last = "date") %>%
    slice(1) %>%
    arrange(desc(.data$total.revenues)) %>%
    as.data.frame()

  # Add total
  table <- table %>%
    add_row(
      exchange = "total",
      date.last = .safe_datetime_max(table$date.last, local.timezone),
      summarize(., across(tidyselect::where(is.numeric), \(x) sum(x, na.rm = TRUE)))
    ) %>%
    mutate(
      currency = "CAD",
      across(tidyselect::where(is.numeric), \(x) round(x, 2))
    )
  table %>% 
    select("exchange", "date.last", "total.revenues", "interests",
           "rebates", "staking", "promos", "airdrops", "referrals",
           "rewards", "forks", "mining", "currency")
}



