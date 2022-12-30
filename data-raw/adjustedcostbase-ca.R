## code to prepare `adjustedcostbase.ca` dataset goes here

ACB.ca <- data.frame(
  transaction = c("buy", "sell", "buy", "sell"),
  price = c(50, 120, 130, 90),
  quantity = c(100, 50, 50, 40),
  fees = rep(10, 4)
)

usethis::use_data(adjustedcostbase.ca, overwrite = TRUE)
