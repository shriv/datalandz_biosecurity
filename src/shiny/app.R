library(png)
library(jpeg)
library(leaflet)
library(dplyr)
library(shiny)


r_colors <- rgb(t(col2rgb(colors()) / 255))
names(r_colors) <- colors()

## Define UI for Insect Classification app
ui <- fluidPage(

  # App title ----
  titlePanel("Invasive Pests"),

  # Sidebar layout with input and output definitions ----
  sidebarLayout(

    # Sidebar panel for inputs ----
    sidebarPanel(

      
      # Input: Select a file ----
      fileInput("file1", "Choose Database",
                multiple = TRUE,
                accept = c("txt/.csv",
                           ".csv"))
    ),
    
    
    # Main panel for displaying outputs ----
      mainPanel(

      
      # Output: Tabset 
      tabsetPanel(type = "tabs",
                  tabPanel("Home", tableOutput("contents")), 
                  tabPanel("Classified Pests"),
                  tabPanel("Species Distribution", leafletOutput("mymap")))
      )
  )
)



server <- function(input, output) {

    ## Read "DB" file

    

    output$contents <- renderTable({
        req(input$file1)
        data <- read.csv(input$file1$datapath, stringsAsFactors=FALSE)
 
        sub_data <- data %>% select(date,
                                    classifier_label_1,
                                    classifier_prob_1,
                                    user_comments,
                                    user_name,
                                    phone)
        return(head(sub_data, 3))
    })

    
    ## Plot points on Leaflet map
    output$mymap <- renderLeaflet({
        req(input$file1)
        data = read.csv(input$file1$datapath, stringsAsFactors=FALSE)
        points <- data %>% select(lon, lat)
        leaflet() %>%
            addProviderTiles(providers$OpenStreetMap.DE,
                             options = providerTileOptions(noWrap = TRUE)
                             ) %>%
            addMarkers(data = points)
  })

}

