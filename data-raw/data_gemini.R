## code to prepare `data_gemini` dataset goes here

data_gemini <- structure(list(
  Date = structure(c(
    1617995788.27, 1618008655.121,
    1618008837.534, 1618010453.947, 1618080487.072, 1618096924.092,
    1618856274.924, 1618856366.084, 1618956300.74, 1620490494.12,
    1621169702.559, 1621172119.666, 1623980334.199, NA
  ), class = c(
    "POSIXct",
    "POSIXt"
  ), tzone = "UTC"), `Time (UTC)` = structure(c(
    1617995788.27,
    1618008655.121, 1618008837.534, 1618010453.947, 1618080487.072,
    1618096924.092, 1618856274.924, 1618856366.084, 1618956300.74,
    1620490494.12, 1621169702.559, 1621172119.666, 1623980334.199,
    NA
  ), class = c("POSIXct", "POSIXt"), tzone = "UTC"), Type = c(
    "Credit",
    "Sell", "Buy", "Buy", "Credit", "Credit", "Debit", "Debit", "Debit",
    "Credit", "Credit", "Credit", "Credit", NA
  ), Symbol = c(
    "LTC",
    "LTCBTC", "LTCBTC", "BATBTC", "LTC", "BTC", "BTC", "LTC", "BAT",
    "BAT", "BAT", "BAT", "BAT", NA
  ), Specification = c(
    "Deposit (Pre-Credited LTC)",
    "Market", "Limit", "Limit", "Deposit (Pre-Credited LTC)", "Administrative Credit",
    "Withdrawal (BTC)", "Withdrawal (LTC)", "Withdrawal (BAT)", "Administrative Credit",
    "Deposit", "Deposit", "Deposit", NA
  ), `Liquidity Indicator` = c(
    NA,
    "Taker", "Taker", "Maker", NA, NA, NA, NA, NA, NA, NA, NA, NA,
    NA
  ), `Trading Fee Rate (bps)` = c(
    NA, 35, 35, 25, NA, NA, NA,
    NA, NA, NA, NA, NA, NA, NA
  ), `BTC Amount BTC` = c(
    NA, 0.000966278355603504,
    0.00000605191150680185, -0.000950730015077889, NA, 0.000285025577645435,
    -0.00705342636528045, NA, NA, NA, NA, NA, NA, NA
  ), `Fee (BTC) BTC` = c(
    NA,
    -0.00000230340864977892, -0.0000000365180991590023, -0.00000181424107430801,
    NA, NA, 0.000000265642840415239, NA, NA, NA, NA, NA, NA, 0
  ),
  `BTC Balance BTC` = c(
    0, 0.00097812412, 0.00089712341, 0.000000864123,
    0.000000864123, 0.009321589712489, 0.000000005291278412,
    0.000000005291278412, 0.000000005291278412, 0.000000005291278412,
    0.000000005291278412, 0.000000005291278412, 0.000000005291278412,
    0.000000005291278412
  ), `LTC Amount LTC` = c(
    0.165149778913637,
    -0.246690598397776, -0.00164082000032067, NA, 2.18565523097012,
    NA, NA, -0.550539317213699, NA, NA, NA, NA, NA, NA
  ), `Fee (LTC) LTC` = c(
    0,
    NA, NA, NA, 0, NA, NA, 0, NA, NA, NA, NA, NA, 0
  ), `LTC Balance LTC` = c(
    0.23492718,
    0.00082198745, 0.0109021785, 0.000045124, 2.2425125167, 0.0079808125,
    0.51250978, 0, 0, 0, 0, 0, 0, 0
  ), `BAT Amount BAT` = c(
    NA,
    NA, NA, 48.7195195851065, NA, NA, NA, NA, -69.1402455104664,
    2.83393478021026, 3.08528833128217, 5.00748146148167, 6.83432254285731,
    NA
  ), `Fee (BAT) BAT` = c(
    NA, NA, NA, NA, NA, NA, NA, NA,
    0, NA, NA, NA, NA, 0
  ), `BAT Balance BAT` = c(
    0, 0, 0, 48.082,
    48.082, 48.082, 63.998, 63.998, 0, 6, 7.521098, 16.4091284125,
    3.9025781905218, 76.4018241790823
  ), `Trade ID` = c(
    NA, 21653474936,
    62877197714, 52774113461, NA, NA, NA, NA, NA, NA, NA, NA,
    NA, NA
  ), `Order ID` = c(
    NA, 56892448228, 49248366213, 94548222968,
    NA, NA, NA, NA, NA, NA, NA, NA, NA, NA
  ), `Order Date` = structure(c(
    NA,
    1618008655.121, 1618008837.534, 1618010453.947, NA, NA, NA,
    NA, NA, NA, NA, NA, NA, NA
  ), tzone = "UTC", class = c(
    "POSIXct",
    "POSIXt"
  )), `Order Time` = structure(c(
    NA, 1618008655.121,
    1618008837.534, 1618010453.947, NA, NA, NA, NA, NA, NA, NA,
    NA, NA, NA
  ), tzone = "UTC", class = c("POSIXct", "POSIXt")), `Client Order ID` = c(
    NA, NA, NA, NA, NA, NA, NA, NA,
    NA, NA, NA, NA, NA, NA
  ), `API Session` = c(
    NA, NA, NA, NA,
    NA, NA, NA, NA, NA, NA, NA, NA, NA, NA
  ), `Tx Hash` = c(
    "abcdefghijklmnopqrstuvwxyz",
    NA, NA, NA, "abcdefghijklmnopqrstuvwxyz", NA, "abcdefghijklmnopqrstuvwxyz",
    "abcdefghijklmnopqrstuvwxyz", "abcdefghijklmnopqrstuvwxyz",
    NA, NA, NA, NA, NA
  ), `Deposit Destination` = c(
    NA, NA, NA,
    NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA
  ), `Deposit Tx Output` = c(
    9,
    NA, NA, NA, 0, NA, NA, NA, NA, NA, NA, NA, NA, NA
  ), `Withdrawal Destination` = c(
    NA,
    NA, NA, NA, NA, NA, "abcdefghijklmnopqrstuvwxyz", "abcdefghijklmnopqrstuvwxyz",
    "abcdefghijklmnopqrstuvwxyz", NA, NA, NA, NA, NA
  ), `Withdrawal Tx Output` = c(
    NA,
    NA, NA, NA, NA, NA, 1, 0, NA, NA, NA, NA, NA, NA
  )
), row.names = c(
  NA,
  -14L
), class = "data.frame")

usethis::use_data(data_gemini, overwrite = TRUE)
