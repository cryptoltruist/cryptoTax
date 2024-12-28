#' @title Download transaction data from the Cronos POS chain
#'
#' @description Downloads transaction data from the Cronos Proof-of-Stake
#' chain / the Crypto.com DeFi wallet, through the API.
#' @param address The Cronos POS wallet address (starts with "cro1...")
#' @param limit Query number of transactions results per page returned
#' (default 100)
#' @param perform Whether to execute the API request (if `TRUE`), or just return
#' how the request would be formatted (if `FALSE`).
#' @param verbose Logical, if `FALSE`, does not print warnings to console.
#' @return A data frame of exchange transactions, formatted for further processing.
#' @export
#' @examples
#' fetch_cronos_pos(
#'   limit = 10, perform = FALSE,
#'   "cro1dec64zlzracgz7fs4thzx45q7a48s22d4ll8m6"
#' )
#' @importFrom dplyr %>% rename mutate filter select arrange bind_rows group_by
#' row_number if_else bind_cols
#' @importFrom rlang .data

fetch_cronos_pos <- function(address, limit = 100, perform = TRUE, verbose = TRUE) {
  rlang::check_installed(c("httr2", "jsonlite"), reason = "for this function.")
  req <- httr2::request("https://cronos-pos.org/explorer/api/v1") %>%
    httr2::req_url_path_append(c("accounts", address, "transactions")) %>%
    httr2::req_url_query(limit = limit)
  if (perform) {
    resp <- httr2::req_perform(req)
    resp <- httr2::resp_body_json(resp)
    if (verbose) {
      print(resp$pagination)
    }
    if (resp$pagination$total_record > limit) {
      warning(
        "Total number of transactions detected higher than the set ",
        "limit. Adjust as needed with the 'limit' argument"
      )
    }
    resp$result <- lapply(resp$result, \(x) {
      if (grepl("MsgUpdateClient", x$messages[[1]]$type)) {
        x[!names(x) == "messages"]
      } else {
        x
      }
    })
    req <- lapply(resp$result, as.data.frame) %>%
      bind_rows() %>%
      mutate(date = trunc(lubridate::as_datetime(.data$blockTime)), .before = "account") %>%
      arrange(.data$date) %>%
      bind_cols(extract_raw_log(.))
  }
  req
}

#' @noRd
extract_raw_log <- function(data) {
  extract_raw_log_internal <- function(raw_log) {
    if (grepl("failed", raw_log)) {
      return(data.frame(
        message_action = "error",
        message_module = "error"
      ))
    }
    x <- jsonlite::fromJSON(txt = raw_log)
    y <- x$events[[1]]$attributes
    z <- lapply(seq(y), function(i) {
      dat <- y[[i]]
      dat %>%
        mutate(row_id = row_number()) %>%
        group_by(.data$key) %>%
        mutate(
          type = x$events[[1]]$type[i],
          count = row_number(), # Count occurrences to help in renaming
          key = if_else(.data$count > 1, paste0(
            .data$key, .data$count
          ), .data$key)
          # Append a suffix if more than one per group
        ) %>%
        ungroup() %>%
        select(-c("row_id", "count", "index")) %>%
        tidyr::pivot_wider(
          names_from = c("type", "key"),
          values_from = "value"
        )
    })
    bind_cols(z)
  }
  lapply(data$log, extract_raw_log_internal) %>%
    bind_rows()
}
