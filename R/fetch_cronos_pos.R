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
    message_fields <- extract_cronos_message_fields(resp$result)
    req <- lapply(resp$result, as.data.frame) %>%
      bind_rows() %>%
      mutate(
        date = as.POSIXct(lubridate::as_datetime(.data$blockTime, tz = "UTC"), tz = "UTC"),
        .before = "account"
      ) %>%
      arrange(.data$date) %>%
      bind_cols(message_fields, extract_raw_log(.)) %>%
      mutate(
        message_action_raw = dplyr::coalesce(.data$message_action_raw, .data$message_action),
        message_action = normalize_cronos_message_action(.data$message_action_raw)
      ) %>%
      select_cronos_pos_columns()
  }
  req
}

#' @noRd
select_cronos_pos_columns <- function(data) {
  keep <- c(
    "date",
    "account",
    "blockHeight",
    "blockHash",
    "blockTime",
    "hash",
    "success",
    "code",
    "log",
    "fee.denom",
    "fee.amount",
    "feePayer",
    "feeGranter",
    "gasWanted",
    "gasUsed",
    "memo",
    "timeoutHeight",
    "message_action_raw",
    "message_action",
    "message_module",
    "message_amount",
    "message_amount_denom",
    "message_auto_claimed_reward_amount",
    "message_auto_claimed_reward_denom",
    "message_validator_address",
    "message_recipient_address",
    "transfer_amount",
    "transfer_sender",
    "transfer_recipient",
    "withdraw_rewards_validator",
    "delegate_validator",
    "redelegate_source_validator",
    "unbond_validator",
    "ibc_client_client_id",
    "ibc_client_consensus_heights",
    "log_parse_error"
  )

  dplyr::select(data, dplyr::any_of(keep))
}

#' @noRd
normalize_cronos_message_action <- function(action) {
  dplyr::case_when(
    is.na(action) ~ NA_character_,
    action %in% c(
      "delegate",
      "/cosmos.staking.v1beta1.MsgDelegate"
    ) ~ "delegate",
    action %in% c(
      "begin_unbonding",
      "/cosmos.staking.v1beta1.MsgUndelegate"
    ) ~ "begin_unbonding",
    action %in% c(
      "begin_redelegate",
      "/cosmos.staking.v1beta1.MsgBeginRedelegate"
    ) ~ "begin_redelegate",
    action %in% c(
      "withdraw_delegator_reward",
      "/cosmos.distribution.v1beta1.MsgWithdrawDelegatorReward"
    ) ~ "withdraw_delegator_reward",
    .default = action
  )
}

#' @noRd
extract_cronos_message_fields <- function(results) {
  first_non_null_character <- function(...) {
    values <- list(...)
    for (value in values) {
      if (!is.null(value) && length(value)) {
        return(as.character(value[[1]]))
      }
    }
    NA_character_
  }

  extract_message_coin_field <- function(x, field) {
    if (is.null(x) || !length(x)) {
      return(NA_character_)
    }

    if (is.list(x) && !is.null(x[[field]])) {
      value <- x[[field]]
      if (length(value)) {
        return(as.character(value[[1]]))
      }
    }

    if (is.list(x) && length(x) == 1 && is.list(x[[1]]) && !is.null(x[[1]][[field]])) {
      value <- x[[1]][[field]]
      if (length(value)) {
        return(as.character(value[[1]]))
      }
    }

    NA_character_
  }

  extract_message_row <- function(result) {
    out <- data.frame(
      message_action_raw = NA_character_,
      message_amount = NA_character_,
      message_amount_denom = NA_character_,
      message_auto_claimed_reward_amount = NA_character_,
      message_auto_claimed_reward_denom = NA_character_,
      message_validator_address = NA_character_,
      message_recipient_address = NA_character_,
      stringsAsFactors = FALSE
    )

    message <- result$messages[[1]]
    if (is.null(message)) {
      return(out)
    }

    content <- message$content
    out$message_action_raw <- if (!is.null(message$type)) as.character(message$type) else NA_character_
    out$message_amount <- extract_message_coin_field(content$amount, "amount")
    out$message_amount_denom <- extract_message_coin_field(content$amount, "denom")
    out$message_auto_claimed_reward_amount <- extract_message_coin_field(content$autoClaimedRewards, "amount")
    out$message_auto_claimed_reward_denom <- extract_message_coin_field(content$autoClaimedRewards, "denom")
    out$message_validator_address <- first_non_null_character(
      content$validatorAddress,
      content$validator_address
    )
    out$message_recipient_address <- first_non_null_character(
      content$recipientAddress,
      content$recipient_address
    )
    out
  }

  lapply(results, extract_message_row) %>%
    bind_rows()
}

#' @noRd
extract_raw_log <- function(data) {
  tracked_raw_log_fields <- c(
    "message_action",
    "message_module",
    "transfer_amount",
    "transfer_sender",
    "transfer_recipient",
    "withdraw_rewards_validator",
    "delegate_validator",
    "redelegate_source_validator",
    "unbond_validator",
    "ibc_client_client_id",
    "ibc_client_consensus_heights",
    "log_parse_error"
  )

  empty_raw_log_row <- function() {
    out <- as.list(rep(NA_character_, length(tracked_raw_log_fields)))
    names(out) <- tracked_raw_log_fields
    as.data.frame(out, stringsAsFactors = FALSE)
  }

  invalid_raw_log_row <- function(message = NULL) {
    out <- empty_raw_log_row()
    out$message_action <- "error"
    out$message_module <- "error"
    out$log_parse_error <- if (!is.null(message) && nzchar(message)) message else NA_character_
    out
  }

  extract_event_value <- function(events, type, key) {
    if (is.null(events) || !is.data.frame(events) || !nrow(events)) {
      return(NA_character_)
    }

    matches <- lapply(seq_len(nrow(events)), function(i) {
      if (!identical(events$type[[i]], type)) {
        return(character())
      }

      attributes <- events$attributes[[i]]
      if (is.null(attributes) || !is.data.frame(attributes) || !nrow(attributes)) {
        return(character())
      }

      values <- ifelse(attributes$key == key, attributes$value, NA_character_)
      stats::na.omit(values)
    })

    matches <- unlist(matches, use.names = FALSE)
    if (!length(matches)) {
      return(NA_character_)
    }
    matches[[1]]
  }

  extract_raw_log_internal <- function(raw_log) {
    if (is.null(raw_log) || length(raw_log) == 0 || is.na(raw_log)) {
      raw_log <- ""
    }
    raw_log <- trimws(raw_log)

    if (!nzchar(raw_log)) {
      return(invalid_raw_log_row("empty raw log"))
    }

    if (grepl("failed", raw_log, ignore.case = TRUE)) {
      return(invalid_raw_log_row())
    }

    x <- tryCatch(
      jsonlite::fromJSON(txt = raw_log),
      error = function(e) invalid_raw_log_row(conditionMessage(e))
    )
    if (identical(x$message_action, "error")) {
      return(x)
    }

    out <- empty_raw_log_row()
    events <- x$events[[1]]

    out$message_action <- extract_event_value(events, "message", "action")
    out$message_module <- extract_event_value(events, "message", "module")
    out$transfer_amount <- extract_event_value(events, "transfer", "amount")
    out$transfer_sender <- extract_event_value(events, "transfer", "sender")
    out$transfer_recipient <- extract_event_value(events, "transfer", "recipient")
    out$withdraw_rewards_validator <- extract_event_value(events, "withdraw_rewards", "validator")
    out$delegate_validator <- extract_event_value(events, "delegate", "validator")
    out$redelegate_source_validator <- extract_event_value(events, "redelegate", "source_validator")
    out$unbond_validator <- extract_event_value(events, "unbond", "validator")
    out$ibc_client_client_id <- extract_event_value(events, "ibc_client", "client_id")
    out$ibc_client_consensus_heights <- extract_event_value(events, "ibc_client", "consensus_heights")
    out
  }
  lapply(data$log, extract_raw_log_internal) %>%
    bind_rows()
}
