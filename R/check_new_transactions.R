.validate_check_new_transactions_input <- function(data, transactions.col, description.col = NULL) {
  if (!transactions.col %in% names(data)) {
    stop("Column '", transactions.col, "' not found in data frame. Double-check for typos.")
  }

  if (!is.null(description.col) && !description.col %in% names(data)) {
    stop("Column '", description.col, "' not found in data frame. Double-check for typos.")
  }
}

.new_transaction_names <- function(data, known.transactions, transactions.col) {
  transaction.values <- unique(data[[transactions.col]])
  sort(transaction.values[!transaction.values %in% known.transactions])
}

.new_transaction_descriptions <- function(data, known.transactions, transactions.col, description.col = NULL) {
  if (is.null(description.col)) {
    return(character())
  }

  new.des.names <- data %>%
    filter(!.data[[transactions.col]] %in% known.transactions) %>%
    pull(.data[[description.col]]) %>%
    unique() %>%
    sort()

  if (!length(new.des.names)) {
    return(character())
  }

  new.des.names
}

.format_new_transaction_warning <- function(new.transactions.names, new.descriptions = character()) {
  warning.message <- paste0(
    "New transaction types detected! These may be unaccounted for: ",
    paste(new.transactions.names, collapse = ", ")
  )

  if (!length(new.descriptions)) {
    return(warning.message)
  }

  paste0(
    warning.message,
    ". Associated descriptions: ",
    paste(new.descriptions, collapse = ", ")
  )
}

#' @title Check for new transactions
#'
#' @description Check for new transactions for a given exchange
#' @param data The dataframe
#' @param known.transactions A list of known transactions
#' @param transactions.col The name of the transaction column
#' @param description.col The name of the description column,
#' if available.
#' @return A warning, if there are new transactions. Returns
#' nothing otherwise.
#' @export
#' @examples
#' data <- data_CDC[1:5, ]
#' known.transactions <- c("crypto_purchase", "lockup_lock")
#' check_new_transactions(data,
#'   known.transactions = known.transactions,
#'   transactions.col = "Transaction.Kind",
#'   description.col = "Transaction.Description"
#' )
#' @importFrom dplyr %>% rename mutate select filter bind_rows
#' @importFrom rlang .data
check_new_transactions <- function(data,
                                   known.transactions,
                                   transactions.col,
                                   description.col = NULL) {
  .validate_check_new_transactions_input(
    data = data,
    transactions.col = transactions.col,
    description.col = description.col
  )

  new.transactions.names <- .new_transaction_names(
    data = data,
    known.transactions = known.transactions,
    transactions.col = transactions.col
  )

  if (length(new.transactions.names)) {
    warning(
      .format_new_transaction_warning(
        new.transactions.names = new.transactions.names,
        new.descriptions = .new_transaction_descriptions(
        data = data,
        known.transactions = known.transactions,
        transactions.col = transactions.col,
        description.col = description.col
      )
      )
    )
  }
}
