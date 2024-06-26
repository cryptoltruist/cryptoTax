% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/prepare_list_prices.R
\docType{data}
\name{prepare_list_prices}
\alias{prepare_list_prices}
\alias{slugs_to_remove}
\title{Prepare the list of coins for prices}
\format{
An object of class \code{character} of length 18.
}
\usage{
prepare_list_prices(
  coins,
  start.date,
  end.date = lubridate::now("UTC"),
  currency = "CAD",
  remove.coins.slug = slugs_to_remove,
  force = FALSE
)

slugs_to_remove
}
\arguments{
\item{coins}{Which coins to include in the list.}

\item{start.date}{What date to start reporting prices for.}

\item{end.date}{What date to end reporting prices for.}

\item{currency}{What currency to get the value of the coins in.}

\item{remove.coins.slug}{Which currencies to filter out, usually when
the \code{list.prices} object symbol for a given coin is shared by
multiple coins (see details).}

\item{force}{Whether to force recreating \code{list.prices} even though
it already exists (e.g., if you added new coins or new dates).}
}
\value{
A data frame, with the following columns: timestamp, id, slug,
name, symbol, ref_cur, open, high, low, close, volume, market_cap,
time_open, time_close, time_high, time_low, spot.rate2, currency, date2.
}
\description{
Prepare the list of coins for prices.
}
\details{
The \link[crypto2:crypto_history]{crypto2::crypto_history} API is at times a bit capricious. You might
need to try a few times before it processes correctly and without
errors.

Sometimes, \code{list.prices} (through coinmarketcap) will contain symbols for
a given coin (e.g., ETH) that is actually shared by multiple coins, thus,
the necessity of the \code{remove.coins.slug} argument. In these cases, we can
look at the slug column of \code{list.prices} to identify the correct coins.
ETH for example possesses two slugs: "ethereum" (the main one) and
"the-infinite-garden" (probably not the one you want). Per default, a
number of duplicate slugs are excluded, the list of which is accessible in
the \code{slugs_to_remove} object. However, you can provide your own list,
should you wish to.
}
\examples{
my.coins <- c("BTC", "ETH")
my.list.prices <- prepare_list_prices(coins = my.coins, start.date = "2023-01-01")
head(my.list.prices)
}
\keyword{datasets}
