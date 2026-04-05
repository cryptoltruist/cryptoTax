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
  only.gains <- formatted.ACB.year %>%
    filter(.data$gains > 0) %>%
    .prepare_proceeds_bucket()

  only.losses <- formatted.ACB.year %>%
    filter(.data$gains < 0) %>%
    .prepare_proceeds_bucket()

  # sup.losses.total <- sup.losses[nrow(sup.losses), "sup.loss"]

  # if(nrow(only.losses) == 0) {
  #  only.losses.sum <- only.losses %>%
  #    ungroup() %>%
  #    summarize(proceeds = sum(total.price) + sup.losses.total,
  #              proceeds = ifelse(proceeds < 0,
  #                                0,
  #                                proceeds),
  #              ACB.total = sum(ACB.quantity),
  #              gains = proceeds - ACB.total)
  # }

  bind_rows(
    .summarize_proceeds_bucket(only.gains),
    .summarize_proceeds_bucket(only.losses)
  ) %>%
    mutate(type = c("Gains", "Losses")) %>%
    relocate("type") %>% 
    as.data.frame()
}
