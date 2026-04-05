# Check for new transactions

Check for new transactions for a given exchange

## Usage

``` r
check_new_transactions(
  data,
  known.transactions,
  transactions.col,
  description.col = NULL
)
```

## Arguments

- data:

  The dataframe

- known.transactions:

  A list of known transactions

- transactions.col:

  The name of the transaction column

- description.col:

  The name of the description column, if available.

## Value

A warning, if there are new transactions. Returns nothing otherwise.

## Examples

``` r
data <- data_CDC[1:5, ]
known.transactions <- c("crypto_purchase", "lockup_lock")
check_new_transactions(data,
  known.transactions = known.transactions,
  transactions.col = "Transaction.Kind",
  description.col = "Transaction.Description"
)
#> Warning: New transaction types detected! These may be unaccounted for: admin_wallet_credited, crypto_viban_exchange, mco_stake_reward, rewards_platform_deposit_credited. Associated descriptions: Adjustment (Credit), BTC -> CAD, CRO Stake Rewards, ETH -> CAD, Mission Rewards Deposit
```
