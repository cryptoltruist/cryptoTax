#' @title Format Shakepay file
#'
#' @description Format a .csv transaction history file from Shakepay for later ACB processing.
#' 
#' In 2024, the Shakepay transaction history file has changed. Shakepay now 
#' provides two files: `crypto_transactions_summary.csv` and 
#' `cash_transactions_summary.csv`. The new correct file with all transactions
#' is the first one, `crypto_transactions_summary.csv`.
#' 
#' Furthermore, this file does not report referral rewards anymore, which
#' need to be added manually or through the `referral` argument (using a 
#' list if multiple referrals).
#' @param data The dataframe
#' @param referral Feature to include referral rewards manually (e.g.,
#' as a list with dates and credit amounts) since Shakepay stopped including
#' these in their transaction history files.
#' @return A data frame of exchange transactions, formatted for further processing.
#' @export
#' @examples
#' formatted.shakepay <- format_shakepay(data_shakepay)
#' head(formatted.shakepay)
#' formatted.shakepay <- format_shakepay(data_shakepay,
#'  referral = list(
#'   Date = c("2021-05-07 21:25:36",
#'            "2021-05-17 21:25:36"),
#'   Credit = c(30, 10)))
#' head(formatted.shakepay)
#' @importFrom dplyr %>% rename mutate rowwise filter select bind_rows arrange
#' case_when add_row
#' @importFrom rlang .data

format_shakepay <- function(data, referral) {
  known.transactions <- c(
    "Reward", "Buy", "Sell", "Send"
    # "shakingsats", "fiat funding", "purchase/sale", "other", "crypto cashout"
  )
  
  if (!missing(referral)) {
    data <- data %>%
      add_row(Date = referral$Date,
              Amount.Credited = referral$Credit,
              Type = "Reward",
              Description = "Referral reward",
              Asset.Credited = "CAD",
              Book.Cost = .data$Amount.Credited,
              Book.Cost.Currency = .data$Asset.Credited,
              Mid.Market.Rate = 1)
    }
  
  # Rename columns
  data <- data %>%
    rename(
      description = "Type",
      comment = "Description",
      spot.rate = "Spot.Rate",
      date = "Date"
    )
  
  # Check if there's any new transactions
  check_new_transactions(data,
                         known.transactions = known.transactions,
                         transactions.col = "description",
                         description.col = "comment"
  )
  
  # Add single dates to dataframe
  data <- data %>%
    mutate(date = lubridate::as_datetime(.data$date))
  # UTC confirmed
  
  # Create a "buy" object
  BUY <- data %>%
    filter(.data$description == "Buy") %>%
    rename(
      quantity = "Amount.Credited",
      currency = "Asset.Credited",
      total.price = "Book.Cost"
    ) %>%
    mutate(transaction = "buy") %>%
    select(
      "date", "quantity", "currency", "total.price", "spot.rate",
      "transaction", "description", "comment"
    )
  
  # Create a "SHAKES" object
  SHAKES <- data %>%
    filter(.data$comment == "ShakingSats") %>%
    rename(
      quantity = "Amount.Credited",
      currency = "Asset.Credited"
    ) %>%
    mutate(
      spot.rate = .data$Mid.Market.Rate,
      total.price = .data$quantity * .data$spot.rate,
      transaction = "revenue",
      revenue.type = "airdrops") %>%
    select(
      "date", "quantity", "currency", "total.price",
      "spot.rate", "transaction", "revenue.type",
      "description", "comment"
    )
  
  # Create a "REFERRAL" object
  REFERRAL <- data %>%
    filter(comment == "Referral reward") %>%
    rename(
      quantity = "Amount.Credited",
      currency = "Asset.Credited",
      total.price = "Book.Cost"
    ) %>%
    mutate(
      transaction = "revenue",
      revenue.type = "referrals",
      spot.rate = 1
    ) %>%
    select(
      "date", "quantity", "currency", "total.price",
      "spot.rate", "transaction", "revenue.type",
      "description", "comment"
    )
  
  # Create a "sell" object
  SELL <- data %>%
    filter(.data$description == "Sell") %>%
    rename(
      quantity = "Amount.Debited",
      currency = "Asset.Debited",
      total.price = "Book.Cost"
    ) %>%
    mutate(transaction = "sell") %>%
    select(
      "date", "quantity", "currency", "total.price",
      "spot.rate", "transaction", "description", "comment"
    )
  
  # Merge the "buy" and "sell" objects
  data <- bind_rows(BUY, SHAKES, REFERRAL, SELL) %>%
    mutate(
      exchange = "shakepay",
      rate.source = "exchange"
    ) %>%
    arrange(date)
  
  # Reorder columns properly
  data <- data %>%
    select(
      "date", "currency", "quantity", "total.price", "spot.rate", "transaction",
      "description", "comment", "revenue.type", "exchange", "rate.source"
    )
  
  # Return result
  data
}

# Old function before 2024 change
format_shakepay_old <- function(data) {
  known.transactions <- c(
    "shakingsats", "fiat funding", "purchase/sale", "other", "crypto cashout"
  )

  # Rename columns
  data <- data %>%
    rename(
      description = "Transaction.Type",
      comment = "Direction",
      spot.rate = "Spot.Rate",
      date = "Date"
    )

  # Check if there's any new transactions
  check_new_transactions(data,
    known.transactions = known.transactions,
    transactions.col = "description",
    description.col = "comment"
  )

  # Add single dates to dataframe
  data <- data %>%
    mutate(date = lubridate::as_datetime(.data$date))
  # UTC confirmed

  # Create a "buy" object
  BUY <- data %>%
    filter(.data$description == "purchase/sale") %>%
    rename(
      quantity = "Amount.Credited",
      currency = "Credit.Currency",
      total.price = "Amount.Debited"
    ) %>%
    mutate(
      transaction = "buy",
      spot.rate = .data$total.price / .data$quantity
    ) %>%
    select(
      "date", "quantity", "currency", "total.price", "spot.rate",
      "transaction", "description", "comment"
    ) %>%
    filter(.data$currency != "CAD")

  # Create a "SHAKES" object
  SHAKES <- data %>%
    filter(.data$description == "shakingsats") %>%
    rename(
      quantity = "Amount.Credited",
      currency = "Credit.Currency"
    ) %>%
    mutate(
      total.price = .data$quantity * .data$spot.rate,
      transaction = "revenue",
      revenue.type = replace(
        .data$description,
        .data$description %in% c("shakingsats"),
        "airdrops"
      )
    ) %>%
    select(
      "date", "quantity", "currency", "total.price",
      "spot.rate", "transaction", "revenue.type",
      "description", "comment"
    )

  # Create a "REFERRAL" object
  REFERRAL <- data %>%
    filter(.data$description == "other" & comment == "credit") %>%
    rename(
      quantity = "Amount.Credited",
      currency = "Credit.Currency"
    ) %>%
    mutate(
      transaction = "revenue",
      revenue.type = "referrals",
      spot.rate = 1,
      total.price = .data$quantity * .data$spot.rate,
    ) %>%
    select(
      "date", "quantity", "currency", "total.price",
      "spot.rate", "transaction", "revenue.type",
      "description", "comment"
    )

  # Create a "sell" object
  SELL <- data %>%
    filter(.data$description == "purchase/sale") %>%
    rename(
      quantity = "Amount.Debited",
      currency = "Debit.Currency",
      total.price = "Amount.Credited"
    ) %>%
    mutate(
      transaction = "sell",
      spot.rate = .data$total.price / .data$quantity
    ) %>%
    select(
      "date", "quantity", "currency", "total.price",
      "spot.rate", "transaction", "description", "comment"
    ) %>%
    filter(.data$currency != "CAD")

  # Merge the "buy" and "sell" objects
  data <- bind_rows(BUY, SHAKES, REFERRAL, SELL) %>%
    mutate(
      exchange = "shakepay",
      rate.source = "exchange"
    ) %>%
    arrange(date)

  # Reorder columns properly
  data <- data %>%
    select(
      "date", "currency", "quantity", "total.price", "spot.rate", "transaction",
      "description", "comment", "revenue.type", "exchange", "rate.source"
    )

  # Return result
  data
}
