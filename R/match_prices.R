.ensure_match_price_columns <- function(data) {
  if (!("spot.rate" %in% names(data))) {
    data$spot.rate <- NA
  }

  if (!("total.price" %in% names(data))) {
    data$total.price <- NA
  }

  if (!("rate.source" %in% names(data))) {
    data$rate.source <- NA
  }

  data %>%
    mutate(spot.rate = ifelse(.data$currency %in% c("TCAD", "CAD"), 1, .data$spot.rate))
}

.requires_online_prices <- function(list.prices = NULL, coin_hist = NULL, verbose = TRUE) {
  if (!is.null(list.prices) || !is.null(coin_hist)) {
    return(FALSE)
  }

  if (isFALSE(curl::has_internet())) {
    if (isTRUE(verbose)) {
      message("This function requires Internet access.")
    }
    return(TRUE)
  }

  FALSE
}

.handle_invalid_match_prices <- function(list.prices, verbose = TRUE) {
  if (.is_valid_list_prices_table(list.prices)) {
    return(list.prices)
  }

  if (isTRUE(verbose)) {
    message(
      "Could not use 'list.prices' because it must contain ",
      "'currency', 'spot.rate2', and 'date2'."
    )
  }

  NULL
}

.join_match_prices <- function(data, list.prices) {
  data %>%
    mutate(date2 = lubridate::as_date(.data$date)) %>%
    left_join(list.prices[c("currency", "spot.rate2", "date2")], by = c("date2", "currency"))
}

.finalize_match_prices <- function(data) {
  data %>%
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
}

.resolve_match_prices <- function(data,
                                  slug = NULL,
                                  start.date = "2021-01-01",
                                  list.prices = NULL,
                                  force = FALSE,
                                  verbose = TRUE,
                                  coins.list = NULL,
                                  coin_hist = NULL,
                                  USD2CAD.table = NULL) {
  prepare_list_prices_slugs(
    data,
    list.prices = list.prices,
    slug = slug,
    start.date = start.date,
    force = force,
    verbose = verbose,
    coins.list = coins.list,
    coin_hist = coin_hist,
    USD2CAD.table = USD2CAD.table
  )
}

#' @title Get Fair Market Value (FMV) of transactions
#'
#' @description Matches prices obtained through the `prepare_list_prices()`
#' function with the transaction data frame. For deterministic or offline
#' use, you can supply explicit `list.prices`, `coins.list`, `coin_hist`,
#' or `USD2CAD.table` inputs.
#' @param data The dataframe
#' @param slug Your coins to match. You must use the long name, the "slug",
#' not the ticker, see [prepare_list_prices()] for more details.
#' @param start.date What date to start reporting prices for.
#' @param list.prices A `list.prices` object from which to fetch coin prices.
#' When supplied explicitly, it must contain at least `currency`,
#' `spot.rate2`, and `date2`.
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
#' data <- format_exchanges(data_shakepay)[c(1:2)]
#' match_prices(data, list.prices = list_prices_example)
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
  if (.requires_online_prices(
    list.prices = list.prices,
    coin_hist = coin_hist,
    verbose = verbose
  )) {
    return(NULL)
  }

  all.data <- .ensure_match_price_columns(data)

  list.prices <- .resolve_match_prices(
    data = all.data,
    list.prices = list.prices,
    slug = slug,
    start.date = start.date,
    force = force,
    verbose = verbose,
    coins.list = coins.list,
    coin_hist = coin_hist,
    USD2CAD.table = USD2CAD.table
  )

  list.prices <- .handle_missing_list_prices(list.prices, verbose = verbose)
  if (is.null(list.prices)) {
    return(NULL)
  }

  list.prices <- .handle_invalid_match_prices(list.prices, verbose = verbose)
  if (is.null(list.prices)) {
    return(NULL)
  }

  new.data <- .join_match_prices(all.data, list.prices)
  .finalize_match_prices(new.data)
}
