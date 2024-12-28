# shakepay

    Code
      formatted.shakepay
    Output
                       date currency   quantity total.price spot.rate transaction
      1 2021-05-07 14:50:41      BTC 0.00103982    53.06974  51002.43         buy
      2 2021-05-08 12:12:57      BTC 0.00011000     0.00000  52582.03     revenue
      3 2021-05-09 12:22:07      BTC 0.00012000     0.00000  50287.01     revenue
      4 2021-05-21 12:47:14      BTC 0.00013000     0.00000  56527.62     revenue
      5 2021-06-11 12:03:31      BTC 0.00014000     0.00000  59978.05     revenue
      6 2021-06-23 12:21:49      BTC 0.00015000     0.00000  59017.16     revenue
      7 2021-07-10 00:52:19      BTC 0.00052991    31.26847  59007.14        sell
        fees description                  comment revenue.type     value exchange
      1    0         Buy Bought @ $51,002.432 CAD         <NA> 53.069740 shakepay
      2    0      Reward              ShakingSats     airdrops  5.784024 shakepay
      3    0      Reward              ShakingSats     airdrops  6.034441 shakepay
      4    0      Reward              ShakingSats     airdrops  7.348590 shakepay
      5    0      Reward              ShakingSats     airdrops  8.396927 shakepay
      6    0      Reward              ShakingSats     airdrops  8.852574 shakepay
      7    0        Sell  Bought @ $59,007.14 CAD         <NA> 31.268470 shakepay
        rate.source currency2 total.quantity
      1    exchange       BTC     0.00103982
      2    exchange       BTC     0.00114982
      3    exchange       BTC     0.00126982
      4    exchange       BTC     0.00139982
      5    exchange       BTC     0.00153982
      6    exchange       BTC     0.00168982
      7    exchange       BTC     0.00115991
                                           suploss.range quantity.60days share.left60
      1 2021-04-07 14:50:41 UTC--2021-06-06 14:50:41 UTC      0.00103982   0.00139982
      2 2021-04-08 12:12:57 UTC--2021-06-07 12:12:57 UTC      0.00103982   0.00139982
      3 2021-04-09 12:22:07 UTC--2021-06-08 12:22:07 UTC      0.00103982   0.00139982
      4 2021-04-21 12:47:14 UTC--2021-06-20 12:47:14 UTC      0.00103982   0.00153982
      5 2021-05-12 12:03:31 UTC--2021-07-11 12:03:31 UTC      0.00000000   0.00115991
      6 2021-05-24 12:21:49 UTC--2021-07-23 12:21:49 UTC      0.00000000   0.00115991
      7 2021-06-10 00:52:19 UTC--2021-08-09 00:52:19 UTC      0.00000000   0.00115991
        sup.loss.quantity sup.loss gains.uncorrected gains.sup gains.excess    gains
      1                 0    FALSE           0.00000        NA           NA       NA
      2                 0    FALSE           0.00000        NA           NA       NA
      3                 0    FALSE           0.00000        NA           NA       NA
      4                 0    FALSE           0.00000        NA           NA       NA
      5                 0    FALSE           0.00000        NA           NA       NA
      6                 0    FALSE           0.00000        NA           NA       NA
      7                 0    FALSE          14.62635        NA           NA 14.62635
             ACB ACB.share
      1 53.06974  51037.43
      2 53.06974  46154.82
      3 53.06974  41793.12
      4 53.06974  37911.83
      5 53.06974  34464.90
      6 53.06974  31405.56
      7 36.42762  31405.56

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
                        date currency       quantity total.price     spot.rate
      1  2021-05-03 22:05:50      BTC   0.0007333710       51.25 69882.7777778
      2  2021-05-07 23:06:50      ETH   0.0205920059       54.21  2632.5750000
      3  2021-05-15 18:07:10      CRO 182.4360090842       53.42     0.2928150
      4  2021-05-23 22:09:39      CRO 117.9468230300        0.00     0.2556449
      5  2021-05-29 23:10:59      CRO   6.4039544538        0.00     0.1764535
      6  2021-06-02 19:11:52      CRO  53.6136687700        0.00     0.2049850
      7  2021-06-10 23:12:24      CRO  86.3572366500        0.00     0.1961619
      8  2021-06-11 19:13:58      CRO  17.3688994200        0.00     0.5291066
      9  2021-06-16 20:14:29      CRO  22.5041772606        0.00     0.5176817
      10 2021-06-18 21:15:51      ETH   0.0000137750        0.05  3629.7640653
      11 2021-06-19 21:16:30      CRO   8.4526209677        0.00     0.1478831
      12 2021-06-27 21:17:50      ETH   0.0007632668        3.12  4087.6923838
      13 2021-07-06 22:18:40      CRO   0.3207992131        0.26     0.8104758
      14 2021-07-11 20:19:55     ETHW   0.3558067180        3.20     8.9936469
      15 2021-07-14 18:20:27      CRO   2.4761904762        0.00     0.4846154
      16 2021-07-23 17:21:19      CRO  37.1602562661        6.98     0.1878351
      17 2021-07-25 18:22:02      BTC   0.0005320542       35.00 65782.7775510
      18 2021-07-28 23:23:04      ETH   0.0099636548       35.00  3512.7672130
         transaction fees                         description
      1          buy    0                     crypto_purchase
      2          buy    0                     crypto_purchase
      3          buy    0                     crypto_purchase
      4      revenue    0                       referral_gift
      5      revenue    0              referral_card_cashback
      6      revenue    0                       reimbursement
      7      revenue    0                       reimbursement
      8      revenue    0                       reimbursement
      9      revenue    0                       reimbursement
      10     revenue    0 supercharger_reward_to_app_credited
      11     revenue    0                 pay_checkout_reward
      12     revenue    0           crypto_earn_interest_paid
      13     revenue    0     crypto_earn_extra_interest_paid
      14     revenue    0               admin_wallet_credited
      15     revenue    0   rewards_platform_deposit_credited
      16     revenue    0                    mco_stake_reward
      17        sell    0               crypto_viban_exchange
      18        sell    0               crypto_viban_exchange
                           comment                        revenue.type   value
      1                    Buy BTC                                <NA> 51.2500
      2                    Buy ETH                                <NA> 54.2100
      3                    Buy CRO                                <NA> 53.4200
      4     Sign-up Bonus Unlocked                           referrals 30.1525
      5              Card Cashback                             rebates  1.1300
      6       Card Rebate: Spotify                             rebates 10.9900
      7       Card Rebate: Netflix                             rebates 16.9400
      8  Card Rebate: Amazon Prime                             rebates  9.1900
      9       Card Rebate: Expedia                             rebates 11.6500
      10       Supercharger Reward supercharger_reward_to_app_credited  0.0500
      11               Pay Rewards                             rebates  1.2500
      12               Crypto Earn                           interests  3.1200
      13       Crypto Earn (Extra)                           interests  0.2600
      14       Adjustment (Credit)                               forks  3.2000
      15   Mission Rewards Deposit                             rewards  1.2000
      16         CRO Stake Rewards                           interests  6.9800
      17                BTC -> CAD                                <NA> 35.0000
      18                ETH -> CAD                                <NA> 35.0000
         exchange               rate.source currency2 total.quantity
      1       CDC                  exchange       BTC   0.0007333710
      2       CDC                  exchange       ETH   0.0205920059
      3       CDC                  exchange       CRO 182.4360090842
      4       CDC exchange (USD conversion)       CRO 300.3828321142
      5       CDC                  exchange       CRO 306.7867865680
      6       CDC                  exchange       CRO 360.4004553380
      7       CDC                  exchange       CRO 446.7576919880
      8       CDC                  exchange       CRO 464.1265914080
      9       CDC                  exchange       CRO 486.6307686686
      10      CDC                  exchange       ETH   0.0206057809
      11      CDC                  exchange       CRO 495.0833896363
      12      CDC                  exchange       ETH   0.0213690478
      13      CDC                  exchange       CRO 495.4041888495
      14      CDC                  exchange      ETHW   0.3558067180
      15      CDC                  exchange       CRO 497.8803793257
      16      CDC                  exchange       CRO 535.0406355918
      17      CDC                  exchange       BTC   0.0002013168
      18      CDC                  exchange       ETH   0.0114053929
                                            suploss.range quantity.60days
      1  2021-04-03 22:05:50 UTC--2021-06-02 22:05:50 UTC     0.000733371
      2  2021-04-07 23:06:50 UTC--2021-06-06 23:06:50 UTC     0.020592006
      3  2021-04-15 18:07:10 UTC--2021-06-14 18:07:10 UTC   182.436009084
      4  2021-04-23 22:09:39 UTC--2021-06-22 22:09:39 UTC   182.436009084
      5  2021-04-29 23:10:59 UTC--2021-06-28 23:10:59 UTC   182.436009084
      6  2021-05-03 19:11:52 UTC--2021-07-02 19:11:52 UTC   182.436009084
      7  2021-05-11 23:12:24 UTC--2021-07-10 23:12:24 UTC   182.436009084
      8  2021-05-12 19:13:58 UTC--2021-07-11 19:13:58 UTC   182.436009084
      9  2021-05-17 20:14:29 UTC--2021-07-16 20:14:29 UTC     0.000000000
      10 2021-05-19 21:15:51 UTC--2021-07-18 21:15:51 UTC     0.000000000
      11 2021-05-20 21:16:30 UTC--2021-07-19 21:16:30 UTC     0.000000000
      12 2021-05-28 21:17:50 UTC--2021-07-27 21:17:50 UTC     0.000000000
      13 2021-06-06 22:18:40 UTC--2021-08-05 22:18:40 UTC     0.000000000
      14 2021-06-11 20:19:55 UTC--2021-08-10 20:19:55 UTC     0.000000000
      15 2021-06-14 18:20:27 UTC--2021-08-13 18:20:27 UTC     0.000000000
      16 2021-06-23 17:21:19 UTC--2021-08-22 17:21:19 UTC     0.000000000
      17 2021-06-25 18:22:02 UTC--2021-08-24 18:22:02 UTC     0.000000000
      18 2021-06-28 23:23:04 UTC--2021-08-27 23:23:04 UTC     0.000000000
           share.left60 sup.loss.quantity sup.loss gains.uncorrected gains.sup
      1    0.0007333710                 0    FALSE          0.000000        NA
      2    0.0205920059                 0    FALSE          0.000000        NA
      3  464.1265914080                 0    FALSE          0.000000        NA
      4  495.0833896363                 0    FALSE          0.000000        NA
      5  495.0833896363                 0    FALSE          0.000000        NA
      6  495.0833896363                 0    FALSE          0.000000        NA
      7  495.4041888495                 0    FALSE          0.000000        NA
      8  495.4041888495                 0    FALSE          0.000000        NA
      9  497.8803793257                 0    FALSE          0.000000        NA
      10   0.0213690478                 0    FALSE          0.000000        NA
      11 497.8803793257                 0    FALSE          0.000000        NA
      12   0.0213690478                 0    FALSE          0.000000        NA
      13 535.0406355918                 0    FALSE          0.000000        NA
      14   0.3558067180                 0    FALSE          0.000000        NA
      15 535.0406355918                 0    FALSE          0.000000        NA
      16 535.0406355918                 0    FALSE          0.000000        NA
      17   0.0002013168                 0    FALSE         -2.181422        NA
      18   0.0114053929                 0    FALSE          8.245672        NA
         gains.excess     gains      ACB     ACB.share
      1            NA        NA 51.25000 69882.7777778
      2            NA        NA 54.21000  2632.5750000
      3            NA        NA 53.42000     0.2928150
      4            NA        NA 53.42000     0.1778397
      5            NA        NA 53.42000     0.1741274
      6            NA        NA 53.42000     0.1482240
      7            NA        NA 53.42000     0.1195726
      8            NA        NA 53.42000     0.1150979
      9            NA        NA 53.42000     0.1097752
      10           NA        NA 54.26000  2633.2416226
      11           NA        NA 53.42000     0.1079010
      12           NA        NA 57.38000  2685.1921836
      13           NA        NA 53.68000     0.1083560
      14           NA        NA  3.20000     8.9936469
      15           NA        NA 53.68000     0.1078171
      16           NA        NA 60.66000     0.1133746
      17           NA -2.181422 14.06858 69882.7777778
      18           NA  8.245672 30.62567  2685.1921836

# celsius

    Code
      formatted.celsius
    Output
                       date currency       quantity total.price  spot.rate
      1 2021-03-03 21:11:00      BTC 0.000707598916   0.0000000  71402.031
      2 2021-03-07 05:00:00      BTC 0.000025237883   0.1366256   5413.514
      3 2021-03-19 05:00:00      BTC 0.000081561209   0.7267146   8910.052
      4 2021-03-28 05:00:00      BTC 0.000003683063   0.5977123 162286.762
      5 2021-04-05 05:00:00      BTC 0.000046940391   0.5849814  12462.217
      6 2021-04-08 05:00:00      BTC 0.000051775622   0.6447880  12453.505
      7 2021-04-08 22:18:00      BTC 0.000733082450   0.0000000  68636.209
      8 2021-05-06 10:32:00      BTC 0.001409023441   0.0000000  43292.395
      9 2021-05-23 05:00:00      BTC 0.000063726694   0.4162554   6531.885
        transaction fees       description revenue.type      value exchange
      1     revenue    0 Promo Code Reward       promos 50.5240000  celsius
      2     revenue    0            Reward    interests  0.1366256  celsius
      3     revenue    0            Reward    interests  0.7267146  celsius
      4     revenue    0            Reward    interests  0.5977123  celsius
      5     revenue    0            Reward    interests  0.5849814  celsius
      6     revenue    0            Reward    interests  0.6447880  celsius
      7     revenue    0    Referred Award    referrals 50.3160000  celsius
      8     revenue    0 Promo Code Reward       promos 61.0000000  celsius
      9     revenue    0            Reward    interests  0.4162554  celsius
                      rate.source currency2 total.quantity
      1 exchange (USD conversion)       BTC   0.0007075989
      2 exchange (USD conversion)       BTC   0.0007328368
      3 exchange (USD conversion)       BTC   0.0008143980
      4 exchange (USD conversion)       BTC   0.0008180811
      5 exchange (USD conversion)       BTC   0.0008650215
      6 exchange (USD conversion)       BTC   0.0009167971
      7 exchange (USD conversion)       BTC   0.0016498795
      8 exchange (USD conversion)       BTC   0.0030589030
      9 exchange (USD conversion)       BTC   0.0031226297
                                           suploss.range quantity.60days share.left60
      1 2021-02-01 21:11:00 UTC--2021-04-02 21:11:00 UTC               0 0.0008180811
      2 2021-02-05 05:00:00 UTC--2021-04-06 05:00:00 UTC               0 0.0008650215
      3 2021-02-17 05:00:00 UTC--2021-04-18 05:00:00 UTC               0 0.0016498795
      4 2021-02-26 05:00:00 UTC--2021-04-27 05:00:00 UTC               0 0.0016498795
      5 2021-03-06 05:00:00 UTC--2021-05-05 05:00:00 UTC               0 0.0016498795
      6 2021-03-09 05:00:00 UTC--2021-05-08 05:00:00 UTC               0 0.0030589030
      7 2021-03-09 22:18:00 UTC--2021-05-08 22:18:00 UTC               0 0.0030589030
      8 2021-04-06 10:32:00 UTC--2021-06-05 10:32:00 UTC               0 0.0031226297
      9 2021-04-23 05:00:00 UTC--2021-06-22 05:00:00 UTC               0 0.0031226297
        sup.loss.quantity sup.loss gains.uncorrected gains.sup gains.excess gains
      1                 0    FALSE                 0        NA           NA    NA
      2                 0    FALSE                 0        NA           NA    NA
      3                 0    FALSE                 0        NA           NA    NA
      4                 0    FALSE                 0        NA           NA    NA
      5                 0    FALSE                 0        NA           NA    NA
      6                 0    FALSE                 0        NA           NA    NA
      7                 0    FALSE                 0        NA           NA    NA
      8                 0    FALSE                 0        NA           NA    NA
      9                 0    FALSE                 0        NA           NA    NA
              ACB ACB.share
      1 0.0000000    0.0000
      2 0.1366256  186.4339
      3 0.8633402 1060.0961
      4 1.4610525 1785.9508
      5 2.0460339 2365.2984
      6 2.6908219 2935.0245
      7 2.6908219 1630.9202
      8 2.6908219  879.6689
      9 3.1070773  995.0195

# blockfi

    Code
      formatted.blockfi
    Output
                        date currency     quantity total.price    spot.rate
      1  2021-05-29 21:43:44      BTC  0.000018512  0.78643467 42482.425898
      2  2021-05-29 21:43:44      LTC  0.022451200  4.62896363   206.178896
      3  2021-06-13 21:43:44      BTC  0.000184120  0.00000000 45344.627640
      4  2021-06-30 21:43:44      BTC  0.000047234  2.07674837 43967.234920
      5  2021-06-30 21:43:44      LTC  0.010125120  1.80823545   178.589038
      6  2021-07-29 21:43:44     USDC  0.038241000  0.04761184     1.245047
      7  2021-08-05 18:34:06      BTC  0.000250000 12.59292517 50371.700691
      8  2021-08-07 21:43:44      BTC  0.000441230  0.00000000 54836.344810
      9  2021-10-24 04:29:23      LTC  0.165122140 68.01411135   411.901828
      10 2021-10-24 04:29:23     USDC 55.000000000 68.01411135     1.236620
         transaction fees      description revenue.type       value exchange
      1      revenue    0 Interest Payment    interests  0.78643467  blockfi
      2      revenue    0 Interest Payment    interests  4.62896363  blockfi
      3      revenue    0   Referral Bonus    referrals  8.34885284  blockfi
      4      revenue    0 Interest Payment    interests  2.07674837  blockfi
      5      revenue    0 Interest Payment    interests  1.80823545  blockfi
      6      revenue    0 Interest Payment    interests  0.04761184  blockfi
      7         sell    0   Withdrawal Fee         <NA> 12.59292517  blockfi
      8      revenue    0    Bonus Payment       promos 24.19544042  blockfi
      9         sell    0            Trade         <NA> 68.01411135  blockfi
      10         buy    0            Trade         <NA> 68.01411135  blockfi
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
      7   0.000441096                 0    FALSE          9.728207        NA
      8   0.000441096                 0    FALSE          0.000000        NA
      9  -0.132545820                 0    FALSE         35.385377        NA
      10 55.038241000                 0    FALSE          0.000000        NA
         gains.excess     gains           ACB    ACB.share
      1            NA        NA   0.786434668 42482.425898
      2            NA        NA   4.628963628   206.178896
      3            NA        NA   0.786434668  3881.098090
      4            NA        NA   2.863183042 11458.874126
      5            NA        NA   6.437199074   197.603630
      6            NA        NA   0.047611837     1.245047
      7            NA  9.728207  -0.001535489     0.000000
      8            NA        NA  -0.001535489     0.000000
      9            NA 35.385377 -26.191535131     0.000000
      10           NA        NA  68.061723185     1.236626

# adalite

    Code
      formatted.adalite
    Output
                       date currency  quantity total.price spot.rate transaction fees
      1 2021-04-28 16:56:00      ADA 0.3120400   0.5092906  1.632132     revenue    0
      2 2021-05-07 16:53:00      ADA 0.3125132   0.6272258  2.007038     revenue    0
      3 2021-05-12 16:56:00      ADA 0.2212410   0.4437400  2.005686     revenue    0
      4 2021-05-17 17:16:00      ADA 0.4123210   1.0790423  2.616996     revenue    0
      5 2021-05-17 21:16:00      ADA 0.1691870   0.4427617  2.616996        sell    0
      6 2021-05-17 21:31:00      ADA 0.1912300   0.5004481  2.616996        sell    0
           description        comment revenue.type     value exchange   rate.source
      1 Reward awarded           <NA>      staking 0.5092906  adalite coinmarketcap
      2 Reward awarded           <NA>      staking 0.6272258  adalite coinmarketcap
      3 Reward awarded           <NA>      staking 0.4437400  adalite coinmarketcap
      4 Reward awarded           <NA>      staking 1.0790423  adalite coinmarketcap
      5           Sent Withdrawal Fee         <NA> 0.4427617  adalite coinmarketcap
      6           Sent Withdrawal Fee         <NA> 0.5004481  adalite coinmarketcap
        currency2 total.quantity                                    suploss.range
      1       ADA      0.3120400 2021-03-29 16:56:00 UTC--2021-05-28 16:56:00 UTC
      2       ADA      0.6245532 2021-04-07 16:53:00 UTC--2021-06-06 16:53:00 UTC
      3       ADA      0.8457942 2021-04-12 16:56:00 UTC--2021-06-11 16:56:00 UTC
      4       ADA      1.2581152 2021-04-17 17:16:00 UTC--2021-06-16 17:16:00 UTC
      5       ADA      1.0889282 2021-04-17 21:16:00 UTC--2021-06-16 21:16:00 UTC
      6       ADA      0.8976982 2021-04-17 21:31:00 UTC--2021-06-16 21:31:00 UTC
        quantity.60days share.left60 sup.loss.quantity sup.loss gains.uncorrected
      1               0    0.8976982                 0    FALSE        0.00000000
      2               0    0.8976982                 0    FALSE        0.00000000
      3               0    0.8976982                 0    FALSE        0.00000000
      4               0    0.8976982                 0    FALSE        0.00000000
      5               0    0.8976982                 0    FALSE        0.08514833
      6               0    0.8976982                 0    FALSE        0.09624211
        gains.sup gains.excess      gains       ACB ACB.share
      1        NA           NA         NA 0.5092906  1.632132
      2        NA           NA         NA 1.1365164  1.819727
      3        NA           NA         NA 1.5802564  1.868370
      4        NA           NA         NA 2.6592987  2.113716
      5        NA           NA 0.08514833 2.3016854  2.113716
      6        NA           NA 0.09624211 1.8974794  2.113716

# coinsmart

    Code
      formatted.coinsmart
    Output
                       date currency  quantity total.price    spot.rate transaction
      1 2021-04-25 16:11:24      ADA 198.50000  237.937430     1.198677         buy
      2 2021-04-28 18:37:15      CAD  15.00000    0.000000     1.000000     revenue
      3 2021-05-15 16:42:07      BTC   0.00004    0.000000 58495.964189     revenue
      4 2021-06-03 02:04:49      ADA   0.30000    0.652675     2.175583        sell
             fees description  comment revenue.type      value  exchange
      1 0.2695238    purchase    Trade         <NA> 237.937430 coinsmart
      2 0.0000000       Other Referral    referrals  15.000000 coinsmart
      3 0.0000000       Other     Quiz     airdrops   2.339839 coinsmart
      4 0.0000000         Fee Withdraw         <NA>   0.652675 coinsmart
          rate.source currency2 total.quantity
      1      exchange       ADA      198.50000
      2      exchange       CAD       15.00000
      3 coinmarketcap       BTC        0.00004
      4 coinmarketcap       ADA      198.20000
                                           suploss.range quantity.60days share.left60
      1 2021-03-26 16:11:24 UTC--2021-05-25 16:11:24 UTC           198.5    198.50000
      2 2021-03-29 18:37:15 UTC--2021-05-28 18:37:15 UTC             0.0     15.00000
      3 2021-04-15 16:42:07 UTC--2021-06-14 16:42:07 UTC             0.0      0.00004
      4 2021-05-04 02:04:49 UTC--2021-07-03 02:04:49 UTC             0.0    198.20000
        sup.loss.quantity sup.loss gains.uncorrected gains.sup gains.excess     gains
      1                 0    FALSE         0.0000000        NA           NA        NA
      2                 0    FALSE         0.0000000        NA           NA        NA
      3                 0    FALSE         0.0000000        NA           NA        NA
      4                 0    FALSE         0.2926645        NA           NA 0.2926645
             ACB ACB.share
      1 238.2070  1.200035
      2   0.0000  0.000000
      3   0.0000  0.000000
      4 237.8469  1.200035

# presearch

    Code
      formatted.presearch
    Output
                        date currency quantity total.price  spot.rate transaction
      1  2021-04-27 17:45:18      PRE     0.13     0.00000 0.09307434     revenue
      2  2021-04-27 17:48:00      PRE     0.13     0.00000 0.09307434     revenue
      3  2021-04-27 17:48:18      PRE     0.13     0.00000 0.09307434     revenue
      4  2021-04-27 17:55:24      PRE     0.13     0.00000 0.09307434     revenue
      5  2021-04-27 17:57:29      PRE     0.13     0.00000 0.09307434     revenue
      6  2021-04-27 19:00:31      PRE     0.13     0.00000 0.09307434     revenue
      7  2021-04-27 19:00:41      PRE     0.13     0.00000 0.09307434     revenue
      8  2021-04-27 19:01:57      PRE     0.13     0.00000 0.09307434     revenue
      9  2021-04-27 19:08:59      PRE     0.13     0.00000 0.09307434     revenue
      10 2021-04-27 19:12:15      PRE     0.13     0.00000 0.09307434     revenue
      11 2021-05-07 05:55:33      PRE  1000.00    78.96909 0.07896909         buy
         fees                                     description revenue.type
      1     0                                   Search Reward     airdrops
      2     0                                   Search Reward     airdrops
      3     0                                   Search Reward     airdrops
      4     0                                   Search Reward     airdrops
      5     0                                   Search Reward     airdrops
      6     0                                   Search Reward     airdrops
      7     0                                   Search Reward     airdrops
      8     0                                   Search Reward     airdrops
      9     0                                   Search Reward     airdrops
      10    0                                   Search Reward     airdrops
      11    0 Transferred from Presearch Portal (PO#: 412893)         <NA>
               value  exchange   rate.source currency2 total.quantity
      1   0.01209966 presearch coinmarketcap       PRE           0.13
      2   0.01209966 presearch coinmarketcap       PRE           0.26
      3   0.01209966 presearch coinmarketcap       PRE           0.39
      4   0.01209966 presearch coinmarketcap       PRE           0.52
      5   0.01209966 presearch coinmarketcap       PRE           0.65
      6   0.01209966 presearch coinmarketcap       PRE           0.78
      7   0.01209966 presearch coinmarketcap       PRE           0.91
      8   0.01209966 presearch coinmarketcap       PRE           1.04
      9   0.01209966 presearch coinmarketcap       PRE           1.17
      10  0.01209966 presearch coinmarketcap       PRE           1.30
      11 78.96908966 presearch coinmarketcap       PRE        1001.30
                                            suploss.range quantity.60days
      1  2021-03-28 17:45:18 UTC--2021-05-27 17:45:18 UTC            1000
      2  2021-03-28 17:48:00 UTC--2021-05-27 17:48:00 UTC            1000
      3  2021-03-28 17:48:18 UTC--2021-05-27 17:48:18 UTC            1000
      4  2021-03-28 17:55:24 UTC--2021-05-27 17:55:24 UTC            1000
      5  2021-03-28 17:57:29 UTC--2021-05-27 17:57:29 UTC            1000
      6  2021-03-28 19:00:31 UTC--2021-05-27 19:00:31 UTC            1000
      7  2021-03-28 19:00:41 UTC--2021-05-27 19:00:41 UTC            1000
      8  2021-03-28 19:01:57 UTC--2021-05-27 19:01:57 UTC            1000
      9  2021-03-28 19:08:59 UTC--2021-05-27 19:08:59 UTC            1000
      10 2021-03-28 19:12:15 UTC--2021-05-27 19:12:15 UTC            1000
      11 2021-04-07 05:55:33 UTC--2021-06-06 05:55:33 UTC            1000
         share.left60 sup.loss.quantity sup.loss gains.uncorrected gains.sup
      1        1001.3                 0    FALSE                 0        NA
      2        1001.3                 0    FALSE                 0        NA
      3        1001.3                 0    FALSE                 0        NA
      4        1001.3                 0    FALSE                 0        NA
      5        1001.3                 0    FALSE                 0        NA
      6        1001.3                 0    FALSE                 0        NA
      7        1001.3                 0    FALSE                 0        NA
      8        1001.3                 0    FALSE                 0        NA
      9        1001.3                 0    FALSE                 0        NA
      10       1001.3                 0    FALSE                 0        NA
      11       1001.3                 0    FALSE                 0        NA
         gains.excess gains      ACB  ACB.share
      1            NA    NA  0.00000 0.00000000
      2            NA    NA  0.00000 0.00000000
      3            NA    NA  0.00000 0.00000000
      4            NA    NA  0.00000 0.00000000
      5            NA    NA  0.00000 0.00000000
      6            NA    NA  0.00000 0.00000000
      7            NA    NA  0.00000 0.00000000
      8            NA    NA  0.00000 0.00000000
      9            NA    NA  0.00000 0.00000000
      10           NA    NA  0.00000 0.00000000
      11           NA    NA 78.96909 0.07886656

# CDC exchange rewards

    Code
      formatted.binance.rewards
    Output
                        date currency   quantity  total.price     spot.rate
      1  2021-02-19 00:00:00      CRO 1.36512341 0.2221748898     0.1627508
      2  2021-02-21 00:00:00      CRO 1.36945123 0.2412313569     0.1761518
      3  2021-04-15 16:04:21      BTC 0.00000023 0.0182120528 79182.8382268
      4  2021-04-18 00:00:00      CRO 1.36512310 0.3795803682     0.2780558
      5  2021-05-14 06:02:22      BTC 0.00000035 0.0210982556 60280.7303238
      6  2021-06-12 15:21:34      BTC 0.00000630 0.2789325106 44275.0016795
      7  2021-06-27 01:34:00      CRO 0.00100000 0.0001240084     0.1240084
      8  2021-07-07 00:00:00      CRO 0.01512903 0.0000000000     0.1512353
      9  2021-07-13 00:00:00      CRO 0.05351230 0.0000000000     0.1575165
      10 2021-09-07 00:00:00      CRO 0.01521310 0.0000000000     0.2348490
         transaction fees description
      1      revenue    0      Reward
      2      revenue    0      Reward
      3      revenue    0      Reward
      4      revenue    0      Reward
      5      revenue    0      Reward
      6      revenue    0      Reward
      7         sell    0  Withdrawal
      8      revenue    0      Reward
      9      revenue    0      Reward
      10     revenue    0      Reward
                                                  comment revenue.type        value
      1  Interest on 5000.00000000 at 10% APR (Completed)    interests 0.2221748898
      2  Interest on 5000.00000000 at 10% APR (Completed)    interests 0.2412313569
      3                           BTC Supercharger reward    interests 0.0182120528
      4  Interest on 5000.00000000 at 10% APR (Completed)    interests 0.3795803682
      5                           BTC Supercharger reward    interests 0.0210982556
      6                           BTC Supercharger reward    interests 0.2789325106
      7                                              <NA>         <NA> 0.0001240084
      8                   Rebate on 0.18512341 CRO at 10%      rebates 0.0022880434
      9                 Rebate on 0.5231512346 CRO at 10%      rebates 0.0084290717
      10                 Rebate on 0.155125123 CRO at 10%      rebates 0.0035727817
             exchange   rate.source currency2 total.quantity
      1  CDC.exchange coinmarketcap       CRO     1.36512341
      2  CDC.exchange coinmarketcap       CRO     2.73457464
      3  CDC.exchange coinmarketcap       BTC     0.00000023
      4  CDC.exchange coinmarketcap       CRO     4.09969774
      5  CDC.exchange coinmarketcap       BTC     0.00000058
      6  CDC.exchange coinmarketcap       BTC     0.00000688
      7  CDC.exchange coinmarketcap       CRO     4.09869774
      8  CDC.exchange coinmarketcap       CRO     4.11382677
      9  CDC.exchange coinmarketcap       CRO     4.16733907
      10 CDC.exchange coinmarketcap       CRO     4.18255217
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
      1    2.73457464                 0    FALSE     0.00000000000        NA
      2    2.73457464                 0    FALSE     0.00000000000        NA
      3    0.00000058                 0    FALSE     0.00000000000        NA
      4    4.09969774                 0    FALSE     0.00000000000        NA
      5    0.00000688                 0    FALSE     0.00000000000        NA
      6    0.00000688                 0    FALSE     0.00000000000        NA
      7    4.16733907                 0    FALSE    -0.00008161323        NA
      8    4.16733907                 0    FALSE     0.00000000000        NA
      9    4.16733907                 0    FALSE     0.00000000000        NA
      10   4.18255217                 0    FALSE     0.00000000000        NA
         gains.excess          gains        ACB     ACB.share
      1            NA             NA 0.22217489     0.1627508
      2            NA             NA 0.46340625     0.1694619
      3            NA             NA 0.01821205 79182.8382268
      4            NA             NA 0.84298661     0.2056217
      5            NA             NA 0.03931031 67776.3938026
      6            NA             NA 0.31824282 46256.2236899
      7            NA -0.00008161323 0.84278099     0.2056217
      8            NA             NA 0.84278099     0.2048655
      9            NA             NA 0.84278099     0.2022348
      10           NA             NA 0.84278099     0.2014992

# CDC wallet

    Code
      formatted.CDC.wallet
    Output
                       date currency quantity   total.price spot.rate transaction
      1 2021-04-12 18:28:50      CRO 0.512510 0.13598426831 0.2653300     revenue
      2 2021-04-18 18:28:50      CRO 0.000200 0.00005561116 0.2780558        sell
      3 2021-04-23 18:51:53      CRO 1.656708 0.36012175964 0.2173720     revenue
      4 2021-04-25 18:51:53      CRO 0.000200 0.00004177234 0.2088617        sell
      5 2021-05-21 01:19:01      CRO 0.000200 0.00002992587 0.1496293        sell
      6 2021-06-25 04:11:53      CRO 0.000200 0.00002406829 0.1203414        sell
      7 2021-06-26 14:51:02      CRO 6.051235 0.70787479660 0.1169802     revenue
        fees  description
      1    0       Reward
      2    0 staking cost
      3    0       Reward
      4    0 staking cost
      5    0   Withdrawal
      6    0 staking cost
      7    0       Reward
                                                                                                          comment
      1                                                                                Auto Withdraw Reward from 
      2                                                            Stake on Validator(abcdefghijklmnopqrstuvwxyz)
      3                                                                                Auto Withdraw Reward from 
      4                                                        Unstake from Validator(abcdefghijklmnopqrstuvwxyz)
      5                                                        Outgoing Transaction to abcdefghijklmnopqrstuvwxyz
      6 Move 530.41289045 CRO from Validator(abcdefghijklmnopqrstuvwxyz) to Validator(abcdefghijklmnopqrstuvwxyz)
      7                                                           Withdraw Reward from abcdefghijklmnopqrstuvwxyz
        revenue.type         value   exchange   rate.source currency2 total.quantity
      1      staking 0.13598426831 CDC.wallet coinmarketcap       CRO       0.512510
      2         <NA> 0.00005561116 CDC.wallet coinmarketcap       CRO       0.512310
      3      staking 0.36012175964 CDC.wallet coinmarketcap       CRO       2.169018
      4         <NA> 0.00004177234 CDC.wallet coinmarketcap       CRO       2.168818
      5         <NA> 0.00002992587 CDC.wallet coinmarketcap       CRO       2.168618
      6         <NA> 0.00002406829 CDC.wallet coinmarketcap       CRO       2.168418
      7      staking 0.70787479660 CDC.wallet coinmarketcap       CRO       8.219653
                                           suploss.range quantity.60days share.left60
      1 2021-03-13 18:28:50 UTC--2021-05-12 18:28:50 UTC               0     2.168818
      2 2021-03-19 18:28:50 UTC--2021-05-18 18:28:50 UTC               0     2.168818
      3 2021-03-24 18:51:53 UTC--2021-05-23 18:51:53 UTC               0     2.168618
      4 2021-03-26 18:51:53 UTC--2021-05-25 18:51:53 UTC               0     2.168618
      5 2021-04-21 01:19:01 UTC--2021-06-20 01:19:01 UTC               0     2.168618
      6 2021-05-26 04:11:53 UTC--2021-07-25 04:11:53 UTC               0     8.219653
      7 2021-05-27 14:51:02 UTC--2021-07-26 14:51:02 UTC               0     8.219653
        sup.loss.quantity sup.loss gains.uncorrected gains.sup gains.excess
      1                 0    FALSE     0.00000000000        NA           NA
      2                 0    FALSE     0.00000254516        NA           NA
      3                 0    FALSE     0.00000000000        NA           NA
      4                 0    FALSE    -0.00000396754        NA           NA
      5                 0    FALSE    -0.00001581401        NA           NA
      6                 0    FALSE    -0.00002167159        NA           NA
      7                 0    FALSE     0.00000000000        NA           NA
                 gains       ACB ACB.share
      1             NA 0.1359843 0.2653300
      2  0.00000254516 0.1359312 0.2653300
      3             NA 0.4960530 0.2286994
      4 -0.00000396754 0.4960072 0.2286994
      5 -0.00001581401 0.4959615 0.2286994
      6 -0.00002167159 0.4959157 0.2286994
      7             NA 1.2037905 0.1464527

# uphold

    Code
      formatted.uphold
    Output
                        date currency    quantity total.price   spot.rate transaction
      1  2021-01-07 02:40:31      BAT  1.59081275   0.0000000   0.3222730     revenue
      2  2021-02-09 14:26:49      BAT 12.69812163   0.0000000   0.5418851     revenue
      3  2021-03-06 21:32:36      BAT  0.37591275   0.0000000   0.8532272     revenue
      4  2021-03-07 21:46:57      BAT 52.59871206  57.1230888   1.0860169        sell
      5  2021-03-07 21:46:57      LTC  0.24129740  57.1230888 236.7331300         buy
      6  2021-03-07 21:54:09      LTC  0.00300000   0.7101994 236.7331300        sell
      7  2021-04-05 12:22:00      BAT  8.52198415   0.0000000   1.5483522     revenue
      8  2021-04-06 03:41:42      LTC  0.00300000   0.8652138 288.4045856        sell
      9  2021-04-06 04:47:00      BAT  8.52198415  10.3998152   1.2203514        sell
      10 2021-04-06 04:47:00      LTC  0.03605981  10.3998152 288.4045856         buy
      11 2021-05-11 07:12:24      BAT  0.47521985   0.0000000   1.6365602     revenue
      12 2021-06-09 04:52:23      BAT  0.67207415   0.0000000   0.8298909     revenue
         fees description         comment revenue.type      value exchange
      1     0          in            <NA>     airdrops  0.5126760   uphold
      2     0          in            <NA>     airdrops  6.8809223   uphold
      3     0          in            <NA>     airdrops  0.3207390   uphold
      4     0       trade         BAT-LTC         <NA> 57.1230888   uphold
      5     0       trade         BAT-LTC         <NA> 57.1230888   uphold
      6     0         out withdrawal fees         <NA>  0.7101994   uphold
      7     0          in            <NA>     airdrops 13.1950331   uphold
      8     0         out withdrawal fees         <NA>  0.8652138   uphold
      9     0       trade         BAT-LTC         <NA> 10.3998152   uphold
      10    0       trade         BAT-LTC         <NA> 10.3998152   uphold
      11    0          in            <NA>     airdrops  0.7777259   uphold
      12    0          in            <NA>     airdrops  0.5577482   uphold
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
      1     1.5908128             0.000    FALSE         0.0000000        NA
      2   -37.9338649             0.000    FALSE         0.0000000        NA
      3   -29.4118808             0.000    FALSE         0.0000000        NA
      4   -37.9338649             0.000    FALSE        57.1230888        NA
      5     0.2713572             0.000    FALSE         0.0000000        NA
      6     0.2713572             0.003    FALSE         0.0000000        NA
      7   -37.9338649             0.000    FALSE         0.0000000        NA
      8     0.2713572             0.003    FALSE         0.1550144        NA
      9   -37.9338649             0.000    FALSE        10.3998152        NA
      10    0.2713572             0.000    FALSE         0.0000000        NA
      11  -36.7865709             0.000    FALSE         0.0000000        NA
      12  -36.7865709             0.000    FALSE         0.0000000        NA
         gains.excess      gains      ACB ACB.share
      1            NA         NA  0.00000    0.0000
      2            NA         NA  0.00000    0.0000
      3            NA         NA  0.00000    0.0000
      4            NA 57.1230888  0.00000    0.0000
      5            NA         NA 57.12309  236.7331
      6            NA         NA 56.41289  236.7331
      7            NA         NA  0.00000    0.0000
      8            NA  0.1550144 55.70269  236.7331
      9            NA 10.3998152  0.00000    0.0000
      10           NA         NA 66.10251  243.5996
      11           NA         NA  0.00000    0.0000
      12           NA         NA  0.00000    0.0000

# gemini

    Code
      formatted.gemini
    Output
                        date currency        quantity total.price     spot.rate
      1  2021-04-08 22:22:22      LTC  1.000000000000 286.0000000   286.0000000
      2  2021-04-09 22:50:55      BTC  0.000966278356  70.6481728 73113.6865846
      3  2021-04-09 22:50:55      LTC  0.246690598398  70.6481728   286.3837264
      4  2021-04-09 22:53:57      BTC  0.000006051912   0.4424776 73113.6865846
      5  2021-04-09 22:53:57      LTC  0.001640820000   0.4424776   269.6685566
      6  2021-04-09 23:20:53      BAT 48.719519585106  86.3813238     1.7730332
      7  2021-04-09 23:20:53      BTC  0.000950730015  86.3813238 90857.8906767
      8  2021-04-10 23:22:04      BTC  0.000285025578   0.0000000 74039.0860637
      9  2021-05-08 16:14:54      BAT  2.833934780210   0.0000000     1.7171469
      10 2021-05-16 12:55:02      BAT  3.085288331282   0.0000000     1.3799628
      11 2021-05-16 13:35:19      BAT  5.007481461482   0.0000000     1.3799628
      12 2021-06-18 01:38:54      BAT  6.834322542857   0.0000000     0.7893537
         transaction            fees                     description
      1          buy 0.0000000000000 fake transaction for format_ACB
      2          buy 0.0000023034086                          LTCBTC
      3         sell 0.0000000000000                          LTCBTC
      4          buy 0.0000000365181                          LTCBTC
      5         sell 0.0000000000000                          LTCBTC
      6          buy 0.0000000000000                          BATBTC
      7         sell 0.0000018142411                          BATBTC
      8      revenue 0.0000000000000                          Credit
      9      revenue 0.0000000000000                          Credit
      10     revenue 0.0000000000000                          Credit
      11     revenue 0.0000000000000                          Credit
      12     revenue 0.0000000000000                          Credit
                       comment revenue.type       value exchange
      1                   <NA>         <NA> 286.0000000   gemini
      2                 Market         <NA>  70.6481728   gemini
      3                 Market         <NA>  70.6481728   gemini
      4                  Limit         <NA>   0.4424776   gemini
      5                  Limit         <NA>   0.4424776   gemini
      6                  Limit         <NA>  86.3813238   gemini
      7                  Limit         <NA>  86.3813238   gemini
      8  Administrative Credit    referrals  21.1030333   gemini
      9  Administrative Credit    referrals   4.8662823   gemini
      10               Deposit     airdrops   4.2575830   gemini
      11               Deposit     airdrops   6.9101380   gemini
      12               Deposit     airdrops   5.3946979   gemini
                       rate.source currency2 total.quantity
      1                       fake       LTC  1.00000000000
      2              coinmarketcap       BTC  0.00096627836
      3  coinmarketcap (buy price)       LTC  0.75330940160
      4              coinmarketcap       BTC  0.00097233027
      5  coinmarketcap (buy price)       LTC  0.75166858160
      6              coinmarketcap       BAT 48.71951958511
      7  coinmarketcap (buy price)       BTC  0.00002160025
      8              coinmarketcap       BTC  0.00030662583
      9              coinmarketcap       BAT 51.55345436532
      10             coinmarketcap       BAT 54.63874269660
      11             coinmarketcap       BAT 59.64622415808
      12             coinmarketcap       BAT 66.48054670094
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
          share.left60 sup.loss.quantity sup.loss gains.uncorrected   gains.sup
      1   0.7516685816        0.00000000    FALSE        0.00000000          NA
      2   0.0003066258        0.00000000    FALSE        0.00000000          NA
      3   0.7516685816        0.24669060    FALSE        0.09466170          NA
      4   0.0003066258        0.00000000    FALSE        0.00000000          NA
      5   0.7516685816        0.00164082     TRUE       -0.02679696 -0.02679696
      6  51.5534543653        0.00000000    FALSE        0.00000000          NA
      7   0.0003066258        0.00095073    FALSE       16.86994332          NA
      8   0.0003066258        0.00000000    FALSE        0.00000000          NA
      9  59.6462241581        0.00000000    FALSE        0.00000000          NA
      10 59.6462241581        0.00000000    FALSE        0.00000000          NA
      11 59.6462241581        0.00000000    FALSE        0.00000000          NA
      12 66.4805467009        0.00000000    FALSE        0.00000000          NA
         gains.excess      gains        ACB    ACB.share
      1            NA         NA 286.000000   286.000000
      2            NA         NA  70.648175 73113.688968
      3            NA  0.0946617 215.446489   286.000000
      4            NA         NA  71.090653 73113.688991
      5            NA         NA 215.004011   286.035650
      6            NA         NA  86.381324     1.773033
      7            NA 16.8699433   1.579274 73113.688991
      8            NA         NA   1.579274  5150.492739
      9            NA         NA  86.381324     1.675568
      10           NA         NA  86.381324     1.580954
      11           NA         NA  86.381324     1.448228
      12           NA         NA  86.381324     1.299347

# exodus

    Code
      formatted.exodus
    Output
                       date currency  quantity total.price    spot.rate transaction
      1 2021-04-25 22:06:11      LTC 0.0028860   0.6411871   222.171556         buy
      2 2021-04-25 23:08:12      ADA 0.3564820   0.6674399     1.872296         buy
      3 2021-05-12 12:15:28      BTC 0.0001006   4.4540652 44275.001680         buy
      4 2021-05-12 22:31:35      ETH 0.0029000   8.3268383  2871.323554         buy
      5 2021-05-25 22:06:11      LTC 0.0014430   0.3205936   222.171556        sell
      6 2021-05-25 23:08:12      ADA 0.1782410   0.3337199     1.872296        sell
      7 2021-06-12 12:15:28      BTC 0.0000503   2.2270326 44275.001680        sell
      8 2021-06-12 22:31:35      ETH 0.0014500   4.1634192  2871.323554        sell
        fees                     description revenue.type     value exchange
      1    0 fake transaction for format_ACB         <NA> 0.6411871   exodus
      2    0 fake transaction for format_ACB         <NA> 0.6674399   exodus
      3    0 fake transaction for format_ACB         <NA> 4.4540652   exodus
      4    0 fake transaction for format_ACB         <NA> 8.3268383   exodus
      5    0                      withdrawal         <NA> 0.3205936   exodus
      6    0                      withdrawal         <NA> 0.3337199   exodus
      7    0                      withdrawal         <NA> 2.2270326   exodus
      8    0                      withdrawal         <NA> 4.1634192   exodus
          rate.source currency2 total.quantity
      1 coinmarketcap       LTC      0.0028860
      2 coinmarketcap       ADA      0.3564820
      3 coinmarketcap       BTC      0.0001006
      4 coinmarketcap       ETH      0.0029000
      5 coinmarketcap       LTC      0.0014430
      6 coinmarketcap       ADA      0.1782410
      7 coinmarketcap       BTC      0.0000503
      8 coinmarketcap       ETH      0.0014500
                                           suploss.range quantity.60days share.left60
      1 2021-03-26 22:06:11 UTC--2021-05-25 22:06:11 UTC       0.0028860    0.0014430
      2 2021-03-26 23:08:12 UTC--2021-05-25 23:08:12 UTC       0.3564820    0.1782410
      3 2021-04-12 12:15:28 UTC--2021-06-11 12:15:28 UTC       0.0001006    0.0001006
      4 2021-04-12 22:31:35 UTC--2021-06-11 22:31:35 UTC       0.0029000    0.0029000
      5 2021-04-25 22:06:11 UTC--2021-06-24 22:06:11 UTC       0.0028860    0.0014430
      6 2021-04-25 23:08:12 UTC--2021-06-24 23:08:12 UTC       0.3564820    0.1782410
      7 2021-05-13 12:15:28 UTC--2021-07-12 12:15:28 UTC       0.0000000    0.0000503
      8 2021-05-13 22:31:35 UTC--2021-07-12 22:31:35 UTC       0.0000000    0.0014500
        sup.loss.quantity sup.loss gains.uncorrected gains.sup gains.excess gains
      1          0.000000    FALSE                 0        NA           NA    NA
      2          0.000000    FALSE                 0        NA           NA    NA
      3          0.000000    FALSE                 0        NA           NA    NA
      4          0.000000    FALSE                 0        NA           NA    NA
      5          0.001443    FALSE                 0        NA           NA    NA
      6          0.178241    FALSE                 0        NA           NA    NA
      7          0.000000    FALSE                 0        NA           NA    NA
      8          0.000000    FALSE                 0        NA           NA    NA
              ACB    ACB.share
      1 0.6411871   222.171556
      2 0.6674399     1.872296
      3 4.4540652 44275.001680
      4 8.3268383  2871.323554
      5 0.3205936   222.171556
      6 0.3337199     1.872296
      7 2.2270326 44275.001680
      8 4.1634192  2871.323554

# binance

    Code
      formatted.binance
    Output
                        date currency   quantity     total.price   spot.rate
      1  2021-03-08 22:22:22      ETH 1.00000000 3098.1375390000 3098.137539
      2  2021-03-08 22:22:22     USDC 5.77124200    7.7365230000    1.340530
      3  2021-05-29 17:07:20      ETH 0.19521000  522.0449644988 2674.273677
      4  2021-05-29 17:07:20      ETH 0.14123140  497.3241148766 3521.342385
      5  2021-05-29 17:07:20      ETH 0.11240000  299.2068137759 2661.982329
      6  2021-05-29 17:07:20      ETH 0.10512900  292.9802111188 2786.863864
      7  2021-05-29 17:07:20      ETH 0.00899120   61.8536687795 6879.356346
      8  2021-05-29 17:07:20      ETH 0.00612410   55.6683019015 9090.038030
      9  2021-05-29 17:07:20      LTC 2.53200000  522.0449644988  206.178896
      10 2021-05-29 17:07:20      LTC 2.41210000  497.3241148766  206.178896
      11 2021-05-29 17:07:20      LTC 1.45120000  299.2068137759  206.178896
      12 2021-05-29 17:07:20      LTC 1.42100000  292.9802111188  206.178896
      13 2021-05-29 17:07:20      LTC 0.30000000   61.8536687795  206.178896
      14 2021-05-29 17:07:20      LTC 0.27000000   55.6683019015  206.178896
      15 2021-05-29 17:07:20      LTC 0.00202500    0.0000000000  206.178896
      16 2021-05-29 17:07:20      LTC 0.00127520    0.0000000000  206.178896
      17 2021-05-29 17:07:20      LTC 0.00113100    0.0000000000  206.178896
      18 2021-05-29 17:07:20      LTC 0.00049230    0.0000000000  206.178896
      19 2021-05-29 17:07:20      LTC 0.00007000    0.0000000000  206.178896
      20 2021-05-29 17:07:20      LTC 0.00005000    0.0000000000  206.178896
      21 2021-05-29 18:12:55      ETH 0.44124211 1251.5087700917 2836.331215
      22 2021-05-29 18:12:55      ETH 0.42124000 1194.7761611271 2836.331215
      23 2021-05-29 18:12:55      ETH 0.00021470    0.0000000000 2836.331215
      24 2021-05-29 18:12:55      ETH 0.00009251    0.0000000000 2836.331215
      25 2021-05-29 18:12:55      LTC 1.60000000 1251.5087700917  782.192981
      26 2021-05-29 18:12:55      LTC 1.23000000 1194.7761611271  971.362733
      27 2021-11-05 04:32:23     BUSD 0.10512330    0.1309409989    1.245594
      28 2022-11-17 11:54:25     ETHW 0.00012050    0.0006093518    5.056861
      29 2022-11-27 08:05:35     BUSD 5.77124200    7.7212045360    1.337876
      30 2022-11-27 08:05:35     USDC 5.77124200    7.7213724784    1.337905
         transaction       fees                     description comment revenue.type
      1          buy 0.00000000 fake transaction for format_ACB    <NA>         <NA>
      2          buy 0.00000000 fake transaction for format_ACB    <NA>         <NA>
      3         sell 0.00000000                             Buy    Spot         <NA>
      4         sell 0.00000000                             Buy    Spot         <NA>
      5         sell 0.00000000                             Buy    Spot         <NA>
      6         sell 0.00000000                             Buy    Spot         <NA>
      7         sell 0.00000000                             Buy    Spot         <NA>
      8         sell 0.00000000                             Buy    Spot         <NA>
      9          buy 1.53005359                             Buy    Spot         <NA>
      10         buy 1.19831174                             Buy    Spot         <NA>
      11         buy 1.11769579                             Buy    Spot         <NA>
      12         buy 0.64389669                             Buy    Spot         <NA>
      13         buy 0.06185367                             Buy    Spot         <NA>
      14         buy 0.04329757                             Buy    Spot         <NA>
      15     revenue 0.00000000               Referral Kickback    Spot      rebates
      16     revenue 0.00000000               Referral Kickback    Spot      rebates
      17     revenue 0.00000000               Referral Kickback    Spot      rebates
      18     revenue 0.00000000               Referral Kickback    Spot      rebates
      19     revenue 0.00000000               Referral Kickback    Spot      rebates
      20     revenue 0.00000000               Referral Kickback    Spot      rebates
      21         buy 6.02188288                            Sell    Spot         <NA>
      22         buy 1.73696924                            Sell    Spot         <NA>
      23     revenue 0.00000000               Referral Kickback    Spot      rebates
      24     revenue 0.00000000               Referral Kickback    Spot      rebates
      25        sell 0.00000000                            Sell    Spot         <NA>
      26        sell 0.00000000                            Sell    Spot         <NA>
      27     revenue 0.00000000   Simple Earn Flexible Interest    Earn    interests
      28     revenue 0.00000000                    Distribution    Spot        forks
      29         buy 0.00000000     Stablecoins Auto-Conversion    Spot         <NA>
      30        sell 0.00000000     Stablecoins Auto-Conversion    Spot         <NA>
                   value exchange               rate.source currency2 total.quantity
      1  3098.1375390000  binance                      fake       ETH      1.0000000
      2     7.7365230000  binance                      fake      USDC      5.7712420
      3   522.0449644988  binance coinmarketcap (buy price)       ETH      0.8047900
      4   497.3241148766  binance coinmarketcap (buy price)       ETH      0.6635586
      5   299.2068137759  binance coinmarketcap (buy price)       ETH      0.5511586
      6   292.9802111188  binance coinmarketcap (buy price)       ETH      0.4460296
      7    61.8536687795  binance coinmarketcap (buy price)       ETH      0.4370384
      8    55.6683019015  binance coinmarketcap (buy price)       ETH      0.4309143
      9   522.0449644988  binance             coinmarketcap       LTC      2.5320000
      10  497.3241148766  binance             coinmarketcap       LTC      4.9441000
      11  299.2068137759  binance             coinmarketcap       LTC      6.3953000
      12  292.9802111188  binance             coinmarketcap       LTC      7.8163000
      13   61.8536687795  binance             coinmarketcap       LTC      8.1163000
      14   55.6683019015  binance             coinmarketcap       LTC      8.3863000
      15    0.4175122643  binance             coinmarketcap       LTC      8.3883250
      16    0.2629193281  binance             coinmarketcap       LTC      8.3896002
      17    0.2331883313  binance             coinmarketcap       LTC      8.3907312
      18    0.1015018705  binance             coinmarketcap       LTC      8.3912235
      19    0.0144325227  binance             coinmarketcap       LTC      8.3912935
      20    0.0103089448  binance             coinmarketcap       LTC      8.3913435
      21 1251.5087700917  binance             coinmarketcap       ETH      0.8721564
      22 1194.7761611271  binance             coinmarketcap       ETH      1.2933964
      23    0.6089603119  binance             coinmarketcap       ETH      1.2936111
      24    0.2623890007  binance             coinmarketcap       ETH      1.2937036
      25 1251.5087700917  binance coinmarketcap (buy price)       LTC      6.7913435
      26 1194.7761611271  binance coinmarketcap (buy price)       LTC      5.5613435
      27    0.1309409989  binance             coinmarketcap      BUSD      0.1051233
      28    0.0006093518  binance             coinmarketcap      ETHW      0.0001205
      29    7.7212045360  binance             coinmarketcap      BUSD      5.8763653
      30    7.7213724784  binance             coinmarketcap      USDC      0.0000000
                                            suploss.range quantity.60days
      1  2021-02-06 22:22:22 UTC--2021-04-07 22:22:22 UTC       1.0000000
      2  2021-02-06 22:22:22 UTC--2021-04-07 22:22:22 UTC       5.7712420
      3  2021-04-29 17:07:20 UTC--2021-06-28 17:07:20 UTC       0.8624821
      4  2021-04-29 17:07:20 UTC--2021-06-28 17:07:20 UTC       0.8624821
      5  2021-04-29 17:07:20 UTC--2021-06-28 17:07:20 UTC       0.8624821
      6  2021-04-29 17:07:20 UTC--2021-06-28 17:07:20 UTC       0.8624821
      7  2021-04-29 17:07:20 UTC--2021-06-28 17:07:20 UTC       0.8624821
      8  2021-04-29 17:07:20 UTC--2021-06-28 17:07:20 UTC       0.8624821
      9  2021-04-29 17:07:20 UTC--2021-06-28 17:07:20 UTC       8.3863000
      10 2021-04-29 17:07:20 UTC--2021-06-28 17:07:20 UTC       8.3863000
      11 2021-04-29 17:07:20 UTC--2021-06-28 17:07:20 UTC       8.3863000
      12 2021-04-29 17:07:20 UTC--2021-06-28 17:07:20 UTC       8.3863000
      13 2021-04-29 17:07:20 UTC--2021-06-28 17:07:20 UTC       8.3863000
      14 2021-04-29 17:07:20 UTC--2021-06-28 17:07:20 UTC       8.3863000
      15 2021-04-29 17:07:20 UTC--2021-06-28 17:07:20 UTC       8.3863000
      16 2021-04-29 17:07:20 UTC--2021-06-28 17:07:20 UTC       8.3863000
      17 2021-04-29 17:07:20 UTC--2021-06-28 17:07:20 UTC       8.3863000
      18 2021-04-29 17:07:20 UTC--2021-06-28 17:07:20 UTC       8.3863000
      19 2021-04-29 17:07:20 UTC--2021-06-28 17:07:20 UTC       8.3863000
      20 2021-04-29 17:07:20 UTC--2021-06-28 17:07:20 UTC       8.3863000
      21 2021-04-29 18:12:55 UTC--2021-06-28 18:12:55 UTC       0.8624821
      22 2021-04-29 18:12:55 UTC--2021-06-28 18:12:55 UTC       0.8624821
      23 2021-04-29 18:12:55 UTC--2021-06-28 18:12:55 UTC       0.8624821
      24 2021-04-29 18:12:55 UTC--2021-06-28 18:12:55 UTC       0.8624821
      25 2021-04-29 18:12:55 UTC--2021-06-28 18:12:55 UTC       8.3863000
      26 2021-04-29 18:12:55 UTC--2021-06-28 18:12:55 UTC       8.3863000
      27 2021-10-06 04:32:23 UTC--2021-12-05 04:32:23 UTC       0.0000000
      28 2022-10-18 11:54:25 UTC--2022-12-17 11:54:25 UTC       0.0000000
      29 2022-10-28 08:05:35 UTC--2022-12-27 08:05:35 UTC       5.7712420
      30 2022-10-28 08:05:35 UTC--2022-12-27 08:05:35 UTC       0.0000000
         share.left60 sup.loss.quantity sup.loss gains.uncorrected gains.sup
      1     1.0000000         0.0000000    FALSE        0.00000000        NA
      2     5.7712420         0.0000000    FALSE        0.00000000        NA
      3     1.2937036         0.1952100     TRUE      -82.74246449 -82.74246
      4     1.2937036         0.1412314    FALSE       45.24946083        NA
      5     1.2937036         0.1124000     TRUE      -60.57996958 -60.57997
      6     1.2937036         0.1051290     TRUE      -55.08759883 -55.08760
      7     1.2937036         0.0089912    FALSE       30.97455684        NA
      8     1.2937036         0.0061241    FALSE       34.63587359        NA
      9     5.5613435         0.0000000    FALSE        0.00000000        NA
      10    5.5613435         0.0000000    FALSE        0.00000000        NA
      11    5.5613435         0.0000000    FALSE        0.00000000        NA
      12    5.5613435         0.0000000    FALSE        0.00000000        NA
      13    5.5613435         0.0000000    FALSE        0.00000000        NA
      14    5.5613435         0.0000000    FALSE        0.00000000        NA
      15    5.5613435         0.0000000    FALSE        0.00000000        NA
      16    5.5613435         0.0000000    FALSE        0.00000000        NA
      17    5.5613435         0.0000000    FALSE        0.00000000        NA
      18    5.5613435         0.0000000    FALSE        0.00000000        NA
      19    5.5613435         0.0000000    FALSE        0.00000000        NA
      20    5.5613435         0.0000000    FALSE        0.00000000        NA
      21    1.2937036         0.0000000    FALSE        0.00000000        NA
      22    1.2937036         0.0000000    FALSE        0.00000000        NA
      23    1.2937036         0.0000000    FALSE        0.00000000        NA
      24    1.2937036         0.0000000    FALSE        0.00000000        NA
      25    5.5613435         1.6000000    FALSE      920.94464834        NA
      26    5.5613435         1.2300000    FALSE      940.65499253        NA
      27    0.1051233         0.0000000    FALSE        0.00000000        NA
      28    0.0001205         0.0000000    FALSE        0.00000000        NA
      29    5.8763653         0.0000000    FALSE        0.00000000        NA
      30    0.0000000         0.0000000    FALSE       -0.01515052        NA
         gains.excess        gains             ACB   ACB.share
      1            NA           NA 3098.1375390000 3098.137539
      2            NA           NA    7.7365230000    1.340530
      3            NA           NA 2576.0925745012 3200.950030
      4            NA  45.24946083 2124.0179204592 3200.950030
      5            NA           NA 1824.8111066833 3310.863891
      6            NA           NA 1531.8308955645 3434.370489
      7            NA  30.97455684 1500.9517836217 3434.370489
      8            NA  34.63587359 1479.9193553086 3434.370489
      9            NA           NA  523.5750180855  206.783182
      10           NA           NA 1022.0974447053  206.730739
      11           NA           NA 1322.4219542761  206.780285
      12           NA           NA 1616.0460620869  206.753331
      13           NA           NA 1677.9615845352  206.739719
      14           NA           NA 1733.6731840049  206.726826
      15           NA           NA 1733.6731840049  206.676921
      16           NA           NA 1733.6731840049  206.645507
      17           NA           NA 1733.6731840049  206.617653
      18           NA           NA 1733.6731840049  206.605531
      19           NA           NA 1733.6731840049  206.603807
      20           NA           NA 1733.6731840049  206.602576
      21           NA           NA 2737.4500082754 3138.714544
      22           NA           NA 3933.9631386387 3041.575737
      23           NA           NA 3933.9631386387 3041.070928
      24           NA           NA 3933.9631386387 3040.853467
      25           NA 920.94464834 1403.1090622516  206.602576
      26           NA 940.65499253 1148.9878936537  206.602576
      27           NA           NA    0.1309409989    1.245594
      28           NA           NA    0.0006093518    5.056861
      29           NA           NA    7.8521455349    1.336225
      30           NA  -0.01515052    0.0000000000    0.000000

# binance withdrawals

    Code
      formatted.binance.withdrawals
    Output
                       date currency quantity total.price spot.rate transaction fees
      1 2021-03-28 17:13:50      LTC 0.002000   0.6404585  320.2293         buy    0
      2 2021-03-28 18:15:14      ETH 0.000142   0.4747382 3343.2269         buy    0
      3 2021-04-06 19:55:52      ETH 0.000124   0.5306760 4279.6449         buy    0
      4 2021-04-28 17:13:50      LTC 0.001000   0.3202293  320.2293        sell    0
      5 2021-04-28 18:15:14      ETH 0.000071   0.2373691 3343.2269        sell    0
      6 2021-05-06 19:55:52      ETH 0.000062   0.2653380 4279.6449        sell    0
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
      1        0.002000     0.002000          0.000000    FALSE        0.00000000
      2        0.000266     0.000266          0.000000    FALSE        0.00000000
      3        0.000266     0.000133          0.000000    FALSE        0.00000000
      4        0.000000     0.001000          0.000000    FALSE        0.00000000
      5        0.000124     0.000133          0.000071     TRUE       -0.03099333
      6        0.000124     0.000133          0.000062    FALSE        0.02113904
          gains.sup gains.excess      gains       ACB ACB.share
      1          NA           NA         NA 0.6404585  320.2293
      2          NA           NA         NA 0.4747382 3343.2269
      3          NA           NA         NA 1.0054142 3779.7526
      4          NA           NA         NA 0.3202293  320.2293
      5 -0.03099333           NA         NA 0.7680451 3938.6927
      6          NA           NA 0.02113904 0.5238461 3938.6927

# CDC exchange trades

    Code
      formatted.CDC.exchange.trades
    Output
                        date currency   quantity total.price    spot.rate transaction
      1  2021-03-08 22:22:22      ETH     1.0000  3098.13754 3098.1375390         buy
      2  2021-12-24 15:34:45      CRO 13260.1300 10383.49502    0.7830613         buy
      3  2021-12-24 15:34:45      CRO  3555.9000  2784.48778    0.7830613         buy
      4  2021-12-24 15:34:45      CRO  1781.7400  1395.21169    0.7830613         buy
      5  2021-12-24 15:34:45      CRO    26.8500    21.02520    0.7830613         buy
      6  2021-12-24 15:34:45      CRO    26.6700    20.88425    0.7830613         buy
      7  2021-12-24 15:34:45      CRO    17.7800    13.92283    0.7830613         buy
      8  2021-12-24 15:34:45      CRO    17.7800    13.92283    0.7830613         buy
      9  2021-12-24 15:34:45      ETH     2.0932 10383.49502 4960.5842834        sell
      10 2021-12-24 15:34:45      ETH     0.5600  2784.48778 4972.2996075        sell
      11 2021-12-24 15:34:45      ETH     0.2800  1395.21169 4982.8989019        sell
      12 2021-12-24 15:34:45      ETH     0.0042    21.02520 5005.9992112        sell
      13 2021-12-24 15:34:45      ETH     0.0042    20.88425 4972.4394399        sell
      14 2021-12-24 15:34:45      ETH     0.0028    13.92283 4972.4394399        sell
      15 2021-12-24 15:34:45      ETH     0.0028    13.92283 4972.4394399        sell
                fees                     description comment     exchange
      1   0.00000000 fake transaction for format_ACB    <NA> CDC.exchange
      2   0.00000000                             BUY ETH_CRO CDC.exchange
      3   0.00000000                             BUY ETH_CRO CDC.exchange
      4   0.00000000                             BUY ETH_CRO CDC.exchange
      5   0.00000000                             BUY ETH_CRO CDC.exchange
      6   0.00000000                             BUY ETH_CRO CDC.exchange
      7   0.00000000                             BUY ETH_CRO CDC.exchange
      8   0.00000000                             BUY ETH_CRO CDC.exchange
      9  41.53398371                            SELL ETH_CRO CDC.exchange
      10 11.13794862                            SELL ETH_CRO CDC.exchange
      11  5.58085805                            SELL ETH_CRO CDC.exchange
      12  0.08411163                            SELL ETH_CRO CDC.exchange
      13  0.08353356                            SELL ETH_CRO CDC.exchange
      14  0.05568992                            SELL ETH_CRO CDC.exchange
      15  0.05568983                            SELL ETH_CRO CDC.exchange
                       rate.source currency2 total.quantity
      1                       fake       ETH         1.0000
      2              coinmarketcap       CRO     13260.1300
      3              coinmarketcap       CRO     16816.0300
      4              coinmarketcap       CRO     18597.7700
      5              coinmarketcap       CRO     18624.6200
      6              coinmarketcap       CRO     18651.2900
      7              coinmarketcap       CRO     18669.0700
      8              coinmarketcap       CRO     18686.8500
      9  coinmarketcap (buy price)       ETH        -1.0932
      10 coinmarketcap (buy price)       ETH        -1.6532
      11 coinmarketcap (buy price)       ETH        -1.9332
      12 coinmarketcap (buy price)       ETH        -1.9374
      13 coinmarketcap (buy price)       ETH        -1.9416
      14 coinmarketcap (buy price)       ETH        -1.9444
      15 coinmarketcap (buy price)       ETH        -1.9472
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
      1        1.0000                 0    FALSE           0.00000        NA
      2    18686.8500                 0    FALSE           0.00000        NA
      3    18686.8500                 0    FALSE           0.00000        NA
      4    18686.8500                 0    FALSE           0.00000        NA
      5    18686.8500                 0    FALSE           0.00000        NA
      6    18686.8500                 0    FALSE           0.00000        NA
      7    18686.8500                 0    FALSE           0.00000        NA
      8    18686.8500                 0    FALSE           0.00000        NA
      9       -1.9472                 0    FALSE        3856.93954        NA
      10      -1.9472                 0    FALSE        2773.34983        NA
      11      -1.9472                 0    FALSE        1389.63083        NA
      12      -1.9472                 0    FALSE          20.94109        NA
      13      -1.9472                 0    FALSE          20.80071        NA
      14      -1.9472                 0    FALSE          13.86714        NA
      15      -1.9472                 0    FALSE          13.86714        NA
         gains.excess      gains       ACB    ACB.share
      1            NA         NA  3098.138 3098.1375390
      2            NA         NA 10383.495    0.7830613
      3            NA         NA 13167.983    0.7830613
      4            NA         NA 14563.194    0.7830613
      5            NA         NA 14584.220    0.7830613
      6            NA         NA 14605.104    0.7830613
      7            NA         NA 14619.027    0.7830613
      8            NA         NA 14632.950    0.7830613
      9            NA 3856.93954 -3386.884    0.0000000
      10           NA 2773.34983 -5121.841    0.0000000
      11           NA 1389.63083 -5989.319    0.0000000
      12           NA   20.94109 -6002.332    0.0000000
      13           NA   20.80071 -6015.344    0.0000000
      14           NA   13.86714 -6024.019    0.0000000
      15           NA   13.86714 -6032.693    0.0000000

