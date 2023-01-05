#' @title Convert USD to CAD
#'
#' @description This function allows you to convert USD to CAD.
#' @param data The data
#' @param conversion What to convert to
#' @param currency What to convert from
#' @export
#' @examples
#' # Not work anymore
#' # USD2CAD(date = "2021-10-08", conversion = "USD", currency = "CAD")
#' @importFrom dplyr %>% filter pull inner_join
#' @importFrom rlang .data

USD2CAD <- function(data, conversion = "USD", currency = "CAD") {
  if (!exists("USD2CAD.table")) {
    USD2CAD.table <- priceR::historical_exchange_rates(
      conversion,
      to = currency, start_date = "2020-01-01", end_date = Sys.Date()
    ) %>%
      mutate(date = as.Date(.data$date))
    names(USD2CAD.table)[2] <- "CAD.rate"
    USD2CAD.table <<- USD2CAD.table
  }

  data <- data %>%
    mutate(
      date2 = date,
      date = as.Date(date)
    )

  inner_join(data, USD2CAD.table, by = "date") %>%
    mutate(date = .data$date2) %>%
    select(-"date2")
}
