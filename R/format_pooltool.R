#' @title Format ADA rewards from blockchain CSV
#'
#' @description Format a .csv transaction history file from the Cardano PoolTool for later ACB processing. Instructions: Use https://pooltool.io/ click on "rewards data for taxes", search your ADA address, scroll to the bottom of the page, and use the export tool to export all transactions. Make sure to use the "Generic(CSV)" format.
#' @details This is necessary e.g., if you used the Exodus wallet which does not report
#' ADA rewards in its transaction history file. The benefit of this tool is that it
#' provides rewards. However, it does not provide staking costs, which are also
#' taxable events.
#' @param data The dataframe
#' @param exchange The name of the exchange to indicate in the resulting data frame.
#' @return A data frame of exchange transactions, formatted for further processing.
#' @export
#' @examples
#' format_pooltool(data_pooltool)
#' @importFrom dplyr %>% rename mutate rowwise filter select bind_rows arrange
#' @importFrom rlang .data

format_pooltool <- function(data, exchange = "exodus") {
  # There are no transaction types at all for this file type

  data <- .format_pooltool_rewards(data)
  .format_pooltool_finalize(data, exchange = exchange)
}

.format_pooltool_rewards <- function(data) {
  data %>%
    rename(
      quantity = "stake_rewards",
      total.price = "stake_rewards_value",
      spot.rate = "rate",
      date = "date" # used to be "\\u00ef..date" ....
    ) %>%
    mutate(
      date = lubridate::ymd_hms(.data$date),
      local.currency = .data$currency,
      currency = "ADA",
      transaction = "revenue",
      revenue.type = "staking",
      rate.source = "pooltool",
      description = paste0("epoch = ", .data$epoch),
      comment = paste0("pool = ", .data$pool)
    )
}

#' @noRd
.format_pooltool_finalize <- function(data, exchange) {
  .finalize_formatted_exchange(
    data,
    exchange = exchange,
    columns = c(
      "date", "currency", "quantity", "total.price",
      "spot.rate", "transaction", "description", "comment",
      "revenue.type", "exchange", "rate.source"
    )
  )
}
