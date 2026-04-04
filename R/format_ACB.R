.validate_format_acb_input <- function(data) {
  if (is.null(data)) {
    message("Could not fetch exchange rates from the exchange rate API.")
    return(NULL)
  }

  if (any(is.na(data$total.price))) {
    stop("Column 'total.price' cannot have any missing values. Please double check your file.")
  }

  if (any(is.na(data$transaction))) {
    stop("Column 'transaction' cannot have any missing values. Please double check your file.")
  }

  if (any(data$total.price < 0)) {
    stop("Column 'total.price' cannot have any negative values. Please double check your file.")
  }

  if (any(data$spot.rate < 0)) {
    stop("Column 'spot.rate' cannot have any negative values. Please double check your file.")
  }

  data
}

.run_format_acb_by_currency <- function(data, as.revenue, sup.loss, verbose) {
  data %>%
    arrange(date) %>%
    mutate(currency2 = .data$currency) %>%
    group_by(.data$currency, .drop = FALSE) %>%
    group_modify(~ ACB(
      .x,
      total.price = "total.price",
      as.revenue = as.revenue,
      sup.loss = sup.loss,
      verbose = verbose
    )) %>%
    arrange(date) %>%
    relocate("date", .before = "currency") %>%
    relocate("fees", .before = "description")
}

.report_format_acb_messages <- function(capital.gains, sup.loss, verbose, start_time) {
  if (any(capital.gains$total.quantity < 0) && isTRUE(verbose)) {
    warning("WARNING: Some balances have negative values. Double-check for missing transactions.\n")
  }

  if (isTRUE(sup.loss) && isTRUE(verbose)) {
    message("Note: Adjusted cost base (ACB) and capital gains have been adjusted for the superficial loss rule. To avoid this, use argument `sup.loss = FALSE`.")
  }

  if (isTRUE(verbose)) {
    end_time <- Sys.time()
    total_time <- difftime(end_time, start_time, units = "min")
    cat(paste0(
      "Process ended at ", end_time, ". Total time elapsed: ",
      round(total_time, 2), " minutes\n"
    ))
  }
}

#' @title Formats transactions with ACB
#'
#' @description Formats transaction data with Adjusted Cost Base (ACB),
#' along with ACB per share and realized capital gains or losses.
#' @param data The dataframe
#' @param as.revenue Which should be treated as revenue, in list of
#' `c("staking", "interests", "mining")`.
#' @param sup.loss Logical, whether to take superficial losses into account.
#' @param cl Number of cores to use for parallel processing.
#' @param verbose Logical: if `FALSE`, does not print progress bar or warnings
#' to console.
#' @return A data frame, formatted for the Adjusted Cost Base (ACB).
#' @export
#' @examples
#' all.data <- format_shakepay(data_shakepay)
#' format_ACB(all.data, verbose = FALSE)
#' @importFrom dplyr %>% arrange group_by group_modify relocate mutate
#' @importFrom rlang .data

format_ACB <- function(data,
                       as.revenue = c("staking", "interests", "mining"),
                       sup.loss = TRUE,
                       cl = NULL,
                       verbose = TRUE) {
  data <- .validate_format_acb_input(data)
  if (is.null(data)) {
    return(NULL)
  }

  start_time <- Sys.time()
  if (isTRUE(verbose)) {
    cat(paste0(
      "Process started at ", start_time,
      ". Please be patient as the transactions process.\n"
    ))
    cat("[Formatting ACB (progress bar repeats for each coin)...]\n")
  }

  capital.gains <- .run_format_acb_by_currency(
    data = data,
    as.revenue = as.revenue,
    sup.loss = sup.loss,
    verbose = verbose
  )

  .report_format_acb_messages(
    capital.gains = capital.gains,
    sup.loss = sup.loss,
    verbose = verbose,
    start_time = start_time
  )

  capital.gains
}
