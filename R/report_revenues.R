#' @title Report all revenues
#'
#' @description Provides a summary of revenues from all sources.
#' @param formatted.ACB The formatted ACB data.
#' @param tax.year Which tax year(s) to include.
#' @param local.timezone Which time zone to use for the date of the report.
#' @export
#' @examples
#' \dontrun{
#' report_revenues(formatted.ACB)
#' }
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
    warning("revenues have been filtered for tax year ", tax.year)
  }

  # Get all revenues for selected year
  sum(revenues$value)

  # Get all revenues for selected year
  revenues2 <- revenues %>%
    group_by(.data$exchange) %>%
    select(.data$exchange, .data$date, .data$value) %>%
    rename(last.date = "date") %>%
    summarize(total.revenues = sum(.data$value))

  revenues.dates <- revenues %>%
    group_by(.data$exchange) %>%
    filter(date == max(.data$date)) %>%
    select(.data$date)

  # Add revenue.type
  airdrop <- revenues %>%
    group_by(.data$exchange) %>%
    filter(.data$revenue.type == "airdrop") %>%
    summarize(airdrop = sum(.data$value))

  referrals <- revenues %>%
    group_by(.data$exchange) %>%
    filter(.data$revenue.type == "referrals") %>%
    summarize(referrals = sum(.data$value))

  staking <- revenues %>%
    group_by(.data$exchange) %>%
    filter(.data$revenue.type == "staking") %>%
    summarize(staking = sum(.data$value))

  promo <- revenues %>%
    group_by(.data$exchange) %>%
    filter(.data$revenue.type == "promo") %>%
    summarize(promo = sum(.data$value))

  interests <- revenues %>%
    group_by(.data$exchange) %>%
    filter(.data$revenue.type == "interests") %>%
    summarize(interests = sum(.data$value))

  rebate <- revenues %>%
    group_by(.data$exchange) %>%
    filter(.data$revenue.type == "rebate") %>%
    summarize(rebate = sum(.data$value))

  rewards <- revenues %>%
    group_by(.data$exchange) %>%
    filter(.data$revenue.type == "rewards") %>%
    summarize(rewards = sum(.data$value))

  # Combine everything together
  table <- list(
    revenues.dates, revenues2, airdrop, referrals, staking,
    promo, interests, rebate, rewards
  ) %>%
    Reduce(function(dtf1, dtf2) full_join(dtf1, dtf2, by = "exchange"), .)

  table <- table %>%
    rename(date.last = .data$date) %>%
    arrange(desc(.data$total.revenues)) %>%
    mutate(across(.data$total.revenues, round, 2)) %>%
    slice(1) %>%
    as.data.frame()

  # Add total
  table <- table %>%
    add_row(
      exchange = "total",
      date.last = max(table$date.last),
      summarize(., across(tidyselect::where(is.numeric), sum, na.rm = TRUE))
    ) %>%
    mutate(currency = "CAD")
  table
}
