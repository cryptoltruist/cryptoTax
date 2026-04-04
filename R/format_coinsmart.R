#' @title Format CoinSmart file
#'
#' @description Format a .csv transaction history file from CoinSmart for later ACB processing.
#' @param data The dataframe
#' @param list.prices A `list.prices` object from which to fetch coin prices.
#' @param force Whether to force recreating `list.prices` even though
#' it already exists (e.g., if you added new coins or new dates).
#' @return A data frame of exchange transactions, formatted for further processing.
#' @export
#' @examples
#' format_coinsmart(data_coinsmart)
#' @importFrom dplyr %>% rename mutate rowwise filter select arrange transmute bind_rows
#' @importFrom rlang .data

format_coinsmart <- function(data, list.prices = NULL, force = FALSE) {
  known.transactions <- c("Withdraw", "Trade", "Quiz", "Deposit", "Referral")

  data <- .format_coinsmart_prepare_input(data, known.transactions)

  data <- match_prices(data, list.prices = list.prices, force = force)

  if (is.null(data)) {
    message("Could not reach the CoinMarketCap API at this time")
    return(NULL)
  }

  if (any(is.na(data$spot.rate))) {
    warning("Could not calculate spot rate. Use `force = TRUE`.")
  }

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
  BUY <- .coinsmart_apply_trade_prices(BUY, CAD.prices, "exchange")

  # Isolate trading fees
  FEES.BUY <- data %>%
    filter(.data$description == "Fee" &
      .data$comment == "Trade") %>%
    mutate(fees = .data$total.price, 
           fees.quantity = .data$Debit,
           fees.currency = .data$currency) %>% 
    select("fees", "fees.quantity", "fees.currency")

  # Merge fees to our BUY object
  BUY <- cbind(BUY, FEES.BUY)

  # Create a "earn" object
  EARN <- data %>%
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
  SELL <- .coinsmart_apply_trade_prices(SELL, coin.prices, "coinmarketcap (buy price)")

  # Create a "withdrawals" object
  WITHDRAWALS <- data %>%
    filter(.data$description == "Fee" &
      .data$comment == "Withdraw") %>%
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
  # We do not agree with the above interpretation anymore

  # Merge the "buy" and "sell" objects
  data <- bind_rows(BUY, EARN, SELL, WITHDRAWALS) %>%
    mutate(exchange = "coinsmart") %>%
    arrange(.data$date, desc(.data$total.price))

  data <- .coinsmart_trade_comments(data)

  # Reorder columns properly
  data <- data %>%
    select(
      "date", "currency", "quantity", "total.price", "spot.rate", 
      "transaction", "fees", "fees.quantity", "fees.currency", 
      "description", "comment", "revenue.type", "exchange", "rate.source"
    )

  # Return result
  data
}

.format_coinsmart_prepare_input <- function(data, known.transactions) {
  data <- data %>%
    rename(
      currency = "Product",
      description = "TransactionType",
      comment = "ReferenceType",
      date = "TimeStamp"
    ) %>%
    mutate(comment = trimws(.data$comment))

  check_new_transactions(data,
    known.transactions = known.transactions,
    transactions.col = "comment",
    description.col = "description"
  )

  data %>%
    mutate(
      date = lubridate::as_datetime(.data$date, tz = "Etc/GMT+6"),
      date = lubridate::with_tz(.data$date, tz = "UTC"),
      date = trunc(.data$date),
      description = ifelse(.data$Credit > 0 & .data$description == "Trade",
        "purchase",
        ifelse(.data$Debit > 0 & .data$description == "Trade",
          "sale",
          .data$description
        )
      ),
      spot.rate = ifelse(.data$currency == "CAD", 1, NA)
    ) %>%
    arrange(.data$date)
}

.coinsmart_apply_trade_prices <- function(data, reference_prices, rate_source_value) {
  if (!nrow(reference_prices)) {
    return(data)
  }

  match_index <- which(data$date %in% reference_prices$date)
  if (!length(match_index)) {
    return(data)
  }

  matched_prices <- reference_prices[which(reference_prices$date %in% data$date), "total.price"]
  data[match_index, "total.price"] <- matched_prices
  data <- data %>%
    mutate(spot.rate = .data$total.price / .data$quantity)
  data[match_index, "rate.source"] <- rate_source_value
  data
}

.coinsmart_trade_comments <- function(data) {
  index.duplicate2 <- data %>%
    select("date") %>%
    duplicated() %>%
    which()

  if (!length(index.duplicate2)) {
    return(data)
  }

  index.duplicate1 <- index.duplicate2 - 1
  double.index <- cbind(index.duplicate1, index.duplicate2)
  string1 <- data[double.index[, 1], "currency"]
  string2 <- data[double.index[, 2], "currency"]
  good.string <- rep(paste0("Trade (", string1, "-", string2, ")"), each = 2)
  data[sort(as.vector(double.index)), "comment"] <- good.string
  data
}
