.usd2cad_table_has_conversion <- function(USD2CAD.table, conversion = "USD") {
  is.data.frame(USD2CAD.table) &&
    "date" %in% names(USD2CAD.table) &&
    conversion %in% names(USD2CAD.table)
}

.resolve_usd2cad_table <- function(force = FALSE, USD2CAD.table = NULL, conversion = "USD") {
  if (!is.null(USD2CAD.table)) {
    return(USD2CAD.table)
  }

  if (!.can_reuse_cached_pricing_object("USD2CAD.table", force = force, allow_null = TRUE)) {
    return(cur2CAD_table())
  }

  cached_table <- .get_cached_pricing_object("USD2CAD.table")

  if (!.usd2cad_table_has_conversion(cached_table, conversion = conversion)) {
    return(cur2CAD_table())
  }

  message(
    "Object 'USD2CAD.table' already exists. Reusing 'USD2CAD.table'. ",
    "To force a fresh download, use argument 'force = TRUE'."
  )

  cached_table
}

.cache_usd2cad_table <- function(USD2CAD.table) {
  if (!is.null(USD2CAD.table)) {
    .set_cached_pricing_object("USD2CAD.table", USD2CAD.table)
  }

  USD2CAD.table
}

.build_usd2cad_crypto2_table <- function(list.prices) {
  USD <- list.prices %>%
    filter(.data$ref_cur == "USD") %>%
    mutate(spot.rate2_USD = .data$spot.rate2)

  CAD <- list.prices %>%
    filter(.data$ref_cur == "CAD") %>%
    mutate(spot.rate2_CAD = .data$spot.rate2)

  if (nrow(USD) == 0 || nrow(CAD) == 0) {
    return(NULL)
  }

  USD %>%
    left_join(
      CAD %>%
        select("date2", "spot.rate2_CAD"),
      by = "date2"
    ) %>%
    mutate(
      CAD.rate = .data$spot.rate2_CAD / .data$spot.rate2_USD,
      diff = .data$spot.rate2_CAD - .data$CAD.rate
    )
}

.normalize_usd2cad_pricer_table <- function(USD2CAD.table) {
  if (is.null(USD2CAD.table)) {
    return(NULL)
  }

  USD2CAD.table <- mutate(USD2CAD.table, date = as.Date(.data$date))
  names(USD2CAD.table)[2] <- "CAD.rate"
  USD2CAD.table
}

.fetch_usd2cad_crypto2_table <- function(start.date, force = FALSE) {
  prepared_prices <- tryCatch(
    expr = {
      prepare_list_prices(
        "USDC",
        start.date = start.date,
        force = force
      )
    },
    error = function(e) {
      message("Could not fetch exchange rates from coinmarketcap")
      return(NULL)
    },
    warning = function(w) {
      return(NULL)
    }
  )

  if (is.null(prepared_prices)) {
    message("Could not fetch exchange rates from coinmarketcap")
    return(NULL)
  }

  .build_usd2cad_crypto2_table(prepared_prices)
}

.fetch_usd2cad_pricer_table <- function(conversion, currency) {
  fetched_rates <- tryCatch(
    expr = {
      priceR::historical_exchange_rates(
        conversion,
        to = currency, start_date = "2020-01-01", end_date = Sys.Date()
      )
    },
    error = function(e) {
      message("Could not fetch exchange rates from the exchange rate API.")
      return(NULL)
    },
    warning = function(w) {
      return(NULL)
    }
  )

  if (is.null(fetched_rates)) {
    message("Could not fetch exchange rates from the exchange rate API.")
    return(NULL)
  }

  .normalize_usd2cad_pricer_table(fetched_rates)
}

.join_usd2cad_rates <- function(data, USD2CAD.table, by_col = "date", restore_datetime = TRUE) {
  data <- data %>%
    mutate(
      date2 = .data$date,
      date = as.Date(.data$date)
    )

  if (identical(by_col, "date2")) {
    data <- data %>%
      mutate(date2 = as.Date(.data$date2))
  }

  data <- inner_join(data, USD2CAD.table, by = by_col)

  if (isTRUE(restore_datetime)) {
    data <- data %>%
      mutate(date = .data$date2)
  }

  data %>%
    select(-"date2")
}

#' @title Convert USD to CAD (Bank of Canada rates)
#'
#' @description This function allows you to convert USD to CAD.
#' The data is extracted from the CSV available for download at
#' <https://www.bankofcanada.ca/rates/exchange/daily-exchange-rates/>
#' The Bank of Canada only provides data for business days. On days which
#' data is not available, the last known value is used instead.
#' You can also supply an explicit `USD2CAD.table` to make the conversion
#' deterministic and independent from session cache or network access.
#' @param data The data
#' @param conversion What to convert to
#' @param force Whether to force recreating `list.prices` even though
#' it already exists (e.g., if you added new coins or new dates).
#' @param USD2CAD.table Optional explicit exchange-rate table to use instead
#' of relying on a cached session object.
#' @return A data frame, with the following columns: date, CAD.rate.
#' @export
#' @examples
#' formatted.dates <- format_exchanges(data_shakepay)[1]
#' example_fx <- data.frame(
#'   date = as.Date("2021-01-01"),
#'   USD = 1.25,
#'   CAD = 1
#' )
#' USD2CAD(formatted.dates, USD2CAD.table = example_fx)
#' @importFrom dplyr %>% filter pull inner_join mutate right_join rename_with
#' @importFrom rlang .data
USD2CAD <- function(data,
                    conversion = "USD",
                    force = FALSE,
                    USD2CAD.table = NULL) {
  USD2CAD.table <- .resolve_usd2cad_table(
    force = force,
    USD2CAD.table = USD2CAD.table,
    conversion = conversion
  )

  if (is.null(USD2CAD.table)) {
    return(NULL)
  }

  USD2CAD.table_short <- USD2CAD.table %>%
    mutate(CAD.rate = .data[[conversion]]) %>%
    select("date", "CAD.rate")

  .join_usd2cad_rates(data, USD2CAD.table_short)
}

#' @rdname USD2CAD
#' @name cur2CAD_table
#' @export
#' @examples
#' x <- cur2CAD_table()
#' head(x)
#' @importFrom dplyr %>% filter pull inner_join mutate right_join rename_with
#' @importFrom rlang .data

cur2CAD_table <- function() {
  USD2CAD.table <- NULL

  if (isFALSE(curl::has_internet())) {
    message("This function requires Internet access.")
    return(NULL)
  }

  BOC_url <-
    "https://www.bankofcanada.ca/valet/observations/group/FX_RATES_DAILY/csv?start_date=2017-01-03"

  tryCatch(
    expr = {
      USD2CAD.table <- utils::read.csv(BOC_url, header = TRUE, skip = 39)
      USD2CAD.table
    },
    error = function(e) {
      message("Could not fetch exchange rates from Bank of Canada")
      return(NULL)
    },
    warning = function(w) {
      return(NULL)
    }
  )

  if (is.null(USD2CAD.table)) {
    message("Could not fetch exchange rates from Bank of Canada")
    return(NULL)
  }

  USD2CAD.table <- USD2CAD.table %>%
    rename_with(~ gsub("FX", "", .x, fixed = TRUE)) %>%
    rename_with(~ gsub("CAD", "", .x, fixed = TRUE)) %>%
    mutate(
      date = as.Date(.data$date),
      CAD = 1
    )

  date.df <- data.frame(
    date = seq(lubridate::as_date("2017-01-03"),
      lubridate::today("UTC"),
      by = "day"
    )
  )

  USD2CAD.table <- left_join(date.df, USD2CAD.table, by = "date") %>%
    tidyr::fill(tidyselect::everything(), .direction = "down")

  USD2CAD.table
}



#' @title Convert USD to CAD (using `crypto2`)
#'
#' @description This function allows you to convert USD to CAD.
#' `crypto2`
#' `crypto2` now only return USD rates, so CAD rates are not available
#' anymore... See:
#' https://github.com/sstoeckl/crypto2/blob/master/NEWS.md#crypto-200
#'
#' *"`fiat_list()` has been modified and no longer delivers all available
#' currencies and precious metals (therefore only USD and Bitcoin are
#' available any more)."*
#'
#' @param data The data
#' @param start.date What date to start reporting prices for.
#' @param end.date What date to end reporting prices for.
#' @param conversion What to convert to
#' @param currency What to convert from
#' @param force Whether to force recreating `list.prices` even though
#' it already exists (e.g., if you added new coins or new dates).
#' @return A data frame, with the following columns: date, CAD.rate.
#' @export
#' @importFrom dplyr %>% filter pull inner_join
#' @importFrom rlang .data

USD2CAD_crypto2 <- function(data,
                            start.date = "2020-01-01",
                            end.date = lubridate::now("UTC"),
                            conversion = "USD",
                            currency = "CAD",
                            force = FALSE) {
  if (isFALSE(curl::has_internet())) {
    message("This function requires Internet access.")
    return(NULL)
  }

  if (!.can_reuse_cached_pricing_object("USD2CAD.table", force = force, allow_null = TRUE)) {
    USD2CAD.table <- .fetch_usd2cad_crypto2_table(
      start.date = start.date,
      force = TRUE
    )

    if (is.null(USD2CAD.table)) {
      return(NULL)
    }

    USD2CAD.table <- .cache_usd2cad_table(USD2CAD.table)
  } else {
    message(
      "Object 'USD2CAD.table' already exists. Reusing 'USD2CAD.table'. ",
      "To force a fresh download, use argument 'force = TRUE'."
    )
  }

  USD2CAD.table_short <- USD2CAD.table %>%
    select("date2", "CAD.rate")

  .join_usd2cad_rates(
    data = data,
    USD2CAD.table = USD2CAD.table_short,
    by_col = "date2",
    restore_datetime = FALSE
  )
}

#' @title Convert USD to CAD (using `priceR`)
#'
#' @description This function allows you to convert USD to CAD.
#' `priceR` now requires an API key from https://exchangerate.host/...
#' See all details on the package author README here: https://github.com/stevecondylios/priceR
#' "Set up only takes a minute and is free for 100 requests per account per calendar month."
#' "Go to https://exchangerate.host/, create a free account, and replace
#' 7e5e3140140bd8e4f4650cc41fc772c0 with your API key in the following, and run once per R session."
#  `Sys.setenv("EXCHANGERATEHOST_ACCESS_KEY"="7e5e3140140bd8e4f4650cc41fc772c0")`
#' @param data The data
#' @param conversion What to convert to
#' @param currency What to convert from
#' @return A data frame, with the following columns: date, CAD.rate.
#' @export
#' @importFrom dplyr %>% filter pull inner_join
#' @importFrom rlang .data

USD2CAD_priceR <- function(data, conversion = "USD", currency = "CAD") {
  if (isFALSE(curl::has_internet())) {
    message("This function requires Internet access.")
    return(NULL)
  }

  if (!.has_cached_pricing_object("USD2CAD.table", allow_null = TRUE)) {
    USD2CAD.table <- .fetch_usd2cad_pricer_table(
      conversion = conversion,
      currency = currency
    )

    if (is.null(USD2CAD.table)) {
      return(NULL)
    }

    USD2CAD.table <- .cache_usd2cad_table(USD2CAD.table)
  }

  .join_usd2cad_rates(data, USD2CAD.table)
}

