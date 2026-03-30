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
  safe_datetime_max <- function(x) {
    if (length(x) == 0 || all(is.na(x))) {
      return(as.POSIXct(NA, tz = local.timezone))
    }

    max(x, na.rm = TRUE)
  }

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
  revenues2 <- revenues %>%
    group_by(.data$exchange) %>%
    select("exchange", "date", "value") %>%
    rename(last.date = "date") %>%
    summarize(total.revenues = sum(.data$value, na.rm = TRUE))

  revenues.dates <- revenues %>%
    group_by(.data$exchange) %>%
    summarize(date = safe_datetime_max(.data$date))

  # Add revenue.type
  airdrops <- revenues %>%
    group_by(.data$exchange) %>%
    filter(.data$revenue.type == "airdrops") %>%
    summarize(airdrops = sum(.data$value, na.rm = TRUE))

  referrals <- revenues %>%
    group_by(.data$exchange) %>%
    filter(.data$revenue.type == "referrals") %>%
    summarize(referrals = sum(.data$value, na.rm = TRUE))

  staking <- revenues %>%
    group_by(.data$exchange) %>%
    filter(.data$revenue.type == "staking") %>%
    summarize(staking = sum(.data$value, na.rm = TRUE))

  promos <- revenues %>%
    group_by(.data$exchange) %>%
    filter(.data$revenue.type == "promos") %>%
    summarize(promos = sum(.data$value, na.rm = TRUE))

  interests <- revenues %>%
    group_by(.data$exchange) %>%
    filter(.data$revenue.type == "interests") %>%
    summarize(interests = sum(.data$value, na.rm = TRUE))

  rebates <- revenues %>%
    group_by(.data$exchange) %>%
    filter(.data$revenue.type == "rebates") %>%
    summarize(rebates = sum(.data$value, na.rm = TRUE))

  rewards <- revenues %>%
    group_by(.data$exchange) %>%
    filter(.data$revenue.type == "rewards") %>%
    summarize(rewards = sum(.data$value, na.rm = TRUE))

  forks <- revenues %>%
    group_by(.data$exchange) %>%
    filter(.data$revenue.type == "forks") %>%
    summarize(forks = sum(.data$value, na.rm = TRUE))

  mining <- revenues %>%
    group_by(.data$exchange) %>%
    filter(.data$revenue.type == "mining") %>%
    summarize(mining = sum(.data$value, na.rm = TRUE))

  # Combine everything together
  table <- list(
    revenues.dates, revenues2, airdrops, referrals, staking,
    promos, interests, rebates, rewards, forks, mining
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
      date.last = safe_datetime_max(table$date.last),
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



