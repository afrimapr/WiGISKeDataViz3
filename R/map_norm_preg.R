#' Draw cloropleth map of normalised adolescent pregnancy data
#' Can select age group
#'
#' @param data_sf The dataframe/tibble that contains normalised pregnancy data and
#' geometry data for the admin boundary of interest- created by the functions normalise_pregnancy_data()
#' and join_adm_boundaries(). Must be an sf object.
#' @param age_group Either 1014 for ages 10 - 14 or 1519 for ages 15 - 19
#' @param year The year for which the map should be drawn (can be 2016, 2017, 2018, 2019 or 2020)
#' @return A cloropleth map showing occurrance of pregnancies for a specific age group across the counties in Kenya
#' @importFrom magrittr "%>%"
#' @importFrom dplyr filter group_by summarise
#' @importFrom tmaptools get_brewer_pal
#' @importFrom tmap tm_shape tm_polygons
#' @example
#' map_norm_preg_2019 <- map_norm_preg(ken_preg_sf, 1519, 2019)
#' @author Anelda van der Walt
#' @seealso normalise_pregnancy_data join_adm_boundaries
#' @export
map_norm_preg <- function(data_sf, age_group, year) {

  if (age_group == 1014){
    data_county <- data_sf %>%
      dplyr::filter(.data$year == year) %>%
      dplyr::group_by(.data$orgunitlevel1) %>%
      dplyr::summarise(count = sum(.data$preg_10_14_norm, na.rm = TRUE), .groups = "keep")


      data_county_map <- tmap::tm_shape(data_county) +
        tmap::tm_polygons("count", palette = "YlOrBr", style = "fisher",
                          title = "Normalised pregnancies per 10'000 girls in age group")
      } else {
    data_county <- data_sf %>%
      dplyr::filter(.data$year == year) %>%
      dplyr::group_by(.data$orgunitlevel1) %>%
      dplyr::summarise(count = sum(.data$preg_15_19_norm, na.rm = TRUE), .groups = "keep")

    data_county_map <- tmap::tm_shape(data_county) +
      tmap::tm_polygons("count", palette = "YlOrBr", style = "fisher",
                        title = "Normalised pregnancies per 10'000 girls in age group")
  }

  return(data_county_map)
}
