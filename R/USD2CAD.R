#' @title Convert USD to CAD
#'
#' @description This function allows you to convert USD to CAD.
#' @param data The data
#' @param start.date What date to start reporting prices for.
#' @param end.date What date to end reporting prices for.
#' @param conversion What to convert to
#' @param currency What to convert from
#' @param force Whether to force recreating `list.prices` even though
#' it already exists (e.g., if you added new coins or new dates).
#' @return A data frame, with the following columns: date, CAD.rate. 
#' @export
#' @examples
#' formatted.dates <- format_shakepay(data_shakepay)[1]
#' USD2CAD(formatted.dates)
#' @importFrom dplyr %>% filter pull inner_join
#' @importFrom rlang .data

USD2CAD <- function(data, 
                    start.date = "2020-01-01", 
                    end.date = lubridate::now("UTC"),
                    conversion = "USD", 
                    currency = "CAD", 
                    force = FALSE) {
  if (isFALSE(curl::has_internet())) {
    message("This function requires Internet access.")
    return(NULL)
  }
  
  if (isTRUE(force) || !exists("USD2CAD.table")) {
    tryCatch(
      expr = {
        USD2CAD.table <- prepare_list_prices(
          "USDC", 
          currency = paste0(currency, ",", conversion), 
          start.date = start.date, 
          force = TRUE)
      },
      error = function(e) {
        message("Could not fetch exchange rates from coinmarketcap")
        return(NULL)},
      warning = function(w) {
        return(NULL)
      })
    
    if (!exists("USD2CAD.table")) {
      message("Could not fetch exchange rates from coinmarketcap")
      return(NULL)
    }
    USD <- USD2CAD.table %>% 
      filter(.data$ref_cur == "USD")
    CAD <- USD2CAD.table %>% 
      filter(.data$ref_cur == "CAD")
    
    USD$spot.rate2_USD <- USD$spot.rate2
    CAD$spot.rate2_CAD <- CAD$spot.rate2
    
    USD2CAD.table <- USD %>% 
      left_join(CAD %>% 
                  select("date2", "spot.rate2_CAD"),
                by = "date2") %>% 
      mutate(CAD.rate = .data$spot.rate2_CAD / .data$spot.rate2_USD,
             diff = .data$spot.rate2_CAD - .data$CAD.rate)
    
    USD2CAD.table <<- USD2CAD.table
  } else {
    message(
      "Object 'USD2CAD.table' already exists. Reusing 'USD2CAD.table'. ",
      "To force a fresh download, use argument 'force = TRUE'."
    )
  }
  
  data <- data %>%
    mutate(
      date2 = as.Date(.data$date)
    )
  
  USD2CAD.table_short <- USD2CAD.table %>% 
    select("date2", "CAD.rate")
  
  data <- inner_join(data, USD2CAD.table_short, by = "date2") %>%
    select(-"date2")
  data
}

#' @title Convert USD to CAD (using `priceR`)
#'
#' @description This function allows you to convert USD to CAD.
#' `priceR` now requires an API key from https://exchangerate.host/...
#' See all details on the package author README here: https://github.com/stevecondylios/priceR
#' "Set up only takes a minute and is free for 100 requests per account per calendar month."
#' "Go to https://exchangerate.host/, create a free account, and replace
#' 7e5e3140140bd8e4f4650cc41fc772c0 with your API key in the following, and run once per R session."
#  `Sys.setenv("EXCHANGERATEHOST_ACCESS_KEY"="7e5e3140140bd8e4f4650cc41fc772c0")`
#' @param data The data
#' @param conversion What to convert to
#' @param currency What to convert from
#' @return A data frame, with the following columns: date, CAD.rate. 
#' @export
#' @importFrom dplyr %>% filter pull inner_join
#' @importFrom rlang .data

USD2CAD_priceR <- function(data, conversion = "USD", currency = "CAD") {
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
      date2 = .data$date,
      date = as.Date(.data$date)
    )
  
  inner_join(data, USD2CAD.table, by = "date") %>%
    mutate(date = .data$date2) %>%
    select(-"date2")
}
