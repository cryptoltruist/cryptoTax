# Print full crypto tax report

Will output a full crypto tax report in HTML format, which can then be
printed or saved as PDF.

## Usage

``` r
print_report(
  formatted.ACB,
  list.prices,
  tax.year = "all",
  local.timezone = "America/Montreal",
  name
)
```

## Arguments

- formatted.ACB:

  The `formatted.ACB` object.

- list.prices:

  A `list.prices` object from which to fetch coin prices. For
  current-price reporting, it must contain at least `currency`,
  `spot.rate2`, and `date2`.

- tax.year:

  The tax year desired.

- local.timezone:

  Which time zone to use for the date of the report.

- name:

  Name of the individual for the report.

## Value

A list, containing the following objects: report.overview,
report.summary, proceeds, sup.losses, table.revenues, tax.box,
pie_exchange, pie_revenue.

An HTML page containing a crypto tax report.

## Examples

``` r
# \donttest{
list.prices <- list_prices_example
all.data <- format_exchanges(data_shakepay)
#> Exchange detected: shakepay
formatted.ACB <- format_ACB(all.data, verbose = FALSE)
if (is.data.frame(list.prices)) {
  print_report(formatted.ACB,
    list.prices = list.prices,
    tax.year = 2021, name = "Mr. Cryptoltruist"
  )
}
#> gains, losses, and net have been filtered for tax year 2021
#> Date of current prices: 2023-12-31
#> gains, losses, and net have been filtered for tax year 2021 (time zone = America/Montreal)
#> Date of current prices: 2023-12-31
#> Note: proceeds have been filtered for tax year 2021
#> Note: superficial losses have been filtered for tax year 2021
#> Note: revenues have been filtered for tax year 2021
#> 
#> 
#> processing file: full_report.Rmd
#> 1/21                  
#> 2/21 [setup]          
#> 3/21                  
#> 4/21 [summary]        
#> 5/21                  
#> 6/21 [values]         
#> 7/21                  
#> 8/21 [overview]       
#> 9/21                  
#> 10/21 [current value]  
#> 11/21                  
#> 12/21 [sup loss]       
#> 13/21                  
#> 14/21 [revenues]       
#> 15/21                  
#> 16/21 [pie_exchange]   
#> 17/21                  
#> 18/21 [pie_revenue]    
#> 19/21                  
#> 20/21 [unnamed-chunk-1]
#> 21/21                  
#> output file: full_report.knit.md
#> /opt/hostedtoolcache/pandoc/3.1.11/x64/pandoc +RTS -K512m -RTS full_report.knit.md --to html4 --from markdown+autolink_bare_uris+tex_math_single_backslash --output /home/runner/work/cryptoTax/cryptoTax/docs/reference/full_report_2021.html --lua-filter /home/runner/work/_temp/Library/rmarkdown/rmarkdown/lua/pagebreak.lua --lua-filter /home/runner/work/_temp/Library/rmarkdown/rmarkdown/lua/latex-div.lua --embed-resources --standalone --variable bs3=TRUE --section-divs --template /home/runner/work/_temp/Library/rmarkdown/rmd/h/default.html --no-highlight --variable highlightjs=1 --variable theme=bootstrap --mathjax --variable 'mathjax-url=https://mathjax.rstudio.com/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML' --include-in-header /tmp/RtmpGqfizd/rmarkdown-str1aa260e358b3.html 
#> 
#> Output created: full_report_2021.html
# }
```
