# cryptoTax 0.0.2

New Features:

- New `pkgdown` website with two vignettes: one for calculating ACB and the other about tax treatments and decisions.
- Informative progress bars with `format_ACB` and `format_suploss` since these functions are extremely slow with thousands of transactions.
- Added example data sets (ACB, cryptotaxcalculator, coinpanda, koinly, shakepay, CDC)
- New function: `format_binance_earn`, to process Binance rewards.
- New function: `format_binance`, a general version that works with the general transaction report.

Improvements:

- `ACB_suploss`: integrates the primary `ACB` function, which accordingly gains a new logical argument, `suploss`.
- `format_suploss`: integrates `ACB` when `suploss = TRUE`, and gains a greatly improved code base.
- `add_quantities`: switches from a for-loop to `dplyr` code.
- `ACB`: 
    - Better error message when not providing first buy transactions (so no ACB...)
    - Added tests for ACB and superficial losses
- `report_revenues`: Now support forks and mining.
- `format_newton`: updated to the new format
- `format_CDC`: 
    - new warning message when withdrawal fees could not be detected automatically.
    - new transaction types supported: forks ("admin_wallet_credited") and sales ("crypto_viban_exchange", "card_top_up", "crypto_wallet_swap_debited")
    - To handle LUNA to LUNC balance conversions, all LUNA transactions are renamed "LUNC" since technically it is simply a change of name, so the ACB from LUNA should follow.
- Consistently use plural for reward types.
- Massive improvements in speed by using joins for price lookups (instead of making a new API request for each row) for both prices of coins and USD to CAD conversions.

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
