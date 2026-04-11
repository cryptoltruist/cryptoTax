.test_exchange_names <- c(
  "adalite",
  "binance",
  "binance_withdrawals",
  "blockfi",
  "CDC",
  "CDC_exchange_rewards",
  "CDC_exchange_trades",
  "CDC_wallet",
  "celsius",
  "coinsmart",
  "exodus",
  "gemini",
  "newton",
  "pooltool",
  "presearch",
  "shakepay",
  "uphold"
)

.test_exchange_data <- function() {
  ns <- asNamespace("cryptoTax")
  lapply(.test_exchange_names, function(exchange) {
    get(paste0("data_", exchange), envir = ns)
  })
}

.test_exchange_data_by_name <- function(exchange) {
  ns <- asNamespace("cryptoTax")
  get(paste0("data_", exchange), envir = ns)
}

.test_mixed_exchange_data <- function(list.prices = list_prices_example) {
  list(
    format_shakepay(.test_exchange_data_by_name("shakepay")),
    .test_exchange_data_by_name("newton"),
    .test_exchange_data_by_name("adalite")
  )
}

.test_usd2cad_table <- function(start = "2017-01-01", end = "2030-12-31", usd = 1.25) {
  data.frame(
    date = seq(as.Date(start), as.Date(end), by = "day"),
    USD = usd,
    CAD = 1
  )
}
