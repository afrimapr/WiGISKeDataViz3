
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

# devtools::install_github("afrimapr/WiGISKeDataViz3")
library(WiGISKeDataViz3)
```

## Example

### Population data to use in normalisation

Access population data from the World Bank Data Bank to normalise
pregnancy data. The World Pop datasets that will work (given the
dataformat and cleanup code) include “SP.POP.1014.FE”, “SP.POP.1014.MA”,
“SP.POP.1519.FE”, “SP.POP.1519.MA”.

``` r
# Create tibble with population data for females age 
ken_fem_1014 <- get_wb_gender_age_pop_data(country_iso = "KEN", indicator_code = "SP.POP.1014.FE", start = 2016, end = 2019, new_date = 2020)
#> Registered S3 method overwritten by 'httr':
#>   method           from  
#>   print.cache_info hoardr
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

### Admin boundaries to use in maps and analysis

Access administrative boundaries for Kenya through the [rgeoboundaries
package](https://github.com/dickoa/rgeoboundaries) from [Ahmadou
Dicko](https://twitter.com/dickoah). rgeoboundaries provides easy access
in R to data from the [GeoBoundaries
project](https://www.geoboundaries.org/).

``` r
# Create sf object for Kenya admin level 2 (sub-county) with cleaned-up sub-county names
ken_adm2 <- get_admin_geoboundaries(country_name = "kenya", boundary_type = "sscgs", admin_level = "adm2")
str(ken_adm2)
#> Classes 'sf' and 'data.frame':   71 obs. of  6 variables:
#>  $ shapeName : chr  "Baringo" "Bomet" "Bondo" "Bungoma" ...
#>  $ shapeISO  : chr  "None" "None" "None" "None" ...
#>  $ shapeID   : chr  "KEN-ADM2-3_0_0-B1" "KEN-ADM2-3_0_0-B2" "KEN-ADM2-3_0_0-B3" "KEN-ADM2-3_0_0-B4" ...
#>  $ shapeGroup: chr  "KEN" "KEN" "KEN" "KEN" ...
#>  $ shapeType : chr  "ADM2" "ADM2" "ADM2" "ADM2" ...
#>  $ geometry  :sfc_MULTIPOLYGON of length 71; first list element: List of 1
#>   ..$ :List of 1
#>   .. ..$ : num [1:1181, 1:2] 35.8 35.8 35.9 35.9 35.9 ...
#>   ..- attr(*, "class")= chr [1:3] "XY" "MULTIPOLYGON" "sfg"
#>  - attr(*, "sf_column")= chr "geometry"
#>  - attr(*, "agr")= Factor w/ 3 levels "constant","aggregate",..: NA NA NA NA NA
#>   ..- attr(*, "names")= chr [1:5] "shapeName" "shapeISO" "shapeID" "shapeGroup" ...
```

### Pregnancy data

``` r

ken_preg <-  get_pregnancy_data(csv_file = "https://tinyurl.com/y35htfoj")
head(ken_preg)
#> # A tibble: 6 x 17
#>   year  month   day quarter date       orgunitlevel2 orgunitlevel3 orgunitlevel4
#>   <chr> <dbl> <dbl> <chr>   <date>     <chr>         <chr>         <chr>        
#> 1 2020      1     1 1       2020-01-01 Baringo       Baringo Cent… Ewalel/Chapc…
#> 2 2020      1     1 1       2020-01-01 Baringo       Baringo Cent… Kabarnet     
#> 3 2020      1     1 1       2020-01-01 Baringo       Baringo Cent… Kapropita    
#> 4 2020      1     1 1       2020-01-01 Baringo       Baringo Cent… Sacho        
#> 5 2020      1     1 1       2020-01-01 Baringo       Baringo Cent… Tenges       
#> 6 2020      4     1 2       2020-04-01 Baringo       Baringo Cent… Ewalel/Chapc…
#> # … with 9 more variables: organisationunitcode <chr>,
#> #   percentage_pregnant_women_as_adolescents <dbl>, adolescent_pregnancy <dbl>,
#> #   adolescents_10_14_years_with_pregnancy <dbl>,
#> #   adolescents_15_19_years_with_pregnancy <dbl>,
#> #   adolescent_family_planning_uptake_10_14_yrs <dbl>,
#> #   adolescent_family_planning_uptake_15_19_yrs <dbl>,
#> #   prop_of_monthly_anc_visit_by_preg_adolescent <dbl>,
#> #   estimated_adolescent_abortions_after_first_anc <dbl>
```
