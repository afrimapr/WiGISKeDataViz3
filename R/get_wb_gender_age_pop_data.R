#' Get World Bank population data by gender and age group for several years.
#'
#' @param country_iso The three letter ISO code for a country in capital letters as character string.
#' @param indicator_code The World Bank data indicator code in all capitals for the dataset in question
#' - can be obtained by running wb_indicators() as character string e.g. SP.POP.1014.FE .
#' @param start The start year from which to collect data from the original dataset - numerical
#' @param end The end year until which to collect data from the original dataset - numerical
#' @param new_date  The new year for which to calculate population data based on existing years
#' in the dataset - as numerical
#' @return A dataframe containing population data from \code{start} to \code{end} for the
#' indicator \code{indicator_code} with an additional row for the new year.
#' @import dplyr
#' @importFrom stringr str_extract str_to_lower
#' @importFrom wbstats wb_data
#' @examples
#' get_wb_gender_age_pop_data(country_iso = "KEN", indicator_code = "SP.POP.1014.FE",
#' start = 2016, end = 2019, new_date = 2020)
#' @author Anelda van der Walt
#' @export
get_wb_gender_age_pop_data <- function(country_iso, indicator_code, start, end, new_date){

  # Obtain indicator data
  pop_df <- wbstats::wb_data(country = country_iso, indicator = indicator_code, start_date = start, end_date = end) %>%
    # Rename the column containing the indicator value to make code reusable across datasets
    dplyr::rename(indicator_value = indicator_code) %>%
    # Drop columns that won't be used in this analysis
    dplyr::select(-c(iso2c, country, unit, obs_status, footnote, last_updated)) %>%
    # Add column that contains the year-on-year growth
    # For more information on the lag function see https://dplyr.tidyverse.org/reference/lead-lag.html
    dplyr::mutate(growth = indicator_value/dplyr::lag(indicator_value))

  # Calculate the mean population growth since start date to calculate estimate for newest date
  # Multiply the last indicator value (nrow used to find last value in vector) with the mean of the growth for start until the last available date
  # Growth is not available in first year so we have to remove the NAs to calculate mean
  new_row <-  data.frame(iso3c = country_iso, date = new_date,
                         indicator_value = pop_df$indicator_value[nrow(pop_df)]*mean(pop_df$growth, na.rm = TRUE),
                         growth = NA)

  # Add row for new date
  pop <- pop_df %>%
    # Add row with population estimate for latest year to original dataset
    dplyr::bind_rows(new_row) %>%
    # Add columns for age and gender to be able to discriminate the data after combining with other indicator data
    # The indicator code contains the age as e.g. 1014 for years 10 - 14
    dplyr::mutate(age = stringr::str_extract(indicator_code, "\\d\\d\\d\\d"),
           # The last two letters of the indicator code is the gender as FE or MA, we change it to f and m here
           gender = stringr::str_to_lower(stringr::str_extract(stringr::str_extract(indicator_code, "\\w\\w$"), "^\\w"))) %>%
    # Drop the growth column as it isn't needed later
    dplyr::select(-growth)
}

