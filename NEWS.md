# cryptoTax 0.0.2

Breaking changes:

- We get rid of the `format_wealtsimple` and `format_binance_trades` functions, since their goal is better fulfilled by the `format_generic` and `format_binance` functions, respectively.

New Features:

- New `pkgdown` website with two vignettes: one for calculating ACB and the other about tax treatments and decisions.
- Informative progress bars with `format_ACB` and `format_suploss` since these functions are extremely slow with thousands of transactions.
- Added example data sets (ACB, cryptotaxcalculator, coinpanda, koinly, shakepay, CDC)
- New function: `format_generic`, to process most transaction history files not supported by existing functions.
- New function: `format_binance`, a general version that works with the general transaction report and includes rewards (but not withdrawal fees). We thus get rid of `format_binance_trades` since the former is superior (as it includes more transaction types).

Improvements:

- Consistently use plural for reward types.
- Massive improvements in speed by using joins for price lookups (instead of making a new API request for each row) for both prices of coins and USD to CAD conversions.
- New tests for `format_shakepay`, `format_CDC`, `format_generic`, and `ACB`.
- `ACB_suploss`: integrates the primary `ACB` function, which accordingly gains a new logical argument, `suploss`.
- `format_suploss`: integrates `ACB` when `suploss = TRUE`, and gains a greatly improved code base.
- `add_quantities`: switches from a for-loop to `dplyr` code.
- `ACB`: 
    - new warning messages:
        - when not providing first buy transactions (so no ACB...)
        - when more than one currency are provided at a time
        - when insufficient columns are provided to calculate 'total.price'
- `report_revenues` and `crypto_pie`: Now support forks and mining.
- `format_newton`: updated to the new format
- `format_CDC`: 
    - new warning messages
        - when new, unregistered transaction types are detected
        - when withdrawal fees could not be detected automatically.
    - new transaction types supported: forks ("admin_wallet_credited"), sales ("crypto_viban_exchange", "card_top_up", "crypto_wallet_swap_debited"), and supercharger rewards ("supercharger_reward_to_app_credited")
    - On coinmarketcap, after 2022-05-28, LUNA gets renamed to LUNC, and the LUNA2 fork gets renamed to LUNA. This is confusing because on CDC, they use the terms LUNA and LUNC (which are the same), and LUNA2, which is the new LUNA fork. Therefore, we now rename "LUNA" transactions (on CDC) to "LUNC", and "LUNA2" to "LUNA".

Bug Fixes:

- `format_shakepay`: now correctly detect CAD referral rewards
- `format_binance`: now correctly detect interest rewards
- `format_ACB`: 
    - fixed a bug whereas a superficial loss of quantity = 0 would prevent the computation of the ACB.
    - corrected "Total time elapsed:" time unit to always be minutes
- `ACB`: now correctly accept alternative column names
- Fixed a bug for NANO/XNO
- Fixed various R CMD check errors, warnings, and notes.

# cryptoTax 0.0.1

New package
