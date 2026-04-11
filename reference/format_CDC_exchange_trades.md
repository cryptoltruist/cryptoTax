# Format CDC exchange file (FOR TRADES ONLY)

Format a .csv transaction history file from the Crypto.com exchange for
later ACB processing. Only processes trades, not rewards (see
`format_CDC_exchange_rewards` for this).

## Usage

``` r
format_CDC_exchange_trades(data, list.prices = NULL, force = FALSE)
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

## Details

Original file name of the right file from the exchange is called
"SPOT_TRADE.csv", make sure you have the right one. It can usually be
accessed with the following steps: (1) connect to the CDC exchange. On
the left menu, click on "Wallet", and choose the "Transactions" tab.
Pick your desired dates. Unfortunately, the CDC exchange history export
only supports 30 days at a time. So if you have more than that, you will
need to export each file and merge them manually before you use this
function.

As of the new changes to the exchange (3.0) transactions before November
1st, 2022, one can go instead through the "Archive" button on the left
vertical menu, choose dates (max 100 days), and download trade
transactions. It will be a zip file with several transaction files
inside. Choose the "SPOT_TRADE.csv".

In newer versions of this transaction history file, CDC has added three
disclaimer character lines at the top of the file, which is messing with
the headers. Thus, when reading the file with
[`read.csv()`](https://rdrr.io/r/utils/read.table.html), add the
argument `skip = 3`. You will then be able to read the file normally.

Update 2024: the unzipped correct file is now named "OEX_TRADE.csv"
instead of "SPOT_TRADE.csv".

Also note that the USD bundle ("USD_Stable_Coin") is treated as USDC for
our purposes since it can be withdrawn as USDC and it is easier to
calculate prices with CoinMarketCap and later capital gains and so on.

## Examples

``` r
format_CDC_exchange_trades(data_CDC_exchange_trades)
#> Object 'list.prices' already exists. Reusing 'list.prices'. To force a fresh download, use argument 'force = TRUE'.
#> Object 'list.prices' already exists. Reusing 'list.prices'. To force a fresh download, use argument 'force = TRUE'.
#>                   date currency   quantity total.price    spot.rate transaction
#> 1  2021-12-24 15:34:45      CRO 13260.1300 10383.49502    0.7830613         buy
#> 2  2021-12-24 15:34:45      ETH     2.0932 10383.49502 4960.5842834        sell
#> 3  2021-12-24 15:34:45      CRO  3555.9000  2784.48778    0.7830613         buy
#> 4  2021-12-24 15:34:45      ETH     0.5600  2784.48778 4972.2996075        sell
#> 5  2021-12-24 15:34:45      CRO  1781.7400  1395.21169    0.7830613         buy
#> 6  2021-12-24 15:34:45      ETH     0.2800  1395.21169 4982.8989019        sell
#> 7  2021-12-24 15:34:45      CRO    26.8500    21.02520    0.7830613         buy
#> 8  2021-12-24 15:34:45      ETH     0.0042    21.02520 5005.9992112        sell
#> 9  2021-12-24 15:34:45      CRO    26.6700    20.88425    0.7830613         buy
#> 10 2021-12-24 15:34:45      ETH     0.0042    20.88425 4972.4394399        sell
#> 11 2021-12-24 15:34:45      CRO    17.7800    13.92283    0.7830613         buy
#> 12 2021-12-24 15:34:45      CRO    17.7800    13.92283    0.7830613         buy
#> 13 2021-12-24 15:34:45      ETH     0.0028    13.92283 4972.4394399        sell
#> 14 2021-12-24 15:34:45      ETH     0.0028    13.92283 4972.4394399        sell
#>           fees fees.quantity fees.currency description comment     exchange
#> 1  41.53398371   53.04052463           CRO         BUY ETH_CRO CDC.exchange
#> 2           NA            NA          <NA>        SELL ETH_CRO CDC.exchange
#> 3  11.13794862   14.22359680           CRO         BUY ETH_CRO CDC.exchange
#> 4           NA            NA          <NA>        SELL ETH_CRO CDC.exchange
#> 5   5.58085805    7.12697440           CRO         BUY ETH_CRO CDC.exchange
#> 6           NA            NA          <NA>        SELL ETH_CRO CDC.exchange
#> 7   0.08411163    0.10741385           CRO         BUY ETH_CRO CDC.exchange
#> 8           NA            NA          <NA>        SELL ETH_CRO CDC.exchange
#> 9   0.08353356    0.10667563           CRO         BUY ETH_CRO CDC.exchange
#> 10          NA            NA          <NA>        SELL ETH_CRO CDC.exchange
#> 11  0.05568992    0.07111821           CRO         BUY ETH_CRO CDC.exchange
#> 12  0.05568983    0.07111810           CRO         BUY ETH_CRO CDC.exchange
#> 13          NA            NA          <NA>        SELL ETH_CRO CDC.exchange
#> 14          NA            NA          <NA>        SELL ETH_CRO CDC.exchange
#>                  rate.source
#> 1              coinmarketcap
#> 2  coinmarketcap (buy price)
#> 3              coinmarketcap
#> 4  coinmarketcap (buy price)
#> 5              coinmarketcap
#> 6  coinmarketcap (buy price)
#> 7              coinmarketcap
#> 8  coinmarketcap (buy price)
#> 9              coinmarketcap
#> 10 coinmarketcap (buy price)
#> 11             coinmarketcap
#> 12             coinmarketcap
#> 13 coinmarketcap (buy price)
#> 14 coinmarketcap (buy price)
```
