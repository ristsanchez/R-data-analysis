#scatter plot

library(lubridate)
library(tidyr)
library(dplyr)
library(ggplot2)
library(plyr)
library(reshape)
library(stringi)
library(ggthemes)


#DATA PREPARATION

#Creating the column names based on the descriptions by the authors
attNames <- c('class', 'age', 'menopause', 'tumorSize', 'invNodes', 'nodeCaps', 'degMalig', 'breast', 'breastQuad', 'irradiat')

#Populate main data set with the breast cancer data
dataSet <- read.table("breast-cancer.data", header=FALSE, sep= ",", col.names = attNames)

#-------------------------------------------------------------------------------


#DATA CLEANSING

#Missing data entries in the set are labeled with the character '?'
#Delete rows containing the '?' character
partial1 <- subset(dataSet, nodeCaps != '?')
partial1 <- subset(partial1, breastQuad != '?')
 
#-------------------------------------------------------------------------------


#DATA ENTRY
#Set up the x and y axis
myplot <- ggplot(data=partial1, aes(x=degMalig, y=age))

#Set up the rest of the plot
#The position is set to 'jitters' to make points not stack on top of each other
myplot <- myplot + facet_wrap(~menopause) +
  geom_point(aes(colour=invNodes, size=tumorSize , ),alpha=0.4, position = "jitter") 

#-------------------------------------------------------------------------------


#DATA PRESENTATION
#Clean up labels and adjust text
myplot <- myplot +ylab("Age (years)")+
  scale_x_continuous("Degree of Malignancy")+
  theme(axis.title=element_text(face="bold"))

#Title
myplot <- myplot + ggtitle("Enhanced Breast Cancer Scatterplot with 5 Variables")+
  theme(plot.title=element_text(face="bold"))

#Set the plot theme to black and white
myplot <- myplot + theme_bw()

myplot

#-------------------------------------------------------------------------------


#Additional information from the breast-cancer.names file
# 1. Class: no-recurrence-events, recurrence-events
# 2. age: 10-19, 20-29, 30-39, 40-49, 50-59, 60-69, 70-79, 80-89, 90-99.
# 3. menopause: lt40, ge40, premeno.
# 4. tumor-size: 0-4, 5-9, 10-14, 15-19, 20-24, 25-29, 30-34, 35-39, 40-44, 45-49, 50-54, 55-59.
# 5. inv-nodes: 0-2, 3-5, 6-8, 9-11, 12-14, 15-17, 18-20, 21-23, 24-26, 27-29, 30-32, 33-35, 36-39.
# 6. node-caps: yes, no.
# 7. deg-malig: 1, 2, 3.
# 8. breast: left, right.
# 9. breast-quad: left-up, left-low, right-up,	right-low, central.
# 10. irradiat:	yes, no.