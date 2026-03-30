#' @title Summary of ACB
#'
#' @description Provides a summary of Adjusted Cost Base (ACB) per share, as well as realized and unrealized gains/losses (plus net value), per coin.
#' @param formatted.ACB The formatted ACB data.
#' @param today.data whether to fetch today's data.
#' @param tax.year Which tax year(s) to include.
#' @param local.timezone Which time zone to use for the date of the report.
#' @param list.prices A `list.prices` object from which to fetch coin prices.
#' @param force Whether to force recreating `list.prices` even though
#' it already exists (e.g., if you added new coins or new dates).
#' @return A summary data frame, containing at least the following columns:
#' date.last, currency, total.quantity, cost.share, total.cost, gains,
#' losses, net, currency.
#' @export
#' @examples
#' all.data <- format_shakepay(data_shakepay)
#' formatted.ACB <- format_ACB(all.data, verbose = FALSE)
#' report_overview(formatted.ACB, today.data = FALSE)
#' @importFrom dplyr %>% filter mutate group_by summarize slice_tail bind_rows
#' arrange add_row across full_join last n

report_overview <- function(formatted.ACB, 
                            today.data = TRUE, 
                            tax.year = "all",
                            local.timezone = Sys.timezone(),
                            list.prices = NULL,
                            slug = NULL,
                            start.date = NULL,
                            force = FALSE,
                            verbose = TRUE) {
  if (isTRUE(today.data) && isFALSE(curl::has_internet()) && isTRUE(verbose)) {
    message("You need Internet access to use the `today.data == TRUE` argument. The today.data argument has been set to `FALSE` automatically.")
    today.data <- FALSE
  }

  # Remove CAD
  formatted.ACB <- formatted.ACB %>%
    filter(.data$currency != "CAD")

  # Filter for year, if necessary!
  if (tax.year != "all") {
    formatted.ACB.year <- formatted.ACB %>%
      mutate(datetime.local = lubridate::with_tz(.data$date, tz = local.timezone)) %>%
      filter(lubridate::year(.data$datetime.local) == tax.year)

    if (isTRUE(verbose)) {
      message("gains, losses, and net have been filtered for tax year ", tax.year)  
    }
  }

  if (tax.year == "all") {
    formatted.ACB.year <- formatted.ACB
  }

  net <- formatted.ACB.year %>%
    group_by(.data$currency) %>%
    summarize(net = sum(.data$gains, na.rm = TRUE))

  gains <- formatted.ACB.year %>%
    group_by(.data$currency) %>%
    filter(.data$gains > 0) %>%
    summarize(gains = sum(.data$gains, na.rm = TRUE))

  losses <- formatted.ACB.year %>%
    group_by(.data$currency) %>%
    filter(.data$gains < 0) %>%
    summarize(losses = sum(.data$gains, na.rm = TRUE))

  ACB.list <- formatted.ACB %>%
    group_by(.data$currency) %>%
    filter(date == max(.data$date)) %>%
    slice_tail() %>%
    select("date", "currency", "total.quantity", "ACB.share", "ACB")

  if (today.data == TRUE) {
    # Make warning for GB, NFTs, etc.
    if (any(ACB.list$currency %in% "GB") && isTRUE(verbose)) {
      warning("1. GB transactions are excluded from today's data because it is not listed on CoinMarketCap.")
    }
    if (any(grepl("NFT", ACB.list$currency)) && isTRUE(verbose)) {
      warning("2. NFTs are excluded from today's data because NFTs are not listed individually on CoinMarketCap.")
    }

    list.prices <- prepare_list_prices_slugs(
      formatted.ACB,
      list.prices = list.prices,
      slug = slug,
      start.date = start.date,
      verbose = verbose)
    
    # if (is.null(list.prices)) {
    #   my.coins <- formatted.ACB %>% 
    #     select(currency) %>% 
    #     unique %>% 
    #     unlist()
    #   my.coins <- popular_slugs %>% 
    #     filter(currency == my.coins) %>% 
    #     select(slug)
    #   list.prices <- prepare_list_prices(my.coins, start.date = lubridate::today())
    # }
    
    rates <- ACB.list %>%
      filter(
        .data$currency != "GB",
        !grepl("NFT", .data$currency)
      ) %>%
      mutate(
        date.temp = .data$date,
        date = last(list.prices$date2)
      )

    rates <- cryptoTax::match_prices(rates, 
                                     list.prices = list.prices, 
                                     force = force, 
                                     verbose = verbose)
    
    if (isTRUE(verbose)) {
      message("Date of current prices: ", last(list.prices$date2))
    }

    rates <- rates %>%
      mutate(
        rate.today = .data$spot.rate,
        value.today = round(.data$total.quantity * .data$rate.today, 2),
        unrealized.net = round(.data$value.today - ACB, 2),
        unrealized.gains = ifelse(.data$unrealized.net > 0,
          .data$unrealized.net,
          NA
        ),
        unrealized.losses = ifelse(.data$unrealized.net < 0,
          .data$unrealized.net,
          NA
        ),
        currency2 = .data$currency
      ) %>%
      select(
        "currency", "rate.today", "value.today", "unrealized.gains",
        "unrealized.losses", "unrealized.net", "currency2"
      )

    full <- list(ACB.list, gains, losses, net, rates) %>%
      Reduce(function(dtf1, dtf2) full_join(dtf1, dtf2, by = "currency"), .)

    full <- full %>%
      rename(
        date.last = "date",
        total.cost = "ACB",
        cost.share = "ACB.share"
      ) %>%
      group_by(.data$currency) %>%
      # arrange(desc(.data$total.cost), desc(.data$cost.share), desc(.data$total.quantity)) %>%
      mutate(across("cost.share":"unrealized.gains", \(x) round(x, 2))) %>%
      as.data.frame(full)

    full <- full %>%
      add_row(
        date.last = max(full$date.last),
        currency = "Total",
        currency2 = "Total",
        summarize(., across(
          c(
            "total.cost":"net",
            "value.today":"unrealized.net"
          ),
          \(x) sum(x, na.rm = TRUE)
        ))
      )
  }

  if (today.data == FALSE) {
    full <- list(ACB.list, gains, losses, net) %>%
      Reduce(function(dtf1, dtf2) full_join(dtf1, dtf2, by = "currency"), .)

    full <- full %>%
      rename(
        date.last = "date",
        total.cost = "ACB",
        cost.share = "ACB.share"
      ) %>%
      group_by(.data$currency) %>%
      mutate(across("cost.share":"net", \(x) round(x, 2)),
        currency2 = .data$currency
      ) %>%
      as.data.frame(full)

    full <- full %>%
      add_row(
        date.last = max(full$date.last),
        currency = "Total",
        currency2 = "Total",
        summarize(., across(
          c("total.cost":"net"),
          \(x) sum(x, na.rm = TRUE)
        ))
      )
  }

  last.col <- last(full)
  
  full <- full %>% 
    slice(1:(n() - 1)) %>% 
    mutate(cost.gains = .data$total.cost + .data$gains) %>% 
    arrange(desc(.data$cost.gains),
            desc(.data$gains),
            # desc(.data$net),
            desc(.data$total.cost),
            desc(.data$cost.share),
            desc(.data$losses),
            desc(.data$total.quantity)) %>% 
    select(-"cost.gains")
  
  bind_rows(full, last.col)
}
