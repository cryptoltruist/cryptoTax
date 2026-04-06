.prepare_proceeds_bucket <- function(x) {
  x %>%
    mutate(
      ACB.quantity = .data$total.price - .data$gains,
      proceeds = .data$total.price,
      profits = .data$proceeds - .data$ACB.quantity - .data$fees
    )
}

#' @noRd
.summarize_proceeds_bucket <- function(x) {
  x %>%
    ungroup() %>%
    summarize(
      proceeds = sum(.data$total.price),
      ACB.total = sum(.data$ACB.quantity),
      gains = .data$proceeds - .data$ACB.total
    )
}

#' @noRd
.split_proceeds_buckets <- function(formatted.ACB.year) {
  list(
    gains = formatted.ACB.year %>%
      filter(.data$gains > 0) %>%
      .prepare_proceeds_bucket(),
    losses = formatted.ACB.year %>%
      filter(.data$gains < 0) %>%
      .prepare_proceeds_bucket()
  )
}

#' @noRd
.proceeds_summary_table <- function(formatted.ACB.year) {
  buckets <- .split_proceeds_buckets(formatted.ACB.year)

  bind_rows(
    .summarize_proceeds_bucket(buckets$gains),
    .summarize_proceeds_bucket(buckets$losses)
  ) %>%
    mutate(type = c("Gains", "Losses")) %>%
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
#' all.data <- format_shakepay(data_shakepay)
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
