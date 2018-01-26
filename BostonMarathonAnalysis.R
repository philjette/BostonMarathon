#Boston Marathon analysis 2015-2017
#Based on a Kaggle dataset found here: https://www.kaggle.com/rojour/boston-results/data#
library(lubridate)

mar2015<-read.csv("marathon_results_2015.csv", header = TRUE, na.strings = c("","-"), stringsAsFactors = FALSE)
mar2016<-read.csv("marathon_results_2016.csv", header = TRUE, na.strings = c("","-"), stringsAsFactors = FALSE)
mar2017<-read.csv("marathon_results_2017.csv", header = TRUE, na.strings = c("","-"), stringsAsFactors = FALSE)

#add a field to eac DF to represent the year
year<-as.factor(rep("2015", dim(mar2015)[1]))
mar2015<-cbind(mar2015, year)

year<-as.factor(rep("2016", dim(mar2016)[1]))
mar2016<-cbind(mar2016, year)

year<-as.factor(rep("2017", dim(mar2017)[1]))
mar2017<-cbind(mar2017, year)

#go through each year and drop cols where > 50% of observations are NA
mar2015<-mar2015[, colSums(is.na(mar2015)) < nrow(mar2015) * 0.5]
mar2016<-mar2016[, colSums(is.na(mar2016)) < nrow(mar2016) * 0.5]
mar2017<-mar2017[, colSums(is.na(mar2017)) < nrow(mar2017) * 0.5]

mar2015<-mar2015[ , !(names(mar2015) %in% c("X"))]
mar2017<-mar2017[ , !(names(mar2017) %in% c("X"))]
mar2016<-mar2016[ , !(names(mar2016) %in% c("Proj.Time"))]

#all now have the same # rows, same field names. aggregate to single DF
results<-rbind(mar2015, mar2016, mar2017)

#for the sake of simplicity in this case we remove countries not appearing in each year
drop<-c("VIE","EGY","GRN","ZIM","BAH","FLK","UGA","VGB","ALG","NCA","TCA","NGR","PAR","KUW","MLT","MGL","KSA",
  "BDI","ALB","QAT","CYP","PAK","SMR","OMA","BLR","LIE","AHO","BUL","BRN","JOR")

'%!in%' <- function(x,y)!('%in%'(x,y))

results<-subset(results, Country %!in% drop)


#Clean up the splits, pace, and OT. Can't have any NAs if we want to convert to seconds.
results$X5K[is.na(results$X5K)] <- "00:00:00"
results$X10K[is.na(results$X10K)] <- "00:00:00"
results$X15K[is.na(results$X15K)] <- "00:00:00"
results$X20K[is.na(results$X20K)] <- "00:00:00"
results$Half[is.na(results$Half)] <- "00:00:00"
results$X25K[is.na(results$X25K)] <- "00:00:00"
results$X30K[is.na(results$X30K)] <- "00:00:00"
results$X35K[is.na(results$X35K)] <- "00:00:00"
results$X40K[is.na(results$X40K)] <- "00:00:00"
results$Pace[is.na(results$Pace)] <- "00:00:00"
results$Official.Time[is.na(results$Official.Time)] <- "00:00:00"

#convert official time to minutes
results$Official.Times<-round(period_to_seconds(hms(results$Official.Time))/60)

write.csv(results,"compiled_data.csv")
