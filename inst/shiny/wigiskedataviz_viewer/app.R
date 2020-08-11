library(shinydashboard)

ui <- shinydashboard::dashboardPage(
    shinydashboard::dashboardHeader(title = "WiGISKe Data Viz Challenge #3"),
    shinydashboard::dashboardSidebar(),
    shinydashboard::dashboardBody(
        # Boxes need to be put in a row (or column)
        fluidRow(
            box(selectInput(inputId = "age",
                            label = "Age group:",
                            choices = c("10 - 14" = 1014, "15 - 19" = 1519))
                ),

            box(tmap::tmapOutput("map_pregs_normalised"))

            )
        )
    )


server <- function(input, output) {

    output$map_pregs_normalised <- tmap::renderTmap({
        map_norm_preg(data_sf = ken_preg_sf, age_group = input$age)
    })
}

shinyApp(ui, server)
