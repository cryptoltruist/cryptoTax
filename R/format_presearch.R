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
  transferred.from <- grep("Transferred from", data$description, value = TRUE)
  staked.to <- unique(grep("Staked to keyword", data$description, value = TRUE))
  known.transactions <- c("Search Reward", transferred.from, staked.to)
  
  # Rename columns
  data <- data %>%
    rename(quantity = "amount")
  
  # Check if there's any new transactions
  check_new_transactions(data, 
                         known.transactions = known.transactions,
                         transactions.col = "description")

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

  # Reorder columns properly
  data <- data %>%
    select(
      "date", "currency", "quantity", "total.price", "spot.rate", "transaction", 
      "description", "revenue.type", "exchange", "rate.source"
    )
  
  # Return result
  data
}
