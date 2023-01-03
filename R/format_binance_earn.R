#' @title Format Binance earn file
#'
#' @description Format a .csv earn history file from Binance for later
#' ACB processing.
#' @details There are two ways to get this file. The first,
#' recommended option, is to download your overall transaction report
#' (this will also include e.g., "Referral Kickback" rewards).
#' To get this file, connect to your Binance account on desktop, click
#' "Wallet" (top right), "Transaction History", then in the top-right,
#' "Generate all statements". For "Time", choose "Customized" and pick
#' your time frame.
#'
#' For option two, click "Orders" (top right), "Earn History", then click on
#' "Export". In "Type", choose "Interest", and choose your time frame
#' (you will probably need to choose "Beyond 6 months - Custom").
#' In both cases, you are allowed one year of transactions. If you have more,
#' you might have to download more than one file and merge them before
#' using this function.
#'
#' Warning: This does NOT process TRADES or WITHDRAWALS (see the
#' `format_binance_trades()` and `format_binance_withdrawals()`
#' functions for this purpose).
#' @param data The dataframe
#' @param filetype Which file type to use, one of ("all", for all
#' transactions, or "earn", for just earn).
#' @keywords money crypto
#' @export
#' @examples
#' \dontrun{
#' format_binance_earn(data)
#' }
#' @importFrom dplyr %>% rename mutate across select arrange bind_rows
#' @importFrom rlang .data

format_binance_earn <- function(data, filetype = "all") {
  if (filetype == "earn") {
    # Rename columns
    data <- data %>%
      rename(
        currency = "Coin",
        quantity = "Change",
        date = "UTC_Time",
        description = "Operation",
        comment = "Account"
      )

    # Add single dates to dataframe
    data <- data %>%
      mutate(date = lubridate::as_datetime(.data$date))
    # UTC confirmed

    # Determine spot rate and value of coins
    data <- cryptoTax::match_prices(data)

    data <- data %>%
      mutate(
        total.price = ifelse(is.na(.data$total.price),
          .data$quantity * .data$spot.rate,
          .data$total.price
        ),
        transaction = "revenue",
        revenue.type = "interests"
      ) %>%
      select(
        "date", "quantity", "currency", "total.price", "spot.rate",
        "transaction", "description", "comment", "revenue.type", "rate.source"
      )

    # Merge the "buy" and "sell" objects
    data <- bind_rows(data) %>%
      mutate(
        fees = 0,
        exchange = "binance"
      ) %>%
      arrange(date)

    # Return result
    data
  } else if (filetype == "all") {
    # Rename columns
    data <- data %>%
      rename(
        currency = "Coin",
        quantity = "Change",
        date = "UTC_Time",
        description = "Operation",
        comment = "Account"
      )

    # Add single dates to dataframe
    data <- data %>%
      mutate(date = lubridate::as_datetime(.data$date))
    # UTC confirmed

    # Determine spot rate and value of coins
    data <- cryptoTax::match_prices(data)

    data <- data %>%
      mutate(
        total.price = ifelse(is.na(.data$total.price),
          .data$quantity * .data$spot.rate,
          .data$total.price
        ),
        transaction = "revenue",
        revenue.type = case_when(
          grepl("Interest", .data$description) ~ "interests",
          grepl("Referral", .data$description) ~ "rebate",
          grepl("Distribution", .data$description) ~ "airdrop"
        )
      ) %>%
      select(
        "date", "quantity", "currency", "total.price", "spot.rate",
        "transaction", "description", "comment", "revenue.type", "rate.source"
      )

    # Remove deposits and withdrawals
    data <- data %>%
      filter(!.data$description %in% c(
        "Deposit", "Withdraw", "Buy", "Sell",
        "Fee", "Stablecoins Auto-Conversion"
      ))

    # Merge the "buy" and "sell" objects
    data <- bind_rows(data) %>%
      mutate(
        fees = 0,
        exchange = "binance"
      ) %>%
      arrange(date)

    # Return result
    data
  }
}
