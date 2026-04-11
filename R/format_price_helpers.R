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
