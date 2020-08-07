#' Get pregnancy data provided by WiGISKe -
#' http://wigis.co.ke/project/visualizing-teenage-pregnancy-and-related-factors/
#'
#' @param country_name The country name of interest in lower case letters e.g. "kenya" as character string
#' Default value is "kenya" for Kenya.
#' @param boundary_type GeoBoundaries allow a choice between Simplified Single Country Unstandardized (sscu)  or
#' Simplified Single Country Globally Standardized (sscgs) . Character string. Default is "sscgs"
#' @param admin_level Character string selecting the admin level for which to obtain boundaries.
#' Depends on data available from GeoBoundaries. Character string. e.g. "adm1", "adm2", etc.
#' @return An sf object containing shape data for \code{country_name} \code{admin_level}
#' @importFrom rgeoboundaries gb_adm0 gb_adm1 gb_adm2 gb_adm3
#' @importFrom stringr str_to_title
#' @importFrom dplyr mutate
#' @examples
#' ken_adm3 <- get_admin_geoboundaries(country_name = "kenya",
#' boundary_type = "sscgs", admin_level = "adm3")
#' @author Anelda van der Walt
#' @export
get_pregnancy_data <- function(sheet_ss, )
# Read data from a copy of the original GS to help with permission settings
gs_preg <- googlesheets4::read_sheet(ss = "https://docs.google.com/spreadsheets/d/1kuqX8QM5uI7J-EhtHLUfthSO8gGyIbupJEuZL5fl9ls/edit?usp=sharing")

preg_columns <- gs_preg %>%
  # Clean column names
  janitor::clean_names() %>%
  dplyr::rename(percentage_pregnant_women_as_adolescents = "of_pregnant_women_adolescents_10_19_years",
                estimated_adolescent_abortions_after_first_anc = "estimated_post_abortion") %>%
  # Reorder columns to help me see what is there and what relates to what
  dplyr::relocate(adolescents_15_19_years_with_pregnancy, .after="adolescents_10_14_years_with_pregnancy") %>%
  dplyr::relocate(prop_of_monthly_anc_visit_by_preg_adolescent, .after="adolescent_family_planning_uptake_15_19_yrs") %>%
  dplyr::relocate(estimated_adolescent_abortions_after_first_anc, .after="prop_of_monthly_anc_visit_by_preg_adolescent") %>%
  # Drop unnecesary columns
  select(-c(periodname, periodcode, perioddescription, orgunitlevel1, organisationunitid, organisationunitname, organisationunitdescription))
# County names contain the word "county"
preg_clean <- preg_columns %>%   mutate(orgunitlevel2 = str_remove(orgunitlevel2, " County"),
                                        orgunitlevel3 = str_remove(orgunitlevel3, " Sub County"),
                                        orgunitlevel4 = str_remove(orgunitlevel4, " Ward")) %>%
  # Fix county names to correspond with other data sets
  mutate(orgunitlevel2 = case_when(orgunitlevel2 == "Muranga" ~ "Murang'a",
                                   TRUE ~ as.character(orgunitlevel2))) %>%
  # Change NAs to 0 where data is available either for 10-14yrs or 15-19 yrs and can be checked against total (adolescents_pregnancy)
  mutate(adolescents_10_14_years_with_pregnancy = case_when(adolescent_pregnancy - adolescents_15_19_years_with_pregnancy == 0 ~ 0,
                                                            TRUE ~ as.numeric(adolescents_10_14_years_with_pregnancy)),
         adolescents_15_19_years_with_pregnancy = case_when(adolescent_pregnancy - adolescents_10_14_years_with_pregnancy == 0 ~ 0,
                                                            TRUE ~ as.numeric(adolescents_15_19_years_with_pregnancy))) %>%
  # Change NAs to 0 where data is available for family planning uptake in either the 10-14yr bracket or the 15-19yr bracket.
  # Assume 0 where no observation is entered for one of two columns but an observation is available for the other
  mutate(adolescent_family_planning_uptake_10_14_yrs = case_when((is.na(adolescent_family_planning_uptake_10_14_yrs) & !is.na(adolescent_family_planning_uptake_15_19_yrs)) ~ 0,
                                                                 TRUE ~ as.numeric(adolescent_family_planning_uptake_10_14_yrs)),
         adolescent_family_planning_uptake_15_19_yrs = case_when((is.na(adolescent_family_planning_uptake_15_19_yrs) & !is.na(adolescent_family_planning_uptake_10_14_yrs)) ~ 0,
                                                                 TRUE ~ as.numeric(adolescent_family_planning_uptake_15_19_yrs)))


preg_final <- preg_clean %>%
  # Separate year from quarter to allow for time series analysis
  tidyr::separate(col = periodid, into = c("year", "quarter"), sep = "Q") %>%
  # Add dates based on quarter data
  mutate(month = case_when(quarter == 1 ~ 1,
                           quarter == 2 ~ 4,
                           quarter == 3 ~ 7,
                           quarter == 4 ~ 10),
         day = 1) %>%
  # Convert date to Date format
  mutate(date = lubridate::as_date(paste(year, month, day, sep="-"))) %>%
  relocate(month, .after = "year") %>%
  relocate(day, .after = "month") %>%
  relocate(date, .after = "quarter")
