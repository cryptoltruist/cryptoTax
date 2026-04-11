.resolve_coins_list <- function(force = FALSE, coins.list = NULL, verbose = TRUE) {
  if (!is.null(coins.list)) {
    return(coins.list)
  }

  if (.can_reuse_cached_pricing_object("coins.list", force = force, allow_null = TRUE)) {
    return(.get_cached_pricing_object("coins.list"))
  }

  if (isFALSE(curl::has_internet()) && isTRUE(verbose)) {
    message("This function requires Internet access.")
    return(NULL)
  }

  fetched_coins <- tryCatch(
    expr = {
      crypto2::crypto_list(only_active = TRUE)
    },
    error = function(e) {
      message("Could not reach the CoinMarketCap API at this time")
      return(NULL)
    },
    warning = function(w) {
      return(NULL)
    }
  )

  if (is.null(fetched_coins) && isTRUE(verbose)) {
    message("Could not reach the CoinMarketCap API at this time")
    return(NULL)
  }

  .set_cached_pricing_object("coins.list", fetched_coins)
}

.resolve_list_prices <- function(force = FALSE, list.prices = NULL, verbose = TRUE) {
  if (!is.null(list.prices)) {
    return(list.prices)
  }

  if (!.can_reuse_cached_pricing_object("list.prices", force = force)) {
    return(NULL)
  }

  cached_list_prices <- .get_cached_pricing_object("list.prices")

  if (!.is_valid_list_prices_table(cached_list_prices)) {
    return(NULL)
  }

  if (isTRUE(verbose)) {
    message(
      "Object 'list.prices' already exists. Reusing 'list.prices'. ",
      "To force a fresh download, use argument 'force = TRUE'."
    )
  }

  cached_list_prices
}

.format_prepare_price_date <- function(x) {
  x %>%
    as.Date() %>%
    stringr::str_split("-", simplify = TRUE) %>%
    paste(collapse = "")
}

.build_list_prices_from_history <- function(coin_hist, USD2CAD.table = NULL) {
  resolved_list_prices <- coin_hist %>%
    mutate(date = lubridate::as_date(.data$timestamp)) %>%
    rowwise() %>%
    mutate(spot.rate_USD = mean(c(.data$open, .data$close))) %>%
    ungroup() %>%
    USD2CAD(USD2CAD.table = USD2CAD.table)

  if (is.null(resolved_list_prices)) {
    return(NULL)
  }

  USD_prices <- resolved_list_prices %>%
    select("date", "CAD.rate") %>%
    distinct()

  USD_df <- data.frame(
    slug = "usdollar",
    name = "US Dollar",
    symbol = "USD",
    spot.rate_USD = 1,
    date = unique(resolved_list_prices$date)
  ) %>%
    left_join(USD_prices, by = "date")

  resolved_list_prices %>%
    bind_rows(USD_df) %>%
    mutate(
      spot.rate2 = .data$spot.rate_USD * .data$CAD.rate,
      currency = .data$symbol,
      date2 = .data$date
    ) %>%
    select(-"date")
}

.maybe_cache_list_prices <- function(list.prices, cache = TRUE) {
  if (isTRUE(cache) && !is.null(list.prices)) {
    .set_cached_pricing_object("list.prices", list.prices)
  }

  list.prices
}

.prepare_price_slugs <- function(data, slug = NULL) {
  if (!is.null(slug)) {
    return(slug)
  }

  data <- add_popular_slugs(data)
  unique(data$slug)
}

.prepare_price_start_date <- function(data, start.date = NULL) {
  if (!is.null(start.date)) {
    return(start.date)
  }

  min(data$date)
}

.prepare_list_price_inputs <- function(data, slug = NULL, start.date = NULL) {
  list(
    slug = .prepare_price_slugs(data, slug = slug),
    start.date = .prepare_price_start_date(data, start.date = start.date)
  )
}

.reject_usd_only_slug <- function(slug, verbose = TRUE) {
  if (all(unique(slug) == "USD")) {
    if (isTRUE(verbose)) {
      message("Slug cannot be only USD for 'prepare_list_prices()'")
    }
    return(TRUE)
  }

  FALSE
}

.handle_missing_list_prices <- function(list.prices, verbose = TRUE) {
  if (!is.null(list.prices)) {
    return(list.prices)
  }

  if (isTRUE(verbose)) {
    message("Could not reach the CoinMarketCap API at this time")
  }

  NULL
}

.fetch_coin_history <- function(my.coins,
                                start.date,
                                end.date,
                                force = FALSE,
                                verbose = TRUE,
                                coins.list = NULL) {
  coins.list <- .resolve_coins_list(
    force = force,
    coins.list = coins.list,
    verbose = verbose
  )

  if (is.null(coins.list)) {
    return(NULL)
  }

  if (isFALSE(curl::has_internet()) && isTRUE(verbose)) {
    message("This function requires Internet access.")
    return(NULL)
  }

  start.date <- .format_prepare_price_date(start.date)
  end.date <- .format_prepare_price_date(end.date)

  coins.temp <- coins.list %>%
    filter(.data$slug %in% my.coins)

  coin_hist <- tryCatch(
    expr = {
      crypto2::crypto_history(
        coin_list = coins.temp,
        start_date = start.date,
        end_date = end.date,
        sleep = 0,
        finalWait = FALSE
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

  if (is.null(coin_hist) && isTRUE(verbose)) {
    message("'coin_hist' could not fetch correctly. Please try again.")
    return(NULL)
  }

  coin_hist
}

.validate_coin_history <- function(coin_hist, verbose = TRUE) {
  if (!"symbol" %in% names(coin_hist)) {
    if (isTRUE(verbose)) {
      message("'coin_hist' could not fetch correctly. Please try again.")
    }
    return(NULL)
  }

  coin_hist
}

#' Prepare the list of coins for prices
#'
#' The [crypto2::crypto_history] API is at times a bit capricious. You might
#' need to try a few times before it processes correctly and without
#' errors.
#'
#' This function can also be run deterministically by supplying explicit
#' `list.prices`, `coins.list`, `coin_hist`, or `USD2CAD.table` inputs.
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
#' You can obtain the correct slug using [crypto2::crypto_list()] and then
#' filtering for your symbol.
#' @param start.date What date to start reporting prices for.
#' @param end.date What date to end reporting prices for.
#' @param force Whether to force recreating `list.prices` even though it
#' already exists (e.g., if you added new coins or new dates).
#' @param verbose Logical; whether to print progress messages.
#' @param list.prices Optional explicit `list.prices` object to reuse instead
#' of relying on a cached session object.
#' @param coins.list Optional explicit output from [crypto2::crypto_list()].
#' @param coin_hist Optional explicit historical price data to transform into
#' a `list.prices` object.
#' @param USD2CAD.table Optional explicit USD/CAD rate table to use when
#' converting USD-denominated history to CAD.
#' @return A data frame, with the following columns: timestamp, id, slug,
#' name, symbol, ref_cur, open, high, low, close, volume, market_cap,
#' time_open, time_close, time_high, time_low, spot.rate2, currency, date2.
#' @name prepare_list_prices
#' @examples
#' my.coins <- c("bitcoin", "ethereum")
#' my.list.prices <- prepare_list_prices(
#'   slug = my.coins,
#'   start.date = "2023-01-01",
#'   list.prices = list_prices_example
#' )
#' head(my.list.prices)
#' @export
#' @importFrom dplyr %>% rename mutate rowwise filter select bind_rows
#' left_join arrange relocate distinct
#' @importFrom utils timestamp
#' @importFrom rlang .data
prepare_list_prices <- function(slug,
                                start.date,
                                end.date = lubridate::now("UTC"),
                                force = FALSE,
                                verbose = TRUE,
                                list.prices = NULL,
                                coins.list = NULL,
                                coin_hist = NULL,
                                USD2CAD.table = NULL) {
  explicit_list_prices <- !is.null(list.prices)
  resolved_list_prices <- .resolve_list_prices(
    force = force,
    list.prices = list.prices,
    verbose = verbose
  )

  if (!is.null(resolved_list_prices)) {
    return(resolved_list_prices)
  }

  if (is.null(slug)) {
    slug <- c("bitcoin", "ethereum")
  }

  my.coins <- slug
  names(my.coins) <- my.coins

  if (is.null(coin_hist)) {
    coin_hist <- .fetch_coin_history(
      my.coins = my.coins,
      start.date = start.date,
      end.date = end.date,
      force = force,
      verbose = verbose,
      coins.list = coins.list
    )
    if (is.null(coin_hist)) {
      return(NULL)
    }
  }

  coin_hist <- .validate_coin_history(coin_hist, verbose = verbose)
  if (is.null(coin_hist)) {
    return(NULL)
  }

  resolved_list_prices <- .build_list_prices_from_history(
    coin_hist = coin_hist,
    USD2CAD.table = USD2CAD.table
  )

  .maybe_cache_list_prices(
    list.prices = resolved_list_prices,
    cache = !explicit_list_prices
  )
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
#' @name prepare_list_prices_slugs
#' @param force Whether to force recreating `list.prices` even though
#' it already exists (e.g., if you added new coins or new dates).
#' @param coins.list Optional explicit output from [crypto2::crypto_list()].
#' @param coin_hist Optional explicit historical price data to transform into
#' a `list.prices` object.
#' @param USD2CAD.table Optional explicit USD/CAD rate table to use when
#' converting USD-denominated history to CAD.
#' @export
prepare_list_prices_slugs <- function(data,
                                      list.prices = NULL,
                                      slug = NULL,
                                      start.date = NULL,
                                      force = FALSE,
                                      verbose = TRUE,
                                      coins.list = NULL,
                                      coin_hist = NULL,
                                      USD2CAD.table = NULL) {
  if (!is.null(list.prices)) {
    return(list.prices)
  }

  prepared_inputs <- .prepare_list_price_inputs(
    data = data,
    slug = slug,
    start.date = start.date
  )
  slug <- prepared_inputs$slug
  start.date <- prepared_inputs$start.date

  if (.reject_usd_only_slug(slug, verbose = verbose)) {
    return(NULL)
  }

  resolved_list_prices <- prepare_list_prices(
    slug = slug,
    start.date = start.date,
    force = force,
    verbose = verbose,
    list.prices = list.prices,
    coins.list = coins.list,
    coin_hist = coin_hist,
    USD2CAD.table = USD2CAD.table
  )

  .handle_missing_list_prices(resolved_list_prices, verbose = verbose)
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


