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
- [x] A partial sale can still be fully superficial when enough pre-sale replacement shares from the prior 30-day window remain owned after the sale.
  Covered by [test-ACB.R](C:/github/cryptoTax/tests/testthat/test-ACB.R).
- [x] Denied-loss carry must not be added twice when a superficial-loss sale already leaves replacement shares in the pool and a later buy happens before the window ends.
  Covered by [test-ACB.R](C:/github/cryptoTax/tests/testthat/test-ACB.R) and
  [test-format_ACB.R](C:/github/cryptoTax/tests/testthat/test-format_ACB.R).
- [x] Repeated partial loss sales inside the same 61-day cluster can each be superficial while enough substituted-property units still remain owned at the end of the later sale's window.
  Covered by [test-ACB.R](C:/github/cryptoTax/tests/testthat/test-ACB.R) and
  [test-format_ACB.R](C:/github/cryptoTax/tests/testthat/test-format_ACB.R).
- [x] Once no substituted-property units remain owned at the end of a later loss sale's window, the engine should transition back to ordinary deductible-loss treatment.
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
- [x] Non-`buy` acquisition-like rows such as `revenue` and `rebates` are not
  themselves counted as `buy` acquisitions for replacement-property quantity
  in the superficial-loss window, but units added by those rows can still
  matter indirectly through the "shares still owned" condition if some
  qualifying `buy` already exists in the 61-day period.
  Covered by [test-ACB.R](C:/github/cryptoTax/tests/testthat/test-ACB.R),
  [test-format_ACB.R](C:/github/cryptoTax/tests/testthat/test-format_ACB.R),
  and clarified in [references.Rmd](C:/github/cryptoTax/vignettes/references.Rmd).

## Known audit gaps

- [ ] Affiliated-person superficial-loss scenarios are not modeled
  programmatically.
  Current ACB logic works on one taxpayer transaction history and does not have
  a first-class concept of spouse, corporation, trust, or other affiliated owner,
  even though the boundary is now documented explicitly.
- [ ] "Identical property" classification is not resolved programmatically
  beyond same-symbol transaction pools.
  Edge cases like wrapped assets, bridged assets, liquid staking tokens, and
  exchange-specific synthetic assets now have an explicit package policy note,
  but still depend on user normalization rather than automatic engine logic.
- [x] Business-income versus capital-account classification is now explicitly
  documented as out of scope for `ACB()` itself and still dependent on user tax
  facts outside the transaction math.
- [x] Network fees, withdrawal fees, and fee-in-kind treatment now have a
  policy note separating what is proven in the current implementation from what
  may still require professional review in ambiguous real-world exports.

## Audit execution order

This is the recommended order for the remaining audit work. The idea is to
finish the highest-confidence same-taxpayer math first, then document the
boundaries where the package should stay conservative rather than pretending to
decide legal or factual questions it does not actually model.

1. Resolve the remaining same-taxpayer transaction-math questions that are still
   partly represented as comments or policy notes.
2. Finish the package policy on what counts as the same pool versus a distinct
   crypto instrument.
3. Write explicit boundary documentation for affiliated-person cases that the
   engine does not currently model.
4. Only after those are explicit, decide whether any code change is needed, or
   whether the right result is just stronger documentation and validation.

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

## Immediate audit queue

These are the concrete unresolved slices to work through next.

### 1. Fee treatment versus `total.price`

- [x] Audit whether any remaining supported formatter paths can produce rows where
  acquisition-side `total.price` already includes fees while `fees` is still
  non-zero, which would make generic ACB fee handling ambiguous.
- [x] For each representative fee contract, record the intended rule explicitly:
  separate fees, fee-inclusive totals with zeroed `fees`, or fee-in-kind modeled
  as a separate disposition row.
- [x] Decide whether the remaining `ACB.R` fee TODO should become stricter
  validation, formatter-contract enforcement, or a retained documented caveat.

Current audit read:

- Coinbase convert buys are the representative fee-inclusive acquisition case,
  and the formatter already zeroes `fees` to avoid double-counting.
- CDC Exchange trades, Gemini trades, Binance trades, and CoinSmart trades are
  representative separate-fee cases, where `fees`, `fees.quantity`, and
  `fees.currency` remain explicit alongside the acquisition/disposition row.
- Uphold withdrawal fees and third-asset trading fees are representative
  separate-disposition cases, where the fee is modeled as its own sell row
  rather than as an attached `fees` value.
- CDC app output remains a known special case with limited fee visibility rather
  than a contradictory mixed contract.

Definition of done:

- We can point to tests and docs showing which fee contracts are supported, and
  the remaining comment in [ACB.R](C:/github/cryptoTax/R/ACB.R) is either
  resolved or intentionally retained with a precise reason.

### 2. Identical-property boundary cases

- [x] Pick a short list of concrete crypto edge cases to treat as policy examples:
  wrapped assets, bridged assets, liquid staking tokens, and exchange-specific
  synthetic assets.
- [x] For each example, state whether the package currently keeps it in a
  separate pool by `currency`, and whether that is an intentional package policy
  or an unresolved tax-judgment limitation.
- [x] Add at least one user-facing note or worked example showing that the engine
  does not automatically merge these assets into the same superficial-loss pool.

Definition of done:

- A user can tell, without reading code, what the package will do for the most
  common same-symbol-versus-same-property ambiguities.

Current audit read:

- CRA's current [Capital Gains – 2025](https://www.canada.ca/en/revenue-agency/services/forms-publications/publications/t4037/capital-gains.html) guide says identical properties are ones where each property in the group is the same as all the others.
- CRA's archived interpretation bulletin on identical properties remains useful context because it reflects the older "same in all material respects" framing and highlights that conversion/exchange rights can matter in superficial-loss analysis.
- That combination supports the package's conservative stance: different `currency` values stay in separate pools by default, while wrapped, bridged, staked, or exchange-specific variants are treated as a user-policy normalization question rather than silently merged by the engine.
- The user-facing note and worked boundary example now live in [references.Rmd](C:/github/cryptoTax/vignettes/references.Rmd).

### 3. Affiliated-person boundary cases

- [x] Expand the existing policy note into a short boundary explanation of what
  the package can and cannot infer from a single transaction history.
- [x] Add one worked boundary example showing why an affiliated-person
  superficial loss cannot be detected from one taxpayer ledger alone.
- [x] Decide whether any warning or documentation pointer should be surfaced near
  `ACB()` / `format_ACB()` usage, or whether the plan/docs note is enough.

Definition of done:

- The limitation is explicit enough that users do not mistake "passes tests" for
  "covers spouse/corporate affiliated-owner scenarios."

Current audit read:

- CRA's current superficial-loss wording explicitly includes acquisitions by the
  taxpayer or an affiliated person, so this is a real rule boundary rather than
  an academic edge case.
- The package cannot infer spouse, corporation, trust, or other affiliated-owner
  activity from a single taxpayer-facing ledger.
- The user-facing boundary explanation and worked example now live in
  [references.Rmd](C:/github/cryptoTax/vignettes/references.Rmd), and the
  `ACB()` / `format_ACB()` docs now state more plainly that clean results from
  one ledger do not prove the absence of affiliated-person superficial-loss
  issues outside that input.

### 4. Residual timing and ordering assumptions

- [x] Review whether any remaining same-timestamp assumptions in ACB processing
  need to be documented as package policy rather than only encoded in tests.
- [x] Confirm that formatter-level ordering and ACB-level ordering together do
  not create hidden tax-policy assumptions beyond "acquisitions before
  dispositions when timestamps are indistinguishable."

Definition of done:

- The repo has one clear statement of the same-timestamp rule and why it exists.

Current audit read:

- The package-level ordering rule is now explicit: when same-pool rows share an
  indistinguishable timestamp and no trustworthy event-order field survives,
  acquisition-like rows are normalized before `sell` rows.
- Within those groups, larger `total.price` rows come first as a deterministic
  tie-break rather than as a claimed legal priority rule.
- Formatter-level reconstruction can still use source-specific identifiers or
  source ordering before `format_ACB()` if an exchange export genuinely
  preserves richer event-sequencing information.
- The user-facing note and worked boundary example now live in
  [references.Rmd](C:/github/cryptoTax/vignettes/references.Rmd), and the
  `format_ACB()` docs now describe the same-timestamp normalization rule
  directly.

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

### Example D: Partial sale made superficial by pre-sale replacement shares still on hand

Facts:

- Day 1: buy 20 units for 200 total. ACB/share = 10.
- Day 10: sell 8 units for 40 total.
- No later buy is needed for the loss to be superficial because 12 units from the
  original 30-day pre-sale acquisition are still owned at the end of the window.

Arithmetic:

- Uncorrected loss on the sale = 40 - (8 x 10) = -40.
- Shares acquired in the 61-day window = 20.
- Shares still owned at the end of the window = 12.
- Denied quantity = min(8 sold, 20 acquired in window, 12 still owned) = 8.
- Denied loss = -40 x (8 / 8) = -40.
- Remaining quantity after the sale = 12.
- Remaining ACB before the denial = 200 x (12 / 20) = 120.
- Remaining ACB after the denial = 120 + 40 = 160.
- Remaining ACB/share = 160 / 12 = 13.333333.

Expected outcome:

- The whole 40 loss is denied even though there is no later reacquisition.
- The denied amount is reflected in the remaining pooled ACB because the taxpayer
  still holds substituted property acquired in the 30 days before the sale.

Coverage:

- [test-ACB.R](C:/github/cryptoTax/tests/testthat/test-ACB.R)

### Example E: Later buy after a superficial-loss sale must not receive the same denied loss twice

Facts:

- Day 1: buy 10 units for 100 total.
- Day 5: buy 5 more units for 50 total. Pool ACB = 150 across 15 units.
- Day 10: sell 10 units for 50 total.
- Day 20: buy 2 more units for 12 total.
- At the end of the 30-day post-sale window, 7 units are still owned.

Arithmetic:

- Uncorrected loss on the Day 10 sale = 50 - (10 x 10) = -50.
- Shares acquired in the 61-day window = 10 + 5 + 2 = 17.
- Shares still owned at the end of the window = 7.
- Denied quantity = min(10 sold, 17 acquired in window, 7 still owned) = 7.
- Denied loss = -50 x (7 / 10) = -35.
- Deductible excess loss = -50 - (-35) = -15.
- Remaining ACB immediately after the sale, before denial = 150 x (5 / 15) = 50.
- Remaining ACB immediately after the denied loss is attached = 50 + 35 = 85.
- After the later Day 20 buy, total pooled ACB should be 85 + 12 = 97.
- Final ACB/share = 97 / 7 = 13.857143.

Expected outcome:

- The denied portion is carried once into the surviving substituted-property pool.
- The later buy adds only its own acquisition cost; it must not receive the same
  denied loss a second time.

Coverage:

- [test-ACB.R](C:/github/cryptoTax/tests/testthat/test-ACB.R)
- [test-format_ACB.R](C:/github/cryptoTax/tests/testthat/test-format_ACB.R)

### Example F: Repeated partial loss sales can both be superficial while replacement shares remain

Facts:

- Day 1: buy 20 units for 200 total. ACB/share = 10.
- Day 10: sell 8 units for 40 total.
- Day 25: sell 4 more units for 28 total.
- No new buys occur, but enough units from the original Day 1 acquisition remain
  owned after each sale to keep both losses inside superficial-loss treatment.

Arithmetic:

- First sale:
  Uncorrected loss = 40 - (8 x 10) = -40.
  Denied quantity = min(8 sold, 20 acquired in window, 12 still owned) = 8.
  Denied loss = -40.
  Remaining ACB after the first sale = 200 x (12 / 20) + 40 = 160.
  ACB/share after the first sale = 160 / 12 = 13.333333.
- Second sale:
  Uncorrected loss = 28 - (4 x 13.333333) = -25.333333.
  At the end of the second sale's window, 8 units are still owned.
  Denied quantity = min(4 sold, 20 acquired in window, 8 still owned) = 4.
  Denied loss = -25.333333.
  Remaining ACB after the second sale = 160 x (8 / 12) + 25.333333 = 132.
  Remaining ACB/share after the second sale = 132 / 8 = 16.5.

Expected outcome:

- Both loss sales are fully superficial.
- Each denied loss is reflected in the surviving pool, increasing ACB/share as the
  remaining position gets smaller.

Coverage:

- [test-ACB.R](C:/github/cryptoTax/tests/testthat/test-ACB.R)
- [test-format_ACB.R](C:/github/cryptoTax/tests/testthat/test-format_ACB.R)

### Example G: Later loss becomes deductible once the replacement pool is exhausted

Facts:

- Day 1: buy 20 units for 200 total. ACB/share = 10.
- Day 10: sell 8 units for 40 total.
- Day 25: sell 4 units for 28 total.
- Day 46: sell the final 8 units for 48 total.
- No new buys occur after the original Day 1 acquisition.

Arithmetic:

- First sale:
  Uncorrected loss = 40 - (8 x 10) = -40.
  Because 8 units are still owned at the end of that window, the whole 40 loss is denied.
  Remaining ACB after the first sale = 160, so ACB/share becomes 13.333333.
- Second sale:
  Uncorrected loss = 28 - (4 x 13.333333) = -25.333333.
  By the end of this later sale's own window, no substituted-property units remain owned.
  So the second sale is not superficial and the -25.333333 remains deductible.
  Remaining ACB after the second sale = 160 x (8 / 12) = 106.666667.
- Final sale:
  Uncorrected loss = 48 - (8 x 13.333333) = -58.666667.
  No shares remain afterward, so this final loss is also deductible.

Expected outcome:

- The engine transitions from denied-loss treatment back to ordinary deductible losses
  once the "still owned at the end of the window" condition is no longer met.
- The earlier denied loss still affects the pool's later ACB/share, but it does not
  force every later loss sale to stay superficial forever.

Coverage:

- [test-ACB.R](C:/github/cryptoTax/tests/testthat/test-ACB.R)
- [test-format_ACB.R](C:/github/cryptoTax/tests/testthat/test-format_ACB.R)
