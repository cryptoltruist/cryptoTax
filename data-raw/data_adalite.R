## code to prepare `data_adalite` dataset goes here

data_adalite <- structure(list(
  Date = c(
    "05/17/2021 09:31 PM UTC", "05/17/2021 09:16 PM UTC",
    "05/17/2021 05:16 PM UTC", "05/12/2021 04:56 PM UTC", "05/07/2021 04:53 PM UTC",
    "05/07/2021 04:51 PM UTC", "04/28/2021 04:56 PM UTC", "04/17/2021 09:18 PM UTC",
    "04/17/2021 09:09 PM UTC", "04/17/2021 08:28 PM UTC"
  ), Transaction.ID = c(
    "abcdefghijklmnopqrstuvwxyz",
    "abcdefghijklmnopqrstuvwxyz", "", "", "", "abcdefghijklmnopqrstuvwxyz",
    "", "abcdefghijklmnopqrstuvwxyz", "abcdefghijklmnopqrstuvwxyz",
    "abcdefghijklmnopqrstuvwxyz"
  ), Type = c(
    "Sent", "Sent", "Reward awarded",
    "Reward awarded", "Reward awarded", "Received", "Reward awarded",
    "Received", "Received", "Received"
  ), Received.from..disclaimer..may.not.be.accurate...first.sender.address.only. = c(
    "",
    "", "", "", "", "abcdefghijklmnopqrstuvwxyz", "", "abcdefghijklmnopqrstuvwxyz",
    "abcdefghijklmnopqrstuvwxyz", "abcdefghijklmnopqrstuvwxyz"
  ),
  Received.amount = c(
    NA, NA, 0.412321, 0.221241, 0.3125132,
    222.21413, 0.31204, 14.712312, 420.71231, 15
  ), Received.currency = c(
    "",
    "", "ADA", "ADA", "ADA", "ADA", "ADA", "ADA", "ADA", "ADA"
  ), Sent.amount = c(2, 15, NA, NA, NA, NA, NA, NA, NA, NA),
  Sent.currency = c(
    "ADA", "ADA", "", "", "", "", "", "", "",
    ""
  ), Fee.amount = c(
    0.19123, 0.169187, NA, NA, NA, NA, NA,
    NA, NA, NA
  ), Fee.currency = c(
    "ADA", "ADA", "", "", "", "",
    "", "", "", ""
  ), X = c(
    NA, NA, NA, NA, NA, NA, NA, NA, NA,
    NA
  )
), row.names = c(6L, 8L, 1L, 2L, 3L, 4L, 5L, 7L, 9L, 10L), class = "data.frame")

usethis::use_data(data_adalite, overwrite = TRUE)
