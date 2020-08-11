library(testthat)
library(WiGISKeDataViz3)

test_check("WiGISKeDataViz3")

if(!require("lattice")){
  # https://github.com/topepo/caret/issues/411#issuecomment-209973908
  install.packages("lattice", repos = "http://cran.us.r-project.org", dependencies = c("Depends", "Imports", "Suggests"))
  library(lattice)
  }
