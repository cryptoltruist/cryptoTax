## code to prepare `adjustedcostbase.ca` dataset goes here

adjustedcostbase.ca_1 <- data.frame(
  date = as.Date(c("2014-03-03", "2014-05-01", "2014-07-18", "2014-09-25")),
  transaction = c("buy", "sell", "buy", "sell"),
  quantity = c(100, 50, 50, 40),
  price = c(50, 120, 130, 90),
  fees = rep(10, 4)
)

usethis::use_data(adjustedcostbase.ca_1, overwrite = TRUE)
