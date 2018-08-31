library("png")
library("jpeg")


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
                accept = c("image/.jpg"))

      ),
    
    # Main panel for displaying outputs ----
      mainPanel(

      
      # Output: Tabset 
      tabsetPanel(type = "tabs",
                  tabPanel("Upload Image", plotOutput("plot1")), 
                  tabPanel("Classifier Results"),
                  tabPanel("Map yo species!"))
      )
  )
)



server <- function(input, output) {
    output$plot1 <- renderPlot({
        req(input$file1)
        inp <- input$file1
        img <- readJPEG(inp$datapath)

        plot(1, type="n", xlim=c(100, 200), ylim=c(300, 350))
        rasterImage(img,100, 300, 150, 350)
  })


}

