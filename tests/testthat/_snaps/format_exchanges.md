# shakepay

    Code
      format_shakepay(data_shakepay)
    Output
                       date currency    quantity total.price spot.rate transaction
      1 2021-05-07 14:50:41      BTC  0.00103982   53.033350  51002.43         buy
      2 2021-05-07 21:25:36      CAD 30.00000000   30.000000      1.00     revenue
      3 2021-05-08 12:12:57      BTC  0.00011000    5.784024  52582.03     revenue
      4 2021-05-09 12:22:07      BTC  0.00012000    6.034441  50287.01     revenue
      5 2021-05-21 12:47:14      BTC  0.00013000    7.348590  56527.62     revenue
      6 2021-06-11 12:03:31      BTC  0.00014000    8.396927  59978.05     revenue
      7 2021-06-23 12:21:49      BTC  0.00015000    8.714877  58099.18     revenue
      8 2021-07-10 00:52:19      BTC  0.00052991   31.268480  59007.15        sell
          description  comment revenue.type exchange rate.source
      1 purchase/sale purchase         <NA> shakepay    exchange
      2         other   credit    referrals shakepay    exchange
      3   shakingsats   credit     airdrops shakepay    exchange
      4   shakingsats   credit     airdrops shakepay    exchange
      5   shakingsats   credit     airdrops shakepay    exchange
      6   shakingsats   credit     airdrops shakepay    exchange
      7   shakingsats   credit     airdrops shakepay    exchange
      8 purchase/sale     sale         <NA> shakepay    exchange

# CDC

    Code
      format_CDC(data_CDC)
    Message <simpleMessage>
      For full currency exchange rate API documentation visit:
       https://exchangerate.host/#/#docs
       (this message will only appear once per session)
    Output
                        date currency       quantity total.price     spot.rate
      1  2021-05-03 22:05:50      BTC   0.0007333710    51.25000 69882.7777778
      2  2021-05-07 23:06:50      ETH   0.0205920059    54.21000  2632.5750000
      3  2021-05-15 18:07:10      CRO 182.4360090842    53.42000     0.2928150
      4  2021-05-23 22:09:39      CRO 117.9468230300    30.19035     0.2559658
      5  2021-05-29 23:10:59      CRO   6.4039544538     1.13000     0.1764535
      6  2021-06-02 19:11:52      CRO  53.6136687700    10.99000     0.2049850
      7  2021-06-10 23:12:24      CRO  86.3572366500    16.94000     0.1961619
      8  2021-06-11 19:13:58      CRO  17.3688994200     9.19000     0.5291066
      9  2021-06-16 20:14:29      CRO  22.5041772606    11.65000     0.5176817
      10 2021-06-18 21:15:51      ETH   0.0000137750     0.05000  3629.7640653
      11 2021-06-19 21:16:30      CRO   8.4526209677     1.25000     0.1478831
      12 2021-06-27 21:17:50      ETH   0.0007632668     3.12000  4087.6923838
      13 2021-07-06 22:18:40      CRO   0.3207992131     0.26000     0.8104758
      14 2021-07-11 20:19:55     ETHW   0.3558067180     3.20000     8.9936469
      15 2021-07-14 18:20:27      CRO   2.4761904762     1.20000     0.4846154
      16 2021-07-23 17:21:19      CRO  37.1602562661     6.98000     0.1878351
      17 2021-07-25 18:22:02      BTC   0.0005320542    35.00000 65782.7775510
      18 2021-07-28 23:23:04      ETH   0.0099636548    35.00000  3512.7672130
         transaction                         description                   comment
      1          buy                     crypto_purchase                   Buy BTC
      2          buy                     crypto_purchase                   Buy ETH
      3          buy                     crypto_purchase                   Buy CRO
      4      revenue                       referral_gift    Sign-up Bonus Unlocked
      5      revenue              referral_card_cashback             Card Cashback
      6      revenue                       reimbursement      Card Rebate: Spotify
      7      revenue                       reimbursement      Card Rebate: Netflix
      8      revenue                       reimbursement Card Rebate: Amazon Prime
      9      revenue                       reimbursement      Card Rebate: Expedia
      10     revenue supercharger_reward_to_app_credited       Supercharger Reward
      11     revenue                 pay_checkout_reward               Pay Rewards
      12     revenue           crypto_earn_interest_paid               Crypto Earn
      13     revenue     crypto_earn_extra_interest_paid       Crypto Earn (Extra)
      14     revenue               admin_wallet_credited       Adjustment (Credit)
      15     revenue   rewards_platform_deposit_credited   Mission Rewards Deposit
      16     revenue                    mco_stake_reward         CRO Stake Rewards
      17        sell               crypto_viban_exchange                BTC -> CAD
      18        sell               crypto_viban_exchange                ETH -> CAD
                                revenue.type exchange               rate.source
      1                                 <NA>      CDC                  exchange
      2                                 <NA>      CDC                  exchange
      3                                 <NA>      CDC                  exchange
      4                            referrals      CDC exchange (USD conversion)
      5                              rebates      CDC                  exchange
      6                              rebates      CDC                  exchange
      7                              rebates      CDC                  exchange
      8                              rebates      CDC                  exchange
      9                              rebates      CDC                  exchange
      10 supercharger_reward_to_app_credited      CDC                  exchange
      11                             rebates      CDC                  exchange
      12                           interests      CDC                  exchange
      13                           interests      CDC                  exchange
      14                               forks      CDC                  exchange
      15                             rewards      CDC                  exchange
      16                           interests      CDC                  exchange
      17                                <NA>      CDC                  exchange
      18                                <NA>      CDC                  exchange

# adalite

    Code
      format_adalite(data_adalite, force = TRUE)
    Output
      > Scraping historical crypto data
    Message <simpleMessage>
      
    Output
      > Processing historical crypto data
    Message <simpleMessage>
      
    Output
                       date currency  quantity total.price spot.rate transaction
      1 2021-04-17 21:16:00      ADA 0.1691870   0.2961423  1.750385        sell
      2 2021-04-17 21:31:00      ADA 0.1912300   0.3347260  1.750385        sell
      3 2021-04-28 16:56:00      ADA 0.3120400   0.5091943  1.631824     revenue
      4 2021-05-07 16:53:00      ADA 0.3125132   0.6266931  2.005333     revenue
      5 2021-05-12 16:56:00      ADA 0.2212410   0.4441940  2.007738     revenue
      6 2021-05-17 17:16:00      ADA 0.4123210   1.0798503  2.618955     revenue
           description        comment revenue.type exchange   rate.source
      1           Sent Withdrawal Fee         <NA>  adalite coinmarketcap
      2           Sent Withdrawal Fee         <NA>  adalite coinmarketcap
      3 Reward awarded           <NA>      staking  adalite coinmarketcap
      4 Reward awarded           <NA>      staking  adalite coinmarketcap
      5 Reward awarded           <NA>      staking  adalite coinmarketcap
      6 Reward awarded           <NA>      staking  adalite coinmarketcap

# generic1 - capitals

    Code
      format_generic(data_generic1)
    Output
                       date currency quantity total.price  spot.rate transaction fees
      1 2021-03-02 10:36:06      BTC 0.001240       50.99 41120.9677         buy 0.72
      2 2021-03-10 12:49:04      ETH 0.063067       50.99   808.5052         buy 0.72
      3 2021-03-15 14:12:08      ETH 0.065048      150.99  2321.2090        sell 1.75
                exchange rate.source
      1 generic_exchange    exchange
      2 generic_exchange    exchange
      3 generic_exchange    exchange

# generic2 - different names

    Code
      format_generic(data_generic2, date = "Date.Transaction", currency = "Coin",
        quantity = "Amount", total.price = "Price", transaction = "Type", fees = "Fee",
        exchange = "Platform")
    Output
                       date currency quantity total.price  spot.rate transaction fees
      1 2021-03-02 10:36:06      BTC 0.001240       50.99 41120.9677         buy 0.72
      2 2021-03-10 12:49:04      ETH 0.063067       50.99   808.5052         buy 0.72
      3 2021-03-15 14:12:08      ETH 0.065048      150.99  2321.2090        sell 1.75
                exchange rate.source
      1 generic_exchange    exchange
      2 generic_exchange    exchange
      3 generic_exchange    exchange

# generic3 - calculate total.price

    Code
      format_generic(data_generic3)
    Output
                       date currency quantity total.price  spot.rate transaction fees
      1 2021-03-02 10:36:06      BTC 0.001240       50.99 41120.9677         buy 0.72
      2 2021-03-10 12:49:04      ETH 0.063067       50.99   808.5052         buy 0.72
      3 2021-03-15 14:12:08      ETH 0.065048      150.99  2321.2090        sell 1.75
                exchange
      1 generic_exchange
      2 generic_exchange
      3 generic_exchange

# generic4 - fetch spot.rate

    Code
      format_generic(data_generic4, force = TRUE)
    Warning <simpleWarning>
      Could not calculate spot rate. Use `force = TRUE`.
    Output
                       date currency quantity total.price spot.rate transaction fees
      1 2021-03-02 10:36:06      BTC 0.001240          NA        NA         buy 0.72
      2 2021-03-10 12:49:04      ETH 0.063067          NA        NA         buy 0.72
      3 2021-03-15 14:12:08      ETH 0.065048          NA        NA        sell 1.75
                exchange   rate.source
      1 generic_exchange coinmarketcap
      2 generic_exchange coinmarketcap
      3 generic_exchange coinmarketcap

