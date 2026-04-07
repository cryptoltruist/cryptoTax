.validate_column_name_arg <- function(x, arg) {
  if (!is.character(x) || length(x) != 1 || is.na(x) || !nzchar(x)) {
    stop("Argument '", arg, "' must be a single non-empty column name.")
  }
}

.validate_check_new_transactions_input <- function(data, transactions.col, description.col = NULL) {
  .validate_column_name_arg(transactions.col, "transactions.col")

  if (!transactions.col %in% names(data)) {
    stop("Column '", transactions.col, "' not found in data frame. Double-check for typos.")
  }

  if (!is.null(description.col)) {
    .validate_column_name_arg(description.col, "description.col")
  }

  if (!is.null(description.col) && !description.col %in% names(data)) {
    stop("Column '", description.col, "' not found in data frame. Double-check for typos.")
  }
}

.unknown_transaction_rows <- function(data, known.transactions, transactions.col) {
  !is.na(data[[transactions.col]]) &
    !data[[transactions.col]] %in% known.transactions
}

.coerce_transaction_values <- function(x) {
  as.character(x)
}

.coerce_known_transactions <- function(x) {
  as.character(x)
}

.new_transaction_names <- function(data, known.transactions, transactions.col) {
  known.transactions <- .coerce_known_transactions(known.transactions)
  transaction.values <- unique(.coerce_transaction_values(data[[transactions.col]])[.unknown_transaction_rows(
    data = data,
    known.transactions = known.transactions,
    transactions.col = transactions.col
  )])
  transaction.values <- transaction.values[!is.na(transaction.values)]
  sort(transaction.values)
}

.new_transaction_descriptions <- function(data, known.transactions, transactions.col, description.col = NULL) {
  if (is.null(description.col)) {
    return(character())
  }

  known.transactions <- .coerce_known_transactions(known.transactions)
  new.des.names <- data %>%
    filter(.unknown_transaction_rows(
      data = data,
      known.transactions = known.transactions,
      transactions.col = transactions.col
    )) %>%
    pull(.data[[description.col]]) %>%
    .coerce_transaction_values() %>%
    .[!is.na(.) & nzchar(.)] %>%
    unique() %>%
    sort()

  if (!length(new.des.names)) {
    return(character())
  }

  new.des.names
}

.has_new_transactions <- function(new.transactions.names) {
  length(new.transactions.names) > 0
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
  known.transactions <- .coerce_known_transactions(known.transactions)
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

  if (.has_new_transactions(new.transactions.names)) {
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
