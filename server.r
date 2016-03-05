library(shiny)
library(leaflet)
library(RColorBrewer)
library(scales)
library(dplyr)
library(DT)

shinyServer(function(input, output, session) {
  
  ## Interactive Map ###########################################
  
  # Create the map
  output$map <- renderLeaflet({
    leaflet() %>%
      addTiles() %>%
      setView(lng=-3.7037902,lat=40.4167754, zoom = 6)
  })
  
  # This observer is responsible for maintaining the circles and legend,
  # according to the variables the user has chosen to map to color and size.
  observe({
    input$goButton
    
    colorData <- rainData$Yearrain
    pal <- colorBin("Spectral", colorData, 7, pretty = FALSE)
    radius <- rainData$Yearrain / max(rainData$Yearrain) * 30000
    
    
    leafletProxy("map", data = rainData) %>%
      clearShapes() %>%
      addCircles(~Longitude, ~Latitude, radius=radius, layerId=~Ind,
                 stroke=FALSE, fillOpacity=0.4, fillColor=pal(colorData),popup=paste(rainData$Station,rainData$Yearrain)) %>%
      addLegend("bottomleft", pal=pal, values=colorData, title="Rain",
                layerId="colorLegend")
  })
  
  
  ## Data Explorer ###########################################

  output$raintable <- DT::renderDataTable({
    df <- rainData %>%
      filter(
        is.null(input$Provinces) | Province %in% input$Provinces,
        is.null(input$Watersheds) | Watershed %in% input$Watersheds
      ) 
    DT::datatable(df,style = "bootstrap")
  })
})