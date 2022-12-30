#' @title Get Fair Market Value (FMV) of transactions
#'
#' @description Matches prices obtained through the `fetch_prices()` function with the transaction data frame.
#' @param data The dataframe
#' @keywords money crypto
#' @export
#' @examples
#' \dontrun{
#' match_prices(data)
#' }
#' @importFrom dplyr %>% rename mutate rowwise filter select bind_rows left_join arrange
#' @importFrom utils timestamp
#' @importFrom rlang .data

match_prices <- function(data) {
  all.data <- data

  # Create an empty spot.rate if missing else the function won't work
  if (!("spot.rate" %in% names(all.data))) {
    all.data$spot.rate <- NA
  }

  # Same for total.price
  if (!("total.price" %in% names(all.data))) {
    all.data$total.price <- NA
  }

  # Same for rate.source
  if (!("rate.source" %in% names(all.data))) {
    all.data$rate.source <- NA
  }

  # Add spot.rate of 1 for TCAD
  all.data <- all.data %>%
    mutate(spot.rate = ifelse(.data$currency == "TCAD", 1, .data$spot.rate))

  # List all active coins
  if (!exists("coins.list")) {
    coins.list <- crypto2::crypto_list(only_active = TRUE)
    coins.list <<- coins.list
  }

  # Remove some bad coins from list (which share the same name with NANO or EFI for example)
  coins.list <- coins.list %>%
    filter(!(.data$slug %in% c("xeno-token", "earnablefi")))

  # Define coins from our merged data set
  my.coins <- unique(all.data$currency)
  names(my.coins) <- my.coins

  # Remove the NFTs, TCAD, CAD, GB
  my.coins <- my.coins[!grepl("NFT", my.coins)]
  my.coins <- my.coins[!grepl("TCAD", my.coins)]
  my.coins <- my.coins[!grepl("CAD", my.coins)]
  my.coins <- my.coins[!grepl("GB", my.coins)]
  # Remove TCAD/CAD (Market data is untracked: This project is featured as an 'Untracked Listing')

  # Apply the fetch_prices function to all the coins
  if (!exists("list.prices")) {
    list.prices <- lapply(my.coins,
      fetch_prices,
      data = all.data,
      coins.list = coins.list
    )
    list.prices <<- list.prices
  }

  # Combine the lists together in one dataframe, and change the date format
  df.prices <- bind_rows(list.prices) %>%
    mutate(
      date2 = lubridate::as_date(.data$timestamp),
      currency = ifelse(.data$currency == "XNO", "NANO", .data$currency)
    )

  # Get date in proper format for matching and merge data
  new.data <- all.data %>%
    mutate(date2 = lubridate::as_date(.data$date)) %>%
    left_join(df.prices[c("currency", "spot.rate2", "date2")], by = c("date2", "currency"))

  # Add source of spot.rate and total.price
  new.data <- new.data %>%
    mutate(
      rate.source = ifelse(is.na(.data$spot.rate),
        "coinmarketcap",
        ifelse(is.na(.data$rate.source),
          "exchange",
          .data$rate.source
        )
      ),
      spot.rate = ifelse(is.na(.data$spot.rate), .data$spot.rate2, .data$spot.rate),
      # total.price = ifelse(is.na(total.price),
      #                      quantity * spot.rate,
      #                      total.price)
    ) %>%
    select(-c(.data$date2, .data$spot.rate2))
  new.data
}
