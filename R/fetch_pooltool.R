#' @title Download Cardano staking rewards in PoolTool-compatible format
#'
#' @description Downloads Cardano staking reward history for a stake or payment
#' address using the public Koios API and returns a data frame shaped like the
#' PoolTool generic CSV export. This can be passed directly to
#' [format_pooltool()] or saved locally as a CSV file.
#'
#' This helper intentionally does not scrape PoolTool. PoolTool's web UI can be
#' stale or change without notice, while the reward history itself is available
#' from chain indexer APIs. The returned columns follow the PoolTool export
#' layout closely enough for [format_pooltool()] to consume them unchanged.
#'
#' @param address A Cardano stake address (`stake1...`) or payment/base address
#'   (`addr1...`).
#' @param currency Local fiat currency for reward values. Currently only `CAD`
#'   is supported. Defaults to `"CAD"`.
#' @param save.path Optional file path. When provided, the returned data frame is
#'   also written to disk as a CSV file.
#' @param format Logical; if `TRUE`, return [format_pooltool()] output instead of
#'   the raw PoolTool-compatible table.
#' @param exchange Exchange label passed to [format_pooltool()] when
#'   `format = TRUE`. Defaults to `"exodus"` to preserve current package
#'   behavior.
#' @param perform Whether to execute the API requests (if `TRUE`), or just
#'   return the request objects that would be used (if `FALSE`).
#' @param list.prices Optional `list.prices` object to use for pricing reward
#'   dates. Supplying this keeps the workflow deterministic and avoids implicit
#'   online pricing lookups.
#' @param force Passed through to [match_prices()] when price data must be
#'   resolved.
#' @param verbose Logical; whether to print progress messages.
#'
#' @return A data frame in PoolTool generic-CSV shape, or formatted exchange
#'   transactions when `format = TRUE`.
#' @export
#'
#' @examples
#' fetch_pooltool(
#'   "stake1u88nvynpjl3lsj6wf8k7p9pxj6ta58rx2jfttqqpkumrlpsf6zeud",
#'   perform = FALSE
#' )
fetch_pooltool <- function(address,
                           currency = "CAD",
                           save.path = NULL,
                           format = FALSE,
                           exchange = "exodus",
                           perform = TRUE,
                           list.prices = NULL,
                           force = FALSE,
                           verbose = TRUE) {
  rlang::check_installed("httr2", reason = "for this function.")

  currency <- .normalize_pooltool_currency(currency)
  stake_address <- .resolve_pooltool_stake_address(address)

  requests <- list(
    account_rewards = .koios_post_request("account_rewards", "_stake_addresses", stake_address)
  )

  if (startsWith(address, "addr1")) {
    requests$address_info <- .koios_post_request("address_info", "_addresses", address)
  }

  if (isFALSE(perform)) {
    return(requests)
  }

  if (isTRUE(verbose)) {
    message("Fetching Cardano reward history from Koios")
  }

  rewards_payload <- httr2::req_perform(requests$account_rewards) %>%
    httr2::resp_body_json(simplifyVector = TRUE)
  rewards <- .extract_pooltool_rewards(rewards_payload, stake_address)

  if (!nrow(rewards)) {
    out <- .empty_pooltool_rewards_table(currency = currency)
    if (!is.null(save.path)) {
      utils::write.csv(out, save.path, row.names = FALSE)
    }
    return(out)
  }

  epochs <- sort(unique(rewards$spendable_epoch))
  epoch_info <- .fetch_pooltool_epochs(epochs)
  pool_lookup <- .fetch_pooltool_pool_lookup(unique(rewards$pool_id))

  out <- .build_pooltool_rewards_table(
    rewards = rewards,
    epoch_info = epoch_info,
    pool_lookup = pool_lookup,
    currency = currency,
    list.prices = list.prices,
    force = force,
    verbose = verbose
  )

  if (isTRUE(format)) {
    out <- format_pooltool(out, exchange = exchange)
  }

  if (!is.null(save.path)) {
    utils::write.csv(out, save.path, row.names = FALSE)
  }

  out
}

.koios_post_request <- function(endpoint, field, values) {
  httr2::request("https://api.koios.rest/api/v1") %>%
    httr2::req_url_path_append(endpoint) %>%
    httr2::req_headers(
      accept = "application/json",
      `content-type` = "application/json"
    ) %>%
    httr2::req_body_json(stats::setNames(list(as.list(values)), field))
}

.koios_get_request <- function(endpoint, query = list()) {
  req <- httr2::request("https://api.koios.rest/api/v1") %>%
    httr2::req_url_path_append(endpoint) %>%
    httr2::req_headers(accept = "application/json")

  if (length(query)) {
    req <- do.call(httr2::req_url_query, c(list(.req = req), query))
  }

  req
}

.unwrap_koios_payload <- function(payload) {
  if (is.list(payload) && "value" %in% names(payload) && length(payload) <= 2) {
    return(payload$value)
  }

  payload
}

.normalize_pooltool_currency <- function(currency) {
  currency <- toupper(as.character(currency[[1]]))

  if (!identical(currency, "CAD")) {
    rlang::abort("`fetch_pooltool()` currently supports only `currency = \"CAD\"`.")
  }

  currency
}

.resolve_pooltool_stake_address <- function(address) {
  address <- trimws(as.character(address[[1]]))

  if (startsWith(address, "stake1")) {
    return(address)
  }

  if (!startsWith(address, "addr1")) {
    rlang::abort(
      paste0(
        "`address` must be a Cardano stake address (`stake1...`) ",
        "or payment address (`addr1...`)."
      )
    )
  }

  req <- .koios_post_request("address_info", "_addresses", address)
  resp <- httr2::req_perform(req) %>%
    httr2::resp_body_json(simplifyVector = TRUE)

  values <- .unwrap_koios_payload(resp)
  stake_address <- values[["stake_address"]][[1]]
  if (is.null(values) || !NROW(values) || is.null(stake_address) ||
    is.na(stake_address) || !nzchar(stake_address)) {
    rlang::abort("Could not resolve a stake address from the provided Cardano payment address.")
  }

  stake_address
}

.extract_pooltool_rewards <- function(payload, stake_address) {
  values <- .unwrap_koios_payload(payload)
  rewards_list <- values[["rewards"]]
  if (is.null(values) || !NROW(values) || is.null(rewards_list)) {
    return(data.frame(
      stake_address = character(),
      amount = numeric(),
      pool_id = character(),
      earned_epoch = integer(),
      spendable_epoch = integer(),
      stringsAsFactors = FALSE
    ))
  }

  rewards <- rewards_list[[1]]
  if (!NROW(rewards)) {
    return(data.frame(
      stake_address = character(),
      amount = numeric(),
      pool_id = character(),
      earned_epoch = integer(),
      spendable_epoch = integer(),
      stringsAsFactors = FALSE
    ))
  }

  data.frame(
    stake_address = stake_address,
    amount = as.numeric(rewards$amount) / 1e6,
    pool_id = rewards$pool_id,
    earned_epoch = as.integer(rewards$earned_epoch),
    spendable_epoch = as.integer(rewards$spendable_epoch),
    stringsAsFactors = FALSE
  )
}

.fetch_pooltool_epochs <- function(epochs) {
  if (!length(epochs)) {
    return(data.frame(
      spendable_epoch = integer(),
      start_time = numeric(),
      stringsAsFactors = FALSE
    ))
  }

  anchor_epoch <- max(epochs)
  req <- .koios_get_request("epoch_info", query = list(`_epoch_no` = anchor_epoch))
  resp <- httr2::req_perform(req) %>%
    httr2::resp_body_json(simplifyVector = TRUE)
  values <- .unwrap_koios_payload(resp)

  if (is.null(values) || !NROW(values)) {
    rlang::abort("Could not resolve Cardano epoch timing information.")
  }

  anchor_start_time <- as.numeric(values$start_time[[1]])
  epoch_seconds <- 5 * 24 * 60 * 60

  data.frame(
    spendable_epoch = as.integer(epochs),
    start_time = anchor_start_time + (as.integer(epochs) - anchor_epoch) * epoch_seconds,
    stringsAsFactors = FALSE
  )
}

.fetch_pooltool_pool_lookup <- function(pool_ids) {
  if (!length(pool_ids)) {
    return(data.frame(
      pool_id = character(),
      pool = character(),
      stringsAsFactors = FALSE
    ))
  }

  req <- .koios_post_request("pool_info", "_pool_bech32_ids", pool_ids)
  resp <- httr2::req_perform(req) %>%
    httr2::resp_body_json(simplifyVector = TRUE)

  values <- .unwrap_koios_payload(resp)
  if (is.null(values) || !NROW(values)) {
    return(data.frame(
      pool_id = character(),
      pool = character(),
      stringsAsFactors = FALSE
    ))
  }

  ticker <- values$pool_id_bech32
  if ("meta_json.ticker" %in% names(values)) {
    ticker <- ifelse(
      is.na(values[["meta_json.ticker"]]) | !nzchar(values[["meta_json.ticker"]]),
      ticker,
      values[["meta_json.ticker"]]
    )
  } else if ("meta_json" %in% names(values)) {
    meta_json <- values[["meta_json"]]
    if (is.data.frame(meta_json) && "ticker" %in% names(meta_json)) {
      ticker <- ifelse(
        is.na(meta_json$ticker) | !nzchar(meta_json$ticker),
        ticker,
        meta_json$ticker
      )
    }
  }

  data.frame(
    pool_id = values$pool_id_bech32,
    pool = ticker,
    stringsAsFactors = FALSE
  )
}

.build_pooltool_rewards_table <- function(rewards,
                                          epoch_info,
                                          pool_lookup,
                                          currency = "CAD",
                                          list.prices = NULL,
                                          force = FALSE,
                                          verbose = TRUE) {
  if (!nrow(rewards)) {
    return(.empty_pooltool_rewards_table(currency = currency))
  }

  priced_rewards <- rewards %>%
    dplyr::left_join(epoch_info, by = "spendable_epoch") %>%
    dplyr::left_join(pool_lookup, by = c("pool_id" = "pool_id")) %>%
    dplyr::mutate(
      date = as.POSIXct(.data$start_time, origin = "1970-01-01", tz = "UTC"),
      currency = "ADA",
      quantity = .data$amount
    ) %>%
    dplyr::select("date", "currency", "quantity") %>%
    dplyr::distinct(.data$date, .keep_all = TRUE)

  priced_rewards <- match_prices(
    priced_rewards,
    list.prices = list.prices,
    force = force,
    verbose = verbose
  )

  if (is.null(priced_rewards)) {
    rlang::abort("Could not price Cardano rewards for the requested dates.")
  }

  priced_rewards <- priced_rewards %>%
    dplyr::select("date", "spot.rate") %>%
    dplyr::distinct(.data$date, .keep_all = TRUE)

  rewards %>%
    dplyr::left_join(epoch_info, by = "spendable_epoch") %>%
    dplyr::left_join(pool_lookup, by = c("pool_id" = "pool_id")) %>%
    dplyr::mutate(
      date = as.POSIXct(.data$start_time, origin = "1970-01-01", tz = "UTC")
    ) %>%
    dplyr::left_join(priced_rewards, by = "date") %>%
    dplyr::mutate(
      epoch = .data$spendable_epoch,
      stake = NA_real_,
      operator_rewards = 0,
      stake_rewards = .data$amount,
      total_rewards = .data$amount,
      rate = .data$spot.rate,
      currency = currency,
      operator_rewards_value = 0,
      stake_rewards_value = .data$amount * .data$spot.rate,
      value = .data$amount * .data$spot.rate,
      pool = dplyr::coalesce(.data$pool, .data$pool_id)
    ) %>%
    dplyr::select(
      "date",
      "epoch",
      "stake",
      "pool",
      "operator_rewards",
      "stake_rewards",
      "total_rewards",
      "rate",
      "currency",
      "operator_rewards_value",
      "stake_rewards_value",
      "value"
    ) %>%
    dplyr::arrange(.data$date)
}

.empty_pooltool_rewards_table <- function(currency = "CAD") {
  data.frame(
    date = as.POSIXct(character(), tz = "UTC"),
    epoch = integer(),
    stake = numeric(),
    pool = character(),
    operator_rewards = numeric(),
    stake_rewards = numeric(),
    total_rewards = numeric(),
    rate = numeric(),
    currency = character(),
    operator_rewards_value = numeric(),
    stake_rewards_value = numeric(),
    value = numeric(),
    stringsAsFactors = FALSE
  ) %>%
    dplyr::mutate(currency = currency)
}
