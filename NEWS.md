# cryptoTax 0.1.0.21

**Improvements:**

- Continued a broader formatter-architecture and deterministic-pricing cleanup across `format_CDC()`, `format_celsius()`, `format_detect()`, `format_exchanges()`, `format_coinsmart()`, `format_CDC_exchange()`, `format_CDC_exchange_trades()`, `format_gemini()`, `format_blockfi()`, and `format_uphold()` so explicit pricing/FX inputs are supported more consistently and more formatter paths reuse shared helper behavior instead of hand-rolled branching.
- Expanded formatter governance by turning the `format_detect()` registry into the source of truth for schema regressions, so every bundled exchange example is now validated against the canonical formatted-transaction contract.
- Replaced repeated sell-price propagation logic with a shared formatter helper and added direct regressions for that paired buy/sell pricing behavior, reducing one of the largest remaining duplicated formatter patterns.

# cryptoTax 0.1.0.20

**Improvements:**

- Continued a broader pricing, FX, formatting, and reporting hardening pass across `prepare_list_prices()`, `match_prices()`, `USD2CAD()`, `format_detect()`, `format_exchanges()`, `report_summary()`, `report_overview()`, `prepare_report()`, and `print_report()` to make explicit offline inputs the primary safe path while preserving compatibility with the older session-cache workflow.
- Hardened malformed-price handling so explicit `list.prices` inputs now fail cleanly and consistently across price matching, formatter entry points, and current-value reporting paths instead of surfacing misleading API/network messages or partial outputs.
- Tightened session-cache behavior by validating cached pricing/FX tables before reuse, scoping cache reads explicitly to `.GlobalEnv`, and removing a lingering `exists()`-driven Bank of Canada FX fetch pattern.
- Moved normal in-session pricing cache writes into a package-owned cache with new `pricing_cache()` and `clear_pricing_cache()` helpers, while keeping `.GlobalEnv` reuse as a deprecated compatibility fallback with explicit migration messaging.
- Converted the full report vignette to the built-in offline `list_prices_example` fixture and standardized formatter/report documentation so the public `list.prices` contract is clearer and more reproducible.
- Added canonical formatted-transaction schema validation at the `format_detect()` / `format_exchanges()` boundary and expanded representative formatter tests so malformed formatted inputs or malformed formatter outputs fail early with direct schema errors.
- Expanded focused regressions around malformed explicit pricing inputs, cache-reuse behavior, FX fallback behavior, formatter orchestration, report helpers, and the public report-preparation path.

# cryptoTax 0.1.0.19

**Improvements:**

- Added `format_exchanges()` as the higher-level public entry point for formatting one or more exchange exports, including mixed raw/formatted inputs, nested lists, empty inputs, and multiple direct arguments.
- Shifted the user-facing workflow toward `format_exchanges()` across the README, report vignette, higher-level help examples, and utility examples so the package now teaches a more consistent ingest-to-report happy path.
- Expanded direct and snapshot coverage around the new public ingest wrapper, including mixed-input behavior and equivalence with the older manual `format_detect()` plus `merge_exchanges()` path.

# cryptoTax 0.1.0.18

**Improvements:**

- Continued a broader ingestion and orchestration hardening pass across `format_detect()`, `merge_exchanges()`, and `check_new_transactions()` to make top-level list formatting, merge ordering, and transaction-warning behavior more explicit and robust without changing the underlying exchange-specific tax logic.
- Hardened the public list path in `format_detect()` so nested lists are accepted recursively, empty data frames are skipped cleanly, and whitespace-only description values do not create false detection signals.
- Expanded focused tests around nested and empty list inputs, public-path whitespace normalization in transaction warnings, missing-date merge ordering, and the full workflow path that now exercises `format_detect()` directly for grouped exchange inputs.

# cryptoTax 0.1.0.17

**Improvements:**

- Continued a broader proceeds, revenues, and superficial-loss cleanup across `get_proceeds()`, `get_sup_losses()`, `report_revenues()`, `report_helpers()`, `tax_box()`, and `print_report()` to make summary-table assembly, total-row handling, and report-metric extraction more explicit and less dependent on row order.
- Fixed a `report_revenues()` regression that was collapsing multi-exchange revenue output down to a single exchange row before totals were added.
- Expanded focused tests around empty proceeds/revenue shapes, multi-exchange revenue finalization, total-row selection for revenues and superficial losses, and tax-box/report helpers that now match values by labels instead of row position.

# cryptoTax 0.1.0.16

**Improvements:**

- Continued a broader ingestion and detection hardening pass across `merge_exchanges()`, `check_new_transactions()`, and `format_detect()` to make merge behavior, transaction-warning generation, exchange detection, and list dispatch more explicit and robust without changing user-facing behavior.
- Expanded focused helper tests around nested merge inputs, schema-preserving empty data frames, factor and blank-string transaction values, format-detect registry lookups, and `NULL`/invalid list inputs.

# cryptoTax 0.1.0.15

**Improvements:**

- Continued a broader formatter cleanup across `format_shakepay()`, `format_celsius()`, `format_coinbase()`, `format_adalite()`, `format_newton()`, `format_exodus()`, `format_presearch()`, and `format_pooltool()` to make wallet and exchange formatting paths more explicit and easier to maintain without changing user-facing behavior.
- Added focused helper tests for the new formatter seams, including exchange-specific classification, timestamp parsing, reward mapping, and final output annotation.

# cryptoTax 0.1.0.14

**Improvements:**

- Continued a broader ACB, reporting, and tax-output cleanup across `ACB()`, `format_ACB()`, `format_suploss()`, `get_proceeds()`, `get_sup_losses()`, `report_summary()`, `report_overview()`, `prepare_report()`, `print_report()`, and `tax_box()` to make cost-base analysis and report-generation logic more explicit and easier to maintain without changing user-facing behavior.
- Expanded focused tests around ACB helper seams, superficial-loss helpers, proceeds and tax-box output contracts, report-summary/report-overview helper behavior, and report timezone propagation.

# cryptoTax 0.1.0.13

**Improvements:**

- Continued a broader ingestion and formatter-entry cleanup across `merge_exchanges()`, `check_new_transactions()`, `format_detect()`, and a shared post-merge pricing flow used by `format_generic()` and many exchange formatters, making merge handling, transaction warnings, exchange dispatch, and price-resolution behavior more explicit and easier to maintain without changing user-facing behavior.
- Expanded focused tests around merge flattening, deterministic new-transaction warnings, format-detect helpers, and the shared formatter pricing helpers.

# cryptoTax 0.1.0.12

**Improvements:**

- Continued a broader pricing-core cleanup across `prepare_list_prices()`, `prepare_list_prices_slugs()`, `match_prices()`, and `USD2CAD()` to make slug preparation, missing-price handling, FX-table preparation, and price-resolution flow more explicit and easier to maintain without changing user-facing behavior.
- Expanded focused tests around deterministic pricing helpers, FX-table builders, slug-preparation behavior, and shared missing-price paths, and updated the pricing documentation/examples to show the explicit offline-input workflows more clearly.

# cryptoTax 0.1.0.11

**Improvements:**

- Continued the pricing-core cleanup across `prepare_list_prices()` and related helper paths to make slug derivation, start-date selection, USD-only rejection, and list-price construction behavior more explicit and easier to maintain without changing user-facing behavior.
- Expanded focused tests around price-prep helpers, `match_prices()` helper contracts, and deterministic list-price construction from injected history and FX data.

# cryptoTax 0.1.0.10

**Improvements:**

- Continued the shared-utility cleanup across `merge_exchanges()`, `check_new_transactions()`, `format_detect()`, `match_prices()`, and `format_generic()` to make ingestion, exchange detection, and pricing helper behavior more explicit and easier to maintain without changing user-facing behavior.
- Expanded focused tests around merge behavior, new-transaction warnings, exchange-detection helpers, generic formatting helpers, and price-matching helper contracts.

# cryptoTax 0.1.0.9

**Improvements:**

- Continued the ACB and tax-output cleanup across `check_missing_transactions()`, `format_ACB()`, `get_latest_transactions()`, `listby_coin()`, `tax_box()`, and `tax_table()` to make the ACB analysis helpers and tax-summary outputs more consistent and easier to maintain without changing user-facing behavior.
- Added shared internal helpers for ACB/report utilities, expanded focused tests around ACB helper outputs and tax-report formatting, and hardened the reporting path for cases where the superficial-loss summary is empty.

# cryptoTax 0.1.0.8

**Improvements:**

- Continued the reporting and tax-summary cleanup across `format_dollars()`, `prepare_report()`, `print_report()`, `crypto_pie()`, `get_proceeds()`, `get_sup_losses()`, `report_overview()`, and `report_summary()` to make report generation, current-price handling, and tax-summary helpers more consistent and easier to maintain without changing user-facing behavior.
- Added focused report-helper and print-report tests, and simplified the full report template so it reads the current pricing date from prepared report data instead of directly depending on `list.prices`.

# cryptoTax 0.1.0.7

**Improvements:**

- Continued a broader formatter-family cleanup across `format_cronos_pos()`, `format_exodus()`, `format_newton()`, `format_pooltool()`, `format_presearch()`, `format_shakepay_old()`, `format_CDC_wallet()`, and `format_suploss()` to make smaller wallet, rewards, and loss-formatting paths easier to follow and maintain without changing user-facing behavior.
- Updated the GitHub Actions coverage workflow to use the supported artifact action version.

# cryptoTax 0.1.0.6

**Improvements:**

- Continued the formatter cleanup across `format_CDC_exchange()` and `format_coinbase()` to make additional exchange-formatting paths easier to read and maintain without changing user-facing behavior.

# cryptoTax 0.1.0.5

**Improvements:**

- Continued the formatter cleanup across `format_uphold()`, `format_blockfi()`, and `format_CDC_exchange_rewards()` to make medium-size exchange-formatting paths easier to maintain without changing user-facing behavior.

# cryptoTax 0.1.0.4

**Improvements:**

- Continued the formatter cleanup across `format_gemini()`, `format_CDC_exchange_trades()`, and `format_CDC()` to make larger exchange-formatting paths easier to read and maintain without changing user-facing behavior.

# cryptoTax 0.1.0.3

**Improvements:**

- Continued the formatter cleanup across `format_generic()`, `format_shakepay()`, `format_binance()`, and `format_coinsmart()` to make exchange formatting workflows easier to follow and maintain without changing user-facing behavior.
- Continued the reporting-output cleanup by simplifying the internal structure of `tax_box()` and `tax_table()`.

# cryptoTax 0.1.0.2

**Improvements:**

- Continued a broader reporting-stack cleanup across `format_ACB()`, `report_overview()`, `report_summary()`, `report_revenues()`, `prepare_report()`, and `print_report()` to make report generation and summary logic easier to maintain without changing user-facing behavior.
- Simplified workflow and exchange-format tests by introducing a shared example-data helper and removing brittle `eval(parse())` test paths.

# cryptoTax 0.1.0.1

**Improvements:**

- Continued the internal maintenance cleanup of `match_prices()`, `format_detect()`, and `ACB()` to make core pricing, formatter dispatch, and cost-base code easier to maintain without changing package behavior.

# cryptoTax 0.1.0

**Improvements:**

- Hardened pricing and FX handling so key workflows can accept explicit pricing inputs instead of relying only on hidden session state.
- Added a built-in offline `list.prices` fixture dataset for examples, reporting, and tests.
- Improved offline behavior for reporting, examples, tests, and vignettes when live pricing data is unavailable.
- Expanded deterministic test coverage around `USD2CAD()`, price preparation, reporting, exchange formatting, and the full workflow.
- Refreshed test snapshots so the main integration paths now run against a deterministic offline pricing baseline.
- Continued the internal pricing and FX cleanup by centralizing `list.prices` and `USD2CAD.table` preparation paths while preserving compatibility.
- Cleaned `R CMD check` issues, updated package metadata, and now declare `R (>= 4.1.0)` explicitly.

# cryptoTax 0.0.7

From the `crypto2` package update:
> fiat_list() has been modified and no longer delivers all available currencies and precious metals (therefore only USD and Bitcoin are available any more).

Therefore, the `USD2CAD()` function now relies on the rates from the Bank of Canada, which only provides data for business days. On days which data is not available, the last known value is used instead. The `prepare_list_prices()` function has also been updated accordingly.

Also, because of too many duplicated symbols, `prepare_list_prices()` now requires using the unique "slug" name of the coin. You can obtain the correct slug using `crypto2::crypto_list(only_active = TRUE)` and then filtering for your symbol.

Updated functions due to changes in exchanges transaction history files:
- `format_CDC_exchange_trades()`
- `format_shakepay()`

# cryptoTax 0.0.6

**Breaking changes:**

- `USD2CAD()` now uses a different system to convert USD rates to CAD. `USD2CAD()` used to rely on the [`priceR`](https://github.com/stevecondylios/priceR), which depends on exchangerate.host which now requires an API key with very few limited free API calls. The old `priceR` function is still available, if you have an API key, with `USD2CAD_priceR()`. One alternative is to take the USDC to CAD rate, since USDC is usually pretty closely pegged to the USD. For instance, from 2021 to 2024, the average difference between USD and and USDC is only 0.00003 CAD. Nonetheless, to get an exact rate, the new system compares USD and CAD rates for USDC and calculates the adjusted CAD rate based on this.

**New Features:**

- New function: `fetch_cronos_pos()` (to download data from the CDC DeFi wallet)
- New function: `format_cronos_pos()` (as a replacement of `format_CDC_wallet()`)
- New function: `format_coinbase()`

**Improvements:**

- Various improvements to `format_` functions (ACB, CDC_wallet, blockfi, presearch) and `prepare_report`

# cryptoTax 0.0.5

- Added CRAN requirements

# cryptoTax 0.0.4

- Added CRAN requirements

# cryptoTax 0.0.3

- Added CRAN requirements

# cryptoTax 0.0.2

**Breaking changes:**

- We get rid of the `format_wealtsimple()`, `format_BSC()`, `format_binance_trades()`, `crypto2fiat()`, and `fetch_prices()` functions, since their goal is better fulfilled by the new `format_generic()`, `format_binance()`, `match_prices()`, and `prepare_list_prices()` functions, respectively.

**New Features:**

- New `pkgdown` website with three vignettes: (1) calculating ACB, (2) full tax report, and (3) tax treatments and decisions.
- Informative progress bars with `format_ACB()` and `format_suploss()` since these functions are extremely slow with thousands of transactions.
- Added example data sets (ACB, cryptotaxcalculator, coinpanda, koinly, shakepay, CDC, CDC exchange rewards, CDC exchange trades, CDC wallet, adalite, binance, binance withdrawals, blockfi, celsius, coinsmart, exodus, newton, presearch, pooltool, gemini, uphold)
- Now detects new transaction types not accounted for
- New functions: 
    - `prepare_report()` to get all the required information for `print_report()` in one go.
    - `get_sup_losses` was it was the last missing piece to get all the info needed for `prepare_report()`.
    - `format_detect()`, to automatically detect the right exchange and process it with the corresponding function (also supports lists of exchanges).
    - `format_generic()`, to process most transaction history files not supported by existing functions.
    - `format_binance()`, a general version that works with the general transaction report and includes rewards (but not withdrawal fees). We thus get rid of `format_binance_trades()` since the former is superior (as it includes more transaction types).
    - `get_latest_transactions()`: get latest transaction date by exchange
    - `check_missing_transactions()`: show you rows with negative total balances to help identify missing transactions.
    - `format_dollars()`: to format numeric values with comma for thousands separator.

**Improvements:**

- `format_blockfi()` and `format_CDC_exchange_trades()` now correctly match prices for purchases and sales for trades (instead of relying on their corresponding daily spot rates).
- Consistently use plural for reward types.
- Massive improvements in speed by using joins for price lookups (instead of making a new API request for each row) for both prices of coins and USD to CAD conversions.
- When prices are fetched through `priceR` (for USD to CAD conversions), now indicates the source of the price accordingly (`rate.source = "exchange (USD conversion)"`)
- All `format_*` functions: now reorder columns in a consistent fashion + tests for all (and `ACB()`).
- `ACB_suploss()`: integrates the primary `ACB()` function, which accordingly gains a new logical argument, `suploss`.
- `format_suploss()`: integrates `ACB()` when `suploss = TRUE`, and gains a greatly improved code base.
- `add_quantities()`: switches from a for-loop to `dplyr` code.
- `ACB()`: 
    - new warning messages:
        - when not providing first buy transactions (so no ACB...)
        - when more than one currency are provided at a time
        - when insufficient columns are provided to calculate 'total.price'
- `report_revenues()` and `crypto_pie()`: Now support forks and mining.
- `format_newton()`: updated to the new format
- `format_CDC()`: 
    - new warning message when withdrawal fees could not be detected automatically.
    - new transaction types supported: forks ("admin_wallet_credited"), sales ("crypto_viban_exchange", "card_top_up", "crypto_wallet_swap_debited"), and supercharger rewards ("supercharger_reward_to_app_credited")
    - On coinmarketcap, after 2022-05-28, LUNA gets renamed to LUNC, and the LUNA2 fork gets renamed to LUNA. This is confusing because on CDC, they use the terms LUNA and LUNC (which are the same), and LUNA2, which is the new LUNA fork. Therefore, we now rename "LUNA" transactions (on CDC) to "LUNC", and "LUNA2" to "LUNA".

**Bug Fixes:**

- `format_shakepay()`: now correctly detects CAD referral rewards
- `format_binance()`: now correctly detects interest rewards
- `format_ACB()`: 
    - fixed a bug whereas a superficial loss of quantity = 0 would prevent the computation of the ACB.
    - corrected "Total time elapsed:" time unit to always be minutes
- `ACB()`: now correctly accept alternative column names
- Fixed a bug for NANO/XNO
- Fixed various R CMD check errors, warnings, and notes.

# cryptoTax 0.0.1

New package





