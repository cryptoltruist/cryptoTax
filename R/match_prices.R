#' @title Get Fair Market Value (FMV) of transactions
#'
#' @description Matches prices obtained through the `prepare_list_prices()`
#' function with the transaction data frame.
#' @param data The dataframe
#' @param slug Your coins to match. You must use the long name, the "slug",
#' not the ticker, see [prepare_list_prices()] for more details.
#' @param start.date What date to start reporting prices for.
#' @param list.prices A `list.prices` object from which to fetch coin prices.
#' @param force Whether to force recreating `list.prices` even though
#' it already exists (e.g., if you added new coins or new dates).
#' @param verbose Logical; whether to print progress messages.
#' @param coins.list Optional explicit output from [crypto2::crypto_list()].
#' @param coin_hist Optional explicit historical price data to transform into
#' a `list.prices` object.
#' @param USD2CAD.table Optional explicit USD/CAD rate table to use when
#' converting USD-denominated history to CAD.
#' @return A data frame, with the following added columns: spot.rate.
#' @export
#' @examples
#' data <- format_shakepay(data_shakepay)[c(1:2)]
#' match_prices(data)
#' @importFrom dplyr %>% rename mutate rowwise filter select bind_rows left_join arrange
#' @importFrom utils timestamp
#' @importFrom rlang .data

match_prices <- function(data,
                         slug = NULL,
                         start.date = "2021-01-01",
                         list.prices = NULL,
                         force = FALSE,
                         verbose = TRUE,
                         coins.list = NULL,
                         coin_hist = NULL,
                         USD2CAD.table = NULL) {
  if (is.null(list.prices) && is.null(coin_hist) && isFALSE(curl::has_internet()) && isTRUE(verbose)) {
    message("This function requires Internet access.")
    return(NULL)
  }

  all.data <- data

  if (!("spot.rate" %in% names(all.data))) {
    all.data$spot.rate <- NA
  }

  if (!("total.price" %in% names(all.data))) {
    all.data$total.price <- NA
  }

  if (!("rate.source" %in% names(all.data))) {
    all.data$rate.source <- NA
  }

  all.data <- all.data %>%
    mutate(spot.rate = ifelse(.data$currency %in% c("TCAD", "CAD"), 1, .data$spot.rate))

  list.prices <- prepare_list_prices_slugs(
    all.data,
    list.prices = list.prices,
    slug = slug,
    start.date = start.date,
    force = force,
    verbose = verbose,
    coins.list = coins.list,
    coin_hist = coin_hist,
    USD2CAD.table = USD2CAD.table
  )

  if (is.null(list.prices)) {
    if (isTRUE(verbose)) {
      message("Could not reach the CoinMarketCap API at this time")
    }
    return(NULL)
  }

  new.data <- all.data %>%
    mutate(date2 = lubridate::as_date(.data$date)) %>%
    left_join(list.prices[c("currency", "spot.rate2", "date2")], by = c("date2", "currency"))

  new.data <- new.data %>%
    mutate(
      rate.source = ifelse(is.na(.data$spot.rate),
        "coinmarketcap",
        ifelse(is.na(.data$rate.source),
          "exchange",
          .data$rate.source
        )
      ),
      spot.rate = ifelse(is.na(.data$spot.rate), .data$spot.rate2, .data$spot.rate)
    ) %>%
    select(-c("date2", "spot.rate2"))
  new.data
}

