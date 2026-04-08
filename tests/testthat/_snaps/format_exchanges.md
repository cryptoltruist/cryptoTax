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
      format_generic(data_generic4, list.prices = list.prices)
    Output
                       date currency quantity total.price spot.rate transaction fees
      1 2021-03-02 10:36:06      BTC 0.001240     58.4040   47100.0         buy 0.72
      2 2021-03-10 12:49:04      ETH 0.063067    128.5305    2038.0         buy 0.72
      3 2021-03-15 14:12:08      ETH 0.065048    133.7062    2055.5        sell 1.75
                exchange   rate.source
      1 generic_exchange coinmarketcap
      2 generic_exchange coinmarketcap
      3 generic_exchange coinmarketcap

# shakepay

    Code
      format_shakepay(data_shakepay)
    Output
                       date currency   quantity total.price spot.rate transaction
      1 2021-05-07 14:50:41      BTC 0.00103982  53.0697400  51037.43         buy
      2 2021-05-08 12:12:57      BTC 0.00001100   0.5784024  52582.03     revenue
      3 2021-05-09 12:22:07      BTC 0.00001200   0.6034441  50287.01     revenue
      4 2021-05-21 12:47:14      BTC 0.00001300   0.7348590  56527.62     revenue
      5 2021-06-11 12:03:31      BTC 0.00001400   0.8396927  59978.05     revenue
      6 2021-06-23 12:21:49      BTC 0.00001500   0.8852574  59017.16     revenue
      7 2021-07-10 00:52:19      BTC 0.00052991  31.2684700  59017.19        sell
        description               comment revenue.type exchange rate.source
      1         Buy Bought @ CA$51,002.43         <NA> shakepay    exchange
      2      Reward           ShakingSats     airdrops shakepay    exchange
      3      Reward           ShakingSats     airdrops shakepay    exchange
      4      Reward           ShakingSats     airdrops shakepay    exchange
      5      Reward           ShakingSats     airdrops shakepay    exchange
      6      Reward           ShakingSats     airdrops shakepay    exchange
      7        Sell Bought @ CA$59,007.14         <NA> shakepay    exchange

# newton

    Code
      format_newton(data_newton)
    Output
                       date currency   quantity  total.price  spot.rate transaction
      1 2021-04-04 22:50:12      LTC  0.1048291   23.4912731   224.0911         buy
      2 2021-04-04 22:53:46      CAD 25.0000000   25.0000000     1.0000     revenue
      3 2021-04-04 22:55:55      ETH  2.7198712 3423.8221510  1258.8178         buy
      4 2021-04-21 19:57:26      BTC  0.0034300  153.1241354 44642.6051         buy
      5 2021-05-12 21:37:42      BTC  0.0000040    0.3049013 76225.3175         buy
      6 2021-05-12 21:52:40      BTC  0.0032130  156.1241341 48591.3894        sell
      7 2021-06-16 18:49:11      CAD 25.0000000   25.0000000     1.0000     revenue
             description revenue.type exchange rate.source
      1            TRADE         <NA>   newton    exchange
      2 Referral Program    referrals   newton    exchange
      3            TRADE         <NA>   newton    exchange
      4            TRADE         <NA>   newton    exchange
      5            TRADE         <NA>   newton    exchange
      6            TRADE         <NA>   newton    exchange
      7 Referral Program    referrals   newton    exchange

# pooltool

    Code
      format_pooltool(data_pooltool)
    Output
                        date currency  quantity total.price spot.rate transaction
      1  2021-04-22 22:03:22      ADA 1.0827498    1.974017      1.82     revenue
      2  2021-04-27 22:22:14      ADA 0.8579850    1.565881      1.83     revenue
      3  2021-05-02 22:03:54      ADA 1.0193882    1.979399      1.94     revenue
      4  2021-05-07 22:54:38      ADA 1.0548971    1.790303      1.70     revenue
      5  2021-05-12 22:12:49      ADA 0.9443321    1.514525      1.60     revenue
      6  2021-05-17 22:47:25      ADA 1.0198183    1.426898      1.40     revenue
      7  2021-05-23 03:43:38      ADA 1.1605830    1.806024      1.56     revenue
      8  2021-05-27 22:07:57      ADA 1.0197753    1.589004      1.56     revenue
      9  2021-06-01 22:13:58      ADA 0.8392135    1.538300      1.83     revenue
      10 2021-06-06 22:14:11      ADA 1.1115378    2.072874      1.86     revenue
         description     comment revenue.type exchange rate.source
      1  epoch = 228 pool = REKT      staking   exodus    pooltool
      2  epoch = 229 pool = REKT      staking   exodus    pooltool
      3  epoch = 230 pool = REKT      staking   exodus    pooltool
      4  epoch = 231 pool = REKT      staking   exodus    pooltool
      5  epoch = 232 pool = REKT      staking   exodus    pooltool
      6  epoch = 233 pool = REKT      staking   exodus    pooltool
      7  epoch = 234 pool = REKT      staking   exodus    pooltool
      8  epoch = 235 pool = REKT      staking   exodus    pooltool
      9  epoch = 236 pool = REKT      staking   exodus    pooltool
      10 epoch = 237 pool = REKT      staking   exodus    pooltool

# CDC

    Code
      suppressMessages(format_CDC(data_CDC))
    Output
      NULL

# celsius

    Code
      format_celsius(data_celsius)
    Message
      Object 'USD2CAD.table' already exists. Reusing 'USD2CAD.table'. To force a fresh download, use argument 'force = TRUE'.
      Could not fetch exchange rates from the exchange rate API.
    Output
      NULL

# adalite

    Code
      format_adalite(data_adalite, list.prices = list.prices)
    Output
                       date currency  quantity total.price spot.rate transaction
      1 2021-04-28 16:56:00      ADA 0.3120400   0.4474654     1.434     revenue
      2 2021-05-07 16:53:00      ADA 0.3125132   0.4537692     1.452     revenue
      3 2021-05-12 16:56:00      ADA 0.2212410   0.3234543     1.462     revenue
      4 2021-05-17 17:16:00      ADA 0.4123210   0.6069365     1.472     revenue
      5 2021-05-17 21:16:00      ADA 0.1691870   0.2490433     1.472        sell
      6 2021-05-17 21:31:00      ADA 0.1912300   0.2814906     1.472        sell
           description        comment revenue.type exchange   rate.source
      1 Reward awarded           <NA>      staking  adalite coinmarketcap
      2 Reward awarded           <NA>      staking  adalite coinmarketcap
      3 Reward awarded           <NA>      staking  adalite coinmarketcap
      4 Reward awarded           <NA>      staking  adalite coinmarketcap
      5           Sent Withdrawal Fee         <NA>  adalite coinmarketcap
      6           Sent Withdrawal Fee         <NA>  adalite coinmarketcap

# binance

    Code
      format_binance(data_binance, list.prices = list.prices)
    Output
                        date currency   quantity   total.price  spot.rate transaction
      1  2021-05-29 17:07:20      LTC 2.53200000  436.01040000  172.20000         buy
      2  2021-05-29 17:07:20      ETH 0.19521000  436.01040000 2233.54541        sell
      3  2021-05-29 17:07:20      LTC 2.41210000  415.36362000  172.20000         buy
      4  2021-05-29 17:07:20      ETH 0.14123140  415.36362000 2941.01468        sell
      5  2021-05-29 17:07:20      LTC 1.45120000  249.89664000  172.20000         buy
      6  2021-05-29 17:07:20      ETH 0.11240000  249.89664000 2223.27972        sell
      7  2021-05-29 17:07:20      LTC 1.42100000  244.69620000  172.20000         buy
      8  2021-05-29 17:07:20      ETH 0.10512900  244.69620000 2327.58040        sell
      9  2021-05-29 17:07:20      LTC 0.30000000   51.66000000  172.20000         buy
      10 2021-05-29 17:07:20      ETH 0.00899120   51.66000000 5745.61794        sell
      11 2021-05-29 17:07:20      LTC 0.27000000   46.49400000  172.20000         buy
      12 2021-05-29 17:07:20      ETH 0.00612410   46.49400000 7591.97270        sell
      13 2021-05-29 17:07:20      LTC 0.00202500    0.34870500  172.20000     revenue
      14 2021-05-29 17:07:20      LTC 0.00127520    0.21958944  172.20000     revenue
      15 2021-05-29 17:07:20      LTC 0.00113100    0.19475820  172.20000     revenue
      16 2021-05-29 17:07:20      LTC 0.00049230    0.08477406  172.20000     revenue
      17 2021-05-29 17:07:20      LTC 0.00007000    0.01205400  172.20000     revenue
      18 2021-05-29 17:07:20      LTC 0.00005000    0.00861000  172.20000     revenue
      19 2021-05-29 18:12:55      ETH 0.44124211 1022.79921098 2318.00000         buy
      20 2021-05-29 18:12:55      LTC 1.60000000 1022.79921098  639.24951        sell
      21 2021-05-29 18:12:55      ETH 0.42124000  976.43432000 2318.00000         buy
      22 2021-05-29 18:12:55      LTC 1.23000000  976.43432000  793.84904        sell
      23 2021-05-29 18:12:55      ETH 0.00021470    0.49767460 2318.00000     revenue
      24 2021-05-29 18:12:55      ETH 0.00009251    0.21443818 2318.00000     revenue
      25 2021-11-05 04:32:23     BUSD 0.10512330    0.13302302    1.26540     revenue
      26 2022-11-17 11:54:25     ETHW 0.00012050    0.00309685   25.70000     revenue
      27 2022-11-27 08:05:35     BUSD 5.77124200    7.41460316    1.28475         buy
      28 2022-11-27 08:05:35     USDC 5.77124200    7.41460316    1.28475        sell
              fees fees.quantity fees.currency                   description comment
      1  1.2778962   0.007421000           LTC                           Buy    Spot
      2         NA            NA          <NA>                           Buy    Spot
      3  1.0008264   0.005812000           LTC                           Buy    Spot
      4         NA            NA          <NA>                           Buy    Spot
      5  0.9334962   0.005421000           LTC                           Buy    Spot
      6         NA            NA          <NA>                           Buy    Spot
      7  0.5377806   0.003123000           LTC                           Buy    Spot
      8         NA            NA          <NA>                           Buy    Spot
      9  0.0516600   0.000300000           LTC                           Buy    Spot
      10        NA            NA          <NA>                           Buy    Spot
      11 0.0361620   0.000210000           LTC                           Buy    Spot
      12        NA            NA          <NA>                           Buy    Spot
      13        NA            NA          <NA>             Referral Kickback    Spot
      14        NA            NA          <NA>             Referral Kickback    Spot
      15        NA            NA          <NA>             Referral Kickback    Spot
      16        NA            NA          <NA>             Referral Kickback    Spot
      17        NA            NA          <NA>             Referral Kickback    Spot
      18        NA            NA          <NA>             Referral Kickback    Spot
      19 4.9214014   0.002123124           ETH                          Sell    Spot
      20        NA            NA          <NA>                          Sell    Spot
      21 1.4195432   0.000612400           ETH                          Sell    Spot
      22        NA            NA          <NA>                          Sell    Spot
      23        NA            NA          <NA>             Referral Kickback    Spot
      24        NA            NA          <NA>             Referral Kickback    Spot
      25        NA            NA          <NA> Simple Earn Flexible Interest    Earn
      26        NA            NA          <NA>                  Distribution    Spot
      27        NA            NA          <NA>   Stablecoins Auto-Conversion    Spot
      28        NA            NA          <NA>   Stablecoins Auto-Conversion    Spot
         revenue.type exchange               rate.source
      1          <NA>  binance             coinmarketcap
      2          <NA>  binance coinmarketcap (buy price)
      3          <NA>  binance             coinmarketcap
      4          <NA>  binance coinmarketcap (buy price)
      5          <NA>  binance             coinmarketcap
      6          <NA>  binance coinmarketcap (buy price)
      7          <NA>  binance             coinmarketcap
      8          <NA>  binance coinmarketcap (buy price)
      9          <NA>  binance             coinmarketcap
      10         <NA>  binance coinmarketcap (buy price)
      11         <NA>  binance             coinmarketcap
      12         <NA>  binance coinmarketcap (buy price)
      13      rebates  binance             coinmarketcap
      14      rebates  binance             coinmarketcap
      15      rebates  binance             coinmarketcap
      16      rebates  binance             coinmarketcap
      17      rebates  binance             coinmarketcap
      18      rebates  binance             coinmarketcap
      19         <NA>  binance             coinmarketcap
      20         <NA>  binance coinmarketcap (buy price)
      21         <NA>  binance             coinmarketcap
      22         <NA>  binance coinmarketcap (buy price)
      23      rebates  binance             coinmarketcap
      24      rebates  binance             coinmarketcap
      25    interests  binance             coinmarketcap
      26        forks  binance             coinmarketcap
      27         <NA>  binance             coinmarketcap
      28         <NA>  binance             coinmarketcap

# binance withdrawals

    Code
      format_binance_withdrawals(data_binance_withdrawals, list.prices = list.prices)
    Output
                       date currency quantity total.price spot.rate transaction
      1 2021-04-28 17:13:50      LTC 0.001000   0.1675500    167.55        sell
      2 2021-04-28 18:15:14      ETH 0.000071   0.1568745   2209.50        sell
      3 2021-05-06 19:55:52      ETH 0.000062   0.1387250   2237.50        sell
            description exchange   rate.source
      1 Withdrawal fees  binance coinmarketcap
      2 Withdrawal fees  binance coinmarketcap
      3 Withdrawal fees  binance coinmarketcap

# blockfi

    Code
      format_blockfi(data_blockfi, list.prices = list.prices)
    Output
                        date currency     quantity total.price   spot.rate
      1  2021-05-29 21:43:44      LTC  0.022451200  3.86609664   172.20000
      2  2021-05-29 21:43:44      BTC  0.000018512  0.92893216 50180.00000
      3  2021-06-13 21:43:44      BTC  0.000184120  9.33580460 50705.00000
      4  2021-06-30 21:43:44      BTC  0.000047234  2.42310420 51300.00000
      5  2021-06-30 21:43:44      LTC  0.010125120  1.79214624   177.00000
      6  2021-07-29 21:43:44     USDC  0.038241000  0.04820087     1.26045
      7  2021-08-05 18:34:06      BTC  0.000250000 13.14000000 52560.00000
      8  2021-08-07 21:43:44      BTC  0.000441230 23.22193490 52630.00000
      9  2021-10-24 04:29:23     USDC 55.000000000 69.56400000     1.26480
      10 2021-10-24 04:29:23      LTC  0.165122140 69.56400000   421.28814
         transaction      description revenue.type exchange               rate.source
      1      revenue Interest Payment    interests  blockfi             coinmarketcap
      2      revenue Interest Payment    interests  blockfi             coinmarketcap
      3      revenue   Referral Bonus    referrals  blockfi             coinmarketcap
      4      revenue Interest Payment    interests  blockfi             coinmarketcap
      5      revenue Interest Payment    interests  blockfi             coinmarketcap
      6      revenue Interest Payment    interests  blockfi             coinmarketcap
      7         sell   Withdrawal Fee         <NA>  blockfi             coinmarketcap
      8      revenue    Bonus Payment       promos  blockfi             coinmarketcap
      9          buy            Trade         <NA>  blockfi             coinmarketcap
      10        sell            Trade         <NA>  blockfi coinmarketcap (buy price)

# CDC exchange rewards

    Code
      format_CDC_exchange_rewards(data_CDC_exchange_rewards, list.prices = list.prices)
    Output
                        date currency   quantity total.price  spot.rate transaction
      1  2021-02-19 00:00:00      CRO 1.36512341 0.238214035     0.1745     revenue
      2  2021-02-21 00:00:00      CRO 1.36945123 0.240338691     0.1755     revenue
      3  2021-04-15 16:04:21      BTC 0.00000023 0.011187200 48640.0000     revenue
      4  2021-04-18 00:00:00      CRO 1.36512310 0.277802551     0.2035     revenue
      5  2021-05-14 06:02:22      BTC 0.00000035 0.017379250 49655.0000     revenue
      6  2021-06-12 15:21:34      BTC 0.00000630 0.319221000 50670.0000     revenue
      7  2021-06-27 01:34:00      CRO 0.00100000 0.000238500     0.2385        sell
      8  2021-07-07 00:00:00      CRO 0.01512903 0.003683919     0.2435     revenue
      9  2021-07-13 00:00:00      CRO 0.05351230 0.013190782     0.2465     revenue
      10 2021-09-07 00:00:00      CRO 0.01521310 0.004175996     0.2745     revenue
         description                                          comment revenue.type
      1       Reward Interest on 5000.00000000 at 10% APR (Completed)    interests
      2       Reward Interest on 5000.00000000 at 10% APR (Completed)    interests
      3       Reward                          BTC Supercharger reward    interests
      4       Reward Interest on 5000.00000000 at 10% APR (Completed)    interests
      5       Reward                          BTC Supercharger reward    interests
      6       Reward                          BTC Supercharger reward    interests
      7   Withdrawal                                             <NA>         <NA>
      8       Reward                  Rebate on 0.18512341 CRO at 10%      rebates
      9       Reward                Rebate on 0.5231512346 CRO at 10%      rebates
      10      Reward                 Rebate on 0.155125123 CRO at 10%      rebates
             exchange   rate.source
      1  CDC.exchange coinmarketcap
      2  CDC.exchange coinmarketcap
      3  CDC.exchange coinmarketcap
      4  CDC.exchange coinmarketcap
      5  CDC.exchange coinmarketcap
      6  CDC.exchange coinmarketcap
      7  CDC.exchange coinmarketcap
      8  CDC.exchange coinmarketcap
      9  CDC.exchange coinmarketcap
      10 CDC.exchange coinmarketcap

# CDC exchange trades

    Code
      format_CDC_exchange_trades(data_CDC_exchange_trades, list.prices = list.prices)
    Output
                        date currency   quantity total.price spot.rate transaction
      1  2021-12-24 15:34:45      CRO 13260.1300 4355.952705    0.3285         buy
      2  2021-12-24 15:34:45      ETH     2.0932 4355.952705 2081.0017        sell
      3  2021-12-24 15:34:45      CRO  3555.9000 1168.113150    0.3285         buy
      4  2021-12-24 15:34:45      ETH     0.5600 1168.113150 2085.9163        sell
      5  2021-12-24 15:34:45      CRO  1781.7400  585.301590    0.3285         buy
      6  2021-12-24 15:34:45      ETH     0.2800  585.301590 2090.3628        sell
      7  2021-12-24 15:34:45      CRO    26.8500    8.820225    0.3285         buy
      8  2021-12-24 15:34:45      ETH     0.0042    8.820225 2100.0536        sell
      9  2021-12-24 15:34:45      CRO    26.6700    8.761095    0.3285         buy
      10 2021-12-24 15:34:45      ETH     0.0042    8.761095 2085.9750        sell
      11 2021-12-24 15:34:45      CRO    17.7800    5.840730    0.3285         buy
      12 2021-12-24 15:34:45      CRO    17.7800    5.840730    0.3285         buy
      13 2021-12-24 15:34:45      ETH     0.0028    5.840730 2085.9750        sell
      14 2021-12-24 15:34:45      ETH     0.0028    5.840730 2085.9750        sell
                fees fees.quantity fees.currency description comment     exchange
      1  17.42381234   53.04052463           CRO         BUY ETH_CRO CDC.exchange
      2           NA            NA          <NA>        SELL ETH_CRO CDC.exchange
      3   4.67245155   14.22359680           CRO         BUY ETH_CRO CDC.exchange
      4           NA            NA          <NA>        SELL ETH_CRO CDC.exchange
      5   2.34121109    7.12697440           CRO         BUY ETH_CRO CDC.exchange
      6           NA            NA          <NA>        SELL ETH_CRO CDC.exchange
      7   0.03528545    0.10741385           CRO         BUY ETH_CRO CDC.exchange
      8           NA            NA          <NA>        SELL ETH_CRO CDC.exchange
      9   0.03504294    0.10667563           CRO         BUY ETH_CRO CDC.exchange
      10          NA            NA          <NA>        SELL ETH_CRO CDC.exchange
      11  0.02336233    0.07111821           CRO         BUY ETH_CRO CDC.exchange
      12  0.02336230    0.07111810           CRO         BUY ETH_CRO CDC.exchange
      13          NA            NA          <NA>        SELL ETH_CRO CDC.exchange
      14          NA            NA          <NA>        SELL ETH_CRO CDC.exchange
                       rate.source
      1              coinmarketcap
      2  coinmarketcap (buy price)
      3              coinmarketcap
      4  coinmarketcap (buy price)
      5              coinmarketcap
      6  coinmarketcap (buy price)
      7              coinmarketcap
      8  coinmarketcap (buy price)
      9              coinmarketcap
      10 coinmarketcap (buy price)
      11             coinmarketcap
      12             coinmarketcap
      13 coinmarketcap (buy price)
      14 coinmarketcap (buy price)

# CDC wallet

    Code
      format_CDC_wallet(data_CDC_wallet, list.prices = list.prices)
    Output
                       date currency quantity total.price spot.rate transaction
      1 2021-04-12 18:28:50      CRO 0.512510   0.1027583    0.2005     revenue
      2 2021-04-18 18:28:50      CRO 0.000200   0.0000407    0.2035        sell
      3 2021-04-23 18:51:53      CRO 1.656708   0.3412818    0.2060     revenue
      4 2021-04-25 18:51:53      CRO 0.000200   0.0000414    0.2070        sell
      5 2021-05-21 01:19:01      CRO 0.000200   0.0000440    0.2200        sell
      6 2021-06-25 04:11:53      CRO 0.000200   0.0000475    0.2375        sell
      7 2021-06-26 14:51:02      CRO 6.051235   1.4401939    0.2380     revenue
         description
      1       Reward
      2 staking cost
      3       Reward
      4 staking cost
      5   Withdrawal
      6 staking cost
      7       Reward
                                                                                                          comment
      1                                                                                Auto Withdraw Reward from 
      2                                                            Stake on Validator(abcdefghijklmnopqrstuvwxyz)
      3                                                                                Auto Withdraw Reward from 
      4                                                        Unstake from Validator(abcdefghijklmnopqrstuvwxyz)
      5                                                        Outgoing Transaction to abcdefghijklmnopqrstuvwxyz
      6 Move 530.41289045 CRO from Validator(abcdefghijklmnopqrstuvwxyz) to Validator(abcdefghijklmnopqrstuvwxyz)
      7                                                           Withdraw Reward from abcdefghijklmnopqrstuvwxyz
        revenue.type   exchange   rate.source
      1      staking CDC.wallet coinmarketcap
      2         <NA> CDC.wallet coinmarketcap
      3      staking CDC.wallet coinmarketcap
      4         <NA> CDC.wallet coinmarketcap
      5         <NA> CDC.wallet coinmarketcap
      6         <NA> CDC.wallet coinmarketcap
      7      staking CDC.wallet coinmarketcap

# coinsmart

    Code
      format_coinsmart(data_coinsmart, list.prices = list.prices)
    Output
                       date currency  quantity total.price    spot.rate transaction
      1 2021-04-25 16:11:24      ADA 198.50000    237.9374     1.198677         buy
      2 2021-04-28 18:37:15      CAD  15.00000     15.0000     1.000000     revenue
      3 2021-05-15 16:42:07      BTC   0.00004      1.9876 49690.000000     revenue
      4 2021-06-03 02:04:49      ADA   0.30000      0.4518     1.506000        sell
            fees fees.quantity fees.currency description  comment revenue.type
      1 0.281316         0.197           ADA    purchase    Trade         <NA>
      2       NA            NA          <NA>       Other Referral    referrals
      3       NA            NA          <NA>       Other     Quiz     airdrops
      4       NA            NA          <NA>         Fee Withdraw         <NA>
         exchange   rate.source
      1 coinsmart      exchange
      2 coinsmart      exchange
      3 coinsmart coinmarketcap
      4 coinsmart coinmarketcap

# exodus

    Code
      format_exodus(data_exodus, list.prices = list.prices)
    Output
                       date currency  quantity total.price spot.rate transaction
      1 2021-05-25 22:06:11      LTC 0.0014430   0.2476188   171.600        sell
      2 2021-05-25 23:08:12      ADA 0.1782410   0.2652226     1.488        sell
      3 2021-06-12 12:15:28      BTC 0.0000503   2.5487010 50670.000        sell
      4 2021-06-12 22:31:35      ETH 0.0014500   3.4321500  2367.000        sell
        description revenue.type exchange   rate.source
      1  withdrawal         <NA>   exodus coinmarketcap
      2  withdrawal         <NA>   exodus coinmarketcap
      3  withdrawal         <NA>   exodus coinmarketcap
      4  withdrawal         <NA>   exodus coinmarketcap

# presearch

    Code
      format_presearch(data_presearch, list.prices = list.prices)
    Output
                       date currency quantity total.price spot.rate transaction
      1 2021-01-02 19:08:59      PRE     1000      50.100    0.0501     revenue
      2 2021-04-27 19:12:15      PRE     1000      61.600    0.0616     revenue
      3 2021-05-07 05:55:33      PRE     1000      62.600    0.0626         buy
      4 2021-12-09 06:24:22      PRE       10       0.842    0.0842     revenue
                                            description revenue.type  exchange
      1                        Transferred from Rewards     airdrops presearch
      2                        Transferred from Rewards     airdrops presearch
      3 Transferred from Presearch Portal (PO#: 412893)         <NA> presearch
      4        Presearch 2021 Airdrop (Increased Stake)     airdrops presearch
          rate.source
      1 coinmarketcap
      2 coinmarketcap
      3 coinmarketcap
      4 coinmarketcap

# gemini

    Code
      format_gemini(data_gemini, list.prices = list.prices)
    Output
                        date currency        quantity total.price  spot.rate
      1  2021-04-09 22:50:55      BTC  0.000966278356  46.7968608 48430.0000
      2  2021-04-09 22:50:55      LTC  0.246690598398  46.7968608   189.6986
      3  2021-04-09 22:53:57      BTC  0.000006051912   0.2930941 48430.0000
      4  2021-04-09 22:53:57      LTC  0.001640820000   0.2930941   178.6266
      5  2021-04-09 23:20:53      BAT 48.719519585106  48.6220805     0.9980
      6  2021-04-09 23:20:53      BTC  0.000950730015  48.6220805 51141.8381
      7  2021-04-10 23:22:04      BTC  0.000285025578  13.8137646 48465.0000
      8  2021-05-08 16:14:54      BAT  2.833934780210   2.9104510     1.0270
      9  2021-05-16 12:55:02      BAT  3.085288331282   3.1932734     1.0350
      10 2021-05-16 13:35:19      BAT  5.007481461482   5.1827433     1.0350
      11 2021-06-18 01:38:54      BAT  6.834322542857   7.2990565     1.0680
         transaction        fees   fees.quantity fees.currency description
      1          buy 0.111554081 0.0000023034086           BTC      LTCBTC
      2         sell          NA              NA           LTC      LTCBTC
      3          buy 0.001768572 0.0000000365181           BTC      LTCBTC
      4         sell          NA              NA           LTC      LTCBTC
      5          buy          NA              NA           BAT      BATBTC
      6         sell 0.087863695 0.0000018142411           BTC      BATBTC
      7      revenue          NA              NA          <NA>      Credit
      8      revenue          NA              NA          <NA>      Credit
      9      revenue          NA              NA          <NA>      Credit
      10     revenue          NA              NA          <NA>      Credit
      11     revenue          NA              NA          <NA>      Credit
                       comment revenue.type exchange               rate.source
      1                 Market         <NA>   gemini             coinmarketcap
      2                 Market         <NA>   gemini coinmarketcap (buy price)
      3                  Limit         <NA>   gemini             coinmarketcap
      4                  Limit         <NA>   gemini coinmarketcap (buy price)
      5                  Limit         <NA>   gemini             coinmarketcap
      6                  Limit         <NA>   gemini coinmarketcap (buy price)
      7  Administrative Credit    referrals   gemini             coinmarketcap
      8  Administrative Credit    referrals   gemini             coinmarketcap
      9                Deposit     airdrops   gemini             coinmarketcap
      10               Deposit     airdrops   gemini             coinmarketcap
      11               Deposit     airdrops   gemini             coinmarketcap

# uphold

    Code
      format_uphold(data_uphold, list.prices = list.prices)
    Output
                        date currency    quantity total.price   spot.rate transaction
      1  2021-01-07 02:40:31      BAT  1.59081275   1.4412764   0.9060000     revenue
      2  2021-02-09 14:26:49      BAT 12.69812163  11.9235362   0.9390000     revenue
      3  2021-03-06 21:32:36      BAT  0.37591275   0.3623799   0.9640000     revenue
      4  2021-03-07 21:46:57      LTC  0.24129740  38.5472597 159.7500000         buy
      5  2021-03-07 21:46:57      BAT 52.59871206  38.5472597   0.7328556        sell
      6  2021-03-07 21:54:09      LTC  0.00300000   0.4792500 159.7500000        sell
      7  2021-04-05 12:22:00      BAT  8.52198415   8.4708522   0.9940000     revenue
      8  2021-04-06 03:41:42      LTC  0.00300000   0.4927500 164.2500000        sell
      9  2021-04-06 04:47:00      LTC  0.03605981   5.9228241 164.2500000         buy
      10 2021-04-06 04:47:00      BAT  8.52198415   5.9228241   0.6950053        sell
      11 2021-05-11 07:12:24      BAT  0.47521985   0.4894764   1.0300000     revenue
      12 2021-06-09 04:52:23      BAT  0.67207415   0.7117265   1.0590000     revenue
         description         comment revenue.type exchange               rate.source
      1           in            <NA>     airdrops   uphold             coinmarketcap
      2           in            <NA>     airdrops   uphold             coinmarketcap
      3           in            <NA>     airdrops   uphold             coinmarketcap
      4        trade         BAT-LTC         <NA>   uphold             coinmarketcap
      5        trade         BAT-LTC         <NA>   uphold coinmarketcap (buy price)
      6          out withdrawal fees         <NA>   uphold             coinmarketcap
      7           in            <NA>     airdrops   uphold             coinmarketcap
      8          out withdrawal fees         <NA>   uphold             coinmarketcap
      9        trade         BAT-LTC         <NA>   uphold             coinmarketcap
      10       trade         BAT-LTC         <NA>   uphold coinmarketcap (buy price)
      11          in            <NA>     airdrops   uphold             coinmarketcap
      12          in            <NA>     airdrops   uphold             coinmarketcap

# format_detect single

    Code
      format_detect(data_shakepay)
    Message
      Exchange detected: shakepay
    Output
                       date currency   quantity total.price spot.rate transaction
      1 2021-05-07 14:50:41      BTC 0.00103982  53.0697400  51037.43         buy
      2 2021-05-08 12:12:57      BTC 0.00001100   0.5784024  52582.03     revenue
      3 2021-05-09 12:22:07      BTC 0.00001200   0.6034441  50287.01     revenue
      4 2021-05-21 12:47:14      BTC 0.00001300   0.7348590  56527.62     revenue
      5 2021-06-11 12:03:31      BTC 0.00001400   0.8396927  59978.05     revenue
      6 2021-06-23 12:21:49      BTC 0.00001500   0.8852574  59017.16     revenue
      7 2021-07-10 00:52:19      BTC 0.00052991  31.2684700  59017.19        sell
        description               comment revenue.type exchange rate.source
      1         Buy Bought @ CA$51,002.43         <NA> shakepay    exchange
      2      Reward           ShakingSats     airdrops shakepay    exchange
      3      Reward           ShakingSats     airdrops shakepay    exchange
      4      Reward           ShakingSats     airdrops shakepay    exchange
      5      Reward           ShakingSats     airdrops shakepay    exchange
      6      Reward           ShakingSats     airdrops shakepay    exchange
      7        Sell Bought @ CA$59,007.14         <NA> shakepay    exchange

---

    Code
      format_detect(data_newton)
    Message
      Exchange detected: newton
    Output
                       date currency   quantity  total.price  spot.rate transaction
      1 2021-04-04 22:50:12      LTC  0.1048291   23.4912731   224.0911         buy
      2 2021-04-04 22:53:46      CAD 25.0000000   25.0000000     1.0000     revenue
      3 2021-04-04 22:55:55      ETH  2.7198712 3423.8221510  1258.8178         buy
      4 2021-04-21 19:57:26      BTC  0.0034300  153.1241354 44642.6051         buy
      5 2021-05-12 21:37:42      BTC  0.0000040    0.3049013 76225.3175         buy
      6 2021-05-12 21:52:40      BTC  0.0032130  156.1241341 48591.3894        sell
      7 2021-06-16 18:49:11      CAD 25.0000000   25.0000000     1.0000     revenue
             description revenue.type exchange rate.source
      1            TRADE         <NA>   newton    exchange
      2 Referral Program    referrals   newton    exchange
      3            TRADE         <NA>   newton    exchange
      4            TRADE         <NA>   newton    exchange
      5            TRADE         <NA>   newton    exchange
      6            TRADE         <NA>   newton    exchange
      7 Referral Program    referrals   newton    exchange

---

    Code
      format_detect(data_pooltool)
    Message
      Exchange detected: pooltool
    Output
                        date currency  quantity total.price spot.rate transaction
      1  2021-04-22 22:03:22      ADA 1.0827498    1.974017      1.82     revenue
      2  2021-04-27 22:22:14      ADA 0.8579850    1.565881      1.83     revenue
      3  2021-05-02 22:03:54      ADA 1.0193882    1.979399      1.94     revenue
      4  2021-05-07 22:54:38      ADA 1.0548971    1.790303      1.70     revenue
      5  2021-05-12 22:12:49      ADA 0.9443321    1.514525      1.60     revenue
      6  2021-05-17 22:47:25      ADA 1.0198183    1.426898      1.40     revenue
      7  2021-05-23 03:43:38      ADA 1.1605830    1.806024      1.56     revenue
      8  2021-05-27 22:07:57      ADA 1.0197753    1.589004      1.56     revenue
      9  2021-06-01 22:13:58      ADA 0.8392135    1.538300      1.83     revenue
      10 2021-06-06 22:14:11      ADA 1.1115378    2.072874      1.86     revenue
         description     comment revenue.type exchange rate.source
      1  epoch = 228 pool = REKT      staking   exodus    pooltool
      2  epoch = 229 pool = REKT      staking   exodus    pooltool
      3  epoch = 230 pool = REKT      staking   exodus    pooltool
      4  epoch = 231 pool = REKT      staking   exodus    pooltool
      5  epoch = 232 pool = REKT      staking   exodus    pooltool
      6  epoch = 233 pool = REKT      staking   exodus    pooltool
      7  epoch = 234 pool = REKT      staking   exodus    pooltool
      8  epoch = 235 pool = REKT      staking   exodus    pooltool
      9  epoch = 236 pool = REKT      staking   exodus    pooltool
      10 epoch = 237 pool = REKT      staking   exodus    pooltool

---

    Code
      format_detect(data_CDC)
    Message
      Object 'USD2CAD.table' already exists. Reusing 'USD2CAD.table'. To force a fresh download, use argument 'force = TRUE'.
      Could not fetch exchange rates from coinmarketcap.
      Exchange detected: CDC
    Output
      NULL

---

    Code
      format_detect(data_celsius)
    Message
      Object 'USD2CAD.table' already exists. Reusing 'USD2CAD.table'. To force a fresh download, use argument 'force = TRUE'.
      Could not fetch exchange rates from the exchange rate API.
      Exchange detected: celsius
    Output
      NULL

---

    Code
      format_detect(data_adalite, list.prices = list.prices)
    Message
      Exchange detected: adalite
    Output
                       date currency  quantity total.price spot.rate transaction
      1 2021-04-28 16:56:00      ADA 0.3120400   0.4474654     1.434     revenue
      2 2021-05-07 16:53:00      ADA 0.3125132   0.4537692     1.452     revenue
      3 2021-05-12 16:56:00      ADA 0.2212410   0.3234543     1.462     revenue
      4 2021-05-17 17:16:00      ADA 0.4123210   0.6069365     1.472     revenue
      5 2021-05-17 21:16:00      ADA 0.1691870   0.2490433     1.472        sell
      6 2021-05-17 21:31:00      ADA 0.1912300   0.2814906     1.472        sell
           description        comment revenue.type exchange   rate.source
      1 Reward awarded           <NA>      staking  adalite coinmarketcap
      2 Reward awarded           <NA>      staking  adalite coinmarketcap
      3 Reward awarded           <NA>      staking  adalite coinmarketcap
      4 Reward awarded           <NA>      staking  adalite coinmarketcap
      5           Sent Withdrawal Fee         <NA>  adalite coinmarketcap
      6           Sent Withdrawal Fee         <NA>  adalite coinmarketcap

---

    Code
      format_detect(data_binance, list.prices = list.prices)
    Message
      Exchange detected: binance
    Output
                        date currency   quantity   total.price  spot.rate transaction
      1  2021-05-29 17:07:20      LTC 2.53200000  436.01040000  172.20000         buy
      2  2021-05-29 17:07:20      ETH 0.19521000  436.01040000 2233.54541        sell
      3  2021-05-29 17:07:20      LTC 2.41210000  415.36362000  172.20000         buy
      4  2021-05-29 17:07:20      ETH 0.14123140  415.36362000 2941.01468        sell
      5  2021-05-29 17:07:20      LTC 1.45120000  249.89664000  172.20000         buy
      6  2021-05-29 17:07:20      ETH 0.11240000  249.89664000 2223.27972        sell
      7  2021-05-29 17:07:20      LTC 1.42100000  244.69620000  172.20000         buy
      8  2021-05-29 17:07:20      ETH 0.10512900  244.69620000 2327.58040        sell
      9  2021-05-29 17:07:20      LTC 0.30000000   51.66000000  172.20000         buy
      10 2021-05-29 17:07:20      ETH 0.00899120   51.66000000 5745.61794        sell
      11 2021-05-29 17:07:20      LTC 0.27000000   46.49400000  172.20000         buy
      12 2021-05-29 17:07:20      ETH 0.00612410   46.49400000 7591.97270        sell
      13 2021-05-29 17:07:20      LTC 0.00202500    0.34870500  172.20000     revenue
      14 2021-05-29 17:07:20      LTC 0.00127520    0.21958944  172.20000     revenue
      15 2021-05-29 17:07:20      LTC 0.00113100    0.19475820  172.20000     revenue
      16 2021-05-29 17:07:20      LTC 0.00049230    0.08477406  172.20000     revenue
      17 2021-05-29 17:07:20      LTC 0.00007000    0.01205400  172.20000     revenue
      18 2021-05-29 17:07:20      LTC 0.00005000    0.00861000  172.20000     revenue
      19 2021-05-29 18:12:55      ETH 0.44124211 1022.79921098 2318.00000         buy
      20 2021-05-29 18:12:55      LTC 1.60000000 1022.79921098  639.24951        sell
      21 2021-05-29 18:12:55      ETH 0.42124000  976.43432000 2318.00000         buy
      22 2021-05-29 18:12:55      LTC 1.23000000  976.43432000  793.84904        sell
      23 2021-05-29 18:12:55      ETH 0.00021470    0.49767460 2318.00000     revenue
      24 2021-05-29 18:12:55      ETH 0.00009251    0.21443818 2318.00000     revenue
      25 2021-11-05 04:32:23     BUSD 0.10512330    0.13302302    1.26540     revenue
      26 2022-11-17 11:54:25     ETHW 0.00012050    0.00309685   25.70000     revenue
      27 2022-11-27 08:05:35     BUSD 5.77124200    7.41460316    1.28475         buy
      28 2022-11-27 08:05:35     USDC 5.77124200    7.41460316    1.28475        sell
              fees fees.quantity fees.currency                   description comment
      1  1.2778962   0.007421000           LTC                           Buy    Spot
      2         NA            NA          <NA>                           Buy    Spot
      3  1.0008264   0.005812000           LTC                           Buy    Spot
      4         NA            NA          <NA>                           Buy    Spot
      5  0.9334962   0.005421000           LTC                           Buy    Spot
      6         NA            NA          <NA>                           Buy    Spot
      7  0.5377806   0.003123000           LTC                           Buy    Spot
      8         NA            NA          <NA>                           Buy    Spot
      9  0.0516600   0.000300000           LTC                           Buy    Spot
      10        NA            NA          <NA>                           Buy    Spot
      11 0.0361620   0.000210000           LTC                           Buy    Spot
      12        NA            NA          <NA>                           Buy    Spot
      13        NA            NA          <NA>             Referral Kickback    Spot
      14        NA            NA          <NA>             Referral Kickback    Spot
      15        NA            NA          <NA>             Referral Kickback    Spot
      16        NA            NA          <NA>             Referral Kickback    Spot
      17        NA            NA          <NA>             Referral Kickback    Spot
      18        NA            NA          <NA>             Referral Kickback    Spot
      19 4.9214014   0.002123124           ETH                          Sell    Spot
      20        NA            NA          <NA>                          Sell    Spot
      21 1.4195432   0.000612400           ETH                          Sell    Spot
      22        NA            NA          <NA>                          Sell    Spot
      23        NA            NA          <NA>             Referral Kickback    Spot
      24        NA            NA          <NA>             Referral Kickback    Spot
      25        NA            NA          <NA> Simple Earn Flexible Interest    Earn
      26        NA            NA          <NA>                  Distribution    Spot
      27        NA            NA          <NA>   Stablecoins Auto-Conversion    Spot
      28        NA            NA          <NA>   Stablecoins Auto-Conversion    Spot
         revenue.type exchange               rate.source
      1          <NA>  binance             coinmarketcap
      2          <NA>  binance coinmarketcap (buy price)
      3          <NA>  binance             coinmarketcap
      4          <NA>  binance coinmarketcap (buy price)
      5          <NA>  binance             coinmarketcap
      6          <NA>  binance coinmarketcap (buy price)
      7          <NA>  binance             coinmarketcap
      8          <NA>  binance coinmarketcap (buy price)
      9          <NA>  binance             coinmarketcap
      10         <NA>  binance coinmarketcap (buy price)
      11         <NA>  binance             coinmarketcap
      12         <NA>  binance coinmarketcap (buy price)
      13      rebates  binance             coinmarketcap
      14      rebates  binance             coinmarketcap
      15      rebates  binance             coinmarketcap
      16      rebates  binance             coinmarketcap
      17      rebates  binance             coinmarketcap
      18      rebates  binance             coinmarketcap
      19         <NA>  binance             coinmarketcap
      20         <NA>  binance coinmarketcap (buy price)
      21         <NA>  binance             coinmarketcap
      22         <NA>  binance coinmarketcap (buy price)
      23      rebates  binance             coinmarketcap
      24      rebates  binance             coinmarketcap
      25    interests  binance             coinmarketcap
      26        forks  binance             coinmarketcap
      27         <NA>  binance             coinmarketcap
      28         <NA>  binance             coinmarketcap

---

    Code
      format_detect(data_binance_withdrawals, list.prices = list.prices)
    Message
      Exchange detected: binance_withdrawals
    Output
                       date currency quantity total.price spot.rate transaction
      1 2021-04-28 17:13:50      LTC 0.001000   0.1675500    167.55        sell
      2 2021-04-28 18:15:14      ETH 0.000071   0.1568745   2209.50        sell
      3 2021-05-06 19:55:52      ETH 0.000062   0.1387250   2237.50        sell
            description exchange   rate.source
      1 Withdrawal fees  binance coinmarketcap
      2 Withdrawal fees  binance coinmarketcap
      3 Withdrawal fees  binance coinmarketcap

---

    Code
      format_detect(data_blockfi, list.prices = list.prices)
    Message
      Exchange detected: blockfi
    Output
                        date currency     quantity total.price   spot.rate
      1  2021-05-29 21:43:44      LTC  0.022451200  3.86609664   172.20000
      2  2021-05-29 21:43:44      BTC  0.000018512  0.92893216 50180.00000
      3  2021-06-13 21:43:44      BTC  0.000184120  9.33580460 50705.00000
      4  2021-06-30 21:43:44      BTC  0.000047234  2.42310420 51300.00000
      5  2021-06-30 21:43:44      LTC  0.010125120  1.79214624   177.00000
      6  2021-07-29 21:43:44     USDC  0.038241000  0.04820087     1.26045
      7  2021-08-05 18:34:06      BTC  0.000250000 13.14000000 52560.00000
      8  2021-08-07 21:43:44      BTC  0.000441230 23.22193490 52630.00000
      9  2021-10-24 04:29:23     USDC 55.000000000 69.56400000     1.26480
      10 2021-10-24 04:29:23      LTC  0.165122140 69.56400000   421.28814
         transaction      description revenue.type exchange               rate.source
      1      revenue Interest Payment    interests  blockfi             coinmarketcap
      2      revenue Interest Payment    interests  blockfi             coinmarketcap
      3      revenue   Referral Bonus    referrals  blockfi             coinmarketcap
      4      revenue Interest Payment    interests  blockfi             coinmarketcap
      5      revenue Interest Payment    interests  blockfi             coinmarketcap
      6      revenue Interest Payment    interests  blockfi             coinmarketcap
      7         sell   Withdrawal Fee         <NA>  blockfi             coinmarketcap
      8      revenue    Bonus Payment       promos  blockfi             coinmarketcap
      9          buy            Trade         <NA>  blockfi             coinmarketcap
      10        sell            Trade         <NA>  blockfi coinmarketcap (buy price)

---

    Code
      format_detect(data_CDC_exchange_rewards, list.prices = list.prices)
    Message
      Exchange detected: CDC_exchange_rewards
    Output
                        date currency   quantity total.price  spot.rate transaction
      1  2021-02-19 00:00:00      CRO 1.36512341 0.238214035     0.1745     revenue
      2  2021-02-21 00:00:00      CRO 1.36945123 0.240338691     0.1755     revenue
      3  2021-04-15 16:04:21      BTC 0.00000023 0.011187200 48640.0000     revenue
      4  2021-04-18 00:00:00      CRO 1.36512310 0.277802551     0.2035     revenue
      5  2021-05-14 06:02:22      BTC 0.00000035 0.017379250 49655.0000     revenue
      6  2021-06-12 15:21:34      BTC 0.00000630 0.319221000 50670.0000     revenue
      7  2021-06-27 01:34:00      CRO 0.00100000 0.000238500     0.2385        sell
      8  2021-07-07 00:00:00      CRO 0.01512903 0.003683919     0.2435     revenue
      9  2021-07-13 00:00:00      CRO 0.05351230 0.013190782     0.2465     revenue
      10 2021-09-07 00:00:00      CRO 0.01521310 0.004175996     0.2745     revenue
         description                                          comment revenue.type
      1       Reward Interest on 5000.00000000 at 10% APR (Completed)    interests
      2       Reward Interest on 5000.00000000 at 10% APR (Completed)    interests
      3       Reward                          BTC Supercharger reward    interests
      4       Reward Interest on 5000.00000000 at 10% APR (Completed)    interests
      5       Reward                          BTC Supercharger reward    interests
      6       Reward                          BTC Supercharger reward    interests
      7   Withdrawal                                             <NA>         <NA>
      8       Reward                  Rebate on 0.18512341 CRO at 10%      rebates
      9       Reward                Rebate on 0.5231512346 CRO at 10%      rebates
      10      Reward                 Rebate on 0.155125123 CRO at 10%      rebates
             exchange   rate.source
      1  CDC.exchange coinmarketcap
      2  CDC.exchange coinmarketcap
      3  CDC.exchange coinmarketcap
      4  CDC.exchange coinmarketcap
      5  CDC.exchange coinmarketcap
      6  CDC.exchange coinmarketcap
      7  CDC.exchange coinmarketcap
      8  CDC.exchange coinmarketcap
      9  CDC.exchange coinmarketcap
      10 CDC.exchange coinmarketcap

---

    Code
      format_detect(data_CDC_exchange_trades, list.prices = list.prices)
    Message
      Exchange detected: CDC_exchange_trades
    Output
                        date currency   quantity total.price spot.rate transaction
      1  2021-12-24 15:34:45      CRO 13260.1300 4355.952705    0.3285         buy
      2  2021-12-24 15:34:45      ETH     2.0932 4355.952705 2081.0017        sell
      3  2021-12-24 15:34:45      CRO  3555.9000 1168.113150    0.3285         buy
      4  2021-12-24 15:34:45      ETH     0.5600 1168.113150 2085.9163        sell
      5  2021-12-24 15:34:45      CRO  1781.7400  585.301590    0.3285         buy
      6  2021-12-24 15:34:45      ETH     0.2800  585.301590 2090.3628        sell
      7  2021-12-24 15:34:45      CRO    26.8500    8.820225    0.3285         buy
      8  2021-12-24 15:34:45      ETH     0.0042    8.820225 2100.0536        sell
      9  2021-12-24 15:34:45      CRO    26.6700    8.761095    0.3285         buy
      10 2021-12-24 15:34:45      ETH     0.0042    8.761095 2085.9750        sell
      11 2021-12-24 15:34:45      CRO    17.7800    5.840730    0.3285         buy
      12 2021-12-24 15:34:45      CRO    17.7800    5.840730    0.3285         buy
      13 2021-12-24 15:34:45      ETH     0.0028    5.840730 2085.9750        sell
      14 2021-12-24 15:34:45      ETH     0.0028    5.840730 2085.9750        sell
                fees fees.quantity fees.currency description comment     exchange
      1  17.42381234   53.04052463           CRO         BUY ETH_CRO CDC.exchange
      2           NA            NA          <NA>        SELL ETH_CRO CDC.exchange
      3   4.67245155   14.22359680           CRO         BUY ETH_CRO CDC.exchange
      4           NA            NA          <NA>        SELL ETH_CRO CDC.exchange
      5   2.34121109    7.12697440           CRO         BUY ETH_CRO CDC.exchange
      6           NA            NA          <NA>        SELL ETH_CRO CDC.exchange
      7   0.03528545    0.10741385           CRO         BUY ETH_CRO CDC.exchange
      8           NA            NA          <NA>        SELL ETH_CRO CDC.exchange
      9   0.03504294    0.10667563           CRO         BUY ETH_CRO CDC.exchange
      10          NA            NA          <NA>        SELL ETH_CRO CDC.exchange
      11  0.02336233    0.07111821           CRO         BUY ETH_CRO CDC.exchange
      12  0.02336230    0.07111810           CRO         BUY ETH_CRO CDC.exchange
      13          NA            NA          <NA>        SELL ETH_CRO CDC.exchange
      14          NA            NA          <NA>        SELL ETH_CRO CDC.exchange
                       rate.source
      1              coinmarketcap
      2  coinmarketcap (buy price)
      3              coinmarketcap
      4  coinmarketcap (buy price)
      5              coinmarketcap
      6  coinmarketcap (buy price)
      7              coinmarketcap
      8  coinmarketcap (buy price)
      9              coinmarketcap
      10 coinmarketcap (buy price)
      11             coinmarketcap
      12             coinmarketcap
      13 coinmarketcap (buy price)
      14 coinmarketcap (buy price)

---

    Code
      format_detect(data_CDC_wallet, list.prices = list.prices)
    Message
      Exchange detected: CDC_wallet
    Output
                       date currency quantity total.price spot.rate transaction
      1 2021-04-12 18:28:50      CRO 0.512510   0.1027583    0.2005     revenue
      2 2021-04-18 18:28:50      CRO 0.000200   0.0000407    0.2035        sell
      3 2021-04-23 18:51:53      CRO 1.656708   0.3412818    0.2060     revenue
      4 2021-04-25 18:51:53      CRO 0.000200   0.0000414    0.2070        sell
      5 2021-05-21 01:19:01      CRO 0.000200   0.0000440    0.2200        sell
      6 2021-06-25 04:11:53      CRO 0.000200   0.0000475    0.2375        sell
      7 2021-06-26 14:51:02      CRO 6.051235   1.4401939    0.2380     revenue
         description
      1       Reward
      2 staking cost
      3       Reward
      4 staking cost
      5   Withdrawal
      6 staking cost
      7       Reward
                                                                                                          comment
      1                                                                                Auto Withdraw Reward from 
      2                                                            Stake on Validator(abcdefghijklmnopqrstuvwxyz)
      3                                                                                Auto Withdraw Reward from 
      4                                                        Unstake from Validator(abcdefghijklmnopqrstuvwxyz)
      5                                                        Outgoing Transaction to abcdefghijklmnopqrstuvwxyz
      6 Move 530.41289045 CRO from Validator(abcdefghijklmnopqrstuvwxyz) to Validator(abcdefghijklmnopqrstuvwxyz)
      7                                                           Withdraw Reward from abcdefghijklmnopqrstuvwxyz
        revenue.type   exchange   rate.source
      1      staking CDC.wallet coinmarketcap
      2         <NA> CDC.wallet coinmarketcap
      3      staking CDC.wallet coinmarketcap
      4         <NA> CDC.wallet coinmarketcap
      5         <NA> CDC.wallet coinmarketcap
      6         <NA> CDC.wallet coinmarketcap
      7      staking CDC.wallet coinmarketcap

---

    Code
      format_detect(data_coinsmart, list.prices = list.prices)
    Message
      Exchange detected: coinsmart
    Output
                       date currency  quantity total.price    spot.rate transaction
      1 2021-04-25 16:11:24      ADA 198.50000    237.9374     1.198677         buy
      2 2021-04-28 18:37:15      CAD  15.00000     15.0000     1.000000     revenue
      3 2021-05-15 16:42:07      BTC   0.00004      1.9876 49690.000000     revenue
      4 2021-06-03 02:04:49      ADA   0.30000      0.4518     1.506000        sell
            fees fees.quantity fees.currency description  comment revenue.type
      1 0.281316         0.197           ADA    purchase    Trade         <NA>
      2       NA            NA          <NA>       Other Referral    referrals
      3       NA            NA          <NA>       Other     Quiz     airdrops
      4       NA            NA          <NA>         Fee Withdraw         <NA>
         exchange   rate.source
      1 coinsmart      exchange
      2 coinsmart      exchange
      3 coinsmart coinmarketcap
      4 coinsmart coinmarketcap

---

    Code
      format_detect(data_exodus, list.prices = list.prices)
    Message
      Exchange detected: exodus
    Output
                       date currency  quantity total.price spot.rate transaction
      1 2021-05-25 22:06:11      LTC 0.0014430   0.2476188   171.600        sell
      2 2021-05-25 23:08:12      ADA 0.1782410   0.2652226     1.488        sell
      3 2021-06-12 12:15:28      BTC 0.0000503   2.5487010 50670.000        sell
      4 2021-06-12 22:31:35      ETH 0.0014500   3.4321500  2367.000        sell
        description revenue.type exchange   rate.source
      1  withdrawal         <NA>   exodus coinmarketcap
      2  withdrawal         <NA>   exodus coinmarketcap
      3  withdrawal         <NA>   exodus coinmarketcap
      4  withdrawal         <NA>   exodus coinmarketcap

---

    Code
      format_detect(data_presearch, list.prices = list.prices)
    Message
      Exchange detected: presearch
    Output
                       date currency quantity total.price spot.rate transaction
      1 2021-01-02 19:08:59      PRE     1000      50.100    0.0501     revenue
      2 2021-04-27 19:12:15      PRE     1000      61.600    0.0616     revenue
      3 2021-05-07 05:55:33      PRE     1000      62.600    0.0626         buy
      4 2021-12-09 06:24:22      PRE       10       0.842    0.0842     revenue
                                            description revenue.type  exchange
      1                        Transferred from Rewards     airdrops presearch
      2                        Transferred from Rewards     airdrops presearch
      3 Transferred from Presearch Portal (PO#: 412893)         <NA> presearch
      4        Presearch 2021 Airdrop (Increased Stake)     airdrops presearch
          rate.source
      1 coinmarketcap
      2 coinmarketcap
      3 coinmarketcap
      4 coinmarketcap

---

    Code
      format_detect(data_gemini, list.prices = list.prices)
    Message
      Exchange detected: gemini
    Output
                        date currency        quantity total.price  spot.rate
      1  2021-04-09 22:50:55      BTC  0.000966278356  46.7968608 48430.0000
      2  2021-04-09 22:50:55      LTC  0.246690598398  46.7968608   189.6986
      3  2021-04-09 22:53:57      BTC  0.000006051912   0.2930941 48430.0000
      4  2021-04-09 22:53:57      LTC  0.001640820000   0.2930941   178.6266
      5  2021-04-09 23:20:53      BAT 48.719519585106  48.6220805     0.9980
      6  2021-04-09 23:20:53      BTC  0.000950730015  48.6220805 51141.8381
      7  2021-04-10 23:22:04      BTC  0.000285025578  13.8137646 48465.0000
      8  2021-05-08 16:14:54      BAT  2.833934780210   2.9104510     1.0270
      9  2021-05-16 12:55:02      BAT  3.085288331282   3.1932734     1.0350
      10 2021-05-16 13:35:19      BAT  5.007481461482   5.1827433     1.0350
      11 2021-06-18 01:38:54      BAT  6.834322542857   7.2990565     1.0680
         transaction        fees   fees.quantity fees.currency description
      1          buy 0.111554081 0.0000023034086           BTC      LTCBTC
      2         sell          NA              NA           LTC      LTCBTC
      3          buy 0.001768572 0.0000000365181           BTC      LTCBTC
      4         sell          NA              NA           LTC      LTCBTC
      5          buy          NA              NA           BAT      BATBTC
      6         sell 0.087863695 0.0000018142411           BTC      BATBTC
      7      revenue          NA              NA          <NA>      Credit
      8      revenue          NA              NA          <NA>      Credit
      9      revenue          NA              NA          <NA>      Credit
      10     revenue          NA              NA          <NA>      Credit
      11     revenue          NA              NA          <NA>      Credit
                       comment revenue.type exchange               rate.source
      1                 Market         <NA>   gemini             coinmarketcap
      2                 Market         <NA>   gemini coinmarketcap (buy price)
      3                  Limit         <NA>   gemini             coinmarketcap
      4                  Limit         <NA>   gemini coinmarketcap (buy price)
      5                  Limit         <NA>   gemini             coinmarketcap
      6                  Limit         <NA>   gemini coinmarketcap (buy price)
      7  Administrative Credit    referrals   gemini             coinmarketcap
      8  Administrative Credit    referrals   gemini             coinmarketcap
      9                Deposit     airdrops   gemini             coinmarketcap
      10               Deposit     airdrops   gemini             coinmarketcap
      11               Deposit     airdrops   gemini             coinmarketcap

---

    Code
      format_detect(data_uphold, list.prices = list.prices)
    Message
      Exchange detected: uphold
    Output
                        date currency    quantity total.price   spot.rate transaction
      1  2021-01-07 02:40:31      BAT  1.59081275   1.4412764   0.9060000     revenue
      2  2021-02-09 14:26:49      BAT 12.69812163  11.9235362   0.9390000     revenue
      3  2021-03-06 21:32:36      BAT  0.37591275   0.3623799   0.9640000     revenue
      4  2021-03-07 21:46:57      LTC  0.24129740  38.5472597 159.7500000         buy
      5  2021-03-07 21:46:57      BAT 52.59871206  38.5472597   0.7328556        sell
      6  2021-03-07 21:54:09      LTC  0.00300000   0.4792500 159.7500000        sell
      7  2021-04-05 12:22:00      BAT  8.52198415   8.4708522   0.9940000     revenue
      8  2021-04-06 03:41:42      LTC  0.00300000   0.4927500 164.2500000        sell
      9  2021-04-06 04:47:00      LTC  0.03605981   5.9228241 164.2500000         buy
      10 2021-04-06 04:47:00      BAT  8.52198415   5.9228241   0.6950053        sell
      11 2021-05-11 07:12:24      BAT  0.47521985   0.4894764   1.0300000     revenue
      12 2021-06-09 04:52:23      BAT  0.67207415   0.7117265   1.0590000     revenue
         description         comment revenue.type exchange               rate.source
      1           in            <NA>     airdrops   uphold             coinmarketcap
      2           in            <NA>     airdrops   uphold             coinmarketcap
      3           in            <NA>     airdrops   uphold             coinmarketcap
      4        trade         BAT-LTC         <NA>   uphold             coinmarketcap
      5        trade         BAT-LTC         <NA>   uphold coinmarketcap (buy price)
      6          out withdrawal fees         <NA>   uphold             coinmarketcap
      7           in            <NA>     airdrops   uphold             coinmarketcap
      8          out withdrawal fees         <NA>   uphold             coinmarketcap
      9        trade         BAT-LTC         <NA>   uphold             coinmarketcap
      10       trade         BAT-LTC         <NA>   uphold coinmarketcap (buy price)
      11          in            <NA>     airdrops   uphold             coinmarketcap
      12          in            <NA>     airdrops   uphold             coinmarketcap

# format_detect list

    Code
      format_detect(list(data_shakepay, data_newton, data_adalite), list.prices = list.prices)
    Message
      Exchange detected: shakepay
      Exchange detected: newton
      Exchange detected: adalite
    Output
                        date currency    quantity  total.price  spot.rate transaction
      1  2021-04-04 22:50:12      LTC  0.10482910   23.4912731   224.0911         buy
      2  2021-04-04 22:53:46      CAD 25.00000000   25.0000000     1.0000     revenue
      3  2021-04-04 22:55:55      ETH  2.71987120 3423.8221510  1258.8178         buy
      4  2021-04-21 19:57:26      BTC  0.00343000  153.1241354 44642.6051         buy
      5  2021-04-28 16:56:00      ADA  0.31204000    0.4474654     1.4340     revenue
      6  2021-05-07 14:50:41      BTC  0.00103982   53.0697400 51037.4327         buy
      7  2021-05-07 16:53:00      ADA  0.31251320    0.4537692     1.4520     revenue
      8  2021-05-08 12:12:57      BTC  0.00001100    0.5784024 52582.0324     revenue
      9  2021-05-09 12:22:07      BTC  0.00001200    0.6034441 50287.0079     revenue
      10 2021-05-12 16:56:00      ADA  0.22124100    0.3234543     1.4620     revenue
      11 2021-05-12 21:37:42      BTC  0.00000400    0.3049013 76225.3175         buy
      12 2021-05-12 21:52:40      BTC  0.00321300  156.1241341 48591.3894        sell
      13 2021-05-17 17:16:00      ADA  0.41232100    0.6069365     1.4720     revenue
      14 2021-05-17 21:16:00      ADA  0.16918700    0.2490433     1.4720        sell
      15 2021-05-17 21:31:00      ADA  0.19123000    0.2814906     1.4720        sell
      16 2021-05-21 12:47:14      BTC  0.00001300    0.7348590 56527.6188     revenue
      17 2021-06-11 12:03:31      BTC  0.00001400    0.8396927 59978.0477     revenue
      18 2021-06-16 18:49:11      CAD 25.00000000   25.0000000     1.0000     revenue
      19 2021-06-23 12:21:49      BTC  0.00001500    0.8852574 59017.1621     revenue
      20 2021-07-10 00:52:19      BTC  0.00052991   31.2684700 59017.1922        sell
              description               comment revenue.type exchange   rate.source
      1             TRADE                  <NA>         <NA>   newton      exchange
      2  Referral Program                  <NA>    referrals   newton      exchange
      3             TRADE                  <NA>         <NA>   newton      exchange
      4             TRADE                  <NA>         <NA>   newton      exchange
      5    Reward awarded                  <NA>      staking  adalite coinmarketcap
      6               Buy Bought @ CA$51,002.43         <NA> shakepay      exchange
      7    Reward awarded                  <NA>      staking  adalite coinmarketcap
      8            Reward           ShakingSats     airdrops shakepay      exchange
      9            Reward           ShakingSats     airdrops shakepay      exchange
      10   Reward awarded                  <NA>      staking  adalite coinmarketcap
      11            TRADE                  <NA>         <NA>   newton      exchange
      12            TRADE                  <NA>         <NA>   newton      exchange
      13   Reward awarded                  <NA>      staking  adalite coinmarketcap
      14             Sent        Withdrawal Fee         <NA>  adalite coinmarketcap
      15             Sent        Withdrawal Fee         <NA>  adalite coinmarketcap
      16           Reward           ShakingSats     airdrops shakepay      exchange
      17           Reward           ShakingSats     airdrops shakepay      exchange
      18 Referral Program                  <NA>    referrals   newton      exchange
      19           Reward           ShakingSats     airdrops shakepay      exchange
      20             Sell Bought @ CA$59,007.14         <NA> shakepay      exchange

# format_exchanges public wrapper

    Code
      format_exchanges(list(data_shakepay, data_newton, data_adalite), list.prices = list.prices)
    Message
      Exchange detected: shakepay
      Exchange detected: newton
      Exchange detected: adalite
    Output
                        date currency    quantity  total.price  spot.rate transaction
      1  2021-04-04 22:50:12      LTC  0.10482910   23.4912731   224.0911         buy
      2  2021-04-04 22:53:46      CAD 25.00000000   25.0000000     1.0000     revenue
      3  2021-04-04 22:55:55      ETH  2.71987120 3423.8221510  1258.8178         buy
      4  2021-04-21 19:57:26      BTC  0.00343000  153.1241354 44642.6051         buy
      5  2021-04-28 16:56:00      ADA  0.31204000    0.4474654     1.4340     revenue
      6  2021-05-07 14:50:41      BTC  0.00103982   53.0697400 51037.4327         buy
      7  2021-05-07 16:53:00      ADA  0.31251320    0.4537692     1.4520     revenue
      8  2021-05-08 12:12:57      BTC  0.00001100    0.5784024 52582.0324     revenue
      9  2021-05-09 12:22:07      BTC  0.00001200    0.6034441 50287.0079     revenue
      10 2021-05-12 16:56:00      ADA  0.22124100    0.3234543     1.4620     revenue
      11 2021-05-12 21:37:42      BTC  0.00000400    0.3049013 76225.3175         buy
      12 2021-05-12 21:52:40      BTC  0.00321300  156.1241341 48591.3894        sell
      13 2021-05-17 17:16:00      ADA  0.41232100    0.6069365     1.4720     revenue
      14 2021-05-17 21:16:00      ADA  0.16918700    0.2490433     1.4720        sell
      15 2021-05-17 21:31:00      ADA  0.19123000    0.2814906     1.4720        sell
      16 2021-05-21 12:47:14      BTC  0.00001300    0.7348590 56527.6188     revenue
      17 2021-06-11 12:03:31      BTC  0.00001400    0.8396927 59978.0477     revenue
      18 2021-06-16 18:49:11      CAD 25.00000000   25.0000000     1.0000     revenue
      19 2021-06-23 12:21:49      BTC  0.00001500    0.8852574 59017.1621     revenue
      20 2021-07-10 00:52:19      BTC  0.00052991   31.2684700 59017.1922        sell
              description               comment revenue.type exchange   rate.source
      1             TRADE                  <NA>         <NA>   newton      exchange
      2  Referral Program                  <NA>    referrals   newton      exchange
      3             TRADE                  <NA>         <NA>   newton      exchange
      4             TRADE                  <NA>         <NA>   newton      exchange
      5    Reward awarded                  <NA>      staking  adalite coinmarketcap
      6               Buy Bought @ CA$51,002.43         <NA> shakepay      exchange
      7    Reward awarded                  <NA>      staking  adalite coinmarketcap
      8            Reward           ShakingSats     airdrops shakepay      exchange
      9            Reward           ShakingSats     airdrops shakepay      exchange
      10   Reward awarded                  <NA>      staking  adalite coinmarketcap
      11            TRADE                  <NA>         <NA>   newton      exchange
      12            TRADE                  <NA>         <NA>   newton      exchange
      13   Reward awarded                  <NA>      staking  adalite coinmarketcap
      14             Sent        Withdrawal Fee         <NA>  adalite coinmarketcap
      15             Sent        Withdrawal Fee         <NA>  adalite coinmarketcap
      16           Reward           ShakingSats     airdrops shakepay      exchange
      17           Reward           ShakingSats     airdrops shakepay      exchange
      18 Referral Program                  <NA>    referrals   newton      exchange
      19           Reward           ShakingSats     airdrops shakepay      exchange
      20             Sell Bought @ CA$59,007.14         <NA> shakepay      exchange

# format_exchanges public wrapper with multiple arguments

    Code
      format_exchanges(data_shakepay, data_newton, data_adalite, list.prices = list.prices)
    Message
      Exchange detected: shakepay
      Exchange detected: newton
      Exchange detected: adalite
    Output
                        date currency    quantity  total.price  spot.rate transaction
      1  2021-04-04 22:50:12      LTC  0.10482910   23.4912731   224.0911         buy
      2  2021-04-04 22:53:46      CAD 25.00000000   25.0000000     1.0000     revenue
      3  2021-04-04 22:55:55      ETH  2.71987120 3423.8221510  1258.8178         buy
      4  2021-04-21 19:57:26      BTC  0.00343000  153.1241354 44642.6051         buy
      5  2021-04-28 16:56:00      ADA  0.31204000    0.4474654     1.4340     revenue
      6  2021-05-07 14:50:41      BTC  0.00103982   53.0697400 51037.4327         buy
      7  2021-05-07 16:53:00      ADA  0.31251320    0.4537692     1.4520     revenue
      8  2021-05-08 12:12:57      BTC  0.00001100    0.5784024 52582.0324     revenue
      9  2021-05-09 12:22:07      BTC  0.00001200    0.6034441 50287.0079     revenue
      10 2021-05-12 16:56:00      ADA  0.22124100    0.3234543     1.4620     revenue
      11 2021-05-12 21:37:42      BTC  0.00000400    0.3049013 76225.3175         buy
      12 2021-05-12 21:52:40      BTC  0.00321300  156.1241341 48591.3894        sell
      13 2021-05-17 17:16:00      ADA  0.41232100    0.6069365     1.4720     revenue
      14 2021-05-17 21:16:00      ADA  0.16918700    0.2490433     1.4720        sell
      15 2021-05-17 21:31:00      ADA  0.19123000    0.2814906     1.4720        sell
      16 2021-05-21 12:47:14      BTC  0.00001300    0.7348590 56527.6188     revenue
      17 2021-06-11 12:03:31      BTC  0.00001400    0.8396927 59978.0477     revenue
      18 2021-06-16 18:49:11      CAD 25.00000000   25.0000000     1.0000     revenue
      19 2021-06-23 12:21:49      BTC  0.00001500    0.8852574 59017.1621     revenue
      20 2021-07-10 00:52:19      BTC  0.00052991   31.2684700 59017.1922        sell
              description               comment revenue.type exchange   rate.source
      1             TRADE                  <NA>         <NA>   newton      exchange
      2  Referral Program                  <NA>    referrals   newton      exchange
      3             TRADE                  <NA>         <NA>   newton      exchange
      4             TRADE                  <NA>         <NA>   newton      exchange
      5    Reward awarded                  <NA>      staking  adalite coinmarketcap
      6               Buy Bought @ CA$51,002.43         <NA> shakepay      exchange
      7    Reward awarded                  <NA>      staking  adalite coinmarketcap
      8            Reward           ShakingSats     airdrops shakepay      exchange
      9            Reward           ShakingSats     airdrops shakepay      exchange
      10   Reward awarded                  <NA>      staking  adalite coinmarketcap
      11            TRADE                  <NA>         <NA>   newton      exchange
      12            TRADE                  <NA>         <NA>   newton      exchange
      13   Reward awarded                  <NA>      staking  adalite coinmarketcap
      14             Sent        Withdrawal Fee         <NA>  adalite coinmarketcap
      15             Sent        Withdrawal Fee         <NA>  adalite coinmarketcap
      16           Reward           ShakingSats     airdrops shakepay      exchange
      17           Reward           ShakingSats     airdrops shakepay      exchange
      18 Referral Program                  <NA>    referrals   newton      exchange
      19           Reward           ShakingSats     airdrops shakepay      exchange
      20             Sell Bought @ CA$59,007.14         <NA> shakepay      exchange

# format_exchanges mixed public wrapper

    Code
      format_exchanges(list(format_shakepay(data_shakepay), data_newton, data_adalite[
        0, ]), list.prices = list.prices)
    Message
      Exchange detected: newton
    Output
                        date currency    quantity  total.price  spot.rate transaction
      1  2021-04-04 22:50:12      LTC  0.10482910   23.4912731   224.0911         buy
      2  2021-04-04 22:53:46      CAD 25.00000000   25.0000000     1.0000     revenue
      3  2021-04-04 22:55:55      ETH  2.71987120 3423.8221510  1258.8178         buy
      4  2021-04-21 19:57:26      BTC  0.00343000  153.1241354 44642.6051         buy
      5  2021-05-07 14:50:41      BTC  0.00103982   53.0697400 51037.4327         buy
      6  2021-05-08 12:12:57      BTC  0.00001100    0.5784024 52582.0324     revenue
      7  2021-05-09 12:22:07      BTC  0.00001200    0.6034441 50287.0079     revenue
      8  2021-05-12 21:37:42      BTC  0.00000400    0.3049013 76225.3175         buy
      9  2021-05-12 21:52:40      BTC  0.00321300  156.1241341 48591.3894        sell
      10 2021-05-21 12:47:14      BTC  0.00001300    0.7348590 56527.6188     revenue
      11 2021-06-11 12:03:31      BTC  0.00001400    0.8396927 59978.0477     revenue
      12 2021-06-16 18:49:11      CAD 25.00000000   25.0000000     1.0000     revenue
      13 2021-06-23 12:21:49      BTC  0.00001500    0.8852574 59017.1621     revenue
      14 2021-07-10 00:52:19      BTC  0.00052991   31.2684700 59017.1922        sell
              description               comment revenue.type exchange rate.source
      1             TRADE                  <NA>         <NA>   newton    exchange
      2  Referral Program                  <NA>    referrals   newton    exchange
      3             TRADE                  <NA>         <NA>   newton    exchange
      4             TRADE                  <NA>         <NA>   newton    exchange
      5               Buy Bought @ CA$51,002.43         <NA> shakepay    exchange
      6            Reward           ShakingSats     airdrops shakepay    exchange
      7            Reward           ShakingSats     airdrops shakepay    exchange
      8             TRADE                  <NA>         <NA>   newton    exchange
      9             TRADE                  <NA>         <NA>   newton    exchange
      10           Reward           ShakingSats     airdrops shakepay    exchange
      11           Reward           ShakingSats     airdrops shakepay    exchange
      12 Referral Program                  <NA>    referrals   newton    exchange
      13           Reward           ShakingSats     airdrops shakepay    exchange
      14             Sell Bought @ CA$59,007.14         <NA> shakepay    exchange

