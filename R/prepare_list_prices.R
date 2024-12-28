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
#' @param slug Which coins to include in the list. However, because of too
#' many duplicated symbols, you must use the unique "slug" name of the coin.
#' You can obtain the correct slug using
#' [crypto2::crypto_list()] and then filtering for your
#' symbol.
#' @param start.date What date to start reporting prices for.
#' @param end.date What date to end reporting prices for.
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
#' my.coins <- c("bitcoin", "ethereum")
#' my.list.prices <- prepare_list_prices(slug = my.coins, start.date = "2023-01-01")
#' head(my.list.prices)
#' @importFrom dplyr %>% rename mutate rowwise filter select bind_rows
#' left_join arrange relocate distinct
#' @importFrom utils timestamp
#' @importFrom rlang .data

prepare_list_prices <- function(slug,
                                start.date,
                                end.date = lubridate::now("UTC"),
                                force = FALSE) {
  # List all active coins
  if (!exists("coins.list")) {
    if (isFALSE(curl::has_internet())) {
      message("This function requires Internet access.")
      return(NULL)
    }

    tryCatch(
      expr = {
        coins.list <- crypto2::crypto_list(only_active = TRUE)
      },
      error = function(e) {
        message("Could not reach the CoinMarketCap API at this time")
        return(NULL)
      },
      warning = function(w) {
        return(NULL)
      }
    )

    if (!exists("coins.list")) {
      message("Could not reach the CoinMarketCap API at this time")
      return(NULL)
    }

    coins.list <<- coins.list
  }

  if (isTRUE(force) || !exists("list.prices")) {
    if (isFALSE(curl::has_internet())) {
      message("This function requires Internet access.")
      return(NULL)
    }

    # Define coins from our merged data set

    if (is.null(slug)) {
      # For demonstration purposes
      coins <- c("bitcoin", "ethereum")
    }

    my.coins <- slug
    names(my.coins) <- my.coins

    # Remove the NFTs, TCAD, CAD, GB
    # my.coins <- my.coins[!grepl("NFT", my.coins)]
    # my.coins <- my.coins[!grepl("TCAD", my.coins)]
    # my.coins <- my.coins[!grepl("CAD", my.coins)]
    # my.coins <- my.coins[!grepl("GB", my.coins)]
    # Remove TCAD/CAD (Market data is untracked: This project is featured as an 'Untracked Listing')

    # Correct for Nano!!
    # my.coins <- gsub("NANO", "XNO", my.coins)

    # Dates cannot have hyphens in crypto2::crypto_history!
    start.date <- start.date %>%
      as.Date() %>%
      stringr::str_split("-", simplify = TRUE) %>%
      paste(collapse = "")

    end.date <- end.date %>%
      as.Date() %>%
      stringr::str_split("-", simplify = TRUE) %>%
      paste(collapse = "")

    coins.temp <- coins.list %>%
      filter(.data$slug %in% my.coins)

    coin_hist <- tryCatch(
      expr = {
        crypto2::crypto_history(
          coin_list = coins.temp,
          start_date = start.date,
          end_date = end.date,
          # convert = currency, # not working anymore with CAD (only USD)
          sleep = 0, # changed from 60
          finalWait = FALSE # changed from TRUE
        )
      },
      error = function(e) {
        message(c(
          "Could not fetch crypto prices from the CoinMarketCap API. ",
          "Please try again, perhaps with fewer coins."
        ))
        return(NULL)
      },
      warning = function(w) {
        return(NULL)
      }
    )

    if (!exists("coin_hist")) {
      message("'coin_hist' could not fetch correctly. Please try again.")
      return(NULL)
    }

    # coin_hist <- bind_rows(coin_hist)

    if (!"symbol" %in% names(coin_hist)) {
      message("'coin_hist' could not fetch correctly. Please try again.")
      return(NULL)
    }

    coin_hist <<- coin_hist

    list.prices <- coin_hist %>%
      mutate(date = lubridate::as_date(.data$timestamp)) %>%
      rowwise() %>%
      mutate(spot.rate_USD = mean(c(.data$open, .data$close))) %>%
      ungroup() %>%
      USD2CAD()
    
    # Add USD as currency to go around some problems of the CDC exchange
    USD_prices <- list.prices %>% 
      select("date", "CAD.rate") %>% 
      distinct()
    
    USD_df <- data.frame(
      slug = "usdollar",
      name = "US Dollar",
      symbol = "USD",
      spot.rate_USD = 1,
      date = unique(list.prices$date)) %>% 
      left_join(USD_prices, by = "date")
    
    list.prices <- list.prices %>% 
      bind_rows(USD_df) %>% 
      mutate(
        spot.rate2 = .data$spot.rate_USD * .data$CAD.rate,
        currency = .data$symbol,
        date2 = date
      ) %>%
      select(-date)
    
  } else {
    message(
      "Object 'list.prices' already exists. Reusing 'list.prices'. ",
      "To force a fresh download, use argument 'force = TRUE'."
    )
  }

  list.prices
}

#' @rdname prepare_list_prices
#' @name add_popular_slugs
#' @param data The data to which to convert the coin symbol / ticker to the 
#' "slug" (full name of the coin).
#' @param slug_dictionary A table of equivalency between the coin symbol /
#' ticker and its slug. By default uses the provided `popular_slugs` object
#' with the most popular coins. This is to avoid all the duplicated coin
#' tickers that are returned with [crypto2::crypto_list()].
#' @export
add_popular_slugs <- function(data, slug_dictionary = popular_slugs) {
  left_join(data, slug_dictionary, by = "currency") %>%
    relocate("slug", .after = "currency")
}

#' @rdname prepare_list_prices
#' @name popular_slugs
#' @export
popular_slugs <- data.frame(
  slug = c(
    "bitcoin", "ethereum", "cardano", "cronos", "litecoin", "dogelon", "basic-attention-token",
    "usd-coin", "gemini-dollar", "tether", "binance-usd", "celsius", "presearch", "monero",
    "xrp", "bitcoin-cash", "stellar", "boson-protocol", "efinity", "nano",
    "ethereum-pow", "terra-luna-v2", "terra-luna", "dydx-chain", "hedera", "shiden-network",
    "shiba-inu", "dogecoin", "enjin-coin", "USD", "CAD"
  ),
  currency = c(
    "BTC", "ETH", "ADA", "CRO", "LTC", "ELON", "BAT",
    "USDC", "GUSD", "USDT", "BUSD", "CEL", "PRE", "XMR",
    "XRP", "BCH", "XLM", "BOSON", "EFI", "XNO",
    "ETHW", "LUNA", "LUNC", "DYDX", "HBAR", "SDN",
    "SHIB", "DOGE", "ENJ", "USD", "CAD"
  )
)
