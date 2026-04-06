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

  .total_sup_loss_table(formatted.ACB.year)
}
