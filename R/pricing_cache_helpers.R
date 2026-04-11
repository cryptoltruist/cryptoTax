.cryptoTax_cache <- new.env(parent = emptyenv())

.pricing_cache_env <- function() {
  .cryptoTax_cache
}

.legacy_pricing_cache_env <- function() {
  .GlobalEnv
}

.pricing_cache_entry_names <- function() {
  c("list.prices", "coins.list", "USD2CAD.table")
}

.find_cached_pricing_object <- function(name, allow_null = FALSE) {
  cache_envs <- list(
    .pricing_cache_env(),
    .legacy_pricing_cache_env()
  )

  for (cache_env in cache_envs) {
    if (!exists(name, envir = cache_env, inherits = FALSE)) {
      next
    }

    value <- get(name, envir = cache_env, inherits = FALSE)

    if (isTRUE(allow_null) || !is.null(value)) {
      return(list(found = TRUE, value = value, env = cache_env))
    }
  }

  list(found = FALSE, value = NULL, env = NULL)
}

.cached_pricing_object_source <- function(name, allow_null = FALSE) {
  cache_match <- .find_cached_pricing_object(name, allow_null = allow_null)

  if (!isTRUE(cache_match$found)) {
    return(NULL)
  }

  if (identical(cache_match$env, .pricing_cache_env())) {
    return("package")
  }

  if (identical(cache_match$env, .legacy_pricing_cache_env())) {
    return("legacy")
  }

  NULL
}

.has_cached_pricing_object <- function(name, allow_null = FALSE) {
  .find_cached_pricing_object(name, allow_null = allow_null)$found
}

.get_cached_pricing_object <- function(name) {
  .find_cached_pricing_object(name, allow_null = TRUE)$value
}

.set_cached_pricing_object <- function(name, value) {
  assign(name, value, envir = .pricing_cache_env())
  value
}

.clear_cached_pricing_object <- function(name) {
  cache_env <- .pricing_cache_env()

  if (exists(name, envir = cache_env, inherits = FALSE)) {
    rm(list = name, envir = cache_env)
  }

  invisible(TRUE)
}

.can_reuse_cached_pricing_object <- function(name, force = FALSE, allow_null = FALSE) {
  !isTRUE(force) && .has_cached_pricing_object(name, allow_null = allow_null)
}

.message_cached_pricing_reuse <- function(name, source, verbose = TRUE) {
  if (!isTRUE(verbose) || is.null(source)) {
    return(invisible(NULL))
  }

  if (identical(source, "legacy")) {
    message(
      "Using deprecated legacy '.GlobalEnv' cache for '", name, "'. ",
      "This compatibility path may be removed in a future release; ",
      "prefer `pricing_cache()` or pass `", name, "` explicitly. ",
      "To force a fresh download, use argument 'force = TRUE'."
    )
    return(invisible(NULL))
  }

  if (identical(source, "package")) {
    message(
      "Using cached '", name, "'. ",
      "To force a fresh download, use argument 'force = TRUE'."
    )
  }

  invisible(NULL)
}

.reuse_cached_pricing_object <- function(name,
                                         force = FALSE,
                                         verbose = TRUE,
                                         allow_null = FALSE,
                                         validator = NULL) {
  if (!.can_reuse_cached_pricing_object(name, force = force, allow_null = allow_null)) {
    return(NULL)
  }

  cached_value <- .get_cached_pricing_object(name)

  if (is.function(validator) && !isTRUE(validator(cached_value))) {
    return(NULL)
  }

  .message_cached_pricing_reuse(
    name = name,
    source = .cached_pricing_object_source(name, allow_null = allow_null),
    verbose = verbose
  )

  cached_value
}

.is_valid_list_prices_table <- function(list.prices) {
  is.data.frame(list.prices) &&
    all(c("currency", "spot.rate2", "date2") %in% names(list.prices))
}

.is_valid_coins_list <- function(coins.list) {
  is.data.frame(coins.list) &&
    "slug" %in% names(coins.list)
}

.is_valid_usd2cad_crypto2_table <- function(USD2CAD.table) {
  is.data.frame(USD2CAD.table) &&
    all(c("date2", "CAD.rate") %in% names(USD2CAD.table))
}

.is_valid_usd2cad_pricer_cache <- function(USD2CAD.table) {
  is.data.frame(USD2CAD.table) &&
    all(c("date", "CAD.rate") %in% names(USD2CAD.table))
}

#' @title Inspect the cryptoTax pricing cache
#'
#' @description Inspect cached pricing-related objects stored by `cryptoTax`
#' during the current R session. This cache is package-owned, so it avoids
#' cluttering the user workspace while still keeping the shared-price workflow
#' easy to inspect.
#'
#' For compatibility with older workflows, `include.legacy = TRUE` will also
#' report matching objects that still live in `.GlobalEnv`. Those legacy
#' workspace objects are supported as a compatibility fallback, but they are no
#' longer the primary cache path and may be removed in a future release.
#'
#' @param name Optional single cache entry to inspect. One of
#'   `"list.prices"`, `"coins.list"`, or `"USD2CAD.table"`.
#' @param include.legacy Logical; whether to also include legacy cache objects
#'   found in `.GlobalEnv`.
#' @return If `name` is `NULL`, a named list of cache entries. Otherwise, the
#'   requested cached object or `NULL` if not present.
#' @export
#' @examples
#' pricing_cache()
#' pricing_cache("list.prices")
pricing_cache <- function(name = NULL, include.legacy = FALSE) {
  valid_names <- .pricing_cache_entry_names()

  if (!is.null(name)) {
    stopifnot(length(name) == 1)
    if (!name %in% valid_names) {
      stop("`name` must be one of 'list.prices', 'coins.list', or 'USD2CAD.table'.")
    }

    if (isTRUE(include.legacy)) {
      return(.find_cached_pricing_object(name, allow_null = TRUE)$value)
    }

    if (!exists(name, envir = .pricing_cache_env(), inherits = FALSE)) {
      return(NULL)
    }

    return(get(name, envir = .pricing_cache_env(), inherits = FALSE))
  }

  cache_entries <- vector("list", length(valid_names))
  names(cache_entries) <- valid_names

  for (cache_name in valid_names) {
    if (isTRUE(include.legacy)) {
      cache_entries[[cache_name]] <- .find_cached_pricing_object(
        cache_name,
        allow_null = TRUE
      )$value
      next
    }

    if (exists(cache_name, envir = .pricing_cache_env(), inherits = FALSE)) {
      cache_entries[[cache_name]] <- get(
        cache_name,
        envir = .pricing_cache_env(),
        inherits = FALSE
      )
    }
  }

  cache_entries
}

#' @title Clear the cryptoTax pricing cache
#'
#' @description Clear one or more cached pricing-related objects stored by
#' `cryptoTax` during the current R session.
#'
#' This clears the package-owned cache only; it does not remove similarly named
#' objects from `.GlobalEnv`.
#'
#' @param name Optional single cache entry to clear. One of `"list.prices"`,
#'   `"coins.list"`, or `"USD2CAD.table"`. If omitted, all package-owned
#'   pricing-cache entries are cleared.
#' @return Invisibly returns `TRUE`.
#' @export
#' @examples
#' clear_pricing_cache()
#' clear_pricing_cache("list.prices")
clear_pricing_cache <- function(name = NULL) {
  valid_names <- .pricing_cache_entry_names()

  if (is.null(name)) {
    for (cache_name in valid_names) {
      .clear_cached_pricing_object(cache_name)
    }
    return(invisible(TRUE))
  }

  stopifnot(length(name) == 1)
  if (!name %in% valid_names) {
    stop("`name` must be one of 'list.prices', 'coins.list', or 'USD2CAD.table'.")
  }

  .clear_cached_pricing_object(name)
}
