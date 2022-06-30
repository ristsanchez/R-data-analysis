library(lubridate)
library(tidyr)
library(dplyr)
library(ggplot2)
library(plyr)
library(reshape)
library(stringi)
library(treemap)

#read csv file
NYSR <-read.csv("2012.csv")

temp <- c('city', 'crimsusp', 'age')

partial1 <- subset (NYSR, select=temp)

#replace all empty city places with unkown
partial1$city[partial1$city == ' '] <- 'UNKNOWN'

#eliminate impossible ages
partial1 <- subset(partial1, age > 10 & age < 98)

#make new subset with only ages
agesSubset <- subset(partial1, select = 'age')

sort(agesSubset, decreasing = FALSE)

#unique elements for testing purposes
uniquePlace <- unique(partial1$city, incomparables = FALSE)

uniquePlace[uniquePlace == ' '] <- 'UNKNOWN'

#unique elements for testing purposes
uniqueCrime <- unique(partial1$crimsusp, incomparables = FALSE)

uniqueAge <- unique(partial1$age, incomparables = FALSE)

#grouping of suspected people ages averages
groupedSus <- ddply(partial1, c('city'), summarize, avgAge=round(mean(age), 0))

#grouping of totals to be added as a column
groupedTotals <- transform(groupedSus, TotalsByPlace = 0)

for(place in uniquePlace){
groupedTotals$TotalsByPlace[groupedTotals$city == place] <- sum(partial1$city == place)
}

agesTable <- table(partial1$age)

agesDist <- as.data.frame(agesTable)

names(agesDist)[1] <- 'Ages'
names(agesDist)[2] <- 'Count'


#Barplot of groupedTotals
my_bar <- barplot(groupedTotals$TotalsByPlace , border=F , names.arg=groupedTotals$city , 
                  las=2 , 
                  col=c(rgb(0.1,0.8,0.9,0.8), rgb(0.9,0.1,0.1,0.8) , rgb(0.3,0.6,0.9,0.8) ,  rgb(0,0.6,0.9,0.8), rgb(0.6,0.2,0.9,0.8)) , 
                  ylim=c(0,200000) , 
                  main="" )

#Treemap of ages by totals
treemap(agesDist,
        index="Ages",
        vSize="Count",
        type="index"
)
