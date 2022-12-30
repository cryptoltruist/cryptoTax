#' @title Formats transactions with ACB
#'
#' @description Formats transaction data with Adjusted Cost Base (ACB), along with ACB per share and realized capital gains or losses.
#' @param data The dataframe
#' @param as.revenue Which should be treated as revenue, in list of `c("staking", "interest", "mining")`.
#' @param sup.loss Logical, whether to take superficial losses into account.
#' @param cl Number of cores to use for parallel processing.
#' @keywords money crypto
#' @export
#' @examples
#' \dontrun{
#' format_ACB(data)
#' }
#' @importFrom dplyr %>% arrange group_by group_modify relocate mutate
#' @importFrom rlang .data

format_ACB <- function(data,
                       as.revenue = c("staking", "interest", "mining"),
                       sup.loss = TRUE,
                       cl = NULL) {
  # Benchmarks
  start_time <- Sys.time()
  cat(paste(
    "Process started at", start_time,
    ". Please be patient as the transactions process.\n"
  ))

  all.data <- data

  if (isTRUE(sup.loss)) {
    all.data <- all.data %>%
      format_suploss()
  }

  capital.gains <- all.data %>%
    arrange(date) %>%
    mutate(currency2 = .data$currency) %>%
    group_by(.data$currency) %>%
    group_modify(~ if (isTRUE(sup.loss)) {
      ACB_suploss(.x, total.price = "total.price", as.revenue = as.revenue)
    } else {
      ACB(.x, total.price = "total.price", as.revenue = as.revenue)
    }) %>%
    arrange(date) %>%
    relocate(.data$date, .before = .data$currency) %>%
    relocate(.data$fees, .before = .data$description)

  neg.val <- "WARNING: Some balances have negative values. Double-check for missing transactions."

  if (any(capital.gains$total.quantity < 0)) {
    cat(neg.val)
  }

  if (any(capital.gains$total.quantity < 0)) {
    warning(neg.val)
  }

  if (sup.loss == TRUE) {
    warning("WARNING: Adjusted cost base (ACB) and capital gains have been adjusted for the superficial loss rule. To avoid adjusting for the superficial loss rule, this, use argument `sup.loss = FALSE`.")
  }

  # Benchmarks
  end_time <- Sys.time()
  cat(paste("Process ended at", end_time))
  total_time <- end_time - start_time
  cat(paste("Total time elapsed:", total_time))

  capital.gains
}
