#' @title Format Presearch wallet file
#'
#' @description Format a .csv transaction history file from Presearch for later ACB processing.
#' @param data The dataframe
#' @export
#' @examples
#' \dontrun{
#' format_presearch(data)
#' }
#' @importFrom dplyr %>% rename mutate rowwise filter select bind_rows arrange
#' @importFrom rlang .data

format_presearch <- function(data) {
  # Rename columns
  data <- data %>%
    rename(quantity = "amount")

  # Remove irrelevant columns
  data <- data %>%
    filter(!grepl(
      "Staked to keyword:",
      .data$description
    ))

  # Add currency, transaction type
  data <- data %>%
    mutate(
      currency = "PRE",
      transaction = case_when(
        .data$description == "Search Reward" ~ "revenue",
        grepl(
          "Transferred from Presearch Portal",
          .data$description
        ) ~ "buy"
      )
    )

  # Add single dates to dataframe
  data <- data %>%
    mutate(date = lubridate::ymd_hms(.data$date))
  # UTC confirmed

  # Add revenu type
  data <- data %>%
    mutate(revenue.type = ifelse(.data$transaction == "revenue",
      "airdrops",
      NA
    ))

  # Determine spot rate and value of coins
  data <- cryptoTax::match_prices(data)

  data <- data %>%
    mutate(total.price = ifelse(is.na(.data$total.price),
      .data$quantity * .data$spot.rate,
      .data$total.price
    ))

  # Add fees, exchange
  data <- merge_exchanges(data) %>%
    mutate(exchange = "presearch")

  # Return result
  data
}
