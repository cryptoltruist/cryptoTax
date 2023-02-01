# shakepay

    Code
      formatted.shakepay
    Output
                       date currency    quantity total.price spot.rate transaction
      1 2021-05-07 14:50:41      BTC  0.00103982    53.03335  51002.43         buy
      2 2021-05-07 21:25:36      CAD 30.00000000     0.00000      1.00     revenue
      3 2021-05-08 12:12:57      BTC  0.00011000     0.00000  52582.03     revenue
      4 2021-05-09 12:22:07      BTC  0.00012000     0.00000  50287.01     revenue
      5 2021-05-21 12:47:14      BTC  0.00013000     0.00000  56527.62     revenue
      6 2021-06-11 12:03:31      BTC  0.00014000     0.00000  59978.05     revenue
      7 2021-06-23 12:21:49      BTC  0.00015000     0.00000  58099.18     revenue
      8 2021-07-10 00:52:19      BTC  0.00052991    31.26848  59007.15        sell
        fees   description  comment revenue.type     value exchange rate.source
      1    0 purchase/sale purchase         <NA> 53.033350 shakepay    exchange
      2    0         other   credit    referrals 30.000000 shakepay    exchange
      3    0   shakingsats   credit     airdrops  5.784024 shakepay    exchange
      4    0   shakingsats   credit     airdrops  6.034441 shakepay    exchange
      5    0   shakingsats   credit     airdrops  7.348590 shakepay    exchange
      6    0   shakingsats   credit     airdrops  8.396927 shakepay    exchange
      7    0   shakingsats   credit     airdrops  8.714877 shakepay    exchange
      8    0 purchase/sale     sale         <NA> 31.268480 shakepay    exchange
        currency2 total.quantity                                    suploss.range
      1       BTC     0.00103982 2021-04-07 14:50:41 UTC--2021-06-06 14:50:41 UTC
      2       CAD    30.00000000 2021-04-07 21:25:36 UTC--2021-06-06 21:25:36 UTC
      3       BTC     0.00114982 2021-04-08 12:12:57 UTC--2021-06-07 12:12:57 UTC
      4       BTC     0.00126982 2021-04-09 12:22:07 UTC--2021-06-08 12:22:07 UTC
      5       BTC     0.00139982 2021-04-21 12:47:14 UTC--2021-06-20 12:47:14 UTC
      6       BTC     0.00153982 2021-05-12 12:03:31 UTC--2021-07-11 12:03:31 UTC
      7       BTC     0.00168982 2021-05-24 12:21:49 UTC--2021-07-23 12:21:49 UTC
      8       BTC     0.00115991 2021-06-10 00:52:19 UTC--2021-08-09 00:52:19 UTC
        quantity.60days share.left60 sup.loss.quantity sup.loss gains.uncorrected
      1      0.00103982   0.00139982                 0    FALSE           0.00000
      2      0.00000000  30.00000000                 0    FALSE           0.00000
      3      0.00103982   0.00139982                 0    FALSE           0.00000
      4      0.00103982   0.00139982                 0    FALSE           0.00000
      5      0.00103982   0.00153982                 0    FALSE           0.00000
      6      0.00000000   0.00115991                 0    FALSE           0.00000
      7      0.00000000   0.00115991                 0    FALSE           0.00000
      8      0.00000000   0.00115991                 0    FALSE          14.63777
        gains.sup gains.excess    gains      ACB ACB.share
      1        NA           NA       NA 53.03335  51002.43
      2        NA           NA       NA  0.00000      0.00
      3        NA           NA       NA 53.03335  46123.18
      4        NA           NA       NA 53.03335  41764.46
      5        NA           NA       NA 53.03335  37885.84
      6        NA           NA       NA 53.03335  34441.27
      7        NA           NA       NA 53.03335  31384.02
      8        NA           NA 14.63777 36.40264  31384.02

# CDC

    Code
      formatted.CDC
    Output
                        date currency       quantity total.price     spot.rate
      1  2021-05-03 22:05:50      BTC   0.0007333710       51.25 69882.7777778
      2  2021-05-07 23:06:50      ETH   0.0205920059       54.21  2632.5750000
      3  2021-05-15 18:07:10      CRO 182.4360090842       53.42     0.2928150
      4  2021-05-23 22:09:39      CRO 117.9468230300        0.00     0.2559658
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
                           comment                        revenue.type    value
      1                    Buy BTC                                <NA> 51.25000
      2                    Buy ETH                                <NA> 54.21000
      3                    Buy CRO                                <NA> 53.42000
      4     Sign-up Bonus Unlocked                           referrals 30.19035
      5              Card Cashback                             rebates  1.13000
      6       Card Rebate: Spotify                             rebates 10.99000
      7       Card Rebate: Netflix                             rebates 16.94000
      8  Card Rebate: Amazon Prime                             rebates  9.19000
      9       Card Rebate: Expedia                             rebates 11.65000
      10       Supercharger Reward supercharger_reward_to_app_credited  0.05000
      11               Pay Rewards                             rebates  1.25000
      12               Crypto Earn                           interests  3.12000
      13       Crypto Earn (Extra)                           interests  0.26000
      14       Adjustment (Credit)                               forks  3.20000
      15   Mission Rewards Deposit                             rewards  1.20000
      16         CRO Stake Rewards                           interests  6.98000
      17                BTC -> CAD                                <NA> 35.00000
      18                ETH -> CAD                                <NA> 35.00000
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

# blockfi

    Code
      formatted.blockfi
    Output
                       date currency     quantity total.price    spot.rate
      1 2021-05-29 21:43:44      BTC  0.000018512   0.7858598 42451.369876
      2 2021-05-29 21:43:44      LTC  0.022451200   4.6255734   206.027889
      3 2021-06-13 21:43:44      BTC  0.000184120   0.0000000 45381.388034
      4 2021-06-30 21:43:44      BTC  0.000047234   2.0770535 43973.694092
      5 2021-06-30 21:43:44      LTC  0.010125120   1.8084980   178.614968
      6 2021-07-29 21:43:44     USDC  0.038241000   0.0477449     1.248526
      7 2021-08-07 21:43:44      BTC  0.000441230   0.0000000 54847.843168
      8 2021-10-24 04:29:23      LTC  0.165122140  68.0777573   412.287276
      9 2021-10-24 04:29:23     USDC 55.000000000  68.0777573     1.237777
        transaction fees      description revenue.type      value exchange
      1     revenue    0 Interest Payment    interests  0.7858598  blockfi
      2     revenue    0 Interest Payment    interests  4.6255734  blockfi
      3     revenue    0   Referral Bonus    referrals  8.3556212  blockfi
      4     revenue    0 Interest Payment    interests  2.0770535  blockfi
      5     revenue    0 Interest Payment    interests  1.8084980  blockfi
      6     revenue    0 Interest Payment    interests  0.0477449  blockfi
      7     revenue    0    Bonus Payment       promos 24.2005138  blockfi
      8        sell    0            Trade         <NA> 68.0777573  blockfi
      9         buy    0            Trade         <NA> 68.0777573  blockfi
                      rate.source currency2 total.quantity
      1             coinmarketcap       BTC    0.000018512
      2             coinmarketcap       LTC    0.022451200
      3             coinmarketcap       BTC    0.000202632
      4             coinmarketcap       BTC    0.000249866
      5             coinmarketcap       LTC    0.032576320
      6             coinmarketcap      USDC    0.038241000
      7             coinmarketcap       BTC    0.000691096
      8 coinmarketcap (buy price)       LTC   -0.132545820
      9             coinmarketcap      USDC   55.038241000
                                           suploss.range quantity.60days share.left60
      1 2021-04-29 21:43:44 UTC--2021-06-28 21:43:44 UTC               0  0.000202632
      2 2021-04-29 21:43:44 UTC--2021-06-28 21:43:44 UTC               0  0.022451200
      3 2021-05-14 21:43:44 UTC--2021-07-13 21:43:44 UTC               0  0.000249866
      4 2021-05-31 21:43:44 UTC--2021-07-30 21:43:44 UTC               0  0.000249866
      5 2021-05-31 21:43:44 UTC--2021-07-30 21:43:44 UTC               0  0.032576320
      6 2021-06-29 21:43:44 UTC--2021-08-28 21:43:44 UTC               0  0.038241000
      7 2021-07-08 21:43:44 UTC--2021-09-06 21:43:44 UTC               0  0.000691096
      8 2021-09-24 04:29:23 UTC--2021-11-23 04:29:23 UTC               0 -0.132545820
      9 2021-09-24 04:29:23 UTC--2021-11-23 04:29:23 UTC              55 55.038241000
        sup.loss.quantity sup.loss gains.uncorrected gains.sup gains.excess    gains
      1                 0    FALSE           0.00000        NA           NA       NA
      2                 0    FALSE           0.00000        NA           NA       NA
      3                 0    FALSE           0.00000        NA           NA       NA
      4                 0    FALSE           0.00000        NA           NA       NA
      5                 0    FALSE           0.00000        NA           NA       NA
      6                 0    FALSE           0.00000        NA           NA       NA
      7                 0    FALSE           0.00000        NA           NA       NA
      8                 0    FALSE          35.46488        NA           NA 35.46488
      9                 0    FALSE           0.00000        NA           NA       NA
                ACB    ACB.share
      1   0.7858598 42451.369876
      2   4.6255734   206.027889
      3   0.7858598  3878.260882
      4   2.8629132 11457.794281
      5   6.4340713   197.507617
      6   0.0477449     1.248526
      7   2.8629132  4142.569521
      8 -26.1788091     0.000000
      9  68.1255022     1.237785

# celsius

    Code
      formatted.celsius
    Output
                       date currency       quantity total.price  spot.rate
      1 2021-03-03 21:11:00      BTC 0.000707598916   0.0000000  71542.733
      2 2021-03-07 05:00:00      BTC 0.000025237883   0.1364482   5406.484
      3 2021-03-19 05:00:00      BTC 0.000081561209   0.7278227   8923.638
      4 2021-03-28 05:00:00      BTC 0.000003683063   0.5977337 162292.567
      5 2021-04-05 05:00:00      BTC 0.000046940391   0.5847333  12456.934
      6 2021-04-08 05:00:00      BTC 0.000051775622   0.6441503  12441.189
      7 2021-04-08 22:18:00      BTC 0.000733082450   0.0000000  68568.331
      8 2021-05-06 10:32:00      BTC 0.001409023441   0.0000000  43137.182
      9 2021-05-23 05:00:00      BTC 0.000063726694   0.4167779   6540.084
        transaction fees       description revenue.type      value exchange
      1     revenue    0 Promo Code Reward       promos 50.6235600  celsius
      2     revenue    0            Reward    interests  0.1364482  celsius
      3     revenue    0            Reward    interests  0.7278227  celsius
      4     revenue    0            Reward    interests  0.5977337  celsius
      5     revenue    0            Reward    interests  0.5847333  celsius
      6     revenue    0            Reward    interests  0.6441503  celsius
      7     revenue    0    Referred Award    referrals 50.2662400  celsius
      8     revenue    0 Promo Code Reward       promos 60.7813000  celsius
      9     revenue    0            Reward    interests  0.4167779  celsius
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
      2 0.1364482  186.1918
      3 0.8642709 1061.2390
      4 1.4620046 1787.1146
      5 2.0467380 2366.1124
      6 2.6908883 2935.0969
      7 2.6908883 1630.9605
      8 2.6908883  879.6906
      9 3.1076662  995.2081

# adalite

    Code
      formatted.adalite
    Output
                       date currency  quantity total.price spot.rate transaction fees
      1 2021-04-28 16:56:00      ADA 0.3120400   0.5091943  1.631824     revenue    0
      2 2021-05-07 16:53:00      ADA 0.3125132   0.6266931  2.005333     revenue    0
      3 2021-05-12 16:56:00      ADA 0.2212410   0.4441940  2.007738     revenue    0
      4 2021-05-17 17:16:00      ADA 0.4123210   1.0798503  2.618955     revenue    0
      5 2021-05-17 21:16:00      ADA 0.1691870   0.4430932  2.618955        sell    0
      6 2021-05-17 21:31:00      ADA 0.1912300   0.5008228  2.618955        sell    0
           description        comment revenue.type     value exchange   rate.source
      1 Reward awarded           <NA>      staking 0.5091943  adalite coinmarketcap
      2 Reward awarded           <NA>      staking 0.6266931  adalite coinmarketcap
      3 Reward awarded           <NA>      staking 0.4441940  adalite coinmarketcap
      4 Reward awarded           <NA>      staking 1.0798503  adalite coinmarketcap
      5           Sent Withdrawal Fee         <NA> 0.4430932  adalite coinmarketcap
      6           Sent Withdrawal Fee         <NA> 0.5008228  adalite coinmarketcap
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
      5               0    0.8976982                 0    FALSE        0.08539476
      6               0    0.8976982                 0    FALSE        0.09652065
        gains.sup gains.excess      gains       ACB ACB.share
      1        NA           NA         NA 0.5091943  1.631824
      2        NA           NA         NA 1.1358874  1.818720
      3        NA           NA         NA 1.5800813  1.868163
      4        NA           NA         NA 2.6599316  2.114219
      5        NA           NA 0.08539476 2.3022332  2.114219
      6        NA           NA 0.09652065 1.8979310  2.114219

# coinsmart

    Code
      formatted.coinsmart
    Output
                       date currency  quantity total.price    spot.rate transaction
      1 2021-04-25 16:11:24      ADA 198.50000 237.9374300     1.198677         buy
      2 2021-04-28 18:37:15      CAD  15.00000   0.0000000     1.000000     revenue
      3 2021-05-15 16:42:07      BTC   0.00004   0.0000000 58492.582640     revenue
      4 2021-06-03 02:04:49      ADA   0.30000   0.6512228     2.170743        sell
            fees description  comment revenue.type       value  exchange
      1 0.269386    purchase    Trade         <NA> 237.9374300 coinsmart
      2 0.000000       Other Referral    referrals  15.0000000 coinsmart
      3 0.000000       Other     Quiz     airdrops   2.3397033 coinsmart
      4 0.000000         Fee Withdraw         <NA>   0.6512228 coinsmart
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
      4                 0    FALSE         0.2912125        NA           NA 0.2912125
             ACB ACB.share
      1 238.2068  1.200034
      2   0.0000  0.000000
      3   0.0000  0.000000
      4 237.8468  1.200034

# presearch

    Code
      formatted.presearch
    Output
                        date currency quantity total.price  spot.rate transaction
      1  2021-04-27 17:45:18      PRE     0.13     0.00000 0.09306492     revenue
      2  2021-04-27 17:48:00      PRE     0.13     0.00000 0.09306492     revenue
      3  2021-04-27 17:48:18      PRE     0.13     0.00000 0.09306492     revenue
      4  2021-04-27 17:55:24      PRE     0.13     0.00000 0.09306492     revenue
      5  2021-04-27 17:57:29      PRE     0.13     0.00000 0.09306492     revenue
      6  2021-04-27 19:00:31      PRE     0.13     0.00000 0.09306492     revenue
      7  2021-04-27 19:00:41      PRE     0.13     0.00000 0.09306492     revenue
      8  2021-04-27 19:01:57      PRE     0.13     0.00000 0.09306492     revenue
      9  2021-04-27 19:08:59      PRE     0.13     0.00000 0.09306492     revenue
      10 2021-04-27 19:12:15      PRE     0.13     0.00000 0.09306492     revenue
      11 2021-05-07 05:55:33      PRE  1000.00    78.90639 0.07890639         buy
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
      1   0.01209844 presearch coinmarketcap       PRE           0.13
      2   0.01209844 presearch coinmarketcap       PRE           0.26
      3   0.01209844 presearch coinmarketcap       PRE           0.39
      4   0.01209844 presearch coinmarketcap       PRE           0.52
      5   0.01209844 presearch coinmarketcap       PRE           0.65
      6   0.01209844 presearch coinmarketcap       PRE           0.78
      7   0.01209844 presearch coinmarketcap       PRE           0.91
      8   0.01209844 presearch coinmarketcap       PRE           1.04
      9   0.01209844 presearch coinmarketcap       PRE           1.17
      10  0.01209844 presearch coinmarketcap       PRE           1.30
      11 78.90639103 presearch coinmarketcap       PRE        1001.30
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
      11           NA    NA 78.90639 0.07880395

# newton

    Code
      formatted.newton
    Output
                       date currency   quantity total.price  spot.rate transaction
      1 2021-04-04 22:50:12      LTC  0.1048291  23.4912731   224.0911         buy
      2 2021-04-04 22:53:46      CAD 25.0000000   0.0000000     1.0000     revenue
      3 2021-04-04 22:55:55      ETH  0.0198712  25.0142098  1258.8173         buy
      4 2021-04-21 19:57:26      BTC  0.0034300 153.1241354 44642.6051         buy
      5 2021-05-12 21:37:42      BTC  0.0000040   0.3049013 76225.3175         buy
      6 2021-05-12 21:52:40      BTC  0.0032130 156.1241341 48591.3894        sell
      7 2021-06-16 18:49:11      CAD 25.0000000   0.0000000     1.0000     revenue
        fees      description revenue.type       value exchange rate.source currency2
      1    0            TRADE         <NA>  23.4912731   newton    exchange       LTC
      2    0 Referral Program    referrals  25.0000000   newton    exchange       CAD
      3    0            TRADE         <NA>  25.0142098   newton    exchange       ETH
      4    0            TRADE         <NA> 153.1241354   newton    exchange       BTC
      5    0            TRADE         <NA>   0.3049013   newton    exchange       BTC
      6    0            TRADE         <NA> 156.1241341   newton    exchange       BTC
      7    0 Referral Program    referrals  25.0000000   newton    exchange       CAD
        total.quantity                                    suploss.range
      1      0.1048291 2021-03-05 22:50:12 UTC--2021-05-04 22:50:12 UTC
      2     25.0000000 2021-03-05 22:53:46 UTC--2021-05-04 22:53:46 UTC
      3      0.0198712 2021-03-05 22:55:55 UTC--2021-05-04 22:55:55 UTC
      4      0.0034300 2021-03-22 19:57:26 UTC--2021-05-21 19:57:26 UTC
      5      0.0034340 2021-04-12 21:37:42 UTC--2021-06-11 21:37:42 UTC
      6      0.0002210 2021-04-12 21:52:40 UTC--2021-06-11 21:52:40 UTC
      7     50.0000000 2021-05-17 18:49:11 UTC--2021-07-16 18:49:11 UTC
        quantity.60days share.left60 sup.loss.quantity sup.loss gains.uncorrected
      1       0.1048291    0.1048291          0.000000    FALSE           0.00000
      2       0.0000000   25.0000000          0.000000    FALSE           0.00000
      3       0.0198712    0.0198712          0.000000    FALSE           0.00000
      4       0.0034340    0.0002210          0.000000    FALSE           0.00000
      5       0.0034340    0.0002210          0.000000    FALSE           0.00000
      6       0.0034340    0.0002210          0.003213    FALSE          12.56924
      7       0.0000000   50.0000000          0.000000    FALSE           0.00000
        gains.sup gains.excess    gains        ACB  ACB.share
      1        NA           NA       NA  23.491273   224.0911
      2        NA           NA       NA   0.000000     0.0000
      3        NA           NA       NA  25.014210  1258.8173
      4        NA           NA       NA 153.124135 44642.6051
      5        NA           NA       NA 153.429037 44679.3933
      6        NA           NA 12.56924   9.874146 44679.3933
      7        NA           NA       NA   0.000000     0.0000

# CDC exchange rewards

    Code
      formatted.binance.rewards
    Output
                        date currency   quantity  total.price     spot.rate
      1  2021-02-19 00:00:00      CRO 1.36512341 0.2227899953     0.1632014
      2  2021-02-21 00:00:00      CRO 1.36945123 0.2411195812     0.1760702
      3  2021-04-15 16:04:21      BTC 0.00000023 0.0182149274 79195.3367033
      4  2021-04-18 00:00:00      CRO 1.36512310 0.3798900187     0.2782826
      5  2021-05-14 06:02:22      BTC 0.00000035 0.0211513332 60432.3807116
      6  2021-06-12 15:21:34      BTC 0.00000630 0.2791139040 44303.7942802
      7  2021-06-27 01:34:00      CRO 0.00100000 0.0001239785     0.1239785
      8  2021-07-07 00:00:00      CRO 0.01512903 0.0000000000     0.1511808
      9  2021-07-13 00:00:00      CRO 0.05351230 0.0000000000     0.1572142
      10 2021-09-07 00:00:00      CRO 0.01521310 0.0000000000     0.2341842
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
      1  Interest on 5000.00000000 at 10% APR (Completed)    interests 0.2227899953
      2  Interest on 5000.00000000 at 10% APR (Completed)    interests 0.2411195812
      3                           BTC Supercharger reward    interests 0.0182149274
      4  Interest on 5000.00000000 at 10% APR (Completed)    interests 0.3798900187
      5                           BTC Supercharger reward    interests 0.0211513332
      6                           BTC Supercharger reward    interests 0.2791139040
      7                                              <NA>         <NA> 0.0001239785
      8                   Rebate on 0.18512341 CRO at 10%      rebates 0.0022872188
      9                 Rebate on 0.5231512346 CRO at 10%      rebates 0.0084128916
      10                 Rebate on 0.155125123 CRO at 10%      rebates 0.0035626681
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
      7    4.16733907                 0    FALSE    -0.00008184142        NA
      8    4.16733907                 0    FALSE     0.00000000000        NA
      9    4.16733907                 0    FALSE     0.00000000000        NA
      10   4.18255217                 0    FALSE     0.00000000000        NA
         gains.excess          gains        ACB     ACB.share
      1            NA             NA 0.22279000     0.1632014
      2            NA             NA 0.46390958     0.1696460
      3            NA             NA 0.01821493 79195.3367033
      4            NA             NA 0.84379960     0.2058200
      5            NA             NA 0.03936626 67872.8632600
      6            NA             NA 0.31848016 46290.7216070
      7            NA -0.00008184142 0.84359378     0.2058200
      8            NA             NA 0.84359378     0.2050630
      9            NA             NA 0.84359378     0.2024298
      10           NA             NA 0.84359378     0.2016935

# CDC wallet

    Code
      formatted.CDC.wallet
    Output
                       date currency quantity   total.price spot.rate transaction
      1 2021-04-12 18:28:50      CRO 0.512510 0.13593610436 0.2652360     revenue
      2 2021-04-23 18:51:53      CRO 1.656708 0.36013687043 0.2173811     revenue
      3 2021-05-21 01:19:01      CRO 0.000200 0.00002993323 0.1496661        sell
      4 2021-06-26 14:51:02      CRO 6.051235 0.70769054418 0.1169498     revenue
        fees description                                            comment
      1    0      Reward                         Auto Withdraw Reward from 
      2    0      Reward                         Auto Withdraw Reward from 
      3    0  Withdrawal Outgoing Transaction to abcdefghijklmnopqrstuvwxyz
      4    0      Reward    Withdraw Reward from abcdefghijklmnopqrstuvwxyz
        revenue.type         value   exchange   rate.source currency2 total.quantity
      1      staking 0.13593610436 CDC.wallet coinmarketcap       CRO       0.512510
      2      staking 0.36013687043 CDC.wallet coinmarketcap       CRO       2.169218
      3         <NA> 0.00002993323 CDC.wallet coinmarketcap       CRO       2.169018
      4      staking 0.70769054418 CDC.wallet coinmarketcap       CRO       8.220253
                                           suploss.range quantity.60days share.left60
      1 2021-03-13 18:28:50 UTC--2021-05-12 18:28:50 UTC               0     2.169218
      2 2021-03-24 18:51:53 UTC--2021-05-23 18:51:53 UTC               0     2.169018
      3 2021-04-21 01:19:01 UTC--2021-06-20 01:19:01 UTC               0     2.169018
      4 2021-05-27 14:51:02 UTC--2021-07-26 14:51:02 UTC               0     8.220253
        sup.loss.quantity sup.loss gains.uncorrected gains.sup gains.excess
      1                 0    FALSE     0.00000000000        NA           NA
      2                 0    FALSE     0.00000000000        NA           NA
      3                 0    FALSE    -0.00001580427        NA           NA
      4                 0    FALSE     0.00000000000        NA           NA
                 gains       ACB ACB.share
      1             NA 0.1359361 0.2652360
      2             NA 0.4960730 0.2286875
      3 -0.00001580427 0.4960272 0.2286875
      4             NA 1.2037178 0.1464332

