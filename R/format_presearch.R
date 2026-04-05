#' @title Format Presearch wallet file
#'
#' @description Format a .csv transaction history file from Presearch for later ACB processing.
#' @param data The dataframe
#' @param list.prices A `list.prices` object from which to fetch coin prices.
#' @param force Whether to force recreating `list.prices` even though
#' it already exists (e.g., if you added new coins or new dates).
#'
#' The way to download this file is to go to
#' <https://account.presearch.com/tokens/pre-wallet> and click on the
#' orange "Export to CSV" button at the bottom right of the screen.
#'
#' As of 2024-12-27, it seems like this file does not include search rewards
#' anymore. One explanation is found on a
#' [Reddit post](<https://www.reddit.com/r/Presearch/comments/urqf34/comment/i8zj98s/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button>):
#' "you have to keep in mind that the tokens are considered the user's only
#' when they hit the claim button." From a tax perspective, it makes sense that
#' airdrops and rewards are only taxable once they become under the user's
#' control. With Presearch, they are not under the user's control until
#' the minimum withdrawal amount (1000) is reached. Therefore, moving forward,
#' we will use this new strategy.
#' @return A data frame of exchange transactions, formatted for further processing.
#' @export
#' @examples
#' format_presearch(data_presearch)
#' @importFrom dplyr %>% rename mutate rowwise filter select bind_rows arrange
#' @importFrom rlang .data

format_presearch <- function(data, list.prices = NULL, force = FALSE) {
  patterns <- .format_presearch_patterns(data)

  known.transactions <- c(
    "Search Reward",
    "Base search reward",
    "Browser Extension Installation Bonus",
    "Increased search staking",
    "Removed from search staking",
    patterns$transferred.from,
    patterns$staked.to,
    patterns$removed.from,
    patterns$search.against,
    patterns$airdrop
  )

  data <- .format_presearch_prepare_input(data)

  # Check if there's any new transactions
  check_new_transactions(data,
    known.transactions = known.transactions,
    transactions.col = "description"
  )

  # Remove irrelevant rows
  data <- data %>%
    filter(!.data$description %in% c(
      patterns$staked.to, patterns$removed.from, "Increased search staking",
      "Removed from search staking"
    ))

  # Add currency, transaction type
  rewards.names <- c(
    "Search Reward",
    "Base search reward",
    "Browser Extension Installation Bonus",
    "Transferred from Rewards",
    patterns$search.against,
    patterns$airdrop
  )

  # Add currency and transaction type
  data <- .format_presearch_classify(data, rewards.names)

  # Determine spot rate and value of coins
  data <- cryptoTax::match_prices(data, list.prices = list.prices, force = force)

  if (is.null(data)) {
    message("Could not reach the CoinMarketCap API at this time")
    return(NULL)
  }

  data <- data %>%
    mutate(
      quantity = as.numeric(gsub(",", "", .data$quantity)),
      total.price = ifelse(is.na(.data$total.price),
        .data$quantity * .data$spot.rate,
        .data$total.price
      )
    )

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

.format_presearch_patterns <- function(data) {
  list(
    transferred.from = grep("Transferred from", data$description, value = TRUE),
    staked.to = unique(grep("Staked to keyword", data$description, value = TRUE)),
    removed.from = unique(grep("Removed from keyword", data$description, value = TRUE)),
    search.against = unique(grep("Search reward against", data$description, value = TRUE)),
    airdrop = unique(grep("Airdrop", data$description, value = TRUE))
  )
}

.format_presearch_prepare_input <- function(data) {
  data %>%
    rename(quantity = "amount") %>%
    mutate(quantity = as.numeric(gsub(",", "", .data$quantity, fixed = TRUE)))
}

.format_presearch_classify <- function(data, rewards.names) {
  data %>%
    mutate(
      currency = "PRE",
      transaction = case_when(
        .data$description %in% rewards.names ~ "revenue",
        grepl("Transferred from Presearch Portal", .data$description) ~ "buy"
      ),
      date = lubridate::ymd_hms(.data$date),
      revenue.type = ifelse(.data$transaction == "revenue", "airdrops", NA)
    )
}
