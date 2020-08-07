
<!-- README.md is generated from README.Rmd. Please edit that file -->

# WiGISKeDataViz3

<!-- badges: start -->

[![Travis build
status](https://travis-ci.org/anelda/WiGISKeDataViz3.svg?branch=master)](https://travis-ci.org/anelda/WiGISKeDataViz3)
[![AppVeyor build
status](https://ci.appveyor.com/api/projects/status/github/anelda/WiGISKeDataViz3?branch=master&svg=true)](https://ci.appveyor.com/project/anelda/WiGISKeDataViz3)
[![Codecov test
coverage](https://codecov.io/gh/anelda/WiGISKeDataViz3/branch/master/graph/badge.svg)](https://codecov.io/gh/anelda/WiGISKeDataViz3?branch=master)
<!-- badges: end -->

The goal of WiGISKeDataViz3 is to facilitate easy access to datasets,
analysis and visualisation used in the Women in GIS Kenya data viz
challenge \#3 where the focus was on teenage pregnancies between 2016 -
2020. For more information about the challenge see
<https://wigis.co.ke/project/visualizing-teenage-pregnancy-and-related-factors/>.

## Installation

WiGISKeDataViz3 is not on CRAN but you can install the development
version available on Github as follows:

``` r
# install.packages("devtools") # if not already installed

devtools::install_github("afrimapr/WiGISKeDataViz3")
```

## Example

Access population data from the World Bank Data Bank to normalise
pregnancy data. The World Pop datasets that will work (given the
dataformat and cleanup code) include “SP.POP.1014.FE”, “SP.POP.1014.MA”,
“SP.POP.1519.FE”, “SP.POP.1519.MA”.

``` r
library(WiGISKeDataViz3)
#> Warning: replacing previous import 'vctrs::data_frame' by 'tibble::data_frame'
#> when loading 'dplyr'

## Obtaining population data for females from Kenya ages 10 - 14 for the years 2016 - 2019
ken_fem_1014 <- get_wb_gender_age_pop_data(country_iso = "KEN", indicator_code = "SP.POP.1014.FE", start = 2016, end = 2019, new_date = 2020)
head(ken_fem_1014)
#> # A tibble: 5 x 5
#>   iso3c  date indicator_value age   gender
#>   <chr> <dbl>           <dbl> <chr> <chr> 
#> 1 KEN    2016         3074808 1014  f     
#> 2 KEN    2017         3149007 1014  f     
#> 3 KEN    2018         3222081 1014  f     
#> 4 KEN    2019         3288073 1014  f     
#> 5 KEN    2020         3362403 1014  f
```
