#' @title Calculate superficial capital losses
#'
#' @description Calculate superficial capital losses to be substracted from total capital losses.
#' @param date The date
#' @keywords money crypto
#' @export
#' @examples
#' \dontrun{
#' ACB(data)
#' }
#' @importFrom dplyr mutate %>% filter summarize bind_rows distinct transmute ungroup group_by select arrange rename add_row
#' @importFrom lubridate %within%
#' @importFrom rlang .data

suploss_range <- function(date) {
  after.30 <- date + lubridate::days(30)
  before.30 <- date - lubridate::days(30)
  range <- lubridate::interval(before.30, after.30)
  range
}

format_suploss <- function(data, cl = NULL) {
  cat("[Calculating superficial losses...]\n")
  out <- pbapply::pblapply(unique(data$currency), function(x) {
    data %>%
      filter(.data$currency == x) %>%
      add_quantities() %>%
      sup_loss_single_df()
  }, cl = cl) %>%
    bind_rows() %>%
    arrange(date)
  cat("[Formatting ACB (progress bar repeats for each coin)...]\n")
  out
}

check_suploss <- function(data) {
  # data <- data %>%
  #  filter(transaction == "sell")
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

keep.gains <- function(x) {
  lapply(x, function(y) any(y$transaction == "buy"))
}

add_quantities <- function(data) {
  for (i in 1:nrow(data)) {
    # First row: add first quantity
    if (i == 1) {
      data[i, "total.quantity"] <- data[i, "quantity"]
    }

    # After first row: add new quantities
    if (i > 1 & (data[i, "transaction"] == "buy" |
      data[i, "transaction"] == "revenue" |
      data[i, "transaction"] == "rebate")) {
      data[i, "total.quantity"] <- data[i - 1, "total.quantity"] +
        data[i, "quantity"]
    }

    # After first row: remove new quantities
    if (i > 1 & data[i, "transaction"] == "sell") {
      data[i, "total.quantity"] <- data[i - 1, "total.quantity"] -
        data[i, "quantity"]
    }
  }
  data
}

add_quantities_experimental <- function(data) {
  data %>%
    group_by(.data$currency) %>%
    mutate(
      quantity.negative = ifelse(.data$transaction == "sell",
        .data$quantity * -1,
        .data$quantity
      ),
      total.quantity = cumsum(.data$quantity.negative)
    )
}
# Need to round to 18 decimals otherwise we don't get the same
# results as the for loop option. The reason is that there are
# some hidden decimals after 18 which leads to negative values
# later since They were probably not taken into account by the
# exchange when trading. So they gave a few decimals extra.
# It is safe to ignore and will prevent false alarms about
# negative values. Have to check though if rounding to 18 decimals
# won't create other problems elsewhere.

sup_loss_single_df <- function(data) {
  data.range <- data %>%
    add_quantities() %>%
    mutate(suploss.range = suploss_range(.data$date))
  list.ranges <- data.range %>%
    filter(.data$transaction == "buy") %>%
    select(.data$currency, .data$suploss.range)
  # Calculate the sum of buy quantities for each range of 60 days...
  list.ranges.df <- check_suploss(data.range)
  quantity.60days <- lapply(list.ranges.df, function(x) {
    x %>%
      mutate(quantity.buy = ifelse(.data$transaction == "buy",
        .data$quantity,
        0
      )) %>%
      summarize(quantity.60days = sum(.data$quantity.buy))
  }) %>% bind_rows()
  # if(nrow(quantity.60days) == 2 &
  # quantity.60days$quantity.60days[1] == 0 &
  # quantity.60days$quantity.60days[2] == 0) {
  # quantity.60days <- quantity.60days %>% slice(-(1:2))
  # }
  if (nrow(quantity.60days) == 0) {
    quantity.60days <- data.range %>%
      ungroup() %>%
      transmute(quantity.60days = NA)
  }

  # Now calculate share.left60
  share.left60 <- lapply(list.ranges.df, function(x) {
    x %>%
      utils::tail(1) %>%
      ungroup() %>%
      select(.data$total.quantity) %>%
      rename(share.left60 = .data$total.quantity)
  }) %>% bind_rows()
  # if(nrow(share.left60) == 2 &
  #   share.left60$share.left60[1] == 0 &
  #   share.left60$share.left60[2] == 0) {
  #  share.left60 <- share.left60 %>% slice(-(1:2))
  # }
  if (nrow(share.left60) == 0) {
    share.left60 <- data.range %>%
      ungroup() %>%
      transmute(share.left60 = NA)
  }

  data.range2 <- data.frame(data.range, quantity.60days, share.left60)
  # data.range2 <- data.frame(data.range, quantity.60days)
  data.range3 <- data.range2 %>%
    rowwise() %>%
    mutate(
      sup.loss = any(.data$date %within% list.ranges[-1]),
      sup.loss = ifelse(.data$transaction != "sell",
        FALSE,
        .data$sup.loss
      ),
      sup.loss.quantity = ifelse(.data$sup.loss == TRUE,
        .data$quantity,
        0
      )
    ) %>%
    ungroup()
  data.range3
}

sup_loss_single <- function(data) {
  # Get summary for only superficial losses
  data %>%
    # sup_loss_single_gains %>%
    # TEMPORARILY GOT RID OF sup_loss_single_gains TO FIX R CMD CHECK NOTE
    group_by(.data$currency) %>%
    filter(
      .data$sup.loss == TRUE,
      .data$gains < 0
    ) %>%
    summarize(sup.loss = sum(.data$corrected.sup.loss))
}

sup_loss <- function(data) {
  lapply(unique(data$currency), function(x) {
    data %>%
      filter(.data$currency == x) %>%
      sup_loss_single()
  }) %>%
    bind_rows() %>%
    add_row(
      currency = "Total",
      summarize(.data, across(.data$sup.loss, .data$sum))
    ) %>%
    as.data.frame() %>%
    mutate(sup.loss = round(.data$sup.loss, 2))
}
