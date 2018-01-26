Boston Marathon Finishers 2015-2017
========================================================
author: Phil Jette
date: Jan 26, 2018
autosize: true

A Shiny App for Boston Finishing Times
========================================================

This Shiny app plots the distribution of official times of Boston Marathon finishers 2015-2017.
Analisys is based on a Kaggle dataset found here: https://www.kaggle.com/rojour/boston-results/data

You can check out the app here: https://philjette.shinyapps.io/BostonMarathon/

Data
========================================================
First we prepped the Kaggle data for use in our app. 3 CSVs are provided (one each for 2015,2016,2017), so upon loading each one some cleanup was required prior to binding them together in a single results file, with a new column representing the year.




```r
#go through each year and drop cols where > 50% of observations are NA
mar2015<-mar2015[, colSums(is.na(mar2015)) < nrow(mar2015) * 0.5]
mar2016<-mar2016[, colSums(is.na(mar2016)) < nrow(mar2016) * 0.5]
mar2017<-mar2017[, colSums(is.na(mar2017)) < nrow(mar2017) * 0.5]

mar2015<-mar2015[ , !(names(mar2015) %in% c("X"))]
mar2017<-mar2017[ , !(names(mar2017) %in% c("X"))]
mar2016<-mar2016[ , !(names(mar2016) %in% c("Proj.Time"))]

#all now have the same # rows, same field names. aggregate to single DF
results<-rbind(mar2015, mar2016, mar2017)
```

Trimming countries with low representation
========================================================
To avoid erros when selecting years, countries not represented in each year were removed. 
This was done for simplicity and will be remedied in later versions. 


```r
drop<-c("VIE","EGY","GRN","ZIM","BAH","FLK","UGA","VGB","ALG",
        "NCA","TCA","NGR","PAR","KUW","MLT","MGL","KSA",
  "BDI","ALB","QAT","CYP","PAK","SMR","OMA","BLR","LIE",
  "AHO","BUL","BRN","JOR")

'%!in%' <- function(x,y)!('%in%'(x,y))

results<-subset(results, Country %!in% drop)
```



Shiny Reactivity
========================================================
We use reactivity to filter the data based on input from the user, allowing selection of
different years and countries.

```r
  # subset the data by country selected
  subset_data <- reactive({
    subset(results, Country==input$country & year==input$year, select=c(Official.Times, year, Age))
  })  
```
