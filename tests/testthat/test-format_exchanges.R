# shakepay ####
test_that("shakepay", {
  data <- data_shakepay
  data
  expect_equal(
    format_shakepay(data),
    structure(list(date = structure(c(
      1620399041, 1620422736, 1620475977,
      1620562927, 1621601234, 1623413011, 1624450909, 1625878339
    ), tzone = "UTC", class = c(
      "POSIXct",
      "POSIXt"
    )), quantity = c(
      0.00103982, 30, 0.00011, 0.00012, 0.00013,
      0.00014, 0.00015, 0.00052991
    ), currency = c(
      "BTC", "CAD", "BTC",
      "BTC", "BTC", "BTC", "BTC", "BTC"
    ), total.price = c(
      53.03335,
      30, 5.784023564, 6.034440948, 7.348590444, 8.396926678, 8.71487655,
      31.26848
    ), spot.rate = c(
      51002.4331134235, 1, 52582.0324, 50287.0079,
      56527.6188, 59978.0477, 58099.177, 59007.1521579136
    ), transaction = c(
      "buy",
      "revenue", "revenue", "revenue", "revenue", "revenue", "revenue",
      "sell"
    ), description = c(
      "purchase/sale", "other", "shakingsats",
      "shakingsats", "shakingsats", "shakingsats", "shakingsats", "purchase/sale"
    ), comment = c(
      "purchase", "credit", "credit", "credit", "credit",
      "credit", "credit", "sale"
    ), revenue.type = c(
      NA, "referrals",
      "airdrops", "airdrops", "airdrops", "airdrops", "airdrops", NA
    ), exchange = c(
      "shakepay", "shakepay", "shakepay", "shakepay",
      "shakepay", "shakepay", "shakepay", "shakepay"
    ), rate.source = c(
      "exchange",
      "exchange", "exchange", "exchange", "exchange", "exchange", "exchange",
      "exchange"
    )), row.names = c(NA, -8L), class = "data.frame")
  )
})

# CDC ####
test_that("CDC", {
  data <- data_CDC
  data
  expect_equal(
    format_CDC(data),
    structure(list(
      date = structure(c(
        1620079550, 1620428810, 1621102030,
        1621807779, 1622329859, 1622661112, 1623366744, 1623438838, 1623874469,
        1624050951, 1624137390, 1624828670, 1625609920, 1626034795, 1626286827,
        1627060879, 1627237322, 1627514584
      ), tzone = "UTC", class = c(
        "POSIXct",
        "POSIXt"
      )), quantity = c(
        0.000733370962484796, 0.0205920059257571,
        182.436009084234, 117.94682303, 6.40395445376923, 53.61366877,
        86.35723665, 17.36889942, 22.5041772605727, 0.000013775, 8.45262096774194,
        0.000763266828087167, 0.320799213147475, 0.35580671798495, 2.47619047619048,
        37.1602562661344, 0.000532054153123365, 0.00996365482758792
      ),
      currency = c(
        "BTC", "ETH", "CRO", "CRO", "CRO", "CRO", "CRO",
        "CRO", "CRO", "ETH", "CRO", "ETH", "CRO", "ETHW", "CRO",
        "CRO", "BTC", "ETH"
      ), total.price = c(
        51.25, 54.21, 53.42,
        30.19035, 1.13, 10.99, 16.94, 9.19, 11.65, 0.05, 1.25, 3.12,
        0.26, 3.2, 1.2, 6.98, 35, 35
      ), spot.rate = c(
        69882.7777777778,
        2632.575, 0.292815, 0.255965775291133, 0.176453472328321,
        0.204985039303066, 0.196161904400168, 0.529106639273751,
        0.517681667057022, 3629.76406533575, 0.147883124627311, 4087.69238382739,
        0.810475803381959, 8.9936469387724, 0.484615384615384, 0.187835087842522,
        65782.777551, 3512.767213
      ), transaction = c(
        "buy", "buy",
        "buy", "revenue", "revenue", "revenue", "revenue", "revenue",
        "revenue", "revenue", "revenue", "revenue", "revenue", "revenue",
        "revenue", "revenue", "sell", "sell"
      ), description = c(
        "crypto_purchase",
        "crypto_purchase", "crypto_purchase", "referral_gift", "referral_card_cashback",
        "reimbursement", "reimbursement", "reimbursement", "reimbursement",
        "supercharger_reward_to_app_credited", "pay_checkout_reward",
        "crypto_earn_interest_paid", "crypto_earn_extra_interest_paid",
        "admin_wallet_credited", "rewards_platform_deposit_credited",
        "mco_stake_reward", "crypto_viban_exchange", "crypto_viban_exchange"
      ), comment = c(
        "Buy BTC", "Buy ETH", "Buy CRO", "Sign-up Bonus Unlocked",
        "Card Cashback", "Card Rebate: Spotify", "Card Rebate: Netflix",
        "Card Rebate: Amazon Prime", "Card Rebate: Expedia", "Supercharger Reward",
        "Pay Rewards", "Crypto Earn", "Crypto Earn (Extra)", "Adjustment (Credit)",
        "Mission Rewards Deposit", "CRO Stake Rewards", "BTC -> CAD",
        "ETH -> CAD"
      ), revenue.type = c(
        NA, NA, NA, "referrals",
        "rebates", "rebates", "rebates", "rebates", "rebates", "supercharger_reward_to_app_credited",
        "rebates", "interests", "interests", "forks", "rewards",
        "interests", NA, NA
      ), exchange = c(
        "CDC", "CDC", "CDC", "CDC",
        "CDC", "CDC", "CDC", "CDC", "CDC", "CDC", "CDC", "CDC", "CDC",
        "CDC", "CDC", "CDC", "CDC", "CDC"
      ), rate.source = c(
        "exchange",
        "exchange", "exchange", "exchange", "exchange", "exchange",
        "exchange", "exchange", "exchange", "exchange", "exchange",
        "exchange", "exchange", "exchange", "exchange", "exchange",
        "exchange", "exchange"
      )
    ), row.names = c(NA, -18L), class = "data.frame")
  )
})

# GENERICS! ####

test_that("generic1", {
  data <- data_generic1
  data
  expect_equal(
    format_generic(data),
    structure(list(date = structure(c(1614699366, 1615398544, 1615831928), class = c("POSIXct", "POSIXt"), tzone = "UTC"), currency = c(
      "BTC",
      "ETH", "ETH"
    ), quantity = c(0.00124, 0.063067, 0.065048), total.price = c(
      50.99,
      50.99, 150.99
    ), spot.rate = c(
      41120.9677419355, 808.50524045856,
      2321.20895338827
    ), transaction = c("buy", "buy", "sell"), fees = c(
      0.72,
      0.72, 1.75
    ), exchange = c(
      "generic_exchange", "generic_exchange",
      "generic_exchange"
    ), rate.source = c(
      "exchange", "exchange",
      "exchange"
    )), class = "data.frame", row.names = c(NA, -3L))
  )
})

test_that("generic2", {
  data <- data_generic2
  data
  expect_equal(
    format_generic(
      data,
      date = "Date.Transaction",
      currency = "Coin",
      quantity = "Amount",
      total.price = "Price",
      transaction = "Type",
      fees = "Fee",
      exchange = "Platform"
    ),
    structure(list(date = structure(c(1614699366, 1615398544, 1615831928), class = c("POSIXct", "POSIXt"), tzone = "UTC"), currency = c(
      "BTC",
      "ETH", "ETH"
    ), quantity = c(0.00124, 0.063067, 0.065048), total.price = c(
      50.99,
      50.99, 150.99
    ), spot.rate = c(
      41120.9677419355, 808.50524045856,
      2321.20895338827
    ), transaction = c("buy", "buy", "sell"), fees = c(
      0.72,
      0.72, 1.75
    ), exchange = c(
      "generic_exchange", "generic_exchange",
      "generic_exchange"
    ), rate.source = c(
      "exchange", "exchange",
      "exchange"
    )), class = "data.frame", row.names = c(NA, -3L))
  )
})

test_that("generic3", {
  data <- data_generic3
  data
  expect_equal(
    format_generic(data),
    structure(list(date = structure(c(1614699366, 1615398544, 1615831928), class = c("POSIXct", "POSIXt"), tzone = "UTC"), currency = c(
      "BTC",
      "ETH", "ETH"
    ), quantity = c(0.00124, 0.063067, 0.065048), total.price = c(
      50.989999948,
      50.9899974484, 150.990003032
    ), spot.rate = c(
      41120.9677, 808.5052,
      2321.209
    ), transaction = c("buy", "buy", "sell"), fees = c(
      0.72,
      0.72, 1.75
    ), exchange = c(
      "generic_exchange", "generic_exchange",
      "generic_exchange"
    )), class = "data.frame", row.names = c(
      NA,
      -3L
    ))
  )
})

test_that("generic4", {
  data <- data_generic4
  data
  expect_equal(
    format_generic(data),
    structure(list(date = structure(c(1614699366, 1615398544, 1615831928), tzone = "UTC", class = c("POSIXct", "POSIXt")), currency = c(
      "BTC",
      "ETH", "ETH"
    ), quantity = c(0.00124, 0.063067, 0.065048), total.price = c(
      76.7859506300744,
      146.119708719111, 147.907447563696
    ), spot.rate = c(
      61924.153733931,
      2316.89645486722, 2273.82006462453
    ), transaction = c(
      "buy", "buy",
      "sell"
    ), fees = c(0.72, 0.72, 1.75), exchange = c(
      "generic_exchange",
      "generic_exchange", "generic_exchange"
    ), rate.source = c(
      "coinmarketcap",
      "coinmarketcap", "coinmarketcap"
    )), row.names = c(NA, -3L), class = "data.frame")
  )
})

