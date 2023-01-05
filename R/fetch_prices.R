#' @title Fetch prices of daily transactions
#'
#' @description Fetches daily prices of coins through the crypto2 package.
#' @param coin The coin
#' @param data The dataframe
#' @param coins.list The coins list
#' @export
#' @examples
#' \dontrun{
#' fetch_prices(data)
#' }
#' @importFrom dplyr %>% filter summarize slice pull rowwise mutate
#' @importFrom rlang .data

fetch_prices <- function(coin, data, coins.list) {
  min.date <- data %>%
    filter(.data$currency == coin) %>%
    summarize(min(.data$date)) %>%
    slice(1) %>%
    pull() %>%
    as.Date() - 5
  min.date <- paste(stringr::str_split(min.date, "-", simplify = TRUE), collapse = "")

  max.date <- data %>%
    filter(.data$currency == coin) %>%
    summarize(max(.data$date)) %>%
    slice(1) %>%
    pull() %>%
    as.Date() + 5
  max.date <- paste(stringr::str_split(max.date, "-", simplify = TRUE), collapse = "")

  # Correct for Nano!!
  if (coin == "NANO") {
    coin <- "XNO"
  }

  # Filter old coins object for coins from our merged data set
  coins.temp <- coins.list %>%
    filter(.data$symbol %in% coin)

  coin_hist <- crypto2::crypto_history(coins.temp,
    start_date = min.date,
    end_date = max.date,
    convert = "CAD",
    sleep = 0, # changed from 60
    finalWait = FALSE
  ) # changed from TRUE

  coin_hist <- coin_hist %>%
    rowwise() %>%
    mutate(
      spot.rate2 = mean(c(.data$open, .data$close)),
      currency = .data$symbol
    )
  coin_hist
}
