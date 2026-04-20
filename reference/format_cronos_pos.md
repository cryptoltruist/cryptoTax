# Format transaction data from the Cronos POS chain

Format a .csv transaction history file from the Crypto.com DeFi wallet
for later ACB processing.

Use
[`fetch_cronos_pos()`](https://cryptoltruist.github.io/cryptoTax/reference/fetch_cronos_pos.md)
to first download the data.

## Usage

``` r
format_cronos_pos(data, list.prices = NULL, force = FALSE)
```

## Arguments

- data:

  The dataframe

- list.prices:

  An optional explicit `list.prices` object from which to fetch coin
  prices. For exchanges that require external pricing, it must contain
  at least `currency`, `spot.rate2`, and `date2`.

- force:

  Whether to force recreating `list.prices` even though it already
  exists (e.g., if you added new coins or new dates).

## Value

A data frame of exchange transactions, formatted for further processing.

## Examples

``` r
# \donttest{
data <- fetch_cronos_pos(
  limit = 30,
  "cro1juv4wda4ty2tas8dwh7jc2ea73ewhtc26eyxwt"
)
#> $total_record
#> [1] 758
#> 
#> $total_page
#> [1] 26
#> 
#> $current_page
#> [1] 1
#> 
#> $limit
#> [1] 30
#> 
#> Warning: Total number of transactions detected higher than the set limit. Adjust as needed with the 'limit' argument
format_cronos_pos(data)
#> Using cached 'list.prices'. To force a fresh download, use argument 'force = TRUE'.
#>                   date currency     quantity  total.price spot.rate transaction
#> 1  2021-11-28 06:00:38      CRO   0.00020000 1.963015e-04 0.9815073        sell
#> 2  2021-11-28 06:00:38      CRO   0.00000000 0.000000e+00 0.9815073     revenue
#> 3  2021-11-28 20:34:08      CRO   0.00020000 1.963015e-04 0.9815073        sell
#> 4  2021-11-28 20:34:08      CRO   0.00000000 0.000000e+00 0.9815073     revenue
#> 5  2021-11-29 22:35:48      CRO   0.00020000 1.873850e-04 0.9369251        sell
#> 6  2021-12-01 00:40:36      CRO   0.00893473 8.053155e-03 0.9013316     revenue
#> 7  2021-12-01 00:40:36      CRO   0.00020000 1.802663e-04 0.9013316        sell
#> 8  2021-12-01 00:42:18      CRO   0.00020000 1.802663e-04 0.9013316        sell
#> 9  2021-12-01 00:42:18      CRO   0.00000348 3.136634e-06 0.9013316     revenue
#> 10 2021-12-01 00:43:26      CRO   0.00003980 3.587300e-05 0.9013316        sell
#> 11 2021-12-01 00:55:29      CRO   0.14445831 1.302048e-01 0.9013316     revenue
#> 12 2021-12-01 00:55:29      CRO   0.00020000 1.802663e-04 0.9013316        sell
#> 13 2021-12-01 00:59:52      CRO   0.00007356 6.630196e-05 0.9013316        sell
#> 14 2021-12-01 01:00:31      CRO   0.00020000 1.802663e-04 0.9013316        sell
#> 15 2021-12-02 20:42:13      CRO   0.12007988 1.088812e-01 0.9067398     revenue
#> 16 2021-12-02 20:42:13      CRO   0.00020000 1.813480e-04 0.9067398        sell
#> 17 2021-12-02 21:27:10      CRO   0.00005946 5.391475e-05 0.9067398        sell
#> 18 2021-12-02 21:28:18      CRO   0.00020000 1.813480e-04 0.9067398        sell
#> 19 2021-12-07 08:12:17      CRO   0.29164927 2.240008e-01 0.7680486     revenue
#> 20 2021-12-07 08:12:17      CRO   0.00020000 1.536097e-04 0.7680486        sell
#> 21 2021-12-07 08:47:16      CRO   0.00030536 2.345313e-04 0.7680486        sell
#> 22 2021-12-07 09:00:53      CRO   0.00030615 2.351381e-04 0.7680486        sell
#> 23 2021-12-09 04:01:47      CRO   0.00005496 4.117366e-05 0.7491569        sell
#> 24 2021-12-11 16:01:07      CRO   0.11824111 8.481185e-02 0.7172788     revenue
#> 25 2021-12-11 16:01:07      CRO   0.00020000 1.434558e-04 0.7172788        sell
#> 26 2021-12-11 16:03:03      CRO 185.05488013 1.327359e+02 0.7172788     revenue
#> 27 2021-12-11 16:03:03      CRO   0.00020000 1.434558e-04 0.7172788        sell
#> 28 2021-12-19 03:08:18      CRO   0.49717646 3.324524e-01 0.6686808     revenue
#> 29 2021-12-19 03:08:18      CRO   0.00020000 1.337362e-04 0.6686808        sell
#> 30 2021-12-27 00:35:19      CRO   0.51924766 4.157489e-01 0.8006756     revenue
#> 31 2021-12-27 00:35:19      CRO   0.00020000 1.601351e-04 0.8006756        sell
#>     description
#> 1  staking cost
#> 2       staking
#> 3  staking cost
#> 4       staking
#> 5    withdrawal
#> 6  distribution
#> 7  staking cost
#> 8  staking cost
#> 9       staking
#> 10   ibc_client
#> 11 distribution
#> 12 staking cost
#> 13   ibc_client
#> 14   withdrawal
#> 15 distribution
#> 16 staking cost
#> 17   ibc_client
#> 18   withdrawal
#> 19 distribution
#> 20 staking cost
#> 21   ibc_client
#> 22   ibc_client
#> 23   ibc_client
#> 24 distribution
#> 25 staking cost
#> 26      staking
#> 27 staking cost
#> 28 distribution
#> 29 staking cost
#> 30 distribution
#> 31 staking cost
#>                                                                                              comment
#> 1                                  Stake on Validator crocncl17ph30pdn43yggj7d72dhztlzwwxnkfj9gn85h8
#> 2                           Auto Withdraw Reward from crocncl17ph30pdn43yggj7d72dhztlzwwxnkfj9gn85h8
#> 3                                  Stake on Validator crocncl12p3emq9ergyynqw5pltnajcuk8yccy3uk2vdd6
#> 4                           Auto Withdraw Reward from crocncl12p3emq9ergyynqw5pltnajcuk8yccy3uk2vdd6
#> 5  Outgoing Transaction to (/cosmos.bank.v1beta1.MsgSend) cro1w2kvwrzp23aq54n3amwav4yy4a9ahq2kz2wtmj
#> 6                                Withdraw Reward from crocncl17ph30pdn43yggj7d72dhztlzwwxnkfj9gn85h8
#> 7                        Withdraw staking reward from crocncl17ph30pdn43yggj7d72dhztlzwwxnkfj9gn85h8
#> 8                                        Unstake from crocncl17ph30pdn43yggj7d72dhztlzwwxnkfj9gn85h8
#> 9                           Auto Withdraw Reward from crocncl17ph30pdn43yggj7d72dhztlzwwxnkfj9gn85h8
#> 10     Bridging chains (crypto.org relayer | hermes 0.8.0+a3a1ad6 (https://hermes.informal.systems))
#> 11                               Withdraw Reward from crocncl12p3emq9ergyynqw5pltnajcuk8yccy3uk2vdd6
#> 12                       Withdraw staking reward from crocncl12p3emq9ergyynqw5pltnajcuk8yccy3uk2vdd6
#> 13     Bridging chains (crypto.org relayer | hermes 0.8.0+a3a1ad6 (https://hermes.informal.systems))
#> 14 Outgoing Transaction to (/cosmos.bank.v1beta1.MsgSend) cro1w2kvwrzp23aq54n3amwav4yy4a9ahq2kz2wtmj
#> 15                               Withdraw Reward from crocncl12p3emq9ergyynqw5pltnajcuk8yccy3uk2vdd6
#> 16                       Withdraw staking reward from crocncl12p3emq9ergyynqw5pltnajcuk8yccy3uk2vdd6
#> 17     Bridging chains (crypto.org relayer | hermes 0.8.0+a3a1ad6 (https://hermes.informal.systems))
#> 18 Outgoing Transaction to (/cosmos.bank.v1beta1.MsgSend) cro1w2kvwrzp23aq54n3amwav4yy4a9ahq2kz2wtmj
#> 19                               Withdraw Reward from crocncl12p3emq9ergyynqw5pltnajcuk8yccy3uk2vdd6
#> 20                       Withdraw staking reward from crocncl12p3emq9ergyynqw5pltnajcuk8yccy3uk2vdd6
#> 21     Bridging chains (crypto.org relayer | hermes 0.8.0+a3a1ad6 (https://hermes.informal.systems))
#> 22     Bridging chains (crypto.org relayer | hermes 0.8.0+a3a1ad6 (https://hermes.informal.systems))
#> 23     Bridging chains (crypto.org relayer | hermes 0.8.0+a3a1ad6 (https://hermes.informal.systems))
#> 24                               Withdraw Reward from crocncl12p3emq9ergyynqw5pltnajcuk8yccy3uk2vdd6
#> 25                       Withdraw staking reward from crocncl12p3emq9ergyynqw5pltnajcuk8yccy3uk2vdd6
#> 26                          Auto Withdraw Reward from crocncl12p3emq9ergyynqw5pltnajcuk8yccy3uk2vdd6
#> 27                                 Stake on Validator crocncl12p3emq9ergyynqw5pltnajcuk8yccy3uk2vdd6
#> 28                               Withdraw Reward from crocncl17ph30pdn43yggj7d72dhztlzwwxnkfj9gn85h8
#> 29                       Withdraw staking reward from crocncl17ph30pdn43yggj7d72dhztlzwwxnkfj9gn85h8
#> 30                               Withdraw Reward from crocncl17ph30pdn43yggj7d72dhztlzwwxnkfj9gn85h8
#> 31                       Withdraw staking reward from crocncl17ph30pdn43yggj7d72dhztlzwwxnkfj9gn85h8
#>    revenue.type   exchange   rate.source
#> 1          <NA> CDC.wallet coinmarketcap
#> 2       staking CDC.wallet coinmarketcap
#> 3          <NA> CDC.wallet coinmarketcap
#> 4       staking CDC.wallet coinmarketcap
#> 5          <NA> CDC.wallet coinmarketcap
#> 6       staking CDC.wallet coinmarketcap
#> 7          <NA> CDC.wallet coinmarketcap
#> 8          <NA> CDC.wallet coinmarketcap
#> 9       staking CDC.wallet coinmarketcap
#> 10         <NA> CDC.wallet coinmarketcap
#> 11      staking CDC.wallet coinmarketcap
#> 12         <NA> CDC.wallet coinmarketcap
#> 13         <NA> CDC.wallet coinmarketcap
#> 14         <NA> CDC.wallet coinmarketcap
#> 15      staking CDC.wallet coinmarketcap
#> 16         <NA> CDC.wallet coinmarketcap
#> 17         <NA> CDC.wallet coinmarketcap
#> 18         <NA> CDC.wallet coinmarketcap
#> 19      staking CDC.wallet coinmarketcap
#> 20         <NA> CDC.wallet coinmarketcap
#> 21         <NA> CDC.wallet coinmarketcap
#> 22         <NA> CDC.wallet coinmarketcap
#> 23         <NA> CDC.wallet coinmarketcap
#> 24      staking CDC.wallet coinmarketcap
#> 25         <NA> CDC.wallet coinmarketcap
#> 26      staking CDC.wallet coinmarketcap
#> 27         <NA> CDC.wallet coinmarketcap
#> 28      staking CDC.wallet coinmarketcap
#> 29         <NA> CDC.wallet coinmarketcap
#> 30      staking CDC.wallet coinmarketcap
#> 31         <NA> CDC.wallet coinmarketcap
# }
```
