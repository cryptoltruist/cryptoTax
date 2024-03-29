#' @title Convert USD to CAD
#'
#' @description This function allows you to convert USD to CAD.
#' @param data The data
#' @param conversion What to convert to
#' @param currency What to convert from
#' @return A data frame, with the following columns: date, CAD.rate. 
#' @export
#' @examples
#' formatted.dates <- format_shakepay(data_shakepay)[1]
#' USD2CAD(formatted.dates)
#' @importFrom dplyr %>% filter pull inner_join
#' @importFrom rlang .data

USD2CAD <- function(data, conversion = "USD", currency = "CAD") {
  if (isFALSE(curl::has_internet())) {
    message("This function requires Internet access.")
    return(NULL)
  }
  
  if (!exists("USD2CAD.table")) {
    tryCatch(
      expr = {
        USD2CAD.table <- priceR::historical_exchange_rates(
          conversion,
          to = currency, start_date = "2020-01-01", end_date = Sys.Date()
        )
      },
      error = function(e) {
        message("Could not fetch exchange rates from the exchange rate API.")
        return(NULL)},
      warning = function(w) {
        return(NULL)
      })
    
    if (!exists("USD2CAD.table")) {
      message("Could not fetch exchange rates from the exchange rate API.")
      return(NULL)
    }
    
    USD2CAD.table <- mutate(USD2CAD.table, date = as.Date(.data$date))
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
