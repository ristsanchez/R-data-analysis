# Time series

library(ggplot2)
library(plyr)
library(reshape)
library(tseries)
library(gridExtra)
library(RColorBrewer)
library(maps)
library(mapproj)
library(ggmap)
library(vcd)
library(ggparallel)
library(lubridate)

gamestop <- get.hist.quote(
  "gme", start="2020-8-1", end="2021-8-1", quote=c("Cl"))

tesla <- get.hist.quote(
  "tsla", start="2020-8-1", end="2021-8-1", quote=c("Cl"))

amc <- get.hist.quote(
  "amc", start="2020-8-1", end="2021-8-1", quote=c("Cl"))


#Set raw data as data frame
gamestop <- as.data.frame(gamestop)

tesla <- as.data.frame(tesla)

amc <- as.data.frame(amc)


#Set row names with the dates
namesGME <- row.names(gamestop)

namesTSLA <- row.names(tesla)

namesAMC <- row.names(amc)


#transform dates into proper date format
datesGME <- ymd(row.names(gamestop))

datesTSLA <- ymd(row.names(tesla))

datesAMC <- ymd(row.names(amc))


#set column name
gamestop <- transform(gamestop, date=datesGME)

tesla <- transform(tesla, date=datesTSLA)

amc <- transform(amc, date=datesAMC)

gamestop <- transform(gamestop, company="GameStop (GME)")

tesla <- transform(tesla, company="Tesla Motors (TSLA)")

amc <- transform(amc, company="AMC Theatres ()")


#Combine all data frames
combined <- rbind(gamestop, tesla, amc)


#calculate max and min for each
maxGME <- gamestop[which.max(gamestop$Close),]
minGME <- gamestop[which.min(gamestop$Close),]

maxTSLA <- tesla[which.max(tesla$Close),]
minTSLA <- tesla[which.min(tesla$Close),]

maxAMC <- amc[which.max(amc$Close),]
minAMC <- amc[which.min(amc$Close),]


#Plot combined results
ggplot(data=combined) + 
  geom_line(aes(x=date,y=Close, colour=company)) + 
  annotate(geom="text", x=as.Date(maxGME$date), y=maxGME$Close + 20,label= toString(maxGME$Close)) +
  annotate(geom="point", x=as.Date(maxGME$date), y=maxGME$Close, size=3, shape=21, fill="red") +
  annotate(geom="text", x=as.Date(minGME$date), y=minGME$Close - 20,label=toString(minGME$Close)) +
  annotate(geom="point", x=as.Date(minGME$date), y=minGME$Close, size=3, shape=21, fill="red") +
  
  annotate(geom="text", x=as.Date(maxTSLA$date), y=maxTSLA$Close + 20,label=toString(maxTSLA$Close)) +
  annotate(geom="point", x=as.Date(maxTSLA$date), y=maxTSLA$Close, size=3, shape=21, fill="red") +
  annotate(geom="text", x=as.Date(minTSLA$date), y=minTSLA$Close - 20,label=toString(minTSLA$Close)) +
  annotate(geom="point", x=as.Date(minTSLA$date), y=minTSLA$Close, size=3, shape=21, fill="red") +
  
  annotate(geom="text", x=as.Date(maxAMC$date), y=maxAMC$Close + 20,label=toString(maxAMC$Close)) +
  annotate(geom="point", x=as.Date(maxAMC$date), y=maxAMC$Close, size=3, shape=21, fill="red") +
  annotate(geom="text", x=as.Date(minAMC$date), y=minAMC$Close - 20,label=toString(minAMC$Close)) +
  annotate(geom="point", x=as.Date(minAMC$date), y=minAMC$Close, size=3, shape=21, fill="red") 
  