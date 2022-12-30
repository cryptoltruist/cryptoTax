#' @title Get proceeds of all sold coins
#'
#' @description Get proceeds of sold coins, ACB of sold coins, and resulting difference between the two, capital gains.
#' @param data The dataframe formatted.ACB,
#' @param tax.year which year
#' @param local.timezone which time zone
#' @keywords money crypto
#' @export
#' @examples
#' \dontrun{
#' ACB(data)
#' }
#' @importFrom dplyr mutate %>% filter ungroup summarize relocate bind_rows
#' @importFrom rlang .data

get_proceeds <- function(data, tax.year, local.timezone) {
  formatted.ACB <- data
  formatted.ACB.year <- formatted.ACB %>%
    mutate(datetime.local = lubridate::with_tz(.data$date, tz = local.timezone)) %>%
    filter(lubridate::year(.data$datetime.local) == tax.year)
  only.gains <- formatted.ACB.year %>%
    filter(.data$gains > 0)
  only.gains <- only.gains %>%
    mutate(
      ACB.quantity = .data$total.price - .data$gains,
      proceeds = .data$total.price,
      profits = .data$proceeds - .data$ACB.quantity - .data$fees
    )

  only.losses <- formatted.ACB.year %>%
    filter(.data$gains < 0)
  only.losses <- only.losses %>%
    mutate(
      ACB.quantity = .data$total.price - .data$gains,
      proceeds = .data$total.price,
      profits = .data$proceeds - .data$ACB.quantity - .data$fees
    )

  only.gains.sum <- only.gains %>%
    ungroup() %>%
    summarize(
      proceeds = sum(.data$total.price),
      ACB.total = sum(.data$ACB.quantity),
      gains = .data$proceeds - .data$ACB.total
    )

  only.losses.sum <- only.losses %>%
    ungroup() %>%
    summarize(
      proceeds = sum(.data$total.price),
      ACB.total = sum(.data$ACB.quantity),
      gains = .data$proceeds - .data$ACB.total
    )

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

  cat("Loss proceeds (and gains) adjusted for superficial losses. \n")

  bind_rows(only.gains.sum, only.losses.sum) %>%
    mutate(type = c("Gains", "Losses")) %>%
    relocate(.data$type) %>%
    as.data.frame()
}
