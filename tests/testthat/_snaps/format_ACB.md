# shakepay

    Code
      formatted.shakepay
    Output
                       date currency   quantity total.price spot.rate transaction
      1 2021-05-07 14:50:41      BTC 0.00103982    53.06974  51037.43         buy
      2 2021-05-08 12:12:57      BTC 0.00001100     0.00000  52582.03     revenue
      3 2021-05-09 12:22:07      BTC 0.00001200     0.00000  50287.01     revenue
      4 2021-05-21 12:47:14      BTC 0.00001300     0.00000  56527.62     revenue
      5 2021-06-11 12:03:31      BTC 0.00001400     0.00000  59978.05     revenue
      6 2021-06-23 12:21:49      BTC 0.00001500     0.00000  59017.16     revenue
      7 2021-07-10 00:52:19      BTC 0.00052991    31.26847  59017.19        sell
        fees description               comment revenue.type      value exchange
      1    0         Buy Bought @ CA$51,002.43         <NA> 53.0697400 shakepay
      2    0      Reward           ShakingSats     airdrops  0.5784024 shakepay
      3    0      Reward           ShakingSats     airdrops  0.6034441 shakepay
      4    0      Reward           ShakingSats     airdrops  0.7348590 shakepay
      5    0      Reward           ShakingSats     airdrops  0.8396927 shakepay
      6    0      Reward           ShakingSats     airdrops  0.8852574 shakepay
      7    0        Sell Bought @ CA$59,007.14         <NA> 31.2684700 shakepay
        rate.source currency2 total.quantity
      1    exchange       BTC     0.00103982
      2    exchange       BTC     0.00105082
      3    exchange       BTC     0.00106282
      4    exchange       BTC     0.00107582
      5    exchange       BTC     0.00108982
      6    exchange       BTC     0.00110482
      7    exchange       BTC     0.00057491
                                           suploss.range quantity.60days share.left60
      1 2021-04-07 14:50:41 UTC--2021-06-06 14:50:41 UTC      0.00103982   0.00107582
      2 2021-04-08 12:12:57 UTC--2021-06-07 12:12:57 UTC      0.00103982   0.00107582
      3 2021-04-09 12:22:07 UTC--2021-06-08 12:22:07 UTC      0.00103982   0.00107582
      4 2021-04-21 12:47:14 UTC--2021-06-20 12:47:14 UTC      0.00103982   0.00108982
      5 2021-05-12 12:03:31 UTC--2021-07-11 12:03:31 UTC      0.00000000   0.00057491
      6 2021-05-24 12:21:49 UTC--2021-07-23 12:21:49 UTC      0.00000000   0.00057491
      7 2021-06-10 00:52:19 UTC--2021-08-09 00:52:19 UTC      0.00000000   0.00057491
        sup.loss.quantity sup.loss gains.uncorrected gains.sup gains.excess    gains
      1                 0    FALSE          0.000000        NA           NA       NA
      2                 0    FALSE          0.000000        NA           NA       NA
      3                 0    FALSE          0.000000        NA           NA       NA
      4                 0    FALSE          0.000000        NA           NA       NA
      5                 0    FALSE          0.000000        NA           NA       NA
      6                 0    FALSE          0.000000        NA           NA       NA
      7                 0    FALSE          5.814382        NA           NA 5.814382
             ACB ACB.share
      1 53.06974  51037.43
      2 53.06974  50503.17
      3 53.06974  49932.95
      4 53.06974  49329.57
      5 53.06974  48695.88
      6 53.06974  48034.74
      7 27.61565  48034.74

# newton

    Code
      formatted.newton
    Output
                       date currency   quantity  total.price  spot.rate transaction
      1 2021-04-04 22:50:12      LTC  0.1048291   23.4912731   224.0911         buy
      2 2021-04-04 22:53:46      CAD 25.0000000    0.0000000     1.0000     revenue
      3 2021-04-04 22:55:55      ETH  2.7198712 3423.8221510  1258.8178         buy
      4 2021-04-21 19:57:26      BTC  0.0034300  153.1241354 44642.6051         buy
      5 2021-05-12 21:37:42      BTC  0.0000040    0.3049013 76225.3175         buy
      6 2021-05-12 21:52:40      BTC  0.0032130  156.1241341 48591.3894        sell
      7 2021-06-16 18:49:11      CAD 25.0000000    0.0000000     1.0000     revenue
        fees      description revenue.type        value exchange rate.source
      1    0            TRADE         <NA>   23.4912731   newton    exchange
      2    0 Referral Program    referrals   25.0000000   newton    exchange
      3    0            TRADE         <NA> 3423.8221510   newton    exchange
      4    0            TRADE         <NA>  153.1241354   newton    exchange
      5    0            TRADE         <NA>    0.3049013   newton    exchange
      6    0            TRADE         <NA>  156.1241341   newton    exchange
      7    0 Referral Program    referrals   25.0000000   newton    exchange
        currency2 total.quantity                                    suploss.range
      1       LTC      0.1048291 2021-03-05 22:50:12 UTC--2021-05-04 22:50:12 UTC
      2       CAD     25.0000000 2021-03-05 22:53:46 UTC--2021-05-04 22:53:46 UTC
      3       ETH      2.7198712 2021-03-05 22:55:55 UTC--2021-05-04 22:55:55 UTC
      4       BTC      0.0034300 2021-03-22 19:57:26 UTC--2021-05-21 19:57:26 UTC
      5       BTC      0.0034340 2021-04-12 21:37:42 UTC--2021-06-11 21:37:42 UTC
      6       BTC      0.0002210 2021-04-12 21:52:40 UTC--2021-06-11 21:52:40 UTC
      7       CAD     50.0000000 2021-05-17 18:49:11 UTC--2021-07-16 18:49:11 UTC
        quantity.60days share.left60 sup.loss.quantity sup.loss gains.uncorrected
      1       0.1048291    0.1048291          0.000000    FALSE           0.00000
      2       0.0000000   25.0000000          0.000000    FALSE           0.00000
      3       2.7198712    2.7198712          0.000000    FALSE           0.00000
      4       0.0034340    0.0002210          0.000000    FALSE           0.00000
      5       0.0034340    0.0002210          0.000000    FALSE           0.00000
      6       0.0034340    0.0002210          0.003213    FALSE          12.56924
      7       0.0000000   50.0000000          0.000000    FALSE           0.00000
        gains.sup gains.excess    gains         ACB  ACB.share
      1        NA           NA       NA   23.491273   224.0911
      2        NA           NA       NA    0.000000     0.0000
      3        NA           NA       NA 3423.822151  1258.8178
      4        NA           NA       NA  153.124135 44642.6051
      5        NA           NA       NA  153.429037 44679.3933
      6        NA           NA 12.56924    9.874146 44679.3933
      7        NA           NA       NA    0.000000     0.0000

# pooltool

    Code
      formatted.pooltool
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
         fees description     comment revenue.type    value exchange rate.source
      1     0 epoch = 228 pool = REKT      staking 1.974017   exodus    pooltool
      2     0 epoch = 229 pool = REKT      staking 1.565881   exodus    pooltool
      3     0 epoch = 230 pool = REKT      staking 1.979399   exodus    pooltool
      4     0 epoch = 231 pool = REKT      staking 1.790303   exodus    pooltool
      5     0 epoch = 232 pool = REKT      staking 1.514525   exodus    pooltool
      6     0 epoch = 233 pool = REKT      staking 1.426898   exodus    pooltool
      7     0 epoch = 234 pool = REKT      staking 1.806024   exodus    pooltool
      8     0 epoch = 235 pool = REKT      staking 1.589004   exodus    pooltool
      9     0 epoch = 236 pool = REKT      staking 1.538300   exodus    pooltool
      10    0 epoch = 237 pool = REKT      staking 2.072874   exodus    pooltool
         currency2 total.quantity                                    suploss.range
      1        ADA       1.082750 2021-03-23 22:03:22 UTC--2021-05-22 22:03:22 UTC
      2        ADA       1.940735 2021-03-28 22:22:14 UTC--2021-05-27 22:22:14 UTC
      3        ADA       2.960123 2021-04-02 22:03:54 UTC--2021-06-01 22:03:54 UTC
      4        ADA       4.015020 2021-04-07 22:54:38 UTC--2021-06-06 22:54:38 UTC
      5        ADA       4.959352 2021-04-12 22:12:49 UTC--2021-06-11 22:12:49 UTC
      6        ADA       5.979170 2021-04-17 22:47:25 UTC--2021-06-16 22:47:25 UTC
      7        ADA       7.139753 2021-04-23 03:43:38 UTC--2021-06-22 03:43:38 UTC
      8        ADA       8.159529 2021-04-27 22:07:57 UTC--2021-06-26 22:07:57 UTC
      9        ADA       8.998742 2021-05-02 22:13:58 UTC--2021-07-01 22:13:58 UTC
      10       ADA      10.110280 2021-05-07 22:14:11 UTC--2021-07-06 22:14:11 UTC
         quantity.60days share.left60 sup.loss.quantity sup.loss gains.uncorrected
      1                0     5.979170                 0    FALSE                 0
      2                0     8.159529                 0    FALSE                 0
      3                0     8.159529                 0    FALSE                 0
      4                0    10.110280                 0    FALSE                 0
      5                0    10.110280                 0    FALSE                 0
      6                0    10.110280                 0    FALSE                 0
      7                0    10.110280                 0    FALSE                 0
      8                0    10.110280                 0    FALSE                 0
      9                0    10.110280                 0    FALSE                 0
      10               0    10.110280                 0    FALSE                 0
         gains.sup gains.excess gains       ACB ACB.share
      1         NA           NA    NA  1.974017  1.823152
      2         NA           NA    NA  3.539898  1.823999
      3         NA           NA    NA  5.519297  1.864550
      4         NA           NA    NA  7.309599  1.820564
      5         NA           NA    NA  8.824124  1.779290
      6         NA           NA    NA 10.251022  1.714456
      7         NA           NA    NA 12.057046  1.688720
      8         NA           NA    NA 13.646050  1.672407
      9         NA           NA    NA 15.184350  1.687386
      10        NA           NA    NA 17.257224  1.706899

# CDC

    Code
      formatted.CDC
    Output
      data frame with 0 columns and 0 rows

# celsius

    Code
      formatted.celsius
    Output
      data frame with 0 columns and 0 rows

# blockfi

    Code
      formatted.blockfi
    Output
                        date currency     quantity total.price   spot.rate
      1  2021-05-29 21:43:44      BTC  0.000018512  0.92893216 50180.00000
      2  2021-05-29 21:43:44      LTC  0.022451200  3.86609664   172.20000
      3  2021-06-13 21:43:44      BTC  0.000184120  0.00000000 50705.00000
      4  2021-06-30 21:43:44      BTC  0.000047234  2.42310420 51300.00000
      5  2021-06-30 21:43:44      LTC  0.010125120  1.79214624   177.00000
      6  2021-07-29 21:43:44     USDC  0.038241000  0.04820087     1.26045
      7  2021-08-05 18:34:06      BTC  0.000250000 13.14000000 52560.00000
      8  2021-08-07 21:43:44      BTC  0.000441230  0.00000000 52630.00000
      9  2021-10-24 04:29:23      LTC  0.165122140 69.56400000   421.28814
      10 2021-10-24 04:29:23     USDC 55.000000000 69.56400000     1.26480
         transaction fees      description revenue.type       value exchange
      1      revenue    0 Interest Payment    interests  0.92893216  blockfi
      2      revenue    0 Interest Payment    interests  3.86609664  blockfi
      3      revenue    0   Referral Bonus    referrals  9.33580460  blockfi
      4      revenue    0 Interest Payment    interests  2.42310420  blockfi
      5      revenue    0 Interest Payment    interests  1.79214624  blockfi
      6      revenue    0 Interest Payment    interests  0.04820087  blockfi
      7         sell    0   Withdrawal Fee         <NA> 13.14000000  blockfi
      8      revenue    0    Bonus Payment       promos 23.22193490  blockfi
      9         sell    0            Trade         <NA> 69.56400000  blockfi
      10         buy    0            Trade         <NA> 69.56400000  blockfi
                       rate.source currency2 total.quantity
      1              coinmarketcap       BTC    0.000018512
      2              coinmarketcap       LTC    0.022451200
      3              coinmarketcap       BTC    0.000202632
      4              coinmarketcap       BTC    0.000249866
      5              coinmarketcap       LTC    0.032576320
      6              coinmarketcap      USDC    0.038241000
      7              coinmarketcap       BTC   -0.000000134
      8              coinmarketcap       BTC    0.000441096
      9  coinmarketcap (buy price)       LTC   -0.132545820
      10             coinmarketcap      USDC   55.038241000
                                            suploss.range quantity.60days
      1  2021-04-29 21:43:44 UTC--2021-06-28 21:43:44 UTC               0
      2  2021-04-29 21:43:44 UTC--2021-06-28 21:43:44 UTC               0
      3  2021-05-14 21:43:44 UTC--2021-07-13 21:43:44 UTC               0
      4  2021-05-31 21:43:44 UTC--2021-07-30 21:43:44 UTC               0
      5  2021-05-31 21:43:44 UTC--2021-07-30 21:43:44 UTC               0
      6  2021-06-29 21:43:44 UTC--2021-08-28 21:43:44 UTC               0
      7  2021-07-06 18:34:06 UTC--2021-09-04 18:34:06 UTC               0
      8  2021-07-08 21:43:44 UTC--2021-09-06 21:43:44 UTC               0
      9  2021-09-24 04:29:23 UTC--2021-11-23 04:29:23 UTC               0
      10 2021-09-24 04:29:23 UTC--2021-11-23 04:29:23 UTC              55
         share.left60 sup.loss.quantity sup.loss gains.uncorrected gains.sup
      1   0.000202632                 0    FALSE          0.000000        NA
      2   0.022451200                 0    FALSE          0.000000        NA
      3   0.000249866                 0    FALSE          0.000000        NA
      4   0.000249866                 0    FALSE          0.000000        NA
      5   0.032576320                 0    FALSE          0.000000        NA
      6   0.038241000                 0    FALSE          0.000000        NA
      7   0.000441096                 0    FALSE          9.786166        NA
      8   0.000441096                 0    FALSE          0.000000        NA
      9  -0.132545820                 0    FALSE         40.883622        NA
      10 55.038241000                 0    FALSE          0.000000        NA
         gains.excess     gains           ACB    ACB.share
      1            NA        NA   0.928932160 50180.000000
      2            NA        NA   3.866096640   172.200000
      3            NA        NA   0.928932160  4584.331004
      4            NA        NA   3.352036360 13415.336060
      5            NA        NA   5.658242880   173.691899
      6            NA        NA   0.048200868     1.260450
      7            NA  9.786166  -0.001797655     0.000000
      8            NA        NA  -0.001797655     0.000000
      9            NA 40.883622 -23.022135167     0.000000
      10           NA        NA  69.612200868     1.264797

# adalite

    Code
      formatted.adalite
    Output
                       date currency  quantity total.price spot.rate transaction fees
      1 2021-04-28 16:56:00      ADA 0.3120400   0.4474654     1.434     revenue    0
      2 2021-05-07 16:53:00      ADA 0.3125132   0.4537692     1.452     revenue    0
      3 2021-05-12 16:56:00      ADA 0.2212410   0.3234543     1.462     revenue    0
      4 2021-05-17 17:16:00      ADA 0.4123210   0.6069365     1.472     revenue    0
      5 2021-05-17 21:16:00      ADA 0.1691870   0.2490433     1.472        sell    0
      6 2021-05-17 21:31:00      ADA 0.1912300   0.2814906     1.472        sell    0
           description        comment revenue.type     value exchange   rate.source
      1 Reward awarded           <NA>      staking 0.4474654  adalite coinmarketcap
      2 Reward awarded           <NA>      staking 0.4537692  adalite coinmarketcap
      3 Reward awarded           <NA>      staking 0.3234543  adalite coinmarketcap
      4 Reward awarded           <NA>      staking 0.6069365  adalite coinmarketcap
      5           Sent Withdrawal Fee         <NA> 0.2490433  adalite coinmarketcap
      6           Sent Withdrawal Fee         <NA> 0.2814906  adalite coinmarketcap
        currency2 total.quantity                                    suploss.range
      1       ADA      0.3120400 2021-03-29 16:56:00 UTC--2021-05-28 16:56:00 UTC
      2       ADA      0.6245532 2021-04-07 16:53:00 UTC--2021-06-06 16:53:00 UTC
      3       ADA      0.8457942 2021-04-12 16:56:00 UTC--2021-06-11 16:56:00 UTC
      4       ADA      1.2581152 2021-04-17 17:16:00 UTC--2021-06-16 17:16:00 UTC
      5       ADA      1.0889282 2021-04-17 21:16:00 UTC--2021-06-16 21:16:00 UTC
      6       ADA      0.8976982 2021-04-17 21:31:00 UTC--2021-06-16 21:31:00 UTC
        quantity.60days share.left60 sup.loss.quantity sup.loss gains.uncorrected
      1               0    0.8976982                 0    FALSE       0.000000000
      2               0    0.8976982                 0    FALSE       0.000000000
      3               0    0.8976982                 0    FALSE       0.000000000
      4               0    0.8976982                 0    FALSE       0.000000000
      5               0    0.8976982                 0    FALSE       0.002732590
      6               0    0.8976982                 0    FALSE       0.003088613
        gains.sup gains.excess       gains       ACB ACB.share
      1        NA           NA          NA 0.4474654  1.434000
      2        NA           NA          NA 0.9012345  1.443007
      3        NA           NA          NA 1.2246889  1.447975
      4        NA           NA          NA 1.8316254  1.455849
      5        NA           NA 0.002732590 1.5853147  1.455849
      6        NA           NA 0.003088613 1.3069128  1.455849

# coinsmart

    Code
      formatted.coinsmart
    Output
                       date currency  quantity total.price    spot.rate transaction
      1 2021-04-25 16:11:24      ADA 198.50000    237.9374     1.198677         buy
      2 2021-04-28 18:37:15      CAD  15.00000      0.0000     1.000000     revenue
      3 2021-05-15 16:42:07      BTC   0.00004      0.0000 49690.000000     revenue
      4 2021-06-03 02:04:49      ADA   0.30000      0.4518     1.506000        sell
        fees.quantity fees.currency     fees description  comment revenue.type
      1         0.197           ADA 0.281316    purchase    Trade         <NA>
      2            NA          <NA> 0.000000       Other Referral    referrals
      3            NA          <NA> 0.000000       Other     Quiz     airdrops
      4            NA          <NA> 0.000000         Fee Withdraw         <NA>
           value  exchange   rate.source currency2 total.quantity
      1 237.9374 coinsmart      exchange       ADA      198.50000
      2  15.0000 coinsmart      exchange       CAD       15.00000
      3   1.9876 coinsmart coinmarketcap       BTC        0.00004
      4   0.4518 coinsmart coinmarketcap       ADA      198.20000
                                           suploss.range quantity.60days share.left60
      1 2021-03-26 16:11:24 UTC--2021-05-25 16:11:24 UTC           198.5    198.50000
      2 2021-03-29 18:37:15 UTC--2021-05-28 18:37:15 UTC             0.0     15.00000
      3 2021-04-15 16:42:07 UTC--2021-06-14 16:42:07 UTC             0.0      0.00004
      4 2021-05-04 02:04:49 UTC--2021-07-03 02:04:49 UTC             0.0    198.20000
        sup.loss.quantity sup.loss gains.uncorrected gains.sup gains.excess
      1                 0    FALSE        0.00000000        NA           NA
      2                 0    FALSE        0.00000000        NA           NA
      3                 0    FALSE        0.00000000        NA           NA
      4                 0    FALSE        0.09177167        NA           NA
             gains      ACB ACB.share
      1         NA 238.2187  1.200094
      2         NA   0.0000  0.000000
      3         NA   0.0000  0.000000
      4 0.09177167 237.8587  1.200094

# presearch

    Code
      formatted.presearch
    Output
                       date currency quantity total.price spot.rate transaction fees
      1 2021-01-02 19:08:59      PRE     1000         0.0    0.0501     revenue    0
      2 2021-04-27 19:12:15      PRE     1000         0.0    0.0616     revenue    0
      3 2021-05-07 05:55:33      PRE     1000        62.6    0.0626         buy    0
      4 2021-12-09 06:24:22      PRE       10         0.0    0.0842     revenue    0
                                            description revenue.type  value  exchange
      1                        Transferred from Rewards     airdrops 50.100 presearch
      2                        Transferred from Rewards     airdrops 61.600 presearch
      3 Transferred from Presearch Portal (PO#: 412893)         <NA> 62.600 presearch
      4        Presearch 2021 Airdrop (Increased Stake)     airdrops  0.842 presearch
          rate.source currency2 total.quantity
      1 coinmarketcap       PRE           1000
      2 coinmarketcap       PRE           2000
      3 coinmarketcap       PRE           3000
      4 coinmarketcap       PRE           3010
                                           suploss.range quantity.60days share.left60
      1 2020-12-03 19:08:59 UTC--2021-02-01 19:08:59 UTC               0         1000
      2 2021-03-28 19:12:15 UTC--2021-05-27 19:12:15 UTC            1000         3000
      3 2021-04-07 05:55:33 UTC--2021-06-06 05:55:33 UTC            1000         3000
      4 2021-11-09 06:24:22 UTC--2022-01-08 06:24:22 UTC               0         3010
        sup.loss.quantity sup.loss gains.uncorrected gains.sup gains.excess gains
      1                 0    FALSE                 0        NA           NA    NA
      2                 0    FALSE                 0        NA           NA    NA
      3                 0    FALSE                 0        NA           NA    NA
      4                 0    FALSE                 0        NA           NA    NA
         ACB  ACB.share
      1  0.0 0.00000000
      2  0.0 0.00000000
      3 62.6 0.02086667
      4 62.6 0.02079734

# CDC exchange rewards

    Code
      formatted.binance.rewards
    Output
                        date currency   quantity total.price  spot.rate transaction
      1  2021-02-19 00:00:00      CRO 1.36512341  0.23821404     0.1745     revenue
      2  2021-02-21 00:00:00      CRO 1.36945123  0.24033869     0.1755     revenue
      3  2021-04-15 16:04:21      BTC 0.00000023  0.01118720 48640.0000     revenue
      4  2021-04-18 00:00:00      CRO 1.36512310  0.27780255     0.2035     revenue
      5  2021-05-14 06:02:22      BTC 0.00000035  0.01737925 49655.0000     revenue
      6  2021-06-12 15:21:34      BTC 0.00000630  0.31922100 50670.0000     revenue
      7  2021-06-27 01:34:00      CRO 0.00100000  0.00023850     0.2385        sell
      8  2021-07-07 00:00:00      CRO 0.01512903  0.00000000     0.2435     revenue
      9  2021-07-13 00:00:00      CRO 0.05351230  0.00000000     0.2465     revenue
      10 2021-09-07 00:00:00      CRO 0.01521310  0.00000000     0.2745     revenue
         fees description                                          comment
      1     0      Reward Interest on 5000.00000000 at 10% APR (Completed)
      2     0      Reward Interest on 5000.00000000 at 10% APR (Completed)
      3     0      Reward                          BTC Supercharger reward
      4     0      Reward Interest on 5000.00000000 at 10% APR (Completed)
      5     0      Reward                          BTC Supercharger reward
      6     0      Reward                          BTC Supercharger reward
      7     0  Withdrawal                                             <NA>
      8     0      Reward                  Rebate on 0.18512341 CRO at 10%
      9     0      Reward                Rebate on 0.5231512346 CRO at 10%
      10    0      Reward                 Rebate on 0.155125123 CRO at 10%
         revenue.type       value     exchange   rate.source currency2 total.quantity
      1     interests 0.238214035 CDC.exchange coinmarketcap       CRO     1.36512341
      2     interests 0.240338691 CDC.exchange coinmarketcap       CRO     2.73457464
      3     interests 0.011187200 CDC.exchange coinmarketcap       BTC     0.00000023
      4     interests 0.277802551 CDC.exchange coinmarketcap       CRO     4.09969774
      5     interests 0.017379250 CDC.exchange coinmarketcap       BTC     0.00000058
      6     interests 0.319221000 CDC.exchange coinmarketcap       BTC     0.00000688
      7          <NA> 0.000238500 CDC.exchange coinmarketcap       CRO     4.09869774
      8       rebates 0.003683919 CDC.exchange coinmarketcap       CRO     4.11382677
      9       rebates 0.013190782 CDC.exchange coinmarketcap       CRO     4.16733907
      10      rebates 0.004175996 CDC.exchange coinmarketcap       CRO     4.18255217
                                            suploss.range quantity.60days
      1  2021-01-20 00:00:00 UTC--2021-03-21 00:00:00 UTC               0
      2  2021-01-22 00:00:00 UTC--2021-03-23 00:00:00 UTC               0
      3  2021-03-16 16:04:21 UTC--2021-05-15 16:04:21 UTC               0
      4  2021-03-19 00:00:00 UTC--2021-05-18 00:00:00 UTC               0
      5  2021-04-14 06:02:22 UTC--2021-06-13 06:02:22 UTC               0
      6  2021-05-13 15:21:34 UTC--2021-07-12 15:21:34 UTC               0
      7  2021-05-28 01:34:00 UTC--2021-07-27 01:34:00 UTC               0
      8  2021-06-07 00:00:00 UTC--2021-08-06 00:00:00 UTC               0
      9  2021-06-13 00:00:00 UTC--2021-08-12 00:00:00 UTC               0
      10 2021-08-08 00:00:00 UTC--2021-10-07 00:00:00 UTC               0
         share.left60 sup.loss.quantity sup.loss gains.uncorrected gains.sup
      1    2.73457464                 0    FALSE      0.0000000000        NA
      2    2.73457464                 0    FALSE      0.0000000000        NA
      3    0.00000058                 0    FALSE      0.0000000000        NA
      4    4.09969774                 0    FALSE      0.0000000000        NA
      5    0.00000688                 0    FALSE      0.0000000000        NA
      6    0.00000688                 0    FALSE      0.0000000000        NA
      7    4.16733907                 0    FALSE      0.0000540095        NA
      8    4.16733907                 0    FALSE      0.0000000000        NA
      9    4.16733907                 0    FALSE      0.0000000000        NA
      10   4.18255217                 0    FALSE      0.0000000000        NA
         gains.excess        gains        ACB     ACB.share
      1            NA           NA 0.23821404     0.1745000
      2            NA           NA 0.47855273     0.1750008
      3            NA           NA 0.01118720 48640.0000000
      4            NA           NA 0.75635528     0.1844905
      5            NA           NA 0.02856645 49252.5000000
      6            NA           NA 0.34778745 50550.5014535
      7            NA 0.0000540095 0.75617079     0.1844905
      8            NA           NA 0.75617079     0.1838120
      9            NA           NA 0.75617079     0.1814517
      10           NA           NA 0.75617079     0.1807917

# CDC wallet

    Code
      formatted.CDC.wallet
    Output
                       date currency quantity total.price spot.rate transaction fees
      1 2021-04-12 18:28:50      CRO 0.512510   0.1027583    0.2005     revenue    0
      2 2021-04-18 18:28:50      CRO 0.000200   0.0000407    0.2035        sell    0
      3 2021-04-23 18:51:53      CRO 1.656708   0.3412818    0.2060     revenue    0
      4 2021-04-25 18:51:53      CRO 0.000200   0.0000414    0.2070        sell    0
      5 2021-05-21 01:19:01      CRO 0.000200   0.0000440    0.2200        sell    0
      6 2021-06-25 04:11:53      CRO 0.000200   0.0000475    0.2375        sell    0
      7 2021-06-26 14:51:02      CRO 6.051235   1.4401939    0.2380     revenue    0
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
        revenue.type     value   exchange   rate.source currency2 total.quantity
      1      staking 0.1027583 CDC.wallet coinmarketcap       CRO       0.512510
      2         <NA> 0.0000407 CDC.wallet coinmarketcap       CRO       0.512310
      3      staking 0.3412818 CDC.wallet coinmarketcap       CRO       2.169018
      4         <NA> 0.0000414 CDC.wallet coinmarketcap       CRO       2.168818
      5         <NA> 0.0000440 CDC.wallet coinmarketcap       CRO       2.168618
      6         <NA> 0.0000475 CDC.wallet coinmarketcap       CRO       2.168418
      7      staking 1.4401939 CDC.wallet coinmarketcap       CRO       8.219653
                                           suploss.range quantity.60days share.left60
      1 2021-03-13 18:28:50 UTC--2021-05-12 18:28:50 UTC               0     2.168818
      2 2021-03-19 18:28:50 UTC--2021-05-18 18:28:50 UTC               0     2.168818
      3 2021-03-24 18:51:53 UTC--2021-05-23 18:51:53 UTC               0     2.168618
      4 2021-03-26 18:51:53 UTC--2021-05-25 18:51:53 UTC               0     2.168618
      5 2021-04-21 01:19:01 UTC--2021-06-20 01:19:01 UTC               0     2.168618
      6 2021-05-26 04:11:53 UTC--2021-07-25 04:11:53 UTC               0     8.219653
      7 2021-05-27 14:51:02 UTC--2021-07-26 14:51:02 UTC               0     8.219653
        sup.loss.quantity sup.loss gains.uncorrected gains.sup gains.excess
      1                 0    FALSE   0.0000000000000        NA           NA
      2                 0    FALSE   0.0000006000000        NA           NA
      3                 0    FALSE   0.0000000000000        NA           NA
      4                 0    FALSE   0.0000004598139        NA           NA
      5                 0    FALSE   0.0000030598139        NA           NA
      6                 0    FALSE   0.0000065598139        NA           NA
      7                 0    FALSE   0.0000000000000        NA           NA
                  gains       ACB ACB.share
      1              NA 0.1027583 0.2005000
      2 0.0000006000000 0.1027182 0.2005000
      3              NA 0.4439999 0.2047009
      4 0.0000004598139 0.4439590 0.2047009
      5 0.0000030598139 0.4439180 0.2047009
      6 0.0000065598139 0.4438771 0.2047009
      7              NA 1.8840710 0.2292154

# uphold

    Code
      formatted.uphold
    Output
                        date currency    quantity total.price   spot.rate transaction
      1  2021-01-07 02:40:31      BAT  1.59081275    0.000000   0.9060000     revenue
      2  2021-02-09 14:26:49      BAT 12.69812163    0.000000   0.9390000     revenue
      3  2021-03-06 21:32:36      BAT  0.37591275    0.000000   0.9640000     revenue
      4  2021-03-07 21:46:57      BAT 52.59871206   38.547260   0.7328556        sell
      5  2021-03-07 21:46:57      LTC  0.24129740   38.547260 159.7500000         buy
      6  2021-03-07 21:54:09      LTC  0.00300000    0.479250 159.7500000        sell
      7  2021-04-05 12:22:00      BAT  8.52198415    0.000000   0.9940000     revenue
      8  2021-04-06 03:41:42      LTC  0.00300000    0.492750 164.2500000        sell
      9  2021-04-06 04:47:00      BAT  8.52198415    5.922824   0.6950053        sell
      10 2021-04-06 04:47:00      LTC  0.03605981    5.922824 164.2500000         buy
      11 2021-05-11 07:12:24      BAT  0.47521985    0.000000   1.0300000     revenue
      12 2021-06-09 04:52:23      BAT  0.67207415    0.000000   1.0590000     revenue
         fees description         comment revenue.type      value exchange
      1     0          in            <NA>     airdrops  1.4412764   uphold
      2     0          in            <NA>     airdrops 11.9235362   uphold
      3     0          in            <NA>     airdrops  0.3623799   uphold
      4     0       trade         BAT-LTC         <NA> 38.5472597   uphold
      5     0       trade         BAT-LTC         <NA> 38.5472597   uphold
      6     0         out withdrawal fees         <NA>  0.4792500   uphold
      7     0          in            <NA>     airdrops  8.4708522   uphold
      8     0         out withdrawal fees         <NA>  0.4927500   uphold
      9     0       trade         BAT-LTC         <NA>  5.9228241   uphold
      10    0       trade         BAT-LTC         <NA>  5.9228241   uphold
      11    0          in            <NA>     airdrops  0.4894764   uphold
      12    0          in            <NA>     airdrops  0.7117265   uphold
                       rate.source currency2 total.quantity
      1              coinmarketcap       BAT      1.5908128
      2              coinmarketcap       BAT     14.2889344
      3              coinmarketcap       BAT     14.6648471
      4  coinmarketcap (buy price)       BAT    -37.9338649
      5              coinmarketcap       LTC      0.2412974
      6              coinmarketcap       LTC      0.2382974
      7              coinmarketcap       BAT    -29.4118808
      8              coinmarketcap       LTC      0.2352974
      9  coinmarketcap (buy price)       BAT    -37.9338649
      10             coinmarketcap       LTC      0.2713572
      11             coinmarketcap       BAT    -37.4586451
      12             coinmarketcap       BAT    -36.7865709
                                            suploss.range quantity.60days
      1  2020-12-08 02:40:31 UTC--2021-02-06 02:40:31 UTC       0.0000000
      2  2021-01-10 14:26:49 UTC--2021-03-11 14:26:49 UTC       0.0000000
      3  2021-02-04 21:32:36 UTC--2021-04-05 21:32:36 UTC       0.0000000
      4  2021-02-05 21:46:57 UTC--2021-04-06 21:46:57 UTC       0.0000000
      5  2021-02-05 21:46:57 UTC--2021-04-06 21:46:57 UTC       0.2773572
      6  2021-02-05 21:54:09 UTC--2021-04-06 21:54:09 UTC       0.2773572
      7  2021-03-06 12:22:00 UTC--2021-05-05 12:22:00 UTC       0.0000000
      8  2021-03-07 03:41:42 UTC--2021-05-06 03:41:42 UTC       0.2773572
      9  2021-03-07 04:47:00 UTC--2021-05-06 04:47:00 UTC       0.0000000
      10 2021-03-07 04:47:00 UTC--2021-05-06 04:47:00 UTC       0.2773572
      11 2021-04-11 07:12:24 UTC--2021-06-10 07:12:24 UTC       0.0000000
      12 2021-05-10 04:52:23 UTC--2021-07-09 04:52:23 UTC       0.0000000
         share.left60 sup.loss.quantity sup.loss gains.uncorrected gains.sup
      1     1.5908128             0.000    FALSE          0.000000        NA
      2   -37.9338649             0.000    FALSE          0.000000        NA
      3   -29.4118808             0.000    FALSE          0.000000        NA
      4   -37.9338649             0.000    FALSE         38.547260        NA
      5     0.2713572             0.000    FALSE          0.000000        NA
      6     0.2713572             0.003    FALSE          0.000000        NA
      7   -37.9338649             0.000    FALSE          0.000000        NA
      8     0.2713572             0.003    FALSE          0.013500        NA
      9   -37.9338649             0.000    FALSE          5.922824        NA
      10    0.2713572             0.000    FALSE          0.000000        NA
      11  -36.7865709             0.000    FALSE          0.000000        NA
      12  -36.7865709             0.000    FALSE          0.000000        NA
         gains.excess     gains      ACB ACB.share
      1            NA        NA  0.00000     0.000
      2            NA        NA  0.00000     0.000
      3            NA        NA  0.00000     0.000
      4            NA 38.547260  0.00000     0.000
      5            NA        NA 38.54726   159.750
      6            NA        NA 38.06801   159.750
      7            NA        NA  0.00000     0.000
      8            NA  0.013500 37.58876   159.750
      9            NA  5.922824  0.00000     0.000
      10           NA        NA 43.51158   160.348
      11           NA        NA  0.00000     0.000
      12           NA        NA  0.00000     0.000

# gemini

    Code
      formatted.gemini
    Output
                        date currency        quantity total.price  spot.rate
      1  2021-04-08 22:22:22      LTC  1.000000000000 286.0000000   286.0000
      2  2021-04-09 22:50:55      BTC  0.000966278356  46.7968608 48430.0000
      3  2021-04-09 22:50:55      LTC  0.246690598398  46.7968608   189.6986
      4  2021-04-09 22:53:57      BTC  0.000006051912   0.2930941 48430.0000
      5  2021-04-09 22:53:57      LTC  0.001640820000   0.2930941   178.6266
      6  2021-04-09 23:20:53      BAT 48.719519585106  48.6220805     0.9980
      7  2021-04-09 23:20:53      BTC  0.000950730015  48.6220805 51141.8381
      8  2021-04-10 23:22:04      BTC  0.000285025578   0.0000000 48465.0000
      9  2021-05-08 16:14:54      BAT  2.833934780210   0.0000000     1.0270
      10 2021-05-16 12:55:02      BAT  3.085288331282   0.0000000     1.0350
      11 2021-05-16 13:35:19      BAT  5.007481461482   0.0000000     1.0350
      12 2021-06-18 01:38:54      BAT  6.834322542857   0.0000000     1.0680
         transaction   fees.quantity fees.currency        fees
      1          buy              NA          <NA> 0.000000000
      2          buy 0.0000023034086           BTC 0.111554081
      3         sell              NA           LTC 0.000000000
      4          buy 0.0000000365181           BTC 0.001768572
      5         sell              NA           LTC 0.000000000
      6          buy              NA           BAT 0.000000000
      7         sell 0.0000018142411           BTC 0.087863695
      8      revenue              NA          <NA> 0.000000000
      9      revenue              NA          <NA> 0.000000000
      10     revenue              NA          <NA> 0.000000000
      11     revenue              NA          <NA> 0.000000000
      12     revenue              NA          <NA> 0.000000000
                             description               comment revenue.type
      1  fake transaction for format_ACB                  <NA>         <NA>
      2                           LTCBTC                Market         <NA>
      3                           LTCBTC                Market         <NA>
      4                           LTCBTC                 Limit         <NA>
      5                           LTCBTC                 Limit         <NA>
      6                           BATBTC                 Limit         <NA>
      7                           BATBTC                 Limit         <NA>
      8                           Credit Administrative Credit    referrals
      9                           Credit Administrative Credit    referrals
      10                          Credit               Deposit     airdrops
      11                          Credit               Deposit     airdrops
      12                          Credit               Deposit     airdrops
               value exchange               rate.source currency2 total.quantity
      1  286.0000000   gemini                      fake       LTC  1.00000000000
      2   46.7968608   gemini             coinmarketcap       BTC  0.00096627836
      3   46.7968608   gemini coinmarketcap (buy price)       LTC  0.75330940160
      4    0.2930941   gemini             coinmarketcap       BTC  0.00097233027
      5    0.2930941   gemini coinmarketcap (buy price)       LTC  0.75166858160
      6   48.6220805   gemini             coinmarketcap       BAT 48.71951958511
      7   48.6220805   gemini coinmarketcap (buy price)       BTC  0.00002160025
      8   13.8137646   gemini             coinmarketcap       BTC  0.00030662583
      9    2.9104510   gemini             coinmarketcap       BAT 51.55345436532
      10   3.1932734   gemini             coinmarketcap       BAT 54.63874269660
      11   5.1827433   gemini             coinmarketcap       BAT 59.64622415808
      12   7.2990565   gemini             coinmarketcap       BAT 66.48054670094
                                            suploss.range quantity.60days
      1  2021-03-09 22:22:22 UTC--2021-05-08 22:22:22 UTC    1.0000000000
      2  2021-03-10 22:50:55 UTC--2021-05-09 22:50:55 UTC    0.0009723303
      3  2021-03-10 22:50:55 UTC--2021-05-09 22:50:55 UTC    1.0000000000
      4  2021-03-10 22:53:57 UTC--2021-05-09 22:53:57 UTC    0.0009723303
      5  2021-03-10 22:53:57 UTC--2021-05-09 22:53:57 UTC    1.0000000000
      6  2021-03-10 23:20:53 UTC--2021-05-09 23:20:53 UTC   48.7195195851
      7  2021-03-10 23:20:53 UTC--2021-05-09 23:20:53 UTC    0.0009723303
      8  2021-03-11 23:22:04 UTC--2021-05-10 23:22:04 UTC    0.0009723303
      9  2021-04-08 16:14:54 UTC--2021-06-07 16:14:54 UTC   48.7195195851
      10 2021-04-16 12:55:02 UTC--2021-06-15 12:55:02 UTC    0.0000000000
      11 2021-04-16 13:35:19 UTC--2021-06-15 13:35:19 UTC    0.0000000000
      12 2021-05-19 01:38:54 UTC--2021-07-18 01:38:54 UTC    0.0000000000
          share.left60 sup.loss.quantity sup.loss gains.uncorrected  gains.sup
      1   0.7516685816        0.00000000    FALSE          0.000000         NA
      2   0.0003066258        0.00000000    FALSE          0.000000         NA
      3   0.7516685816        0.24669060     TRUE        -23.756650 -23.756650
      4   0.0003066258        0.00000000    FALSE          0.000000         NA
      5   0.7516685816        0.00164082     TRUE         -0.227926  -0.227926
      6  51.5534543653        0.00000000    FALSE          0.000000         NA
      7   0.0003066258        0.00095073    FALSE          2.379557         NA
      8   0.0003066258        0.00000000    FALSE          0.000000         NA
      9  59.6462241581        0.00000000    FALSE          0.000000         NA
      10 59.6462241581        0.00000000    FALSE          0.000000         NA
      11 59.6462241581        0.00000000    FALSE          0.000000         NA
      12 66.4805467009        0.00000000    FALSE          0.000000         NA
         gains.excess    gains        ACB     ACB.share
      1            NA       NA 286.000000   286.0000000
      2            NA       NA  46.908415 48545.4471486
      3            NA       NA 239.203139   317.5363785
      4            NA       NA  47.203277 48546.5474904
      5            NA       NA 238.910045   317.8396051
      6            NA       NA  48.622081     0.9980000
      7            NA 2.379557   1.048618 48546.5474904
      8            NA       NA   1.048618  3419.8608193
      9            NA       NA  48.622081     0.9431391
      10           NA       NA  48.622081     0.8898829
      11           NA       NA  48.622081     0.8151745
      12           NA       NA  48.622081     0.7313731

# exodus

    Code
      formatted.exodus
    Output
                       date currency  quantity total.price spot.rate transaction fees
      1 2021-04-25 22:06:11      LTC 0.0028860   0.4952376   171.600         buy    0
      2 2021-04-25 23:08:12      ADA 0.3564820   0.5304452     1.488         buy    0
      3 2021-05-12 12:15:28      BTC 0.0001006   5.0974020 50670.000         buy    0
      4 2021-05-12 22:31:35      ETH 0.0029000   6.8643000  2367.000         buy    0
      5 2021-05-25 22:06:11      LTC 0.0014430   0.2476188   171.600        sell    0
      6 2021-05-25 23:08:12      ADA 0.1782410   0.2652226     1.488        sell    0
      7 2021-06-12 12:15:28      BTC 0.0000503   2.5487010 50670.000        sell    0
      8 2021-06-12 22:31:35      ETH 0.0014500   3.4321500  2367.000        sell    0
                            description revenue.type     value exchange   rate.source
      1 fake transaction for format_ACB         <NA> 0.4952376   exodus coinmarketcap
      2 fake transaction for format_ACB         <NA> 0.5304452   exodus coinmarketcap
      3 fake transaction for format_ACB         <NA> 5.0974020   exodus coinmarketcap
      4 fake transaction for format_ACB         <NA> 6.8643000   exodus coinmarketcap
      5                      withdrawal         <NA> 0.2476188   exodus coinmarketcap
      6                      withdrawal         <NA> 0.2652226   exodus coinmarketcap
      7                      withdrawal         <NA> 2.5487010   exodus coinmarketcap
      8                      withdrawal         <NA> 3.4321500   exodus coinmarketcap
        currency2 total.quantity                                    suploss.range
      1       LTC      0.0028860 2021-03-26 22:06:11 UTC--2021-05-25 22:06:11 UTC
      2       ADA      0.3564820 2021-03-26 23:08:12 UTC--2021-05-25 23:08:12 UTC
      3       BTC      0.0001006 2021-04-12 12:15:28 UTC--2021-06-11 12:15:28 UTC
      4       ETH      0.0029000 2021-04-12 22:31:35 UTC--2021-06-11 22:31:35 UTC
      5       LTC      0.0014430 2021-04-25 22:06:11 UTC--2021-06-24 22:06:11 UTC
      6       ADA      0.1782410 2021-04-25 23:08:12 UTC--2021-06-24 23:08:12 UTC
      7       BTC      0.0000503 2021-05-13 12:15:28 UTC--2021-07-12 12:15:28 UTC
      8       ETH      0.0014500 2021-05-13 22:31:35 UTC--2021-07-12 22:31:35 UTC
        quantity.60days share.left60 sup.loss.quantity sup.loss gains.uncorrected
      1       0.0028860    0.0014430          0.000000    FALSE                 0
      2       0.3564820    0.1782410          0.000000    FALSE                 0
      3       0.0001006    0.0001006          0.000000    FALSE                 0
      4       0.0029000    0.0029000          0.000000    FALSE                 0
      5       0.0028860    0.0014430          0.001443    FALSE                 0
      6       0.3564820    0.1782410          0.178241    FALSE                 0
      7       0.0000000    0.0000503          0.000000    FALSE                 0
      8       0.0000000    0.0014500          0.000000    FALSE                 0
        gains.sup gains.excess gains       ACB ACB.share
      1        NA           NA    NA 0.4952376   171.600
      2        NA           NA    NA 0.5304452     1.488
      3        NA           NA    NA 5.0974020 50670.000
      4        NA           NA    NA 6.8643000  2367.000
      5        NA           NA    NA 0.2476188   171.600
      6        NA           NA    NA 0.2652226     1.488
      7        NA           NA    NA 2.5487010 50670.000
      8        NA           NA    NA 3.4321500  2367.000

# binance

    Code
      formatted.binance
    Output
                        date currency   quantity   total.price  spot.rate transaction
      1  2021-03-08 22:22:22      ETH 1.00000000 3098.13753900 3098.13754         buy
      2  2021-03-08 22:22:22     USDC 5.77124200    7.73652300    1.34053         buy
      3  2021-05-29 17:07:20      ETH 0.19521000  436.01040000 2233.54541        sell
      4  2021-05-29 17:07:20      ETH 0.14123140  415.36362000 2941.01468        sell
      5  2021-05-29 17:07:20      ETH 0.11240000  249.89664000 2223.27972        sell
      6  2021-05-29 17:07:20      ETH 0.10512900  244.69620000 2327.58040        sell
      7  2021-05-29 17:07:20      ETH 0.00899120   51.66000000 5745.61794        sell
      8  2021-05-29 17:07:20      ETH 0.00612410   46.49400000 7591.97270        sell
      9  2021-05-29 17:07:20      LTC 2.53200000  436.01040000  172.20000         buy
      10 2021-05-29 17:07:20      LTC 2.41210000  415.36362000  172.20000         buy
      11 2021-05-29 17:07:20      LTC 1.45120000  249.89664000  172.20000         buy
      12 2021-05-29 17:07:20      LTC 1.42100000  244.69620000  172.20000         buy
      13 2021-05-29 17:07:20      LTC 0.30000000   51.66000000  172.20000         buy
      14 2021-05-29 17:07:20      LTC 0.27000000   46.49400000  172.20000         buy
      15 2021-05-29 17:07:20      LTC 0.00202500    0.00000000  172.20000     revenue
      16 2021-05-29 17:07:20      LTC 0.00127520    0.00000000  172.20000     revenue
      17 2021-05-29 17:07:20      LTC 0.00113100    0.00000000  172.20000     revenue
      18 2021-05-29 17:07:20      LTC 0.00049230    0.00000000  172.20000     revenue
      19 2021-05-29 17:07:20      LTC 0.00007000    0.00000000  172.20000     revenue
      20 2021-05-29 17:07:20      LTC 0.00005000    0.00000000  172.20000     revenue
      21 2021-05-29 18:12:55      ETH 0.44124211 1022.79921098 2318.00000         buy
      22 2021-05-29 18:12:55      ETH 0.42124000  976.43432000 2318.00000         buy
      23 2021-05-29 18:12:55      ETH 0.00021470    0.00000000 2318.00000     revenue
      24 2021-05-29 18:12:55      ETH 0.00009251    0.00000000 2318.00000     revenue
      25 2021-05-29 18:12:55      LTC 1.60000000 1022.79921098  639.24951        sell
      26 2021-05-29 18:12:55      LTC 1.23000000  976.43432000  793.84904        sell
      27 2021-11-05 04:32:23     BUSD 0.10512330    0.13302302    1.26540     revenue
      28 2022-11-17 11:54:25     ETHW 0.00012050    0.00309685   25.70000     revenue
      29 2022-11-27 08:05:35     BUSD 5.77124200    7.41460316    1.28475         buy
      30 2022-11-27 08:05:35     USDC 5.77124200    7.41460316    1.28475        sell
         fees.quantity fees.currency      fees                     description
      1             NA          <NA> 0.0000000 fake transaction for format_ACB
      2             NA          <NA> 0.0000000 fake transaction for format_ACB
      3             NA          <NA> 0.0000000                             Buy
      4             NA          <NA> 0.0000000                             Buy
      5             NA          <NA> 0.0000000                             Buy
      6             NA          <NA> 0.0000000                             Buy
      7             NA          <NA> 0.0000000                             Buy
      8             NA          <NA> 0.0000000                             Buy
      9    0.007421000           LTC 1.2778962                             Buy
      10   0.005812000           LTC 1.0008264                             Buy
      11   0.005421000           LTC 0.9334962                             Buy
      12   0.003123000           LTC 0.5377806                             Buy
      13   0.000300000           LTC 0.0516600                             Buy
      14   0.000210000           LTC 0.0361620                             Buy
      15            NA          <NA> 0.0000000               Referral Kickback
      16            NA          <NA> 0.0000000               Referral Kickback
      17            NA          <NA> 0.0000000               Referral Kickback
      18            NA          <NA> 0.0000000               Referral Kickback
      19            NA          <NA> 0.0000000               Referral Kickback
      20            NA          <NA> 0.0000000               Referral Kickback
      21   0.002123124           ETH 4.9214014                            Sell
      22   0.000612400           ETH 1.4195432                            Sell
      23            NA          <NA> 0.0000000               Referral Kickback
      24            NA          <NA> 0.0000000               Referral Kickback
      25            NA          <NA> 0.0000000                            Sell
      26            NA          <NA> 0.0000000                            Sell
      27            NA          <NA> 0.0000000   Simple Earn Flexible Interest
      28            NA          <NA> 0.0000000                    Distribution
      29            NA          <NA> 0.0000000     Stablecoins Auto-Conversion
      30            NA          <NA> 0.0000000     Stablecoins Auto-Conversion
         comment revenue.type         value exchange               rate.source
      1     <NA>         <NA> 3098.13753900  binance                      fake
      2     <NA>         <NA>    7.73652300  binance                      fake
      3     Spot         <NA>  436.01040000  binance coinmarketcap (buy price)
      4     Spot         <NA>  415.36362000  binance coinmarketcap (buy price)
      5     Spot         <NA>  249.89664000  binance coinmarketcap (buy price)
      6     Spot         <NA>  244.69620000  binance coinmarketcap (buy price)
      7     Spot         <NA>   51.66000000  binance coinmarketcap (buy price)
      8     Spot         <NA>   46.49400000  binance coinmarketcap (buy price)
      9     Spot         <NA>  436.01040000  binance             coinmarketcap
      10    Spot         <NA>  415.36362000  binance             coinmarketcap
      11    Spot         <NA>  249.89664000  binance             coinmarketcap
      12    Spot         <NA>  244.69620000  binance             coinmarketcap
      13    Spot         <NA>   51.66000000  binance             coinmarketcap
      14    Spot         <NA>   46.49400000  binance             coinmarketcap
      15    Spot      rebates    0.34870500  binance             coinmarketcap
      16    Spot      rebates    0.21958944  binance             coinmarketcap
      17    Spot      rebates    0.19475820  binance             coinmarketcap
      18    Spot      rebates    0.08477406  binance             coinmarketcap
      19    Spot      rebates    0.01205400  binance             coinmarketcap
      20    Spot      rebates    0.00861000  binance             coinmarketcap
      21    Spot         <NA> 1022.79921098  binance             coinmarketcap
      22    Spot         <NA>  976.43432000  binance             coinmarketcap
      23    Spot      rebates    0.49767460  binance             coinmarketcap
      24    Spot      rebates    0.21443818  binance             coinmarketcap
      25    Spot         <NA> 1022.79921098  binance coinmarketcap (buy price)
      26    Spot         <NA>  976.43432000  binance coinmarketcap (buy price)
      27    Earn    interests    0.13302302  binance             coinmarketcap
      28    Spot        forks    0.00309685  binance             coinmarketcap
      29    Spot         <NA>    7.41460316  binance             coinmarketcap
      30    Spot         <NA>    7.41460316  binance             coinmarketcap
         currency2 total.quantity                                    suploss.range
      1        ETH      1.0000000 2021-02-06 22:22:22 UTC--2021-04-07 22:22:22 UTC
      2       USDC      5.7712420 2021-02-06 22:22:22 UTC--2021-04-07 22:22:22 UTC
      3        ETH      0.8047900 2021-04-29 17:07:20 UTC--2021-06-28 17:07:20 UTC
      4        ETH      0.6635586 2021-04-29 17:07:20 UTC--2021-06-28 17:07:20 UTC
      5        ETH      0.5511586 2021-04-29 17:07:20 UTC--2021-06-28 17:07:20 UTC
      6        ETH      0.4460296 2021-04-29 17:07:20 UTC--2021-06-28 17:07:20 UTC
      7        ETH      0.4370384 2021-04-29 17:07:20 UTC--2021-06-28 17:07:20 UTC
      8        ETH      0.4309143 2021-04-29 17:07:20 UTC--2021-06-28 17:07:20 UTC
      9        LTC      2.5320000 2021-04-29 17:07:20 UTC--2021-06-28 17:07:20 UTC
      10       LTC      4.9441000 2021-04-29 17:07:20 UTC--2021-06-28 17:07:20 UTC
      11       LTC      6.3953000 2021-04-29 17:07:20 UTC--2021-06-28 17:07:20 UTC
      12       LTC      7.8163000 2021-04-29 17:07:20 UTC--2021-06-28 17:07:20 UTC
      13       LTC      8.1163000 2021-04-29 17:07:20 UTC--2021-06-28 17:07:20 UTC
      14       LTC      8.3863000 2021-04-29 17:07:20 UTC--2021-06-28 17:07:20 UTC
      15       LTC      8.3883250 2021-04-29 17:07:20 UTC--2021-06-28 17:07:20 UTC
      16       LTC      8.3896002 2021-04-29 17:07:20 UTC--2021-06-28 17:07:20 UTC
      17       LTC      8.3907312 2021-04-29 17:07:20 UTC--2021-06-28 17:07:20 UTC
      18       LTC      8.3912235 2021-04-29 17:07:20 UTC--2021-06-28 17:07:20 UTC
      19       LTC      8.3912935 2021-04-29 17:07:20 UTC--2021-06-28 17:07:20 UTC
      20       LTC      8.3913435 2021-04-29 17:07:20 UTC--2021-06-28 17:07:20 UTC
      21       ETH      0.8721564 2021-04-29 18:12:55 UTC--2021-06-28 18:12:55 UTC
      22       ETH      1.2933964 2021-04-29 18:12:55 UTC--2021-06-28 18:12:55 UTC
      23       ETH      1.2936111 2021-04-29 18:12:55 UTC--2021-06-28 18:12:55 UTC
      24       ETH      1.2937036 2021-04-29 18:12:55 UTC--2021-06-28 18:12:55 UTC
      25       LTC      6.7913435 2021-04-29 18:12:55 UTC--2021-06-28 18:12:55 UTC
      26       LTC      5.5613435 2021-04-29 18:12:55 UTC--2021-06-28 18:12:55 UTC
      27      BUSD      0.1051233 2021-10-06 04:32:23 UTC--2021-12-05 04:32:23 UTC
      28      ETHW      0.0001205 2022-10-18 11:54:25 UTC--2022-12-17 11:54:25 UTC
      29      BUSD      5.8763653 2022-10-28 08:05:35 UTC--2022-12-27 08:05:35 UTC
      30      USDC      0.0000000 2022-10-28 08:05:35 UTC--2022-12-27 08:05:35 UTC
         quantity.60days share.left60 sup.loss.quantity sup.loss gains.uncorrected
      1        1.0000000    1.0000000         0.0000000    FALSE         0.0000000
      2        5.7712420    5.7712420         0.0000000    FALSE         0.0000000
      3        0.8624821    1.2937036         0.1952100     TRUE      -168.7770290
      4        0.8624821    1.2937036         0.1412314     TRUE       -51.8091118
      5        0.8624821    1.2937036         0.1124000     TRUE      -130.6819849
      6        0.8624821    1.2937036         0.1051290     TRUE      -136.1898428
      7        0.8624821    1.2937036         0.0089912    FALSE        16.3392119
      8        0.8624821    1.2937036         0.0061241    FALSE        22.4362503
      9        8.3863000    5.5613435         0.0000000    FALSE         0.0000000
      10       8.3863000    5.5613435         0.0000000    FALSE         0.0000000
      11       8.3863000    5.5613435         0.0000000    FALSE         0.0000000
      12       8.3863000    5.5613435         0.0000000    FALSE         0.0000000
      13       8.3863000    5.5613435         0.0000000    FALSE         0.0000000
      14       8.3863000    5.5613435         0.0000000    FALSE         0.0000000
      15       8.3863000    5.5613435         0.0000000    FALSE         0.0000000
      16       8.3863000    5.5613435         0.0000000    FALSE         0.0000000
      17       8.3863000    5.5613435         0.0000000    FALSE         0.0000000
      18       8.3863000    5.5613435         0.0000000    FALSE         0.0000000
      19       8.3863000    5.5613435         0.0000000    FALSE         0.0000000
      20       8.3863000    5.5613435         0.0000000    FALSE         0.0000000
      21       0.8624821    1.2937036         0.0000000    FALSE         0.0000000
      22       0.8624821    1.2937036         0.0000000    FALSE         0.0000000
      23       0.8624821    1.2937036         0.0000000    FALSE         0.0000000
      24       0.8624821    1.2937036         0.0000000    FALSE         0.0000000
      25       8.3863000    5.5613435         1.6000000    FALSE       746.7130407
      26       8.3863000    5.5613435         1.2300000    FALSE       764.1930766
      27       0.0000000    0.1051233         0.0000000    FALSE         0.0000000
      28       0.0000000    0.0001205         0.0000000    FALSE         0.0000000
      29       5.7712420    5.8763653         0.0000000    FALSE         0.0000000
      30       0.0000000    0.0000000         0.0000000    FALSE        -0.3219198
          gains.sup gains.excess       gains           ACB   ACB.share
      1          NA           NA          NA 3098.13753900 3098.137539
      2          NA           NA          NA    7.73652300    1.340530
      3  -168.77703           NA          NA 2662.12713900 3307.853153
      4   -51.80911           NA          NA 2246.76351900 3385.930827
      5  -130.68198           NA          NA 1996.86687900 3623.034965
      6  -136.18984           NA          NA 1752.17067900 3928.373092
      7          NA           NA  16.3392119 1716.84989085 3928.373092
      8          NA           NA  22.4362503 1692.79214120 3928.373092
      9          NA           NA          NA  437.28829620  172.704698
      10         NA           NA          NA  853.65274260  172.660897
      11         NA           NA          NA 1104.48287880  172.702278
      12         NA           NA          NA 1349.71685940  172.679767
      13         NA           NA          NA 1401.42851940  172.668398
      14         NA           NA          NA 1447.95868140  172.657630
      15         NA           NA          NA 1447.95868140  172.615949
      16         NA           NA          NA 1447.95868140  172.589712
      17         NA           NA          NA 1447.95868140  172.566448
      18         NA           NA          NA 1447.95868140  172.556324
      19         NA           NA          NA 1447.95868140  172.554885
      20         NA           NA          NA 1447.95868140  172.553856
      21         NA           NA          NA 2720.51275361 3119.294570
      22         NA           NA          NA 3698.36661681 2859.422361
      23         NA           NA          NA 3698.36661681 2858.947784
      24         NA           NA          NA 3698.36661681 2858.743347
      25         NA           NA 746.7130407 1171.87251114  172.553856
      26         NA           NA 764.1930766  959.63126775  172.553856
      27         NA           NA          NA    0.13302302    1.265400
      28         NA           NA          NA    0.00309685   25.700000
      29         NA           NA          NA    7.54762618    1.284404
      30         NA           NA  -0.3219198    0.00000000    0.000000

# binance withdrawals

    Code
      formatted.binance.withdrawals
    Output
                       date currency quantity total.price spot.rate transaction fees
      1 2021-03-28 17:13:50      LTC 0.002000   0.3351000    167.55         buy    0
      2 2021-03-28 18:15:14      ETH 0.000142   0.3137490   2209.50         buy    0
      3 2021-04-06 19:55:52      ETH 0.000124   0.2774500   2237.50         buy    0
      4 2021-04-28 17:13:50      LTC 0.001000   0.1675500    167.55        sell    0
      5 2021-04-28 18:15:14      ETH 0.000071   0.1568745   2209.50        sell    0
      6 2021-05-06 19:55:52      ETH 0.000062   0.1387250   2237.50        sell    0
                            description exchange   rate.source currency2
      1 fake transaction for format_ACB  binance coinmarketcap       LTC
      2 fake transaction for format_ACB  binance coinmarketcap       ETH
      3 fake transaction for format_ACB  binance coinmarketcap       ETH
      4                 Withdrawal fees  binance coinmarketcap       LTC
      5                 Withdrawal fees  binance coinmarketcap       ETH
      6                 Withdrawal fees  binance coinmarketcap       ETH
        total.quantity                                    suploss.range
      1       0.002000 2021-02-26 17:13:50 UTC--2021-04-27 17:13:50 UTC
      2       0.000142 2021-02-26 18:15:14 UTC--2021-04-27 18:15:14 UTC
      3       0.000266 2021-03-07 19:55:52 UTC--2021-05-06 19:55:52 UTC
      4       0.001000 2021-03-29 17:13:50 UTC--2021-05-28 17:13:50 UTC
      5       0.000195 2021-03-29 18:15:14 UTC--2021-05-28 18:15:14 UTC
      6       0.000133 2021-04-06 19:55:52 UTC--2021-06-05 19:55:52 UTC
        quantity.60days share.left60 sup.loss.quantity sup.loss gains.uncorrected
      1        0.002000     0.002000          0.000000    FALSE      0.0000000000
      2        0.000266     0.000266          0.000000    FALSE      0.0000000000
      3        0.000266     0.000133          0.000000    FALSE      0.0000000000
      4        0.000000     0.001000          0.000000    FALSE      0.0000000000
      5        0.000124     0.000133          0.000071     TRUE     -0.0009267368
      6        0.000124     0.000133          0.000062    FALSE      0.0006320821
            gains.sup gains.excess        gains       ACB ACB.share
      1            NA           NA           NA 0.3351000   167.550
      2            NA           NA           NA 0.3137490  2209.500
      3            NA           NA           NA 0.5911990  2222.553
      4            NA           NA           NA 0.1675500   167.550
      5 -0.0009267368           NA           NA 0.4343245  2227.305
      6            NA           NA 0.0006320821 0.2962316  2227.305

# CDC exchange trades

    Code
      formatted.CDC.exchange.trades
    Output
                        date currency   quantity total.price spot.rate transaction
      1  2021-03-08 22:22:22      ETH     1.0000 3098.137539 3098.1375         buy
      2  2021-12-24 15:34:45      CRO 13260.1300 4355.952705    0.3285         buy
      3  2021-12-24 15:34:45      CRO  3555.9000 1168.113150    0.3285         buy
      4  2021-12-24 15:34:45      CRO  1781.7400  585.301590    0.3285         buy
      5  2021-12-24 15:34:45      CRO    26.8500    8.820225    0.3285         buy
      6  2021-12-24 15:34:45      CRO    26.6700    8.761095    0.3285         buy
      7  2021-12-24 15:34:45      CRO    17.7800    5.840730    0.3285         buy
      8  2021-12-24 15:34:45      CRO    17.7800    5.840730    0.3285         buy
      9  2021-12-24 15:34:45      ETH     2.0932 4355.952705 2081.0017        sell
      10 2021-12-24 15:34:45      ETH     0.5600 1168.113150 2085.9163        sell
      11 2021-12-24 15:34:45      ETH     0.2800  585.301590 2090.3628        sell
      12 2021-12-24 15:34:45      ETH     0.0042    8.820225 2100.0536        sell
      13 2021-12-24 15:34:45      ETH     0.0042    8.761095 2085.9750        sell
      14 2021-12-24 15:34:45      ETH     0.0028    5.840730 2085.9750        sell
      15 2021-12-24 15:34:45      ETH     0.0028    5.840730 2085.9750        sell
         fees.quantity fees.currency        fees                     description
      1             NA          <NA>  0.00000000 fake transaction for format_ACB
      2    53.04052463           CRO 17.42381234                             BUY
      3    14.22359680           CRO  4.67245155                             BUY
      4     7.12697440           CRO  2.34121109                             BUY
      5     0.10741385           CRO  0.03528545                             BUY
      6     0.10667563           CRO  0.03504294                             BUY
      7     0.07111821           CRO  0.02336233                             BUY
      8     0.07111810           CRO  0.02336230                             BUY
      9             NA          <NA>  0.00000000                            SELL
      10            NA          <NA>  0.00000000                            SELL
      11            NA          <NA>  0.00000000                            SELL
      12            NA          <NA>  0.00000000                            SELL
      13            NA          <NA>  0.00000000                            SELL
      14            NA          <NA>  0.00000000                            SELL
      15            NA          <NA>  0.00000000                            SELL
         comment     exchange               rate.source currency2 total.quantity
      1     <NA> CDC.exchange                      fake       ETH         1.0000
      2  ETH_CRO CDC.exchange             coinmarketcap       CRO     13260.1300
      3  ETH_CRO CDC.exchange             coinmarketcap       CRO     16816.0300
      4  ETH_CRO CDC.exchange             coinmarketcap       CRO     18597.7700
      5  ETH_CRO CDC.exchange             coinmarketcap       CRO     18624.6200
      6  ETH_CRO CDC.exchange             coinmarketcap       CRO     18651.2900
      7  ETH_CRO CDC.exchange             coinmarketcap       CRO     18669.0700
      8  ETH_CRO CDC.exchange             coinmarketcap       CRO     18686.8500
      9  ETH_CRO CDC.exchange coinmarketcap (buy price)       ETH        -1.0932
      10 ETH_CRO CDC.exchange coinmarketcap (buy price)       ETH        -1.6532
      11 ETH_CRO CDC.exchange coinmarketcap (buy price)       ETH        -1.9332
      12 ETH_CRO CDC.exchange coinmarketcap (buy price)       ETH        -1.9374
      13 ETH_CRO CDC.exchange coinmarketcap (buy price)       ETH        -1.9416
      14 ETH_CRO CDC.exchange coinmarketcap (buy price)       ETH        -1.9444
      15 ETH_CRO CDC.exchange coinmarketcap (buy price)       ETH        -1.9472
                                            suploss.range quantity.60days
      1  2021-02-06 22:22:22 UTC--2021-04-07 22:22:22 UTC            1.00
      2  2021-11-24 15:34:45 UTC--2022-01-23 15:34:45 UTC        18686.85
      3  2021-11-24 15:34:45 UTC--2022-01-23 15:34:45 UTC        18686.85
      4  2021-11-24 15:34:45 UTC--2022-01-23 15:34:45 UTC        18686.85
      5  2021-11-24 15:34:45 UTC--2022-01-23 15:34:45 UTC        18686.85
      6  2021-11-24 15:34:45 UTC--2022-01-23 15:34:45 UTC        18686.85
      7  2021-11-24 15:34:45 UTC--2022-01-23 15:34:45 UTC        18686.85
      8  2021-11-24 15:34:45 UTC--2022-01-23 15:34:45 UTC        18686.85
      9  2021-11-24 15:34:45 UTC--2022-01-23 15:34:45 UTC            0.00
      10 2021-11-24 15:34:45 UTC--2022-01-23 15:34:45 UTC            0.00
      11 2021-11-24 15:34:45 UTC--2022-01-23 15:34:45 UTC            0.00
      12 2021-11-24 15:34:45 UTC--2022-01-23 15:34:45 UTC            0.00
      13 2021-11-24 15:34:45 UTC--2022-01-23 15:34:45 UTC            0.00
      14 2021-11-24 15:34:45 UTC--2022-01-23 15:34:45 UTC            0.00
      15 2021-11-24 15:34:45 UTC--2022-01-23 15:34:45 UTC            0.00
         share.left60 sup.loss.quantity sup.loss gains.uncorrected gains.sup
      1        1.0000                 0    FALSE          0.000000        NA
      2    18686.8500                 0    FALSE          0.000000        NA
      3    18686.8500                 0    FALSE          0.000000        NA
      4    18686.8500                 0    FALSE          0.000000        NA
      5    18686.8500                 0    FALSE          0.000000        NA
      6    18686.8500                 0    FALSE          0.000000        NA
      7    18686.8500                 0    FALSE          0.000000        NA
      8    18686.8500                 0    FALSE          0.000000        NA
      9       -1.9472                 0    FALSE      -2129.068792        NA
      10      -1.9472                 0    FALSE       1168.113150        NA
      11      -1.9472                 0    FALSE        585.301590        NA
      12      -1.9472                 0    FALSE          8.820225        NA
      13      -1.9472                 0    FALSE          8.761095        NA
      14      -1.9472                 0    FALSE          5.840730        NA
      15      -1.9472                 0    FALSE          5.840730        NA
         gains.excess        gains       ACB   ACB.share
      1            NA           NA  3098.138 3098.137539
      2            NA           NA  4373.377    0.329814
      3            NA           NA  5546.162    0.329814
      4            NA           NA  6133.805    0.329814
      5            NA           NA  6142.660    0.329814
      6            NA           NA  6151.457    0.329814
      7            NA           NA  6157.321    0.329814
      8            NA           NA  6163.185    0.329814
      9            NA -2129.068792 -3386.884    0.000000
      10           NA  1168.113150 -5121.841    0.000000
      11           NA   585.301590 -5989.319    0.000000
      12           NA     8.820225 -6002.332    0.000000
      13           NA     8.761095 -6015.344    0.000000
      14           NA     5.840730 -6024.019    0.000000
      15           NA     5.840730 -6032.693    0.000000

