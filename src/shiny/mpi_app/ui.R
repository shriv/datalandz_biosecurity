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
  titlePanel(title="Invasive Pests"),
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
                  tabPanel("Home", span(tableOutput("contents"), style="color:red")), 
                  tabPanel("Classified Pests", textOutput("ref_table")),
                  tabPanel("Species Distribution", leafletOutput("mymap")))
      )
  )
)
