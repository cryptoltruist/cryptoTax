## code to prepare `data_celsius` dataset goes here

data_celsius <- structure(list(
  Internal.id = c(
    "abcdefghijklmnopqrstuvwxyz",
    "abcdefghijklmnopqrstuvwxyz", "abcdefghijklmnopqrstuvwxyz", "abcdefghijklmnopqrstuvwxyz",
    "abcdefghijklmnopqrstuvwxyz", "abcdefghijklmnopqrstuvwxyz", "abcdefghijklmnopqrstuvwxyz",
    "abcdefghijklmnopqrstuvwxyz", "abcdefghijklmnopqrstuvwxyz", "abcdefghijklmnopqrstuvwxyz",
    "abcdefghijklmnopqrstuvwxyz", "abcdefghijklmnopqrstuvwxyz"
  ),
  Date.and.time = c(
    "June 15, 2021 5:25 PM", "May 25, 2021 4:17 AM",
    "May 23, 2021 5:00 AM", "May 6, 2021 10:32 AM", "April 8, 2021 10:18 PM",
    "April 8, 2021 5:00 AM", "April 5, 2021 5:00 AM", "March 28, 2021 5:00 AM",
    "March 19, 2021 5:00 AM", "March 7, 2021 5:00 AM", "March 3, 2021 9:11 PM",
    "March 3, 2021 9:09 PM"
  ), Transaction.type = c(
    "Referrer Award",
    "Withdrawal", "Reward", "Promo Code Reward", "Referred Award",
    "Reward", "Reward", "Reward", "Reward", "Reward", "Promo Code Reward",
    "Transfer"
  ), Coin.type = c(
    "BTC", "BTC", "BTC", "BTC", "BTC",
    "BTC", "BTC", "BTC", "BTC", "BTC", "BTC", "BTC"
  ), Coin.amount = c(
    0.00112524527168633,
    -0.0166795464177858, -0.0000637266939226747, 0.00140902344098454,
    0.000733082450302954, -0.0000517756222355121, -0.0000469403905661057,
    0.00000368306276665178, 0.0000815612085280039, -0.0000252378832255609,
    0.000707598916200572, 0.0138778831199655
  ), USD.Value = c(
    50,
    -437.98724512412, 0.345125124123257, 50, 40, 0.5125908141,
    0.46705098123121, 0.4751290381221, 0.581092731212,
    0.107850981231231, 40, 522.9742131312
  ), Original.Reward.Coin = c(
    "",
    "", "BTC", "", "", "BTC", "BTC", "BTC", "BTC", "BTC", "",
    ""
  ), Reward.Amount.In.Original.Coin = c(
    NA_real_, NA_real_,
    NA_real_, NA_real_, NA_real_, NA_real_, NA_real_, NA_real_,
    NA_real_, NA_real_, NA_real_, NA_real_
  ), Confirmed = c(
    "Yes",
    "Yes", "Yes", "Yes", "Yes", "Yes", "Yes", "Yes", "Yes", "Yes",
    "Yes", "Yes"
  )
), row.names = c(NA, -12L), class = "data.frame")

usethis::use_data(data_celsius, overwrite = TRUE)
