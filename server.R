#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(ggplot2)

shinyServer(function(input, output) {
  library(lubridate)

results<-read.csv("compiled_data.csv", header = TRUE)
countries<-unique(results$Country)
countries<-sort(countries)
  
  # subset the data by country selected
  subset_data <- reactive({
    subset(results, Country==input$country & year==input$year, select=c(Official.Times, year, Age))
  })  
   
  output$distPlot <- renderPlot({
    hist(subset_data()$Official.Times, breaks = 40, col = 'darkgray', border = 'white', xlab="Official Time (Minutes)", main="Boston Marathon Finishers")
  })
  
  output$meanTime <- renderText({
    round(mean(subset_data()$Official.Times),2)
  })
  
  output$stdevTime <- renderText({
    round(sd(subset_data()$Official.Times),2)
  })
  
  output$totalFinishers <- renderText({
    dim(subset_data())[1]
  })
  
  output$medAge <- renderText({
    round(median(subset_data()$Age))
  })
  
})
