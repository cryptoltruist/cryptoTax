.pricing_cache_env <- function() {
  .GlobalEnv
}

.has_cached_pricing_object <- function(name, allow_null = FALSE) {
  cache_env <- .pricing_cache_env()

  if (!exists(name, envir = cache_env, inherits = FALSE)) {
    return(FALSE)
  }

  if (isTRUE(allow_null)) {
    return(TRUE)
  }

  !is.null(get(name, envir = cache_env, inherits = FALSE))
}

.get_cached_pricing_object <- function(name) {
  get(name, envir = .pricing_cache_env(), inherits = FALSE)
}

.set_cached_pricing_object <- function(name, value) {
  assign(name, value, envir = .pricing_cache_env())
  value
}

.can_reuse_cached_pricing_object <- function(name, force = FALSE, allow_null = FALSE) {
  !isTRUE(force) && .has_cached_pricing_object(name, allow_null = allow_null)
}

.is_valid_list_prices_table <- function(list.prices) {
  is.data.frame(list.prices) &&
    all(c("currency", "spot.rate2", "date2") %in% names(list.prices))
}
