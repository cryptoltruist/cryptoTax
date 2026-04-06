.acb_seed_buy <- function(data,
                          date,
                          currency,
                          quantity,
                          total.price,
                          spot.rate = total.price,
                          exchange = NULL,
                          description = "fake transaction for format_ACB",
                          rate.source = "fake") {
  data %>%
    dplyr::add_row(
      date = lubridate::as_datetime(date),
      currency = currency,
      quantity = quantity,
      total.price = total.price,
      spot.rate = spot.rate,
      transaction = "buy",
      description = description,
      exchange = exchange,
      rate.source = rate.source
    ) %>%
    merge_exchanges()
}

.acb_seed_from_existing <- function(data,
                                    date_offset = months(1),
                                    quantity_multiplier = 2,
                                    total_price_multiplier = 2,
                                    description = "fake transaction for format_ACB") {
  seed <- data %>%
    dplyr::mutate(
      date = .data$date - date_offset,
      quantity = .data$quantity * quantity_multiplier,
      total.price = .data$total.price * total_price_multiplier,
      transaction = "buy",
      description = .env$description
    )

  merge_exchanges(data, seed)
}
