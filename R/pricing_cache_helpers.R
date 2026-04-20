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

.package_cached_pricing_object <- function(name, allow_null = FALSE) {
  cache_env <- .pricing_cache_env()

  if (!exists(name, envir = cache_env, inherits = FALSE)) {
    return(list(found = FALSE, value = NULL, env = NULL))
  }

  value <- get(name, envir = cache_env, inherits = FALSE)

  if (!isTRUE(allow_null) && is.null(value)) {
    return(list(found = FALSE, value = NULL, env = NULL))
  }

  list(found = TRUE, value = value, env = cache_env)
}

.reusable_package_cached_pricing_object <- function(name,
                                                    allow_null = FALSE,
                                                    validator = NULL) {
  cache_match <- .package_cached_pricing_object(name, allow_null = allow_null)

  if (!isTRUE(cache_match$found)) {
    return(cache_match)
  }

  if (is.function(validator) && !isTRUE(validator(cache_match$value))) {
    return(list(found = FALSE, value = NULL, env = NULL))
  }

  cache_match
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

.find_reusable_cached_pricing_object <- function(name,
                                                 allow_null = FALSE,
                                                 validator = NULL) {
  cache_envs <- list(
    .pricing_cache_env(),
    .legacy_pricing_cache_env()
  )

  for (cache_env in cache_envs) {
    if (!exists(name, envir = cache_env, inherits = FALSE)) {
      next
    }

    value <- get(name, envir = cache_env, inherits = FALSE)

    if (!isTRUE(allow_null) && is.null(value)) {
      next
    }

    if (is.function(validator) && !isTRUE(validator(value))) {
      next
    }

    return(list(found = TRUE, value = value, env = cache_env))
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

.can_reuse_cached_pricing_object <- function(name,
                                             force = FALSE,
                                             allow_null = FALSE,
                                             include_legacy = FALSE) {
  if (isTRUE(force)) {
    return(FALSE)
  }

  if (isTRUE(include_legacy)) {
    return(.has_cached_pricing_object(name, allow_null = allow_null))
  }

  .package_cached_pricing_object(name, allow_null = allow_null)$found
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
                                         validator = NULL,
                                         include_legacy = FALSE) {
  if (!.can_reuse_cached_pricing_object(
    name,
    force = force,
    allow_null = allow_null,
    include_legacy = include_legacy
  )) {
    return(NULL)
  }

  cache_match <- if (isTRUE(include_legacy)) {
    .find_reusable_cached_pricing_object(
      name = name,
      allow_null = allow_null,
      validator = validator
    )
  } else {
    .reusable_package_cached_pricing_object(
      name = name,
      allow_null = allow_null,
      validator = validator
    )
  }

  if (!isTRUE(cache_match$found)) {
    return(NULL)
  }

  .message_cached_pricing_reuse(
    name = name,
    source = if (identical(cache_match$env, .pricing_cache_env())) {
      "package"
    } else if (identical(cache_match$env, .legacy_pricing_cache_env())) {
      "legacy"
    } else {
      NULL
    },
    verbose = verbose
  )

  cache_match$value
}

.resolve_pricing_object <- function(name,
                                    value = NULL,
                                    force = FALSE,
                                    verbose = TRUE,
                                    allow_null = FALSE,
                                    validator = NULL,
                                    fetch = NULL,
                                    cache = TRUE) {
  if (!is.null(value)) {
    return(value)
  }

  cached_value <- .reuse_cached_pricing_object(
    name = name,
    force = force,
    verbose = verbose,
    allow_null = allow_null,
    validator = validator
  )
  if (!is.null(cached_value)) {
    return(cached_value)
  }

  if (!is.function(fetch)) {
    return(NULL)
  }

  fetched_value <- fetch()

  if (is.null(fetched_value)) {
    return(NULL)
  }

  if (is.function(validator) && !isTRUE(validator(fetched_value))) {
    return(NULL)
  }

  if (isTRUE(cache)) {
    .set_cached_pricing_object(name, fetched_value)
  }

  fetched_value
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
#' The package-owned cache is a convenience layer for the current R session.
#' It is the only implicit cache path reused during normal pricing/FX
#' resolution. For reproducible or offline workflows, passing explicit
#' `list.prices`, `coins.list`, or `USD2CAD.table` inputs remains the preferred
#' path.
#'
#' For compatibility with older workflows, `include.legacy = TRUE` will also
#' report matching objects that still live in `.GlobalEnv`. Those legacy
#' workspace objects are no longer part of the normal implicit resolution path;
#' they are exposed here only for inspection/transition purposes and may be
#' removed in a future release.
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

#' @title Add pricing objects to the cryptoTax cache
#'
#' @description Seed the package-owned pricing cache explicitly from objects
#' already available in the current R session, for example after loading a
#' previously saved `list.prices` or `USD2CAD.table` from disk.
#'
#' This is especially useful for multi-day tax workflows where you want to keep
#' explicit saved pricing files on disk, but still let formatter helpers reuse
#' those objects through the package cache during the current R session.
#'
#' All supplied objects are validated before being cached. Invalid objects fail
#' early with a clear error instead of silently poisoning later pricing or FX
#' resolution.
#'
#' @param list.prices Optional `list.prices` object to store in the package
#'   cache.
#' @param coins.list Optional output from [crypto2::crypto_list()] to store in
#'   the package cache.
#' @param USD2CAD.table Optional USD/CAD rate table to store in the package
#'   cache.
#'
#' @return Invisibly returns `TRUE`.
#' @export
#'
#' @examples
#' add_to_cache(list.prices = list_prices_example)
#' pricing_cache("list.prices")
add_to_cache <- function(list.prices = NULL,
                         coins.list = NULL,
                         USD2CAD.table = NULL) {
  if (is.null(list.prices) && is.null(coins.list) && is.null(USD2CAD.table)) {
    stop(
      "At least one of 'list.prices', 'coins.list', or 'USD2CAD.table' must be supplied."
    )
  }

  if (!is.null(list.prices) && !isTRUE(.is_valid_list_prices_table(list.prices))) {
    stop(
      "'list.prices' must be a data.frame containing columns ",
      "'currency', 'spot.rate2', and 'date2'."
    )
  }

  if (!is.null(coins.list) && !isTRUE(.is_valid_coins_list(coins.list))) {
    stop(
      "'coins.list' must be a data.frame containing column 'slug'."
    )
  }

  if (!is.null(USD2CAD.table) &&
    !isTRUE(.is_valid_usd2cad_pricer_cache(USD2CAD.table)) &&
    !isTRUE(.is_valid_usd2cad_crypto2_table(USD2CAD.table))) {
    stop(
      "'USD2CAD.table' must be a data.frame containing either columns ",
      "'date' and 'CAD.rate' or columns 'date2' and 'CAD.rate'."
    )
  }

  if (!is.null(list.prices)) {
    .set_cached_pricing_object("list.prices", list.prices)
  }

  if (!is.null(coins.list)) {
    .set_cached_pricing_object("coins.list", coins.list)
  }

  if (!is.null(USD2CAD.table)) {
    .set_cached_pricing_object("USD2CAD.table", USD2CAD.table)
  }

  invisible(TRUE)
}

#' @title Clear the cryptoTax pricing cache
#'
#' @description Clear one or more cached pricing-related objects stored by
#' `cryptoTax` during the current R session.
#'
#' This clears the package-owned cache only; it does not remove similarly named
#' objects from `.GlobalEnv`.
#'
#' Clearing the package cache is the safest way to force fresh pricing/FX
#' resolution without mutating user workspace objects.
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
