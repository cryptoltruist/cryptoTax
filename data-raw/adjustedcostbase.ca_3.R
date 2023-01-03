## code to prepare `adjustedcostbase.ca` dataset goes here

adjustedcostbase.ca_3 <- data.frame(
  date = as.Date(c("2014-01-06", "2014-11-03", "2014-11-04", "2015-12-02")),
  transaction = c("buy", "buy", "sell", "sell"),
  quantity = c(100, 100, 100, 100),
  price = c(50, 30, 30, 80)
)

usethis::use_data(adjustedcostbase.ca_3, overwrite = TRUE)
