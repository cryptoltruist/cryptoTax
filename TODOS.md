# TODOS

## Performance improvements

- Only calculate superficial losses for rows that are sales and with a loss instead of every row.
- Replace for-loops with dplyr (e.g., in ACB)
- Think about using `data.table` or `dtplyr`

## Bugs

- `lubridate::with_tz` seems to be creating problems in other timezones (based on GHA). Might be better to find a replacement like `lubridate::as_datetime` everywhere.

## Features

- New function: `format_detect()`! To automatically detect the right exchange and process it with the corresponding function.
- Make sample data sets for all exchanges (remaining: gemini, pooltool).
- New error message for functions where it is required: "You must first create an object 'list.prices' using `prepare_list_prices()` before using this function." [or just add it as a required argument?? Would do the same thing... think about this].
- For `report_revenues()`, better and more clearly accommodate tax year
- Finish the Shiny app: editable table, see <https://www.r-bloggers.com/2019/04/edit-datatables-in-r-shiny-app/>

## Tax

- Remove trading fees from total quantity??
- Should trading fees be applied to the quantity from the superficial loss? I think so... Write a test to check that
- Clarify the time zones for year to year transition days!
- Superficial loss needs to look at least 30 days in the new year (assuming a transaction occured on the last day of the year). Therefore, when filtering for year, it should first calculate superficial losses until say January 30 of the next year, and at the end filter again for the selected year.

## Code optimization

- Use `format_generic` as much as possible in every other `format_*` function, whenever possible, to reduce code redundancy.
- Fix duplicated columns in sup loss calculations
- Check <https://github.com/BittyTax/BittyTax> for general inspiration

## Vignettes

- List benefits: full transparency on algorithms (open code), in control of your data (no need to upload it on another platform), can use and reuse your script (no need to start all over from scratch), no limit on number of transactions, easy to automatically recategorize transactions, community can contribute, etc.
- Explain in vignette how to add option to change whether different transaction types (cashback, airdrops) are considered as part of taxable revenue stream.
- Write a longer vignette on the general workflow using `prepare_list_prices` and several (all?) exchanges, etc.