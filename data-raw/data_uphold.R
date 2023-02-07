## code to prepare `data_uphold` dataset goes here

data_uphold <- structure(list(Date = c(
  "Wed June 09 2021 04:52:23 GMT+0000",
  "Tue May 11 2021 07:12:24 GMT+0000", "Tue April 06 2021 03:41:42 GMT+0000",
  "Tue April 06 2021 04:47:00 GMT+0000", "Mon April 05 2021 12:22:00 GMT+0000",
  "Sun March 07 2021 21:54:09 GMT+0000", "Sun March 07 2021 21:46:57 GMT+0000",
  "Sat March 06 2021 21:32:36 GMT+0000", "Tue February 09 2021 14:26:49 GMT+0000",
  "Thu January 07 2021 02:40:31 GMT+0000"
), Destination = c(
  "uphold",
  "uphold", "litecoin", "uphold", "uphold", "litecoin", "uphold",
  "uphold", "uphold", "uphold"
), Destination.Amount = c(
  0.672074147102947124,
  0.47521984712404, 0.0330598121, 0.0360598121, 8.52198415126512, 0.2412974,
  0.2412974, 0.375912752168, 12.698121631259, 1.59081275128
), Destination.Currency = c(
  "BAT", "BAT", "LTC", "LTC", "BAT",
  "LTC", "LTC", "BAT", "BAT", "BAT"
), Fee.Amount = c(
  NA, NA, 0.003,
  NA, NA, 0.003, NA, NA, NA, NA
), Fee.Currency = c(
  "", "", "LTC",
  "", "", "LTC", "", "", "", ""
), Id = c(
  "abcdefghijklmnopqrstuvwxyz",
  "abcdefghijklmnopqrstuvwxyz", "abcdefghijklmnopqrstuvwxyz",
  "abcdefghijklmnopqrstuvwxyz", "abcdefghijklmnopqrstuvwxyz",
  "abcdefghijklmnopqrstuvwxyz", "abcdefghijklmnopqrstuvwxyz",
  "abcdefghijklmnopqrstuvwxyz", "abcdefghijklmnopqrstuvwxyz",
  "abcdefghijklmnopqrstuvwxyz"
), Origin = c(
  "uphold",
  "uphold", "uphold", "uphold", "uphold", "uphold", "uphold", "uphold",
  "uphold", "uphold"
), Origin.Amount = c(
  0.672074147102947124, 0.47521984712404,
  0.0360598121, 8.52198415126512, 8.52198415126512, 0.2412974, 52.59871205812,
  0.375912752168, 12.698121631259, 1.59081275128
), Origin.Currency = c(
  "BAT",
  "BAT", "LTC", "BAT", "BAT", "LTC", "BAT", "BAT", "BAT", "BAT"
), Status = c(
  "completed", "completed", "completed", "completed",
  "completed", "completed", "completed", "completed", "completed",
  "completed"
), Type = c(
  "in", "in", "out", "transfer", "in", "out",
  "transfer", "in", "in", "in"
)), row.names = c(NA, 10L), class = "data.frame")

usethis::use_data(data_uphold, overwrite = TRUE)
