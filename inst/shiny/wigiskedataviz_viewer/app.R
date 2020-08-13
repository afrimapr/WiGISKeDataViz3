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
                                box(leaflet::leafletOutput("map_pregs_normalised2020"), width = 4, title = "2020")
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
}

shinyApp(ui, server)
