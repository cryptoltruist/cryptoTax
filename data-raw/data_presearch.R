## code to prepare `data_presearch` dataset goes here

data_presearch <- structure(list(date = c(
  "2021-04-27, 17:45:18", "2021-04-27, 17:48:00",
  "2021-04-27, 17:48:18", "2021-04-27, 17:55:24", "2021-04-27, 17:57:29",
  "2021-04-27, 19:00:31", "2021-04-27, 19:00:41", "2021-04-27, 19:01:57",
  "2021-04-27, 19:08:59", "2021-04-27, 19:12:15", "2021-05-07, 05:55:33",
  "2021-05-09, 05:51:14"
), amount = c(
  0.13, 0.13, 0.13, 0.13, 0.13,
  0.13, 0.13, 0.13, 0.13, 0.13, 1000, -1000
), description = c(
  "Search Reward",
  "Search Reward", "Search Reward", "Search Reward", "Search Reward",
  "Search Reward", "Search Reward", "Search Reward", "Search Reward",
  "Search Reward", "Transferred from Presearch Portal (PO#: 412893)",
  "Staked to keyword: abcdefghijklmnopqrstuvwxyz"
)), row.names = c(
  NA,
  12L
), class = "data.frame")

usethis::use_data(data_presearch, overwrite = TRUE)
