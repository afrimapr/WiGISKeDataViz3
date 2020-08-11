library(WiGISKeDataViz3)

# Get pregnancy data
ken_preg <- get_pregnancy_data(csv_file = "https://tinyurl.com/y35htfoj")

# Get population data for two age groups
ken_1014_fem <- get_wb_gender_age_pop_data(country_iso = "KEN",
                                           indicator_code = "SP.POP.1014.FE",
                                           start = 2016,
                                           end = 2019,
                                           new_date = 2020)

ken_1519_fem <- get_wb_gender_age_pop_data(country_iso = "KEN",
                                           indicator_code = "SP.POP.1519.FE",
                                           start = 2016,
                                           end = 2019,
                                           new_date = 2020)

# Normalise pregnancy data
norm_preg <- normalise_pregnancy_data(ken_preg, ken_1014_fem, ken_1519_fem)



# Get boundary data for admin level 1
ken_adm1 <- get_admin_geoboundaries(country_name = "kenya",
                                    boundary_type = "sscgs",
                                    admin_level = "adm1")

# Add boundary data to pregnancy data
ken_preg_sf <- join_adm_boundaries(adm_column = "orgunitlevel1", boundaries_sf = ken_adm1, data_df = norm_preg)


# Create maps for 10 - 14 years old
map_norm_preg(ken_preg_sf, 1014)

# Create maps for 15 - 19 years old
map_norm_preg(ken_preg_sf, 1519)

