## code to prepare `data_presearch` dataset goes here

data_presearch <- structure(list(date = c(
  "2021-01-02, 19:08:59", "2021-04-27, 19:12:15", "2021-05-07, 05:55:33",
  "2021-05-09, 05:51:14", "2021-12-09, 06:24:22"
), amount = c(
  "1,000.0000", "1,000.0000", "1,000.0000", "-1.0000", "10.0000"
), description = c(
  "Transferred from Rewards", "Transferred from Rewards",
  "Transferred from Presearch Portal (PO#: 412893)",
  "Staked to keyword: abcdefghijklmnopqrstuvwxyz",
  "Presearch 2021 Airdrop (Increased Stake)"
)), row.names = c(
  NA,
  5L
), class = "data.frame")

usethis::use_data(data_presearch, overwrite = TRUE)
