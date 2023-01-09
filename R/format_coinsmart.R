#' @title Format CoinSmart file
#'
#' @description Format a .csv transaction history file from CoinSmart for later ACB processing.
#' @param data The dataframe
#' @export
#' @examples
#' \dontrun{
#' format_coinsmart(data)
#' }
#' @importFrom dplyr %>% rename mutate rowwise filter select arrange transmute bind_rows
#' @importFrom rlang .data

format_coinsmart <- function(data) {
  # Rename columns
  data <- data %>%
    rename(
      currency = "Product",
      description = "TransactionType",
      comment = "ReferenceType",
      date = "TimeStamp"
    )

  # Add single dates to dataframe
  data <- data %>%
    mutate(
      date = lubridate::as_datetime(.data$date, tz = "Etc/GMT+6"),
      date = lubridate::with_tz(.data$date, tz = "UTC")
    )
  # 2022-01-15 agent sending the file confirmed CST so I have adjusted the code above

  # We actually need to do a little trick here for later processing of the dates
  data <- data %>%
    mutate(date = trunc(.data$date))

  # Rearrange on chronological order
  data <- data %>%
    arrange(date)

  # Specify whether it's a buy or sell
  data <- data %>%
    mutate(description = ifelse(.data$Credit > 0 & .data$description == "Trade",
      "purchase",
      ifelse(.data$Debit > 0 & .data$description == "Trade",
        "sale",
        .data$description
      )
    ))

  # Determine spot rate and value of coins
  data <- data %>%
    mutate(spot.rate = ifelse(.data$currency == "CAD",
      1,
      NA
    ))
  data <- cryptoTax::match_prices(data)

  # Add total.price
  data <- data %>%
    rowwise() %>%
    mutate(total.price = sum(.data$Credit, .data$Debit) * .data$spot.rate)

  # Create a "buy" object
  BUY <- data %>%
    filter(.data$description %in% c("purchase")) %>%
    mutate(
      quantity = .data$Credit,
      transaction = "buy"
    ) %>%
    select(
      "date", "quantity", "currency", "total.price", "spot.rate",
      "transaction", "description", "comment", "rate.source"
    )

  # CORRECT SPOT RATE FOR CAD TO CRYPTO TRANSACTIONS [for CAD purchases]
  # Replace total.price first, then in a second step spot.rate
  CAD.prices <- data %>%
    filter(.data$description %in% c("sale")) %>%
    mutate(
      quantity = .data$Debit,
      transaction = "sell"
    ) %>%
    filter(.data$currency == "CAD")

  # These are the prices I want to replace
  BUY[which(BUY$date %in% CAD.prices$date), "total.price"]

  # These are the correct prices
  CAD.prices$total.price

  # Let's replace them
  BUY[which(BUY$date %in% CAD.prices$date), "total.price"] <- CAD.prices$total.price

  # Now let's recalculate spot.rate
  BUY <- BUY %>%
    mutate(spot.rate = .data$total.price / .data$quantity)

  # Let's also replace the rate.source for these transactions
  BUY[which(BUY$date %in% CAD.prices$date), "rate.source"] <- "exchange"

  # Isolate trading fees
  FEES.BUY <- data %>%
    filter(.data$description == "Fee" &
      comment == "Trade") %>%
    transmute(fees = .data$total.price)

  # Merge fees to our BUY object
  BUY <- cbind(BUY, FEES.BUY)

  # Create a "earn" object
  EARN <- data %>%
    mutate(comment = trimws(.data$comment)) %>%
    # Have to trim white spaces here because they made a typo
    # And added a space in "Referral ".
    filter(.data$comment %in% c(
      "Quiz",
      "Referral"
    )) %>%
    mutate(
      quantity = .data$Credit,
      transaction = "revenue",
      revenue.type = replace(
        .data$comment,
        .data$comment %in% c("Quiz"),
        "airdrops"
      ),
      revenue.type = replace(
        .data$revenue.type,
        .data$revenue.type %in% c("Referral"),
        "referrals"
      )
    ) %>%
    select(
      "date", "quantity", "currency", "total.price",
      "spot.rate", "transaction", "revenue.type",
      "description", "comment", "rate.source"
    )

  # Create a "sell" object
  SELL <- data %>%
    filter(.data$description %in% c("sale")) %>%
    mutate(
      quantity = .data$Debit,
      transaction = "sell"
    ) %>%
    select(
      "date", "quantity", "currency", "total.price", "spot.rate",
      "transaction", "description", "comment", "rate.source"
    ) %>%
    filter(.data$currency != "CAD")

  # CORRECT SPOT RATE FOR COIN TO COIN TRANSACTIONS [for sales]
  # Replace total.price first, then in a second step spot.rate

  coin.prices <- data %>%
    filter(.data$description %in% c("purchase")) %>%
    mutate(
      quantity = .data$Debit,
      transaction = "sell"
    )

  # These are the prices I want to replace
  SELL[which(SELL$date %in% coin.prices$date), "total.price"]

  # These are the correct prices
  coin.prices[which(coin.prices$date %in% SELL$date), "total.price"]

  # Let's replace them
  SELL[which(SELL$date %in% coin.prices$date), "total.price"] <- coin.prices[which(
    coin.prices$date %in% SELL$date
  ), "total.price"]

  # Now let's recalculate spot.rate
  SELL <- SELL %>%
    mutate(spot.rate = .data$total.price / .data$quantity)

  # Let's also replace the rate.source for these transactions
  SELL[which(SELL$date %in% coin.prices$date), "rate.source"] <- "coinmarketcap - buy price"

  # Create a "withdrawals" object
  WITHDRAWALS <- data %>%
    filter(.data$description == "Fee" &
      comment == "Withdraw") %>%
    mutate(
      quantity = .data$Debit,
      total.price = .data$quantity * .data$spot.rate,
      transaction = "sell"
    ) %>%
    select(
      "date", "quantity", "currency", "spot.rate", "total.price",
      "transaction", "description", "comment", "rate.source"
    )

  # Actually withdrawal fees should be like "selling at zero", so correct total.price
  # WITHDRAWALS <- WITHDRAWALS %>%
  #  mutate(total.price = 0)

  # Merge the "buy" and "sell" objects
  data <- merge_exchanges(BUY, EARN, SELL, WITHDRAWALS) %>%
    mutate(exchange = "coinsmart")

  # Add trade info in comments

  # Find duplicate indexes
  index.duplicate2 <- data %>%
    select(date) %>%
    duplicated() %>%
    which()

  # Find indexes before duplicates
  index.duplicate1 <- index.duplicate2 - 1

  # Combine them in a matrix
  double.index <- cbind(index.duplicate1, index.duplicate2)

  # Get the respective currency names
  string1 <- data[double.index[, 1], "currency"]
  string2 <- data[double.index[, 2], "currency"]

  # Define the right string
  good.string <- rep(paste0("Trade (", string1, "-", string2, ")"), each = 2)

  # Replace values
  data[sort(as.vector(double.index)), "comment"] <- good.string

  # Return result
  data
}