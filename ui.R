#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
results<-read.csv("compiled_data.csv", header = TRUE)
countries<-unique(results$Country)
countries<-sort(countries)

shinyUI(fluidPage(
  
  titlePanel("Boston Marathon Times 2015-2017"),
  
  # Sidebar
  sidebarLayout(
    sidebarPanel(
      selectInput("year",
                  "Race Year(s):",
                  c("2015","2016","2017"), 
                  multiple = TRUE, selected=c("2015","2016","2017")),
       selectInput("country",
                   "Country:",
                   countries, 
                   multiple = FALSE, selected = "CAN")
      ),
    #Output in main panel
    mainPanel(
       plotOutput("distPlot"),
       h3("Total finishers:"),
       textOutput("totalFinishers"),
       h3("Median Age:"),
       textOutput("medAge"),
       h3("Mean time (mins):"),
       textOutput("meanTime"),
       h3("Standard Deviation:"),
       textOutput("stdevTime")
    )
  )
  )
)
