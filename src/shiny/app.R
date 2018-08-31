library("png")
library("jpeg")
library(leaflet)

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
      fileInput("file1", "Choose Image File",
                multiple = TRUE,
                accept = c("image/.jpg",
                           "image/.png"))
    ),
    
    
    # Main panel for displaying outputs ----
      mainPanel(

      
      # Output: Tabset 
      tabsetPanel(type = "tabs",
                  tabPanel("Upload Image", plotOutput("plot1")), 
                  tabPanel("Classifier Results"),
                  tabPanel("Map yo species!", leafletOutput("mymap")))
      )
  )
)



server <- function(input, output) {

    ## Plot invasive insect image to be classified
    output$plot1 <- renderPlot({
        ## Read input image file 
        req(input$file1)
        inp <- input$file1
        imgfile <- inp$datapath

        ## Read png or jpg image
        if (strsplit(imgfile, '[.]')[[1]][2] == "png"){
            img <- readPNG(imgfile)
        } else {
            img <- readJPEG(imgfile)
        }

        ## Plot the image
        ## Don't understand the plot limits
        plot(1, type="n" , xlim=c(100, 200), ylim=c(300, 350))
        rasterImage(img, 100, 300, 150, 350)

    })

    
    ## Generate points around Wellington
    points <- eventReactive(input$recalc, {
        cbind(rnorm(10.0, mean=174.78, sd=0.01), rnorm(10, mean=-41.28, sd=0.01))
    }, ignoreNULL = FALSE)

    ## Plot points on Leaflet map
    output$mymap <- renderLeaflet({
        leaflet() %>%
            addProviderTiles(providers$OpenStreetMap.DE,
                             options = providerTileOptions(noWrap = TRUE)
                             ) %>%
            addMarkers(data = points())
  })

}

