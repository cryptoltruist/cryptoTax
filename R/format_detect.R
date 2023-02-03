#' @title Detect transaction file exchange and format it
#'
#' @description Detect the exchange of a given transaction file and format
#' it with the proper function for later ACB processing.
#' @param data The dataframe
#' @param list.prices A `list.prices` object from which to fetch coin prices.
#' @param force Whether to force recreating `list.prices` even though
#' it already exists (e.g., if you added new coins or new dates).
#' @export
#' @examples
#' format_detect(data_shakepay)
#' format_detect(data_newton)
#' @importFrom dplyr %>% rename mutate select filter bind_rows
#' @importFrom rlang .data

format_detect <- function(data, list.prices = NULL, force = FALSE) {
  
  # Extract data col names
  data.names <- toString(names(data))
  
  # Generate string list of exchanges
  exchanges <- paste0(c(
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
    "shakepay"))
  
  data_exchanges <- paste0("data_", exchanges)
  
  # Extract col names of all exchanges
  exchanges.cols <- lapply(data_exchanges, function(x) {
    toString(names(eval(parse(text = x))))
  }) %>% 
    stats::setNames(exchanges)
  
  # Generate logical condition to identify right exchange
  condition <- names(which(data.names == exchanges.cols))
  
  if (length(condition) == 0) {
    stop("Could not identify the correct exchange automatically. ",
         "Please use the appropriate function or 'format_generic()'.")
  }
  
  # Apply right function
  formatted.data <- switch(
    condition,
    adalite = {format_adalite(data, list.prices = list.prices, force = force)},
    binance = {format_binance(data, list.prices = list.prices, force = force)},
    binance_withdrawals = {format_binance_withdrawals(data, list.prices = list.prices, force = force)},
    blockfi = {format_blockfi(data, list.prices = list.prices, force = force)},
    CDC = {format_CDC(data)},
    CDC_exchange_rewards = {format_CDC_exchange_rewards(data, list.prices = list.prices, force = force)},
    CDC_exchange_trades = {format_CDC_exchange_trades(data, list.prices = list.prices, force = force)},
    CDC_wallet = {format_CDC_wallet(data, list.prices = list.prices, force = force)},
    celsius = {format_celsius(data)},
    coinsmart = {format_coinsmart(data, list.prices = list.prices, force = force)},
    exodus = {format_exodus(data, list.prices = list.prices, force = force)},
    gemini = {format_gemini(data, list.prices = list.prices, force = force)},
    newton = {format_newton(data)},
    pooltool = {format_pooltool(data)},
    presearch = {format_presearch(data, list.prices = list.prices, force = force)},
    shakepay = {format_shakepay(data)},
  )
  
  formatted.data
}
