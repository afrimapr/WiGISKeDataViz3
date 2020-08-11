#' Use World bank data to normalise number of female teenagers from 2016 - 2020
#'
#' @param preg_df The dataframe or tibble created when running get_pregnancy_data("https://tinyurl.com/y35htfoj").
#' @param pop_f_1014 The World Bank data for females from Kenya aged 10 - 14
#' obtained when running get_wb_gender_age_pop_data(indicator_code = "SP.POP.1014.FE")
#' @param pop_f_1519 The World Bank data for females from Kenya aged 15 - 19
#' obtained when running get_wb_gender_age_pop_data(indicator_code = "SP.POP.1519.FE")
#' @return A dataframe containing normalised pregnancy data.
#' @importFrom magrittr "%>%"
#' @importFrom dplyr case_when mutate
#' @examples
#' norm_preg <- normalise_pregnancy_data(preg_df, pop_f_1014, pop_f_1519)
#' @author Anelda van der Walt
#' @seealso get_pregnancy_data get_wb_gender_age_pop_data
#' @export
normalise_pregnancy_data <- function(preg_df, pop_f_1014, pop_f_1519){
  ken_preg_norm <- preg_df %>%
    # Get the population count for each year for the two age groups but leave normalised count as NA if no count available
    # Normalised value is X per 10'000 women in the age group for the year
    dplyr::mutate(preg_10_14_norm = dplyr::case_when(.data$year == 2016 & !is.na(.data$adolescents_10_14_years_with_pregnancy) ~ .data$adolescents_10_14_years_with_pregnancy/pop_f_1014$indicator_value[pop_f_1014$date == 2016]*10000,
                                                     .data$year == 2017 & !is.na(.data$adolescents_10_14_years_with_pregnancy) ~ .data$adolescents_10_14_years_with_pregnancy/pop_f_1014$indicator_value[pop_f_1014$date == 2017]*10000,
                                                     .data$year == 2018 & !is.na(.data$adolescents_10_14_years_with_pregnancy) ~ .data$adolescents_10_14_years_with_pregnancy/pop_f_1014$indicator_value[pop_f_1014$date == 2018]*10000,
                                                     .data$year == 2019 & !is.na(.data$adolescents_10_14_years_with_pregnancy) ~ .data$adolescents_10_14_years_with_pregnancy/pop_f_1014$indicator_value[pop_f_1014$date == 2019]*10000,
                                                     .data$year == 2020 & !is.na(.data$adolescents_10_14_years_with_pregnancy) ~ .data$adolescents_10_14_years_with_pregnancy/pop_f_1014$indicator_value[pop_f_1014$date == 2020]*10000*2),
                  preg_15_19_norm = dplyr::case_when(.data$year == 2016 & !is.na(.data$adolescents_15_19_years_with_pregnancy) ~ .data$adolescents_15_19_years_with_pregnancy/pop_f_1519$indicator_value[pop_f_1519$date == 2016]*10000,
                                                     .data$year == 2017 & !is.na(.data$adolescents_15_19_years_with_pregnancy) ~ .data$adolescents_15_19_years_with_pregnancy/pop_f_1519$indicator_value[pop_f_1519$date == 2017]*10000,
                                                     .data$year == 2018 & !is.na(.data$adolescents_15_19_years_with_pregnancy) ~ .data$adolescents_15_19_years_with_pregnancy/pop_f_1519$indicator_value[pop_f_1519$date == 2018]*10000,
                                                     .data$year == 2019 & !is.na(.data$adolescents_15_19_years_with_pregnancy) ~ .data$adolescents_15_19_years_with_pregnancy/pop_f_1519$indicator_value[pop_f_1519$date == 2019]*10000,
                                                     .data$year == 2020 & !is.na(.data$adolescents_15_19_years_with_pregnancy) ~ .data$adolescents_15_19_years_with_pregnancy/pop_f_1519$indicator_value[pop_f_1519$date == 2020]*10000*2))

  return(ken_preg_norm)
}

