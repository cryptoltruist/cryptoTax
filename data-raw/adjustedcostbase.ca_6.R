## code to prepare `adjustedcostbase.ca` dataset goes here

adjustedcostbase.ca_6 <- data.frame(
  date = as.Date(c("2015-04-09", "2015-04-10", "2015-04-15", "2015-04-20", "2015-05-15")),
  transaction = c("buy", "sell", "buy", "sell", "sell"),
  quantity = c(150, 20, 50, 10, 80),
  price = c(3, 2, 3, 2, 2)
)

usethis::use_data(adjustedcostbase.ca_6, overwrite = TRUE)
