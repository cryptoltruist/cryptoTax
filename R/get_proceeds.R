.prepare_proceeds_bucket <- function(x) {
  x %>%
    mutate(
      ACB.quantity = .data$total.price - .data$gains,
      proceeds = .data$total.price,
      profits = .data$proceeds - .data$ACB.quantity - .data$fees
    )
}

.empty_proceeds_summary <- function() {
  data.frame(
    proceeds = 0,
    ACB.total = 0,
    gains = 0
  )
}

#' @noRd
.summarize_proceeds_values <- function(x) {
  if (nrow(x) == 0) {
    return(.empty_proceeds_summary())
  }

  proceeds <- sum(x$total.price)
  ACB.total <- sum(x$ACB.quantity)

  data.frame(
    proceeds = proceeds,
    ACB.total = ACB.total,
    gains = proceeds - ACB.total
  )
}

#' @noRd
.summarize_proceeds_bucket <- function(x) {
  if (nrow(x) == 0) {
    return(.empty_proceeds_summary())
  }

  x %>%
    ungroup() %>%
    .summarize_proceeds_values()
}

#' @noRd
.proceeds_type_labels <- function() {
  c("Gains", "Losses")
}

.proceeds_bucket_rows <- function(formatted.ACB.year, gains_sign = c("positive", "negative")) {
  gains_sign <- match.arg(gains_sign)

  if (gains_sign == "positive") {
    return(formatted.ACB.year %>% filter(.data$gains > 0))
  }

  formatted.ACB.year %>% filter(.data$gains < 0)
}

#' @noRd
.proceeds_summary_rows <- function(formatted.ACB.year) {
  buckets <- .split_proceeds_buckets(formatted.ACB.year)

  bind_rows(
    .summarize_proceeds_bucket(buckets$gains),
    .summarize_proceeds_bucket(buckets$losses)
  )
}

#' @noRd
.split_proceeds_buckets <- function(formatted.ACB.year) {
  list(
    gains = .proceeds_bucket_rows(formatted.ACB.year, "positive") %>%
      .prepare_proceeds_bucket(),
    losses = .proceeds_bucket_rows(formatted.ACB.year, "negative") %>%
      .prepare_proceeds_bucket()
  )
}

#' @noRd
.proceeds_summary_table <- function(formatted.ACB.year) {
  .proceeds_summary_rows(formatted.ACB.year) %>%
    mutate(type = .proceeds_type_labels()) %>%
    relocate("type") %>%
    as.data.frame()
}

#' @title Get proceeds of all sold coins
#'
#' @description Get proceeds of sold coins, ACB of sold coins, and resulting
#' difference between the two, capital gains.
#' @param formatted.ACB The `formatted.ACB` object,
#' @param tax.year which year
#' @param local.timezone which time zone
#' @return A data frame, with the following columns: type, proceeds, ACB.total,
#' gains.
#' @export
#' @examples
#' all.data <- format_exchanges(data_shakepay)
#' formatted.ACB <- format_ACB(all.data, verbose = FALSE)
#' get_proceeds(formatted.ACB, 2021)
#' @importFrom dplyr mutate %>% filter ungroup summarize relocate bind_rows
#' @importFrom rlang .data
get_proceeds <- function(formatted.ACB, tax.year = "all", local.timezone = Sys.timezone()) {
  formatted.ACB.year <- .filter_formatted_acb_tax_year(
    formatted.ACB = formatted.ACB,
    tax.year = tax.year,
    local.timezone = local.timezone,
    label = "proceeds"
  )

  .proceeds_summary_table(formatted.ACB.year)
}
