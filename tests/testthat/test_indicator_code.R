context("Worldbank indicator code")
library(WiGISKeDataViz3)

test_that("World Bank indicator code is provided", {
  expect_error(get_wb_gender_age_pop_data(), "argument \"indicator_code\" is missing, with no default")
})

