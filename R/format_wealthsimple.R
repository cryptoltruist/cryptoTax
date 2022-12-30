#' @title Format Wealthsimple file
#'
#' @description Format a .csv transaction history file from Wealthsimple for later ACB processing.
#' @param data The dataframe
#' @keywords money crypto
#' @export
#' @examples
#' \dontrun{
#' format_wealthsimple(data)
#' }
#' @importFrom dplyr %>% rename mutate rowwise filter select bind_rows arrange
#' @importFrom rlang .data

format_wealthsimple <- function(data) {
  # Add single dates to dataframe
  data <- data %>%
    mutate(
      date =
        lubridate::with_tz(.data$date, tz = "UTC")
    )
  # UTC confirmed

  # Add spot rate
  data <- data %>%
    mutate(
      spot.rate = .data$total.price / .data$quantity,
      rate.source = "exchange"
    )

  # Return result
  data
}
