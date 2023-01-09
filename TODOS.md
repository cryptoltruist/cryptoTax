# TODOS

## Performance improvements

- Only calculate superficial losses for rows that are sales and with a loss instead of every row.
- Replace for-loops with dplyr (e.g., in ACB)
- Think about using `data.table` or `dtplyr`

## Features

- New error message for appropriate functions: "You must first run 'prepare_list_prices' before using this function."
- Make sample data sets for all exchanges (remaining: adalite, binance, blockfi, BSC, CDC_exchange_rewards, CDC_exchange_trades, CDC_wallet, celsius, coinsmart, exodus, gemini, newton, pooltool, presearch)
- Detect new transaction types not accounted for every exchange (done: CDC)
- Write new function to get latest transaction dates by exchanges.
- Write new function to check where negative balances appear.
- When price is fetched through `priceR`, indicate the source of the price accordingly
- For `report_revenues()`, better and more clearly accommodate tax year
- Finish the Shiny app: editable table, see <https://www.r-bloggers.com/2019/04/edit-datatables-in-r-shiny-app/>

## Tax

- Remove trading fees from total quantity??
- Should trading fees be applied to the quantity from the superficial loss? I think so... Write a test to check that
- Check for all trading exchanges that prices of sells and buys match
- Clarify the time zones for year to year transition days!
- Still have to follow-up with each exchange where time isn't specified to know whether it is EST or EDT time! Including: Wealthsimple.
- Superficial loss needs to look at least 30 days in the new year (assuming a transaction occured on the last day of the year). Therefore, when filtering for year, it should first calculate superficial losses until say January 30 of the next year, and at the end filter again for the selected year.

## Code optimization

- Use `format_generic` as much as possible in every other `format_*` function, whenever possible, to reduce code redundancy.
- New function: format_dollars
- Fix duplicated columns in sup loss calculations
- For NA fees, check and replace with 0 in ACB instead of each exchange...
- Check <https://github.com/BittyTax/BittyTax> for general inspiration

## Vignettes

- Explain in vignette how to add option to change whether different transaction types (cashback, airdrops) are considered as part of taxable revenue stream.
- Write a longer vignette on the general workflow using `prepare_list_prices` and several (all?) exchanges, etc.