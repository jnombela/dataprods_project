library(shiny)
library(leaflet)

shinyUI(navbarPage("Weather in Spain. Rain normal levels", id="nav",
                   
                   tabPanel("Interactive map",
                            div(class="outer",
                            
                            tags$head(
                                  # Include our custom CSS
                                  includeCSS("styles.css")
                                ),
                                
                                leafletOutput("map", width="100%", height="100%"),
                                absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
                                              draggable = TRUE, top = 60, left = "auto", right = 20, bottom = "auto",
                                              width = 330, height = "auto",
                                              
                                              h2("Rain data"),
                                              
                                              actionButton("goButton", "GO!")
)
                                
                                 
                           )
                   ),
                   
                   tabPanel("Data explorer",
                            fluidRow(
                              column(3,
                                     selectizeInput("Provinces", "Province:", choices=provinces, multiple=TRUE),
                                     selectizeInput("Watersheds", "Watershed:", choices=watersheds, multiple=TRUE)
                              ),
                            hr(),
                            DT::dataTableOutput("raintable")
                            
                          )   
                          )
                   )     
                 
)
