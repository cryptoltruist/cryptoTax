# Changelog

## cryptoTax 0.1.0.4

**Improvements:**

- Continued the formatter cleanup across
  [`format_gemini()`](https://cryptoltruist.github.io/cryptoTax/reference/format_gemini.md),
  [`format_CDC_exchange_trades()`](https://cryptoltruist.github.io/cryptoTax/reference/format_CDC_exchange_trades.md),
  and
  [`format_CDC()`](https://cryptoltruist.github.io/cryptoTax/reference/format_CDC.md)
  to make larger exchange-formatting paths easier to read and maintain
  without changing user-facing behavior.
- Kept the package fully green through the CDC and Gemini refactor
  batch, including `devtools::check(document = TRUE)`.

## cryptoTax 0.1.0.3

**Improvements:**

- Continued the formatter cleanup across
  [`format_generic()`](https://cryptoltruist.github.io/cryptoTax/reference/format_generic.md),
  [`format_shakepay()`](https://cryptoltruist.github.io/cryptoTax/reference/format_shakepay.md),
  [`format_binance()`](https://cryptoltruist.github.io/cryptoTax/reference/format_binance.md),
  and
  [`format_coinsmart()`](https://cryptoltruist.github.io/cryptoTax/reference/format_coinsmart.md)
  to make exchange formatting workflows easier to follow and maintain
  without changing user-facing behavior.
- Continued the reporting-output cleanup by simplifying the internal
  structure of
  [`tax_box()`](https://cryptoltruist.github.io/cryptoTax/reference/tax_box.md)
  and
  [`tax_table()`](https://cryptoltruist.github.io/cryptoTax/reference/tax_table.md).
- Kept the package fully green through the formatter and tax-output
  refactor batch, including `devtools::check(document = TRUE)`.

## cryptoTax 0.1.0.2

**Improvements:**

- Continued a broader reporting-stack cleanup across
  [`format_ACB()`](https://cryptoltruist.github.io/cryptoTax/reference/format_ACB.md),
  [`report_overview()`](https://cryptoltruist.github.io/cryptoTax/reference/report_overview.md),
  [`report_summary()`](https://cryptoltruist.github.io/cryptoTax/reference/report_summary.md),
  [`report_revenues()`](https://cryptoltruist.github.io/cryptoTax/reference/report_revenues.md),
  [`prepare_report()`](https://cryptoltruist.github.io/cryptoTax/reference/prepare_report.md),
  and
  [`print_report()`](https://cryptoltruist.github.io/cryptoTax/reference/print_report.md)
  to make report generation and summary logic easier to maintain without
  changing user-facing behavior.
- Simplified workflow and exchange-format tests by introducing a shared
  example-data helper and removing brittle `eval(parse())` test paths.
- Kept the package fully green through the reporting refactor batch,
  including `devtools::check(document = TRUE)`.

## cryptoTax 0.1.0.1

**Improvements:**

- Continued the internal maintenance cleanup of
  [`match_prices()`](https://cryptoltruist.github.io/cryptoTax/reference/match_prices.md),
  [`format_detect()`](https://cryptoltruist.github.io/cryptoTax/reference/format_detect.md),
  and
  [`ACB()`](https://cryptoltruist.github.io/cryptoTax/reference/ACB.md)
  to make core pricing, formatter dispatch, and cost-base code easier to
  maintain without changing package behavior.
- Kept the package fully green after the refactor batch, including
  `R CMD check` and the built-package test suite.

## cryptoTax 0.1.0

**Improvements:**

- Hardened pricing and FX handling so key workflows can accept explicit
  pricing inputs instead of relying only on hidden session state.
- Added a built-in offline `list.prices` fixture dataset for examples,
  reporting, and tests.
- Improved offline behavior for reporting, examples, tests, and
  vignettes when live pricing data is unavailable.
- Expanded deterministic test coverage around
  [`USD2CAD()`](https://cryptoltruist.github.io/cryptoTax/reference/USD2CAD.md),
  price preparation, reporting, exchange formatting, and the full
  workflow.
- Refreshed test snapshots so the main integration paths now run against
  a deterministic offline pricing baseline.
- Continued the internal pricing and FX cleanup by centralizing
  `list.prices` and `USD2CAD.table` preparation paths while preserving
  compatibility.
- Cleaned `R CMD check` issues, updated package metadata, and now
  declare `R (>= 4.1.0)` explicitly.

## cryptoTax 0.0.7

From the `crypto2` package update: \> fiat_list() has been modified and
no longer delivers all available currencies and precious metals
(therefore only USD and Bitcoin are available any more).

Therefore, the
[`USD2CAD()`](https://cryptoltruist.github.io/cryptoTax/reference/USD2CAD.md)
function now relies on the rates from the Bank of Canada, which only
provides data for business days. On days which data is not available,
the last known value is used instead. The
[`prepare_list_prices()`](https://cryptoltruist.github.io/cryptoTax/reference/prepare_list_prices.md)
function has also been updated accordingly.

Also, because of too many duplicated symbols,
[`prepare_list_prices()`](https://cryptoltruist.github.io/cryptoTax/reference/prepare_list_prices.md)
now requires using the unique “slug” name of the coin. You can obtain
the correct slug using `crypto2::crypto_list(only_active = TRUE)` and
then filtering for your symbol.

Updated functions due to changes in exchanges transaction history
files: -
[`format_CDC_exchange_trades()`](https://cryptoltruist.github.io/cryptoTax/reference/format_CDC_exchange_trades.md) -
[`format_shakepay()`](https://cryptoltruist.github.io/cryptoTax/reference/format_shakepay.md)

## cryptoTax 0.0.6

**Breaking changes:**

- [`USD2CAD()`](https://cryptoltruist.github.io/cryptoTax/reference/USD2CAD.md)
  now uses a different system to convert USD rates to CAD.
  [`USD2CAD()`](https://cryptoltruist.github.io/cryptoTax/reference/USD2CAD.md)
  used to rely on the
  [`priceR`](https://github.com/stevecondylios/priceR), which depends on
  exchangerate.host which now requires an API key with very few limited
  free API calls. The old `priceR` function is still available, if you
  have an API key, with
  [`USD2CAD_priceR()`](https://cryptoltruist.github.io/cryptoTax/reference/USD2CAD_priceR.md).
  One alternative is to take the USDC to CAD rate, since USDC is usually
  pretty closely pegged to the USD. For instance, from 2021 to 2024, the
  average difference between USD and and USDC is only 0.00003 CAD.
  Nonetheless, to get an exact rate, the new system compares USD and CAD
  rates for USDC and calculates the adjusted CAD rate based on this.

**New Features:**

- New function:
  [`fetch_cronos_pos()`](https://cryptoltruist.github.io/cryptoTax/reference/fetch_cronos_pos.md)
  (to download data from the CDC DeFi wallet)
- New function:
  [`format_cronos_pos()`](https://cryptoltruist.github.io/cryptoTax/reference/format_cronos_pos.md)
  (as a replacement of
  [`format_CDC_wallet()`](https://cryptoltruist.github.io/cryptoTax/reference/format_CDC_wallet.md))
- New function:
  [`format_coinbase()`](https://cryptoltruist.github.io/cryptoTax/reference/format_coinbase.md)

**Improvements:**

- Various improvements to `format_` functions (ACB, CDC_wallet, blockfi,
  presearch) and `prepare_report`

## cryptoTax 0.0.5

CRAN release: 2023-03-12

- Added CRAN requirements

## cryptoTax 0.0.4

CRAN release: 2023-03-08

- Added CRAN requirements

## cryptoTax 0.0.3

CRAN release: 2023-03-07

- Added CRAN requirements

## cryptoTax 0.0.2

CRAN release: 2023-02-20

**Breaking changes:**

- We get rid of the `format_wealtsimple()`, `format_BSC()`,
  `format_binance_trades()`, `crypto2fiat()`, and `fetch_prices()`
  functions, since their goal is better fulfilled by the new
  [`format_generic()`](https://cryptoltruist.github.io/cryptoTax/reference/format_generic.md),
  [`format_binance()`](https://cryptoltruist.github.io/cryptoTax/reference/format_binance.md),
  [`match_prices()`](https://cryptoltruist.github.io/cryptoTax/reference/match_prices.md),
  and
  [`prepare_list_prices()`](https://cryptoltruist.github.io/cryptoTax/reference/prepare_list_prices.md)
  functions, respectively.

**New Features:**

- New `pkgdown` website with three vignettes: (1) calculating ACB, (2)
  full tax report, and (3) tax treatments and decisions.
- Informative progress bars with
  [`format_ACB()`](https://cryptoltruist.github.io/cryptoTax/reference/format_ACB.md)
  and
  [`format_suploss()`](https://cryptoltruist.github.io/cryptoTax/reference/format_suploss.md)
  since these functions are extremely slow with thousands of
  transactions.
- Added example data sets (ACB, cryptotaxcalculator, coinpanda, koinly,
  shakepay, CDC, CDC exchange rewards, CDC exchange trades, CDC wallet,
  adalite, binance, binance withdrawals, blockfi, celsius, coinsmart,
  exodus, newton, presearch, pooltool, gemini, uphold)
- Now detects new transaction types not accounted for
- New functions:
  - [`prepare_report()`](https://cryptoltruist.github.io/cryptoTax/reference/prepare_report.md)
    to get all the required information for
    [`print_report()`](https://cryptoltruist.github.io/cryptoTax/reference/print_report.md)
    in one go.
  - `get_sup_losses` was it was the last missing piece to get all the
    info needed for
    [`prepare_report()`](https://cryptoltruist.github.io/cryptoTax/reference/prepare_report.md).
  - [`format_detect()`](https://cryptoltruist.github.io/cryptoTax/reference/format_detect.md),
    to automatically detect the right exchange and process it with the
    corresponding function (also supports lists of exchanges).
  - [`format_generic()`](https://cryptoltruist.github.io/cryptoTax/reference/format_generic.md),
    to process most transaction history files not supported by existing
    functions.
  - [`format_binance()`](https://cryptoltruist.github.io/cryptoTax/reference/format_binance.md),
    a general version that works with the general transaction report and
    includes rewards (but not withdrawal fees). We thus get rid of
    `format_binance_trades()` since the former is superior (as it
    includes more transaction types).
  - [`get_latest_transactions()`](https://cryptoltruist.github.io/cryptoTax/reference/get_latest_transactions.md):
    get latest transaction date by exchange
  - [`check_missing_transactions()`](https://cryptoltruist.github.io/cryptoTax/reference/check_missing_transactions.md):
    show you rows with negative total balances to help identify missing
    transactions.
  - [`format_dollars()`](https://cryptoltruist.github.io/cryptoTax/reference/format_dollars.md):
    to format numeric values with comma for thousands separator.

**Improvements:**

- [`format_blockfi()`](https://cryptoltruist.github.io/cryptoTax/reference/format_blockfi.md)
  and
  [`format_CDC_exchange_trades()`](https://cryptoltruist.github.io/cryptoTax/reference/format_CDC_exchange_trades.md)
  now correctly match prices for purchases and sales for trades (instead
  of relying on their corresponding daily spot rates).
- Consistently use plural for reward types.
- Massive improvements in speed by using joins for price lookups
  (instead of making a new API request for each row) for both prices of
  coins and USD to CAD conversions.
- When prices are fetched through `priceR` (for USD to CAD conversions),
  now indicates the source of the price accordingly
  (`rate.source = "exchange (USD conversion)"`)
- All `format_*` functions: now reorder columns in a consistent
  fashion + tests for all (and
  [`ACB()`](https://cryptoltruist.github.io/cryptoTax/reference/ACB.md)).
- `ACB_suploss()`: integrates the primary
  [`ACB()`](https://cryptoltruist.github.io/cryptoTax/reference/ACB.md)
  function, which accordingly gains a new logical argument, `suploss`.
- [`format_suploss()`](https://cryptoltruist.github.io/cryptoTax/reference/format_suploss.md):
  integrates
  [`ACB()`](https://cryptoltruist.github.io/cryptoTax/reference/ACB.md)
  when `suploss = TRUE`, and gains a greatly improved code base.
- `add_quantities()`: switches from a for-loop to `dplyr` code.
- [`ACB()`](https://cryptoltruist.github.io/cryptoTax/reference/ACB.md):
  - new warning messages:
    - when not providing first buy transactions (so no ACB…)
    - when more than one currency are provided at a time
    - when insufficient columns are provided to calculate ‘total.price’
- [`report_revenues()`](https://cryptoltruist.github.io/cryptoTax/reference/report_revenues.md)
  and
  [`crypto_pie()`](https://cryptoltruist.github.io/cryptoTax/reference/crypto_pie.md):
  Now support forks and mining.
- [`format_newton()`](https://cryptoltruist.github.io/cryptoTax/reference/format_newton.md):
  updated to the new format
- [`format_CDC()`](https://cryptoltruist.github.io/cryptoTax/reference/format_CDC.md):
  - new warning message when withdrawal fees could not be detected
    automatically.
  - new transaction types supported: forks (“admin_wallet_credited”),
    sales (“crypto_viban_exchange”, “card_top_up”,
    “crypto_wallet_swap_debited”), and supercharger rewards
    (“supercharger_reward_to_app_credited”)
  - On coinmarketcap, after 2022-05-28, LUNA gets renamed to LUNC, and
    the LUNA2 fork gets renamed to LUNA. This is confusing because on
    CDC, they use the terms LUNA and LUNC (which are the same), and
    LUNA2, which is the new LUNA fork. Therefore, we now rename “LUNA”
    transactions (on CDC) to “LUNC”, and “LUNA2” to “LUNA”.

**Bug Fixes:**

- [`format_shakepay()`](https://cryptoltruist.github.io/cryptoTax/reference/format_shakepay.md):
  now correctly detects CAD referral rewards
- [`format_binance()`](https://cryptoltruist.github.io/cryptoTax/reference/format_binance.md):
  now correctly detects interest rewards
- [`format_ACB()`](https://cryptoltruist.github.io/cryptoTax/reference/format_ACB.md):
  - fixed a bug whereas a superficial loss of quantity = 0 would prevent
    the computation of the ACB.
  - corrected “Total time elapsed:” time unit to always be minutes
- [`ACB()`](https://cryptoltruist.github.io/cryptoTax/reference/ACB.md):
  now correctly accept alternative column names
- Fixed a bug for NANO/XNO
- Fixed various R CMD check errors, warnings, and notes.

## cryptoTax 0.0.1

New package
