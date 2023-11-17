################################################################################
# Johanna Winder
# William Boulton
# Antonia Otte
# University of East Anglia
# 17/11/2023
################################################################################

library(caroline)
library(dplyr)

# data source:

#GBIF.org (09 November 2023) GBIF Occurrence Download https://doi.org/10.15468/dl.r77p9f

#################################################################################

# import the data

setwd() # change working directory
data <- read.delim('occurrence.txt')

# subset the data for relevant columns

data_sub <- data.frame(cbind(data$gbifID, data$organismQuantity, data$occurrenceStatus, data$class, data$decimalLatitude, data$decimalLongitude, data$scientificName, data$species, data$eventDate, data$year, data$month, data$day))
colnames(data_sub) <- c('gbifID', 'organismQuantity', 'occurrenceStatus', 'class','decimalLatitude', 'decimalLongitude', 'scientificName', 'species', 'eventDate', 'year'
                        , 'month', 'day')

levels(as.factor(data_sub$class))

# subset for polar species, latitude above 55
data_polar <- subset(data_sub[(as.numeric(data_sub$decimalLatitude) < -55),])
data_polar <- data_polar %>% mutate(monthyear = paste(year, month, sep = '_'))
data_polar$location <- paste(data_polar$decimalLongitude, data_polar$decimalLatitude, sep = '_')

# rounding the location, so that data from within the same one latitude and longitude are grouped
lon <- round(as.numeric(data_polar$decimalLongitude))
lat <- round(as.numeric(data_polar$decimalLatitude))

#add location as column
data_polar_loc <- data_polar %>% mutate(location = paste(round(as.numeric(decimalLatitude)), round(as.numeric(decimalLongitude)), sep = ','))

# save the file or move on to 'EG-ABI-JWA'
write.delim(data_polar_loc, file = 'data_set_for_plot.txt')
