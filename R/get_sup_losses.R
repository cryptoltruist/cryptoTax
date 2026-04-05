#' @title Get superficial loss amounts
#'
#' @description Get superficial loss amounts
#' @param formatted.ACB The dataframe `formatted.ACB`,
#' @param tax.year which year
#' @param local.timezone which time zone
#' @return A data frame, with the following columns: currency, sup.loss.
#' @export
#' @examples
#' all.data <- format_shakepay(data_shakepay)
#' formatted.ACB <- format_ACB(all.data, verbose = FALSE)
#' get_sup_losses(formatted.ACB, 2021)
#' @importFrom dplyr mutate %>% filter summarize
#' @importFrom rlang .data

get_sup_losses <- function(formatted.ACB, tax.year = "all", local.timezone = Sys.timezone()) {
  formatted.ACB.year <- .filter_formatted_acb_tax_year(
    formatted.ACB = formatted.ACB,
    tax.year = tax.year,
    local.timezone = local.timezone,
    label = "superficial losses"
  )
  total.sup.loss <- formatted.ACB.year %>%
    summarize(sup.loss = sum(.data$gains.sup, na.rm = TRUE)) %>%
    mutate(sup.loss = round(.data$sup.loss, 2))

  if (identical(total.sup.loss$sup.loss[[1]], 0)) {
    return(data.frame(currency = character(), sup.loss = numeric()))
  }

  data.frame(
    currency = "Total",
    sup.loss = total.sup.loss$sup.loss,
    stringsAsFactors = FALSE
  )
}
