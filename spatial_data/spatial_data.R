# Spatial Data

library(tidyverse)
library(leaflet)
library(stringr)
library(sf)
library(here)
library(widgetframe)
library(rgdal)
library(sp)


#This R script produces 3 different plots, clusters, markers, and areas by borough

#-------------------------------------------------------------------------------
#Reading Airbnb data from CSV file


#NOTE: file MUST be inside the working directory 
NY_airbnb <- read.csv("AB_NYC_2019.csv")

#-------------------------------------------------------------------------------
#Graphing Data by clusters


#Include all listings that cost something
clusters <- NY_airbnb %>%
  filter(price >= 0)

#clear empty entries
clusters <-na.omit(clusters)


#Graph data with clusters
leaflet(data = clusters) %>%
  addTiles() %>%
  addMarkers(clusterOptions = markerClusterOptions()) %>%
  frameWidget()

#-------------------------------------------------------------------------------
#Graphing Individual data point with markers; Only for Staten Island 


#filter out non Staten Island entries
markers <- NY_airbnb %>%
  filter(neighbourhood_group == "Staten Island")

#clear empty entries
markers <-na.omit(markers)


#Graph data with markes with custom parameters
markers %>%
  mutate(popup = str_c(name,
                       str_c("Room type:", `room_type`,
                             sep = " "),
                       str_c("Neighbourhood:", `neighbourhood`,
                             sep = " "),
                       sep = "<br/>")) %>%
  leaflet() %>%
  addTiles() %>%
  addMarkers(popup = ~popup) %>%
  frameWidget()

#-------------------------------------------------------------------------------
#Group and graph listings by borough area

#Include all listings that cost something
prices <- NY_airbnb %>%
  filter(price >= 0)

#clear empty entries
prices <-na.omit(prices)

#Read shape file containing New York borough boundaries
to_set_areas <- st_read("geo_export_e11a6d8c-b73a-4141-b78f-c9e352d4dc53.shp", stringsAsFactors=FALSE) %>%
  mutate(boro_name = str_to_title(boro_name))

ready_areas <- st_transform(to_set_areas, "+proj=longlat +ellps=WGS84 +datum=WGS84")


#Map Airbnb data to the spatial data
areas_price <- ready_areas %>%
  dplyr::select(boro_name, boro_code) %>%
  mutate(boro_code = as.character(boro_code)) %>%
  left_join(prices %>%
              count(`neighbourhood_group`),
            by = c("boro_name" = "neighbourhood_group")) %>%
  mutate(n = ifelse(is.na(n), 0, n))

areas_price
#Assign range values & color palette
bins <- c(0, 500, 1000, 2000, 5000, 10000, Inf)
pal <- colorBin("YlOrRd", domain = areas_price$n, bins = bins)


#Set the areas to match the listings according to the Airbnb data set
areas_price %>%
  mutate(popup = str_c("<strong>", boro_name, "</strong>",#variable name
                       "<br/>",
                       "Airbnb Listings 2019: ", n) %>%    #Title
           map(htmltools::HTML)) %>%
  leaflet() %>%
  addTiles() %>%
  addPolygons(label = ~popup,
              fillColor = ~pal(n),
              color = "#444444",
              weight = 1,
              smoothFactor = 0.5,
              opacity = 1.0,
              fillOpacity = 0.5,
              highlightOptions = highlightOptions(color = "white",
                                                  weight = 2,
                                                  bringToFront = TRUE),
              labelOptions = labelOptions(
                style = list("font-weight" = "normal", padding = "3px 8px"),
                textsize = "15px",
                direction = "auto")) %>%
  addLegend(pal = pal,
            values = ~n,
            opacity = 0.7,
            title = NULL,
            position = "bottomright") %>%
  frameWidget()

