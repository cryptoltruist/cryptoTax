## code to prepare `adjustedcostbase.ca` data sets goes here
# https://www.adjustedcostbase.ca/blog/how-to-calculate-adjusted-cost-base-acb-and-capital-gains/
# https://www.adjustedcostbase.ca/blog/what-is-the-superficial-loss-rule/

adjustedcostbase.ca1 <- data.frame(
  date = as.Date(c("2014-03-03", "2014-05-01", "2014-07-18", "2014-09-25")),
  transaction = c("buy", "sell", "buy", "sell"),
  quantity = c(100, 50, 50, 40),
  price = c(50, 120, 130, 90),
  fees = rep(10, 4)
)
usethis::use_data(adjustedcostbase.ca1, overwrite = TRUE)

adjustedcostbase.ca2 <- data.frame(
  date = as.Date(c("2014-01-06", "2014-11-03", "2014-11-04", "2015-12-02")),
  transaction = c("buy", "sell", "buy", "sell"),
  quantity = c(100, 100, 100, 100),
  price = c(50, 30, 30, 80)
)
usethis::use_data(adjustedcostbase.ca2, overwrite = TRUE)

adjustedcostbase.ca3 <- data.frame(
  date = as.Date(c("2014-01-06", "2014-11-03", "2014-11-04", "2015-12-02")),
  transaction = c("buy", "buy", "sell", "sell"),
  quantity = c(100, 100, 100, 100),
  price = c(50, 30, 30, 80)
)
usethis::use_data(adjustedcostbase.ca3, overwrite = TRUE)

adjustedcostbase.ca4 <- data.frame(
  date = as.Date(c("2015-01-02", "2015-04-09", "2015-04-10")),
  transaction = c("buy", "sell", "buy"),
  quantity = c(100, 100, 25),
  price = c(3, 2, 2.20)
)
usethis::use_data(adjustedcostbase.ca4, overwrite = TRUE)

adjustedcostbase.ca5 <- data.frame(
  date = as.Date(c("2015-04-09", "2015-04-10")),
  transaction = c("buy", "sell"),
  quantity = c(100, 80),
  price = c(3, 2)
)
usethis::use_data(adjustedcostbase.ca5, overwrite = TRUE)

adjustedcostbase.ca6 <- data.frame(
  date = as.Date(c("2015-04-09", "2015-04-10", "2015-04-15", "2015-04-20", "2015-05-15")),
  transaction = c("buy", "sell", "buy", "sell", "sell"),
  quantity = c(150, 20, 50, 10, 80),
  price = c(3, 2, 3, 2, 2)
)
usethis::use_data(adjustedcostbase.ca6, overwrite = TRUE)
