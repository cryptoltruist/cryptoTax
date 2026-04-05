.report_summary_filter_year <- function(formatted.ACB, tax.year, local.timezone) {
  if (identical(tax.year, "all")) {
    return(formatted.ACB)
  }

  formatted.ACB %>%
    mutate(datetime.local = lubridate::with_tz(.data$date, tz = local.timezone)) %>%
    filter(lubridate::year(.data$datetime.local) == tax.year)
}

.report_summary_latest_acb <- function(formatted.ACB) {
  formatted.ACB %>%
    group_by(.data$currency) %>%
    filter(.data$date == max(.data$date)) %>%
    slice_tail() %>%
    select("date", "currency", "total.quantity", "ACB.share", "ACB")
}

.report_summary_table <- function(temp, tax.year) {
  results <- temp %>%
    as.data.frame() %>%
    rename("Amount" = "gains") %>%
    mutate(Type = rownames(temp)) %>%
    select("Type", "Amount")
  rownames(results) <- NULL

  results <- rbind(c("tax.year", tax.year), results)
  cbind(results, currency = "CAD")
}

#' @title Summary of gains and losses
#'
#' @description Provides a summary of realized capital gains and losses (and total).
#' @param formatted.ACB The formatted ACB data.
#' @param today.data whether to fetch today's data.
#' @param tax.year Which tax year(s) to include.
#' @param local.timezone Which time zone to use for the date of the report.
#' @param list.prices A `list.prices` object from which to fetch coin prices.
#' @param slug Optional explicit slug vector used when preparing prices.
#' @param start.date Optional explicit start date used when preparing prices.
#' @param force Whether to force recreating `list.prices` even though
#' it already exists (e.g., if you added new coins or new dates).
#' @return A summary data frame, containing at least the following columns:
#' Type, Amount, currency.
#' @export
#' @examples
#' all.data <- format_shakepay(data_shakepay)
#' formatted.ACB <- format_ACB(all.data, verbose = FALSE)
#' report_summary(formatted.ACB, today.data = FALSE)
#' @importFrom dplyr %>% filter mutate group_by ungroup select summarize
#' slice_tail arrange add_row rename
#' @importFrom rlang .data
report_summary <- function(formatted.ACB,
                           today.data = TRUE,
                           tax.year = "all",
                           local.timezone = Sys.timezone(),
                           list.prices = NULL,
                           slug = NULL,
                           start.date = NULL,
                           force = FALSE) {
  formatted.ACB <- formatted.ACB %>%
    filter(.data$currency != "CAD")

  ACB.list <- .report_summary_latest_acb(formatted.ACB)

  if (tax.year != "all") {
    formatted.ACB.year <- .report_summary_filter_year(formatted.ACB, tax.year, local.timezone)
    message(
      "gains, losses, and net have been filtered for tax year ",
      tax.year, " (time zone = ", local.timezone, ")"
    )
  } else {
    formatted.ACB.year <- formatted.ACB
  }

  gains <- formatted.ACB.year %>%
    filter(.data$gains > 0) %>%
    ungroup() %>%
    select("gains") %>%
    summarize(gains = sum(.data$gains))

  gains <- formatC_2(gains)

  losses <- formatted.ACB.year %>%
    filter(.data$gains < 0) %>%
    ungroup() %>%
    select("gains") %>%
    summarize(losses = sum(.data$gains))

  losses <- formatC_2(losses)

  net <- sum(formatted.ACB.year$gains, na.rm = TRUE)
  net.numeric <- net
  net <- formatC_2(net)

  total.cost <- formatC_2(sum(ACB.list$ACB))

  revenue <- formatted.ACB.year %>%
    filter(.data$transaction == "revenue") %>%
    ungroup() %>%
    select("value") %>%
    summarize(revenue = sum(.data$value))

  price.state <- .resolve_report_today_data(
    formatted.ACB = formatted.ACB,
    today.data = today.data,
    list.prices = list.prices,
    slug = slug,
    start.date = start.date,
    force = force,
    verbose = TRUE
  )
  today.data <- price.state$today.data
  list.prices <- price.state$list.prices

  if (isTRUE(today.data)) {
    rates <- .prepare_report_current_rates(
      ACB.list = ACB.list,
      list.prices = list.prices,
      force = force,
      signal = "message"
    )

    rates <- rates %>%
      mutate(
        rate.today = .data$spot.rate,
        value.today = round(.data$total.quantity * .data$rate.today, 2),
        unrealized.net = round(.data$value.today - .data$ACB, 2),
        unrealized.gains = ifelse(.data$unrealized.net > 0,
          .data$unrealized.net,
          NA
        ),
        unrealized.losses = ifelse(.data$unrealized.net < 0,
          .data$unrealized.net,
          NA
        )
      ) %>%
      select(
        "currency", "rate.today", "value.today", "unrealized.gains",
        "unrealized.losses", "unrealized.net"
      )

    unrealized.gains <- sum(rates$unrealized.gains, na.rm = TRUE)
    unrealized.losses <- sum(rates$unrealized.losses, na.rm = TRUE)
    unrealized.net <- sum(rates$unrealized.net, na.rm = TRUE)
    value.today <- sum(rates$value.today)
    percentage.up <- (value.today / sum(ACB.list$ACB) - 1) * 100
    all.time.up.CAD <- value.today + net.numeric
    all.time.up <- (all.time.up.CAD / sum(ACB.list$ACB) - 1) * 100
    all.time.up.revenue.CAD <- all.time.up.CAD + revenue
    all.time.up.revenue <- (all.time.up.revenue.CAD / sum(ACB.list$ACB) - 1) * 100

    unrealized.gains <- formatC_2(unrealized.gains)
    unrealized.losses <- formatC_2(unrealized.losses)
    unrealized.net <- formatC_2(unrealized.net)
    value.today <- formatC_2(value.today)
    percentage.up <- paste0(formatC_2(percentage.up), "%")
    all.time.up <- paste0(formatC_2(all.time.up), "%")
    revenue <- formatC_2(revenue)
    all.time.up.revenue <- paste0(formatC_2(all.time.up.revenue), "%")

    temp <- t(data.frame(
      gains, losses, net, total.cost,
      value.today, unrealized.gains,
      unrealized.losses, unrealized.net,
      percentage.up, all.time.up, revenue,
      all.time.up.revenue
    ))
  }

  if (isFALSE(today.data)) {
    temp <- t(data.frame(gains, losses, net, total.cost, revenue))
  }

  .report_summary_table(temp, tax.year)
}

formatC_2 <- function(x) {formatC(unlist(unlist(x)), format = "f", big.mark = ",", digits = 2)}

