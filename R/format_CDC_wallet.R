#' @title Format CDC wallet file
#'
#' @description Format a .csv transaction history file from the Crypto.com DeFi
#' wallet for later ACB processing.
#'
#' One way to download the CRO staking rewards data from the blockchain is to
#' visit http://crypto.barkisoft.de/ and input your CRO address. Keep the default
#' export option ("Koinly"). It will output a CSV file with your transactions.
#' Note: the site does not use a secure connection: use at your own risks.
#' The file is semi-column separated; when using `read.csv`, add the `sep = ";"`
#' argument.
#'
#' @param data The dataframe
#' @export
#' @examples
#' \dontrun{
#' format_CDC_wallet(data)
#' }
#' @importFrom dplyr %>% rename mutate filter select arrange bind_rows mutate_at
#' @importFrom rlang .data

format_CDC_wallet <- function(data) {
  # Rename columns
  data <- data %>%
    rename(
      quantity = "Received.Amount",
      currency = "Received.Currency",
      description = "Label",
      comment = "Description",
      date = "Date"
    )

  # Add single dates to dataframe
  data <- data %>%
    mutate(date = lubridate::as_datetime(.data$date))
  # UTC confirmed

  # Add description to deposits and withdrawals
  data <- data %>%
    mutate(
      description = ifelse(grepl("Incoming", .data$comment),
        "Deposit",
        ifelse(grepl("Outgoing", .data$comment),
          "Withdrawal",
          .data$description
        )
      ),
      currency = ifelse(.data$Sent.Currency != "",
        .data$Sent.Currency,
        .data$currency
      ),
      quantity = ifelse(!is.na(.data$Sent.Amount),
        .data$Sent.Amount,
        .data$quantity
      )
    )

  # Create a "earn" object
  EARN <- data %>%
    filter(.data$description %in% c("Reward")) %>%
    mutate(
      transaction = "revenue",
      revenue.type = "staking"
    ) %>%
    select(
      "date", "quantity", "currency", "transaction",
      "revenue.type", "description", "comment"
    )

  # Create a "withdrawals" object
  WITHDRAWALS <- data %>%
    filter(.data$description == "Withdrawal") %>%
    mutate(
      quantity = .data$Fee.Amount,
      transaction = "sell"
    ) %>%
    select(
      "date", "quantity", "currency", "transaction",
      "description", "comment"
    )

  # Actually withdrawal fees should be like "selling at zero", so correct total.price
  # WITHDRAWALS <- WITHDRAWALS %>%
  #  mutate(total.price = 0)

  # Merge the "buy" and "sell" objects
  data <- bind_rows(EARN, WITHDRAWALS) %>%
    mutate(
      fees = 0,
      exchange = "CDC.wallet"
    ) %>%
    arrange(date)

  # Determine spot rate and value of coins
  data <- cryptoTax::match_prices(data)

  data <- data %>%
    mutate(total.price = ifelse(is.na(.data$total.price),
      .data$quantity * .data$spot.rate,
      .data$total.price
    ))

  # Return result
  data
}
