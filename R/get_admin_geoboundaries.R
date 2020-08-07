#' Get admin boundaries from GeoBoundaries via rgeoboundaries for drawing maps .
#'
#' @param country_name The country name of interest in lower case letters e.g. "kenya" as character string
#' Default value is "kenya" for Kenya.
#' @param boundary_type GeoBoundaries allow a choice between Simplified Single Country Unstandardized (sscu)  or
#' Simplified Single Country Globally Standardized (sscgs) . Character string. Default is "sscgs"
#' @param admin_level Character string selecting the admin level for which to obtain boundaries.
#' Depends on data available from GeoBoundaries. Character string. e.g. "adm1", "adm2", etc.
#' @return An sf object containing shape data for \code{country_name} \code{admin_level}
#' @import rgeoboundaries
#' @importFrom stringr str_to_title
#' @importFrom dplyr mutate
#' @examples ken_adm3 <- get_admin_geoboundaries(country_name = "kenya", type = "sscgs", admin_level = "adm1")
#' @author Anelda van der Walt
#' @export
get_admin_geoboundaries <- function(country_name = "kenya", boundary_type = "sscgs", admin_level){
  if (admin_level == "adm0"){
    boundary_sf <- rgeoboundaries::gb_adm0(country = country_name, type = boundary_type) %>%
      dplyr::mutate(shapeName = str_to_title(.data$shapeName))
  }
  else if (admin_level == "adm1"){
    boundary_sf <- rgeoboundaries::gb_adm1(country = country_name, type = boundary_type) %>%
      dplyr::mutate(shapeName = str_to_title(.data$shapeName))
  }
  else if (admin_level == "adm2") {
    boundary_sf <- rgeoboundaries::gb_adm2(country = country_name, type = boundary_type) %>%
      dplyr::mutate(shapeName = str_to_title(.data$shapeName))
  }
  else if (admin_level == "adm3") {
    boundary_sf <- rgeoboundaries::gb_adm3(country = country_name, type = boundary_type) %>%
      dplyr::mutate(shapeName = str_to_title(.data$shapeName))
  }

  if (country_name == "kenya" & admin_level == "adm1"){
    # County name problems in original data from geoboundaries
    boundary_sf <-dplyr::mutate(shapeName = dplyr::case_when(.data$shapeName == "Elegeyo-Marakwet" ~ "Elgeyo Marakwet",
                                                             .data$shapeName == "Murang`a" ~ "Murang'a",
                                                             .data$shapeName == "Tharaka-Nithi" ~ "Tharaka Nithi",
                                                             TRUE ~ as.character(.data$shapeName)))
  }

  return(boundary_sf)
}
