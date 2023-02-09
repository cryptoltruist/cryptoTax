# TODOS

## Performance improvements

- Only calculate superficial losses for rows that are sales and with a loss instead of every row.
- Replace for-loops with dplyr (e.g., in ACB)
- Think about using `data.table` or `dtplyr`

## Features

- Prepare for CRAN(?)
- Finish the Shiny app: editable table, see <https://www.r-bloggers.com/2019/04/edit-datatables-in-r-shiny-app/>

## Code optimization

- Use `format_generic` as much as possible in every other `format_*` function, whenever possible, to reduce code redundancy.
- Fix duplicated columns in sup loss calculations
- Check <https://github.com/BittyTax/BittyTax> for general inspiration

## Vignettes

- List benefits: full transparency on algorithms (open code), in control of your data (no need to upload it on another platform), can use and reuse your script (no need to start all over from scratch), no limit on number of transactions, easy to automatically recategorize transactions, unlimited flexibility, community can contribute, etc.
- Explain in vignette how to add option to change whether different transaction types (cashback, airdrops) are considered as part of taxable revenue stream.
- Write a longer vignette on the general workflow using `prepare_list_prices` and several (all?) exchanges, etc.