# Fiscal Audit Plan

Date: 2026-04-12
Status: In progress

## Purpose

This file tracks a focused fiscal-audit pass for the package's capital-gains and
ACB logic. The goal is not more generic refactoring. The goal is to validate
high-risk tax rules against trusted references and to make any remaining gaps
explicit.

## Reference anchors

These references are the current audit anchors for the first pass:

- CRA, "Capital losses": superficial loss exists when the taxpayer or an
  affiliated person acquires the same or identical property in the 30 calendar
  days before or after the sale and still owns it 30 calendar days after the
  sale; if the taxpayer acquires the substituted property, the denied loss can
  usually be added to the ACB of that substituted property.
  Source: <https://www.canada.ca/en/revenue-agency/services/tax/individuals/topics/about-your-tax-return/tax-return/completing-a-tax-return/personal-income/line-12700-capital-gains/capital-losses-deductions.html>
- CRA, "Reporting your capital gains as a crypto-asset user": crypto capital
  gains and losses are measured from proceeds of disposition relative to ACB,
  taking outlays and expenses on disposition into account.
  Source: <https://www.canada.ca/en/revenue-agency/news/newsroom/tax-tips/tax-tips-2024/reporting-your-capital-gains-as-crypto-asset-user.html>
- CRA, Income Tax Audit Manual Chapter 29: a superficial loss is denied when
  the substituted property is acquired in the 30-day window and is still owned
  at the end of the 60-day period.
  Source: <https://www.canada.ca/en/revenue-agency/services/tax/technical-information/income-tax-audit-manual-domestic-compliance-programs-branch-dcpb-29.html>

## Audit checklist

### Core superficial-loss rule

- [x] Full reacquisition inside the 30-day window denies the loss.
  Covered by [test-ACB.R](C:/github/cryptoTax/tests/testthat/test-ACB.R) and
  [test-format_ACB.R](C:/github/cryptoTax/tests/testthat/test-format_ACB.R).
- [x] Partial reacquisition denies only the corresponding part of the loss.
  Covered by [test-ACB.R](C:/github/cryptoTax/tests/testthat/test-ACB.R).
- [x] Replacement shares already owned before the sale can trigger a denied loss.
  Covered by [test-ACB.R](C:/github/cryptoTax/tests/testthat/test-ACB.R).
- [x] Reacquisition exactly 30 calendar days after the sale counts as inside the window.
  Covered by [test-ACB.R](C:/github/cryptoTax/tests/testthat/test-ACB.R).
- [x] Reacquisition after the 30-day window does not trigger superficial-loss treatment.
  Covered by [test-ACB.R](C:/github/cryptoTax/tests/testthat/test-ACB.R).
- [x] If replacement shares are reacquired and then fully sold before the end of the window, the loss is not denied.
  Covered by [test-ACB.R](C:/github/cryptoTax/tests/testthat/test-ACB.R).
- [x] If replacement shares are reacquired and only partly sold before the end of the window, only the shares still held should drive the denied portion.
  Covered by [test-ACB.R](C:/github/cryptoTax/tests/testthat/test-ACB.R) and
  [test-format_ACB.R](C:/github/cryptoTax/tests/testthat/test-format_ACB.R).
- [x] A sale at a gain must not be converted into a superficial-loss case just because there is a nearby reacquisition.
  Covered by [test-ACB.R](C:/github/cryptoTax/tests/testthat/test-ACB.R) and
  [test-format_ACB.R](C:/github/cryptoTax/tests/testthat/test-format_ACB.R).

### ACB consequences of denied losses

- [x] Fully denied superficial losses are rolled into replacement-share ACB.
  Covered by adjustedcostbase-style examples in
  [test-ACB.R](C:/github/cryptoTax/tests/testthat/test-ACB.R).
- [x] Partially denied superficial losses increase ACB only for the denied portion, while the deductible excess remains available.
  Covered by [test-ACB.R](C:/github/cryptoTax/tests/testthat/test-ACB.R) and
  [test-format_ACB.R](C:/github/cryptoTax/tests/testthat/test-format_ACB.R).

### Fees and outlays

- [x] Buy-side fees increase cost base when fees are separate from acquisition totals.
  Covered by [test-ACB.R](C:/github/cryptoTax/tests/testthat/test-ACB.R).
- [x] Sell-side fees reduce realized gains or deepen realized losses.
  Covered by [test-ACB.R](C:/github/cryptoTax/tests/testthat/test-ACB.R).
- [x] Fee-inclusive acquisition totals are not double-counted when formatters zero the separate fee field.
  Covered by [test-ACB.R](C:/github/cryptoTax/tests/testthat/test-ACB.R),
  [test-format_coinbase_helpers.R](C:/github/cryptoTax/tests/testthat/test-format_coinbase_helpers.R),
  and [test-format_fee_contracts.R](C:/github/cryptoTax/tests/testthat/test-format_fee_contracts.R).
- [x] Representative formatter families document whether fees are separate, embedded in totals, or modeled as separate rows.
  Covered by [test-format_fee_contracts.R](C:/github/cryptoTax/tests/testthat/test-format_fee_contracts.R).

### Revenue entering ACB

- [x] Taxable crypto revenue enters ACB by default.
  Covered by [test-ACB.R](C:/github/cryptoTax/tests/testthat/test-ACB.R) and
  [test-format_ACB.R](C:/github/cryptoTax/tests/testthat/test-format_ACB.R).
- [x] Non-taxable revenue types can be excluded from ACB through `as.revenue`.
  Covered by [test-ACB.R](C:/github/cryptoTax/tests/testthat/test-ACB.R) and
  [test-format_ACB.R](C:/github/cryptoTax/tests/testthat/test-format_ACB.R).

## Known audit gaps

- [ ] Affiliated-person superficial-loss scenarios are not modeled explicitly.
  Current ACB logic works on one taxpayer transaction history and does not have
  a first-class concept of spouse, corporation, trust, or other affiliated owner.
- [ ] "Identical property" classification is not yet audited beyond same-symbol
  transaction pools. Edge cases like wrapped assets, bridged assets, liquid
  staking tokens, and exchange-specific synthetic assets need a policy decision.
- [x] Business-income versus capital-account classification is now explicitly
  documented as out of scope for `ACB()` itself and still dependent on user tax
  facts outside the transaction math.
- [x] Network fees, withdrawal fees, and fee-in-kind treatment now have a
  policy note separating what is proven in the current implementation from what
  may still require professional review in ambiguous real-world exports.

## Next audit slices

- [x] Add one explicit affiliated-person policy note to package docs or plan material.
- [x] Add an explicit package-scope note that "identical property" judgments across distinct crypto instruments are not fully decided by the engine.
- [x] Decide and document the package stance on "identical property" for common
  crypto edge cases such as wrapped tokens and liquid staking derivatives.
  Current package stance: different `currency` values remain distinct pools by
  default; the package does not automatically merge wrapped, bridged, staked,
  or exchange-specific variants into the same superficial-loss pool as the
  underlying asset.
- [x] Add a short worked-example appendix showing the expected arithmetic for the
  current core superficial-loss scenarios outside of code, so the audit record
  does not live only inside tests.
- [x] Add a policy note distinguishing tested fee-in-kind behavior from more
  ambiguous withdrawal/network-fee export cases.
- [x] Add an explicit package-scope note that business-income versus capital-account classification is not decided by the ACB engine.

## Worked-example appendix

These examples are intentionally small and human-checkable. They are not meant
to replace the test suite; they make the core audit arithmetic legible outside
of code.

### Example A: Full superficial loss after full reacquisition

Facts:

- Day 1: buy 100 units at 50 each. ACB = 5,000.
- Day 30: sell 100 units at 30 each. Proceeds = 3,000.
- Day 40: buy 100 replacement units at 30 each.
- Day 61+: replacement units are still owned at the end of the 30-day post-sale window.

Arithmetic:

- Pre-sale ACB/share = 5,000 / 100 = 50.
- Uncorrected loss on the sale = 3,000 - 5,000 = -2,000.
- Replacement units acquired in the 61-day window = 100.
- Replacement units still owned at the end of the window = 100.
- Denied quantity = min(100 sold, 100 reacquired, 100 still owned) = 100.
- Denied loss = -2,000 x (100 / 100) = -2,000.
- Deductible excess loss = 0.
- That denied amount is carried into the replacement property ACB.
- Replacement ACB after reacquisition = 3,000 purchase cost + 2,000 denied loss = 5,000.
- Replacement ACB/share = 5,000 / 100 = 50.

Expected outcome:

- The original sale does not realize a deductible capital loss at that time.
- The replacement lot carries the denied loss forward through a higher ACB.

Coverage:

- [test-ACB.R](C:/github/cryptoTax/tests/testthat/test-ACB.R)
- [test-format_ACB.R](C:/github/cryptoTax/tests/testthat/test-format_ACB.R)

### Example B: Partial superficial loss after only partial reacquisition

Facts:

- Day 1: buy 10 units for 100 total. ACB/share = 10.
- Day 10: sell all 10 units for 50 total.
- Day 20: buy back 4 units for 24 total.
- The 4 replacement units are still owned at the end of the 30-day post-sale window.

Arithmetic:

- Uncorrected loss on the sale = 50 - 100 = -50.
- Denied quantity = min(10 sold, 4 reacquired, 4 still owned) = 4.
- Denied loss = -50 x (4 / 10) = -20.
- Deductible excess loss = -50 - (-20) = -30.
- Reacquired lot base cost = 24.
- Reacquired lot adjusted ACB = 24 + 20 = 44.
- Reacquired ACB/share = 44 / 4 = 11.

Expected outcome:

- A deductible capital loss of 30 remains available immediately.
- The denied 20 is carried forward through the reacquired lot's ACB.

Coverage:

- [test-ACB.R](C:/github/cryptoTax/tests/testthat/test-ACB.R)
- [test-format_ACB.R](C:/github/cryptoTax/tests/testthat/test-format_ACB.R)

### Example C: Reacquired replacement shares partly sold before the window ends

Facts:

- Day 1: buy 10 units for 100 total. ACB/share = 10.
- Day 10: sell all 10 units for 50 total.
- Day 20: buy 6 replacement units for 36 total.
- Day 25: sell 4 of those replacement units for 40 total.
- At the end of the 30-day post-sale window, only 2 replacement units remain.

Arithmetic:

- Original uncorrected loss = 50 - 100 = -50.
- Replacement units acquired in the window = 6.
- Replacement units still owned at window end = 2.
- Denied quantity = min(10 sold, 6 reacquired, 2 still owned) = 2.
- Denied loss = -50 x (2 / 10) = -10.
- Deductible excess loss = -50 - (-10) = -40.
- Reacquired lot cost = 36.
- Reacquired lot adjusted ACB before the later sale = 36 + 10 = 46.
- Reacquired ACB/share before the later sale = 46 / 6 = 7.666667.
- Later sale of 4 replacement units at 40 realizes a gain of:
  40 - (4 x 7.666667) = 9.333333.
- Remaining ACB after selling 4 of the 6 replacement units:
  46 x (2 / 6) = 15.333333.

Expected outcome:

- Only the part tied to the 2 remaining replacement units is denied.
- The remaining 40 of the original loss stays deductible.
- The later replacement-lot sale uses the higher adjusted ACB/share.

Coverage:

- [test-ACB.R](C:/github/cryptoTax/tests/testthat/test-ACB.R)
- [test-format_ACB.R](C:/github/cryptoTax/tests/testthat/test-format_ACB.R)
