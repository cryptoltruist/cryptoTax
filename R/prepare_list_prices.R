#' @title Prepare the list of coins for prices
#'
#' @description Prepare the list of coins for prices.
#' @param coins Which coins to include in the list.
#' @param start.date What date to start reporting prices for.
#' @param end.date What date to end reporting prices for.
#' @keywords money crypto
#' @export
#' @examples
#' \dontrun{
#' match_prices(data)
#' }
#' @importFrom dplyr %>% rename mutate rowwise filter select bind_rows left_join arrange
#' @importFrom utils timestamp
#' @importFrom rlang .data

prepare_list_prices <- function(coins, start.date, end.date = Sys.Date()) {
  # List all active coins
  if (!exists("coins.list")) {
    coins.list <- crypto2::crypto_list(only_active = TRUE)
    # Remove some bad coins from list (which share the same name with NANO or EFI for example)
    coins.list <- coins.list %>%
      filter(!(.data$slug %in% c("xeno-token", "earnablefi")))

    coins.list <<- coins.list
  }

  if (!exists("list.prices")) {
    # Define coins from our merged data set
    my.coins <- coins
    names(my.coins) <- my.coins

    # Remove the NFTs, TCAD, CAD, GB
    my.coins <- my.coins[!grepl("NFT", my.coins)]
    my.coins <- my.coins[!grepl("TCAD", my.coins)]
    my.coins <- my.coins[!grepl("CAD", my.coins)]
    my.coins <- my.coins[!grepl("GB", my.coins)]
    # Remove TCAD/CAD (Market data is untracked: This project is featured as an 'Untracked Listing')

    # Correct for Nano!!
    my.coins <- gsub("NANO", "XNO", my.coins)

    # Filter old coins object for coins from our merged data set
    coins.temp <- coins.list %>%
      filter(.data$symbol %in% my.coins)

    # Dates cannot have hyphens in crypto2::crypto_history!
    start.date <- paste(stringr::str_split(start.date, "-", simplify = TRUE), collapse = "")
    end.date <- paste(stringr::str_split(end.date, "-", simplify = TRUE), collapse = "")

    coin_hist <- crypto2::crypto_history(
      coin_list = coins.temp,
      start_date = start.date,
      end_date = end.date,
      convert = "CAD",
      sleep = 0, # changed from 60
      finalWait = FALSE
    ) # changed from TRUE

    coin_hist <<- coin_hist

    list.prices <- coin_hist %>%
      rowwise() %>%
      mutate(
        spot.rate2 = mean(c(.data$open, .data$close)),
        currency = .data$symbol
      )
  }

  list.prices
}
