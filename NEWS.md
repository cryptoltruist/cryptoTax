# cryptoTax 0.0.2

New Features:

- New `pkgdown` website with two vignettes: one for calculating ACB and the other about tax treatments and decisions.
- Informative progress bars with `format_ACB` and `format_suploss` since these functions are extremely slow.
- Added ACB example data sets
- New function: `format_binance_earn`, to process Binance rewards.
- New function: `format_binance`, a general version that works with the general transaction report.

Improvements:

- Massive improvements in speed by using joins for price lookups (instead of making a new API request for each row) for both prices of coins and USD to CAD conversions.
- Added tests for ACB and superficial losses
- Updated `format_newton` to the new format

Bug Fixes:

- Fixed a bug for NANO/XNO
- Fixed various R CMD check errors, warnings, and notes.

# cryptoTax 0.0.1

New package
