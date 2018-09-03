library(png)
library(jpeg)
library(leaflet)
library(dplyr)
library(shiny)


server <- function(input, output) {  


    output$contents <- renderTable({
        req(input$file1)
        data <- read.csv(input$file1$datapath, stringsAsFactors=FALSE)
        data <- data %>% mutate(alert = ifelse(classifier_prob_1 > 0.8, 'High', 'Low')) 
        
        sub_data <- data %>%
            filter(alert == 'High') %>% 
            select(alert,
                   date,
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
        data <- read.csv(input$file1$datapath, stringsAsFactors=FALSE) %>%
            mutate(alert = ifelse(classifier_prob_1 > 0.8, 'High', 'Low')) %>% 
            mutate(colour = ifelse(alert == 'High', 'red', 'green'))

        icons <- awesomeIcons(
            icon = 'ios-close',
            iconColor = 'black',
            library = 'ion',
            markerColor = data$colour
            
        )
        
        leaflet(data) %>%
            ## addProviderTiles(providers$OpenStreetMap.DE,
            ##                  options = providerTileOptions(noWrap = TRUE)
            ##                  )
        addTiles() %>%
            addAwesomeMarkers(~lon, ~lat, icon=icons, label=~as.character(classifier_label_1))
    })

    output$ref_table <- renderText({

        paste("The brown marmorated stink bug (Halyomorpha halys)  is an insect in the family Pentatomidae that is native to China, Japan, the Korean peninsula, and Taiwan. It was accidentally introduced into the United States, with the first specimen being collected in September 1998. The brown marmorated stink bug is an agricultural pest and by 2010–11 had become a season-long pest in U.S. orchards. It has recently established itself in Europe and South America.The adults are approximately 1.7 centimetres (0.67 in) long and about as wide, forming the shield shape characteristic of other stink bugs. They are various shades of brown on both the top and undersides, with gray, off-white, black, copper, and bluish markings. The term marmorated means variegated or veined like marble. Markings unique to this species include alternating light bands on the antennae and alternating dark bands on the thin outer edge of the abdomen. The legs are brown with faint white mottling or banding. The stink glands are located on the underside of the thorax, between the first and second pair of legs, and on the dorsal surface of the abdomen.")
    })

}

