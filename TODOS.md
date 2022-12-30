# Development roadmap (to-do list)

-   Think about using data.table or dtplyr to increase efficiency 
-   Ask for local time zone in format_ACB!!? Then easier to filter for local time zone later!!
-   Clarify the time zones with for year to year transition days!
-   Still have to follow-up with each exchange where time isn't specified to know whether it is EST or EDT time! Including: Wealthsimple, Binance.
-   Superficial losses
    -   Remember to technically substract the capital losses from the amount purchased to avoid scenarios where for example 100\$ of capital losses would be considered superficial whereas the purchase amount was only 5\$.
-   Optimize processing time by
    -   only scraping prices of coins that don't already have a spot price: filter(is.na(spot.rate)
    -   same for `priceR` for USD to CAD conversions... Call it only once to reuse later instead of 100s of calls...
-   When price is fetched through `priceR`, indicate the source of the price accordingly
-   Add option to change whether different transaction types (cashback, airdrops) are considered as part of taxable revenue stream (or explain how to do it in the Tax report)
-   For report_revenues(), better and more clearly accommodate tax year
-   Add custom import with no non-sense defaults, but also the possibility for custom columns. Also add option for time zone.
-   Make sample datasets (2 exchanges, then combine them), e.g. CDC, ShakePay, Newton.
-   Fix warning message: Problem with `mutate()` column `CAD.rate`. i `CAD.rate = cryptoTaxR::USD2CAD(date = date)`. i the condition has length \> 1 and only the first element will be used
-   Clean up all the scripts; optimize code with renaming names at the top, etc.
-   Check <https://github.com/BittyTax/BittyTax> for general inspiration
-   Finish the Shiny app: editable table, see <https://www.r-bloggers.com/2019/04/edit-datatables-in-r-shiny-app/>
