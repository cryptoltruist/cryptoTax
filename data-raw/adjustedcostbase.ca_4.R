## code to prepare `adjustedcostbase.ca` dataset goes here

adjustedcostbase.ca_4 <- data.frame(
  date = as.Date(c("2015-01-02", "2015-04-09", "2015-04-10")),
  transaction = c("buy", "sell", "buy"),
  quantity = c(100, 100, 25),
  price = c(3, 2, 2.20)
)

usethis::use_data(adjustedcostbase.ca_4, overwrite = TRUE)
