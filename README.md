
<!-- README.md is generated from README.Rmd. Please edit that file -->

# cryptoTax: Crypto taxes in R (Canada only) <img src='man/figures/logo.png' align="right" height="140" style="float:right; height:200px;" />

*Disclaimer: This is not financial advice. Use at your own risks. There
are no guarantees whatsoever in relation to the use of this package.
Please consult a tax professional as necessary*.

Helps calculate crypto taxes in R.

1.  First by allowing you to format .CSV files from various exchanges to
    one large dataframe of organized transactions.
2.  Second, by allowing you to calculate your Adjusted Cost Base (ACB),
    ACB per share, and realized and unrealized capital gains/losses.
3.  Third by calculating revenues gained from staking, interest,
    airdrops, etc.
4.  Fourth, by calculating superficial losses as well, if desired.

Only supports basic or simple tax scenarios (for now).

# Installation

To install, use:

``` r
remotes::install_github("cryptoltruist/cryptoTax")
```

# ACB demo

``` r
library(cryptoTax)
data <- adjustedcostbase.ca_1
data
```

    ##         date transaction quantity price fees
    ## 1 2014-03-03         buy      100    50   10
    ## 2 2014-05-01        sell       50   120   10
    ## 3 2014-07-18         buy       50   130   10
    ## 4 2014-09-25        sell       40    90   10

``` r
ACB(data, spot.rate = "price")
```

    ##         date transaction quantity price fees total.price total.quantity  ACB
    ## 1 2014-03-03         buy      100    50   10        5000            100 5010
    ## 2 2014-05-01        sell       50   120   10        6000             50 2505
    ## 3 2014-07-18         buy       50   130   10        6500            100 9015
    ## 4 2014-09-25        sell       40    90   10        3600             60 5409
    ##   ACB.share gains
    ## 1     50.10    NA
    ## 2     50.10  3485
    ## 3     90.15    NA
    ## 4     90.15   -16

*Disclaimer: This is not financial advice. Use at your own risks. There
are no guarantees whatsoever in relation to the use of this package.
Please consult a tax professional as necessary*.
