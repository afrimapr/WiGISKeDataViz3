library(shinydashboard)

ui <- shinydashboard::dashboardPage(skin = "black",
    shinydashboard::dashboardHeader(title = "WiGISKe Data Viz Challenge #3",
                                    titleWidth = 450),
    shinydashboard::dashboardSidebar(
        sidebarMenu(
            menuItem("Pregnancy maps", tabName = "maps", icon = icon("map")),
            menuItem("Widgets", tabName = "widgets", icon = icon("th"))
            )),
    shinydashboard::dashboardBody(
            tabItems(
                # First tab content
                tabItem(tabName = "maps",
                            fluidRow(
                                box(selectInput(inputId = "age",
                                                label = "Age group:",
                                                choices = c("10 - 14" = 1014, "15 - 19" = 1519))
                                )
                            ),

                            fluidRow(
                                box(leaflet::leafletOutput("map_pregs_normalised2016"), width = 4, title = "2016"),
                                box(leaflet::leafletOutput("map_pregs_normalised2017"), width = 4, title = "2017"),
                                box(leaflet::leafletOutput("map_pregs_normalised2018"), width = 4, title = "2018"),
                                box(leaflet::leafletOutput("map_pregs_normalised2019"), width = 4, title = "2019"),
                                box(leaflet::leafletOutput("map_pregs_normalised2020"), width = 4, title = "2020"),
                                box(shiny::textOutput("map_pregs_normalised_info"), width = 4, title = "Understanding the map and underlying data")
                                )
                        ),

                # Second tab content
                tabItem(tabName = "widgets",
                        h2("Widgets tab content")
                )
            )
        )

    )



server <- function(input, output, session) {

    output$map_pregs_normalised2016 <- leaflet::renderLeaflet({
        tmap::tmap_leaflet(map_norm_preg(data_sf = ken_preg_sf, age_group = input$age, year = 2016))
    })

    output$map_pregs_normalised2017 <- leaflet::renderLeaflet({
        tmap::tmap_leaflet(map_norm_preg(data_sf = ken_preg_sf, age_group = input$age, year = 2017))
    })

    output$map_pregs_normalised2018 <- leaflet::renderLeaflet({
        tmap::tmap_leaflet(map_norm_preg(data_sf = ken_preg_sf, age_group = input$age, year = 2018))
    })

    output$map_pregs_normalised2019 <- leaflet::renderLeaflet({
        tmap::tmap_leaflet(map_norm_preg(data_sf = ken_preg_sf, age_group = input$age, year = 2019))
    })

    output$map_pregs_normalised2020 <- leaflet::renderLeaflet({
        tmap::tmap_leaflet(map_norm_preg(data_sf = ken_preg_sf, age_group = input$age, year = 2020))
    })

    output$map_pregs_normalised_info = renderText({
        paste0("Data shown here represents a cleaned up version of the data received from WiGISKE for the
               third data visualisation challenge. The scripts showing how the data was cleaned up is available
               in our Github repository.

               Raw numbers were normalised using population numbers for the different age
               groups obtained from the World Bank Data Bank for the years 2016 - 2020. As we only received pregnancy
               data for the first 2 quarters of 2020, we simply multiplied those numbers by two to be able to compare
               against other full years. We recognise that there are more elegant ways of modeling the expected number
               of pregnancies for the year 2020.

               The data was grouped by County although numbers are also available for sub counties and wards and is
               available for further exploration.")
    })
}

shinyApp(ui, server)
