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
