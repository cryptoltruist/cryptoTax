#' @title Prepare the list of coins for prices
#'
#' @description Prepare the list of coins for prices.
#' @details The [crypto2::crypto_history] API is at times a bit capricious. You might
#' need to try a few times before it processes correctly and without
#' errors.
#' 
#' Sometimes, `list.prices` (through coinmarketcap) will contain symbols for 
#' a given coin (e.g., ETH) that is actually shared by multiple coins, thus, 
#' the necessity of the `remove.coins.slug` argument. In these cases, we can 
#' look at the slug column of `list.prices` to identify the correct coins. 
#' ETH for example possesses two slugs: "ethereum" (the main one) and 
#' "the-infinite-garden" (probably not the one you want). Per default, a 
#' number of duplicate slugs are excluded, the list of which is accessible in 
#' the `slugs_to_remove` object. However, you can provide your own list, 
#' should you wish to.
#' 
#' @param coins Which coins to include in the list.
#' @param start.date What date to start reporting prices for.
#' @param end.date What date to end reporting prices for.
#' @param currency What currency to get the value of the coins in.
#' @param remove.coins.slug Which currencies to filter out, usually when
#' the `list.prices` object symbol for a given coin is shared by
#' multiple coins (see details).
#' @param force Whether to force recreating `list.prices` even though
#' it already exists (e.g., if you added new coins or new dates).
#' @return A data frame, with the following columns: timestamp, id, slug, 
#' name, symbol, ref_cur, open, high, low, close, volume, market_cap, 
#' time_open, time_close, time_high, time_low, spot.rate2, currency, date2.
#' @export
#' @name prepare_list_prices
#' @examples
#' my.coins <- c("BTC", "ETH")
#' my.list.prices <- prepare_list_prices(coins = my.coins, start.date = "2023-01-01")
#' head(my.list.prices)
#' @importFrom dplyr %>% rename mutate rowwise filter select bind_rows left_join arrange
#' @importFrom utils timestamp
#' @importFrom rlang .data

prepare_list_prices <- function(coins,
                                start.date,
                                end.date = lubridate::now("UTC"),
                                currency = "CAD",
                                remove.coins.slug = slugs_to_remove,
                                force = FALSE) {
  # List all active coins
  if (!exists("coins.list")) {
    if (isFALSE(curl::has_internet())) {
      message("This function requires Internet access.")
      return(NULL)
    }
    
  tryCatch(
    expr = {coins.list <- crypto2::crypto_list(only_active = TRUE)},
    error = function(e) {
      message("Could not reach the CoinMarketCap API at this time")
      return(NULL)
      },
    warning = function(w) {
      return(NULL)
    })
    
    if (!exists("coins.list")) {
      message("Could not reach the CoinMarketCap API at this time")
      return(NULL)
    }
    
    # Remove some bad coins from list (which share the same name with NANO or EFI for example)
    coins.list <- coins.list %>%
      filter(!(.data$slug %in% remove.coins.slug))
    
    coins.list <<- coins.list
  }
  
  if (isTRUE(force) || !exists("list.prices")) {
    
    if (isFALSE(curl::has_internet())) {
      message("This function requires Internet access.")
      return(NULL)
    }
    
    # Define coins from our merged data set

    if (is.null(coins)) {
      # For demonstration purposes
      coins <- c("BTC", "ETH")
    }

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

    coin_hist <- lapply(my.coins, function(x) {
      # Filter old coins object for coins from our merged data set
      coins.temp <- coins.list %>%
        filter(.data$symbol %in% x)
      
      # Dates cannot have hyphens in crypto2::crypto_history!
      start.date <- start.date %>%
        as.Date() %>%
        stringr::str_split("-", simplify = TRUE) %>%
        paste(collapse = "")
      
      end.date <- end.date %>%
        as.Date() %>%
        stringr::str_split("-", simplify = TRUE) %>%
        paste(collapse = "")
      
      tryCatch(
        expr = {
          crypto2::crypto_history(
            coin_list = coins.temp,
            start_date = start.date,
            end_date = end.date,
            convert = currency,
            sleep = 0, # changed from 60
            finalWait = FALSE # changed from TRUE
          )
        },
        error = function(e) {
          message(c("Could not fetch crypto prices from the CoinMarketCap API. ",
                    "Please try again, perhaps with fewer coins."))
          return(NULL)},
        warning = function(w) {
          return(NULL)
        })
      })
    
    if (!exists("coin_hist")) {
      message("'coin_hist' could not fetch correctly. Please try again.")
      return(NULL)
    }
    
    coin_hist <- bind_rows(coin_hist)
    
    if (!"symbol" %in% names(coin_hist)) {
      message("'coin_hist' could not fetch correctly. Please try again.")
      return(NULL)
    }
        
    coin_hist <<- coin_hist
    
    list.prices <- coin_hist %>%
      rowwise() %>%
      mutate(
        spot.rate2 = mean(c(.data$open, .data$close)),
        currency = .data$symbol,
        date2 = lubridate::as_date(.data$timestamp)
      )
  } else {
    message(
      "Object 'list.prices' already exists. Reusing 'list.prices'. ",
      "To force a fresh download, use argument 'force = TRUE'."
    )
  }

  list.prices
}

#' @rdname prepare_list_prices
#' @export
slugs_to_remove <- c(
  "xeno-token", 
  "earnablefi", 
  "upsidedowncat",
  "the-infinite-garden",
  "ada",
  "pre",
  "niccagewaluigielmo42069inu",
  "shibwifhat",
  "shibainu-on-solana",
  "shibaqua",
  "tooly-i-am-king",
  "doge-on-pulsechain",
  "doge-satellite-inu",
  "dogecoin-x",
  "space-doge",
  "elon-doge-token",
  "super-doge",
  "moon-doge"
)
