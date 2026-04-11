.should_surface_generic_pricing_failure <- function(list.prices = NULL) {
  is.null(list.prices) || .is_valid_list_prices_table(list.prices)
}

.handle_formatted_pricing_failure <- function(list.prices = NULL) {
  if (.should_surface_generic_pricing_failure(list.prices)) {
    message("Could not reach the CoinMarketCap API at this time")
  }

  NULL
}

.resolve_formatted_prices <- function(data,
                                     list.prices = NULL,
                                     force = FALSE,
                                     warn_on_missing_spot = FALSE) {
  data <- match_prices(data, list.prices = list.prices, force = force)

  if (is.null(data)) {
    return(.handle_formatted_pricing_failure(list.prices))
  }

  if (isTRUE(warn_on_missing_spot) && any(is.na(data$spot.rate))) {
    warning("Could not calculate spot rate. Use `force = TRUE`.")
  }

  data
}

.fill_missing_total_price_from_spot <- function(data) {
  data %>%
    mutate(total.price = ifelse(
      is.na(.data$total.price),
      .data$quantity * .data$spot.rate,
      .data$total.price
    ))
}

.apply_buy_price_reference <- function(target_rows,
                                       reference_rows,
                                       rate_source_value = "coinmarketcap (buy price)") {
  if (!nrow(target_rows) || !nrow(reference_rows)) {
    return(target_rows)
  }

  has_match <- target_rows$date %in% reference_rows$date

  if (!any(has_match)) {
    return(target_rows)
  }

  matched_reference_prices <- reference_rows[
    which(reference_rows$date %in% target_rows$date),
    "total.price"
  ]

  target_rows[has_match, "total.price"] <- matched_reference_prices
  target_rows <- target_rows %>%
    mutate(spot.rate = .data$total.price / .data$quantity)
  target_rows[has_match, "rate.source"] <- rate_source_value
  target_rows
}

.reuse_buy_total_prices_for_sells <- function(data,
                                              sell_mask = NULL,
                                              preserve_mask = NULL,
                                              rate_source_value = "coinmarketcap (buy price)") {
  data$.row_id_temp <- seq_len(nrow(data))

  if (is.null(sell_mask)) {
    sell_mask <- data$transaction %in% "sell"
  }

  if (is.null(preserve_mask)) {
    preserve_mask <- rep(FALSE, nrow(data))
  }

  buy_rows <- data %>%
    filter(.data$transaction %in% "buy") %>%
    mutate(transaction = "sell")
  sell_rows <- data[sell_mask, , drop = FALSE]

  if (!nrow(sell_rows)) {
    return(data)
  }

  updated_sell_rows <- .apply_buy_price_reference(
    target_rows = sell_rows,
    reference_rows = buy_rows,
    rate_source_value = rate_source_value
  )

  retained_rows <- data[!(sell_mask | preserve_mask), , drop = FALSE]
  preserved_rows <- data[preserve_mask, , drop = FALSE]

  bind_rows(retained_rows, updated_sell_rows, preserved_rows) %>%
    arrange(.data$.row_id_temp) %>%
    select(-".row_id_temp")
}
