#' @title Format ADA rewards from blockchain CSV
#'
#' @description Format a .csv transaction history file from the Cardano PoolTool for later ACB processing. Instructions: Use https://pooltool.io/ click on "rewards data for taxes", search your ADA address, scroll to the bottom of the page, and use the export tool to export all transactions. Make sure to use the "Generic(CSV)" format.
#' @param data The dataframe
#' @export
#' @examples
#' \dontrun{
#' format_pooltool(data)
#' }
#' @importFrom dplyr %>% rename mutate rowwise filter select bind_rows arrange
#' @importFrom rlang .data

format_pooltool <- function(data) {
  # Rename columns
  data <- data %>%
    rename(
      quantity = "stake_rewards",
      total.price = "stake_rewards_value",
      spot.rate = "rate",
      date = "\\u00ef..date"
    )
  # Have to find a way to remove that special character, "ï" (solution = use "\\u00ef")

  # Add single dates to dataframe
  data <- data %>%
    mutate(date = lubridate::ymd_hms(.data$date))
  # Time zone (-04:00) being converted to UTC automatically confirmed

  # Add currency to missing places
  data <- data %>%
    mutate(
      local.currency = .data$currency,
      currency = "ADA",
      transaction = "revenue",
      revenue.type = "staking",
      rate.source = "pooltool",
      description = paste0("epoch = ", .data$epoch),
      comment = paste0("pool = ", .data$pool)
    )

  # Select and reorder correct columns
  data <- data %>%
    select(
      "date", "currency", "quantity", "total.price",
      "spot.rate", "transaction", "description", "comment",
      "revenue.type", "rate.source"
    )

  # Put fees to zero and add exchange
  data <- merge_exchanges(data) %>%
    mutate(exchange = "exodus")

  # Return result
  data
}
