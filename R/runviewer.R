#' to run the shiny web application.
#' @export
launch_application <- function(){
  if (!requireNamespace("shiny", quietly = TRUE)) {
    stop("Package \"shiny\" needed for this function to work. Please install it from CRAN",
         call. = FALSE)
  }

  shiny::runApp(appDir = system.file("shiny/WiGISKeDataViz3_viewer",
                                     package = "WiGISKeDataViz3"))
}
