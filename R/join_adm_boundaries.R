#' Add admin boundaries to dataframe and convert to an sf object to use in mapping and other analysis
#'
#' @param adm_column Name of the column in dataframe/tibble that contains the admin level names.
#' Default: orgunitlevel1
#' @param data_df Dataframe or tibble containing the data that needs to be converted to sf object. Obtained
#' by running get_pregnancy_data() and normalise_pregnancy_data()
#' @param boundaries_sf SF object containing the admin boundaries for the relevant admin level.
#' Obtained by running get_admin_geoboundaries()
#' @return An sf object
#' @importFrom dplyr left_join
#' @importFrom magrittr "%>%"
#' @importFrom sf st_as_sf
#' @example
#' data_sf <- join_adm_boundaries(adm_column = "orgunitlevel1", boundaries_sf = ken_adm1, data_df = norm_preg)
#' @author Anelda van der Walt
#' @export
join_adm_boundaries <- function(adm_column = "orgunitlevel1", boundaries_sf, data_df) {
  # Create named vector with adm_column to use in left_join
  # (https://stackoverflow.com/questions/54823846/dplyr-left-join-does-not-work-with-a-character-objects-as-the-lhs-variable)
  data_adm_column <- c("shapeName")
  names(data_adm_column) <- adm_column


  # Combine the boundaries sf object with the data df
  data_with_geometry <- data_df %>%
    dplyr::left_join(boundaries_sf, by = data_adm_column)

  data_sf <- sf::st_as_sf(data_with_geometry)

  return(data_sf)
}
