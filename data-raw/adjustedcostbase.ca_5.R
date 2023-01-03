## code to prepare `adjustedcostbase.ca` dataset goes here

adjustedcostbase.ca_5 <- data.frame(
  date = as.Date(c("2015-04-09", "2015-04-10")),
  transaction = c("buy", "sell"),
  quantity = c(100, 80),
  price = c(3, 2)
)

usethis::use_data(adjustedcostbase.ca_5, overwrite = TRUE)
