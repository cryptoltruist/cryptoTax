#' @title Calculate superficial capital losses
#'
#' @description Calculate superficial capital losses to be substracted from total capital losses.
#' @param data The data
#' @param transaction Name of transaction column
#' @param quantity Name of quantity column
#' @param cl The number of cores to use.
#' @return A data frame of formatted transactions, with added columns
#' with information about superficial losses.
#' @export
#' @examples
#' data <- data_adjustedcostbase1
#' format_suploss(data)
#' @importFrom dplyr mutate %>% filter summarize bind_rows distinct transmute ungroup group_by select arrange rename add_row
#' @importFrom lubridate %within%
#' @importFrom rlang .data

format_suploss <- function(data,
                           transaction = "transaction",
                           quantity = "quantity",
                           cl = NULL) {
  out <- data %>%
    add_quantities(transaction = transaction, quantity = quantity) %>%
    sup_loss_single_df(transaction = transaction, quantity = quantity) %>%
    bind_rows() %>%
    arrange(date)
  out
}

add_quantities <- function(data, transaction = "transaction", quantity = "quantity") {
  data %>%
    mutate(
      quantity.negative = ifelse(.data[[transaction]] == "sell",
        .data[[quantity]] * -1,
        .data[[quantity]]
      ),
      total.quantity = cumsum(.data$quantity.negative)
    ) %>%
    select(-"quantity.negative")
}
# Need to round to 18 decimals otherwise we don't get the same
# results as the for loop option. The reason is that there are
# some hidden decimals after 18 which leads to negative values
# later since They were probably not taken into account by the
# exchange when trading. So they gave a few decimals extra.
# It is safe to ignore and will prevent false alarms about
# negative values. Have to check though if rounding to 18 decimals
# won't create other problems elsewhere.

sup_loss_single_df <- function(data, transaction = "transaction", quantity = "quantity") {
  data.range <- .prepare_suploss_ranges(data)
  summaries <- .compute_suploss_window_summaries(
    data.range,
    transaction = transaction,
    quantity = quantity
  )

  data.frame(
    data.range,
    quantity.60days = summaries$quantity.60days,
    share.left60 = summaries$share.left60
  ) %>%
    .mark_superficial_losses(transaction = transaction, quantity = quantity)
}

.compute_suploss_window_summaries <- function(data,
                                              transaction = "transaction",
                                              quantity = "quantity") {
  if (nrow(data) == 0) {
    return(list(
      quantity.60days = numeric(),
      share.left60 = numeric()
    ))
  }

  dates <- data$date
  buy_rows <- data[[transaction]] == "buy"
  quantities <- data[[quantity]]
  total_quantities <- data$total.quantity

  quantity.60days <- numeric(nrow(data))
  share.left60 <- numeric(nrow(data))

  for (i in seq_len(nrow(data))) {
    window_start <- dates[[i]] - lubridate::days(30)
    window_end <- dates[[i]] + lubridate::days(30)
    in_window <- dates >= window_start & dates <= window_end
    quantity.60days[[i]] <- sum(quantities[buy_rows & in_window], na.rm = TRUE)

    last_index <- utils::tail(which(in_window), 1)
    share.left60[[i]] <- if (length(last_index)) {
      total_quantities[[last_index]]
    } else {
      NA_real_
    }
  }

  list(
    quantity.60days = quantity.60days,
    share.left60 = share.left60
  )
}

.prepare_suploss_ranges <- function(data) {
  data %>%
    mutate(suploss.range = suploss_range(.data$date))
}

.summarize_suploss_buy_quantities <- function(list.ranges.df,
                                              template,
                                              transaction = "transaction",
                                              quantity = "quantity") {
  lapply(list.ranges.df, function(x) {
    x %>%
      mutate(quantity.buy = ifelse(.data[[transaction]] == "buy",
        .data[[quantity]],
        0
      )) %>%
      summarize(quantity.60days = sum(.data$quantity.buy))
  }) %>%
    bind_rows() %>%
    .suploss_default_column(template = template, column_name = "quantity.60days")
}

.summarize_suploss_share_left <- function(list.ranges.df, template) {
  lapply(list.ranges.df, function(x) {
    x %>%
      utils::tail(1) %>%
      ungroup() %>%
      select("total.quantity") %>%
      rename(share.left60 = "total.quantity")
  }) %>%
    bind_rows() %>%
    .suploss_default_column(template = template, column_name = "share.left60")
}

.mark_superficial_losses <- function(data.range,
                                     transaction = "transaction",
                                     quantity = "quantity") {
  buy_dates <- data.range$date[data.range[[transaction]] == "buy"]

  if (!length(buy_dates)) {
    data.range$sup.loss <- FALSE
    data.range$sup.loss.quantity <- 0
    return(data.range)
  }

  in_buy_window <- vapply(data.range$date, function(x) {
    any(abs(as.numeric(difftime(buy_dates, x, units = "days"))) <= 30)
  }, logical(1))

  data.range$sup.loss <- data.range[[transaction]] == "sell" & in_buy_window
  data.range$sup.loss.quantity <- ifelse(
    data.range$sup.loss,
    data.range[[quantity]],
    0
  )

  data.range
}

.suploss_ranges <- function(data, transaction = "transaction") {
  data %>%
    filter(.data[[transaction]] == "buy") %>%
    select("suploss.range")
}

.suploss_default_column <- function(data, template, column_name) {
  if (nrow(data) > 0) {
    return(data)
  }

  out <- template %>%
    ungroup() %>%
    transmute(value = NA)
  names(out) <- column_name
  out
}

suploss_range <- function(date) {
  after.30 <- date + lubridate::days(30)
  before.30 <- date - lubridate::days(30)
  range <- lubridate::interval(before.30, after.30)
  range
}

check_suploss <- function(data) {
  # data <- data %>%
  #  filter(transaction == "sell")
  # Should we filter for sell transactions to increase efficiency?
  if (nrow(data) > 0) {
    list.ranges.df <- lapply(seq(nrow(data)), function(x) {
      data %>%
        filter(date %within% .data$suploss.range[x])
    })
  } else {
    list.ranges.df <- list()
  }
  list.ranges.df
}
