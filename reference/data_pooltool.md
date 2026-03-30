# Sample data set of a fictive Cardano PoolTool transaction history file

A fictive Cardano PoolTool data set to demonstrate
[`format_pooltool()`](https://cryptoltruist.github.io/cryptoTax/reference/format_pooltool.md).

## Usage

``` r
data_pooltool
```

## Format

A data frame with 10 rows and 12 variables:

- date:

  the date

- epoch:

  the epoch

- stake:

  total staked

- pool:

  staking pool

- operator_rewards:

  rewards for operator

- stake_rewards:

  rewards for staking

- total_rewards:

  rewards for operator + staking

- rate:

  (usually) CAD rate

- currency:

  (usually) CAD

- operator_rewards_value:

  (usually) CAD value for operator rewards

- stake_rewards_value:

  (usually) CAD value for staking rewards

- value:

  (usually) CAD value for operator + staking rewards

## Source

<https://pooltool.io/>
