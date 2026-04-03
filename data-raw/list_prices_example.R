## code to prepare `list_prices_example` dataset goes here

dates <- seq.Date(as.Date("2021-01-01"), as.Date("2023-12-31"), by = "day")
assets <- data.frame(
  slug = c(
    "bitcoin", "ethereum", "cardano", "cronos", "litecoin",
    "usd-coin", "binance-usd", "celsius", "presearch",
    "ethereum-pow", "basic-attention-token", "usdollar"
  ),
  name = c(
    "Bitcoin", "Ethereum", "Cardano", "Cronos", "Litecoin",
    "USD Coin", "Binance USD", "Celsius", "Presearch",
    "EthereumPoW", "Basic Attention Token", "US Dollar"
  ),
  currency = c("BTC", "ETH", "ADA", "CRO", "LTC", "USDC", "BUSD", "CEL", "PRE", "ETHW", "BAT", "USD"),
  base = c(45000, 1800, 1.20, 0.15, 150, 1.25, 1.25, 6.00, 0.05, 12.00, 0.90, 1.25),
  slope = c(35, 3.5, 0.002, 0.0005, 0.15, 0.00005, 0.00005, 0.01, 0.0001, 0.02, 0.001, 0.00005)
)

idx <- seq_along(dates) - 1
list_prices_example <- do.call(rbind, lapply(seq_len(nrow(assets)), function(i) {
  asset <- assets[i, ]
  spot <- round(asset$base + idx * asset$slope, 8)
  data.frame(
    timestamp = as.POSIXct(dates, tz = "UTC"),
    slug = asset$slug,
    name = asset$name,
    currency = asset$currency,
    open = spot,
    close = spot,
    spot.rate_USD = if (asset$currency == "USD") rep(1, length(dates)) else rep(NA_real_, length(dates)),
    CAD.rate = if (asset$currency == "USD") spot else rep(NA_real_, length(dates)),
    spot.rate2 = spot,
    date = dates,
    date2 = dates
  )
}))

save(list_prices_example, file = "data/list_prices_example.rda", compress = "bzip2")

