

#######

library(ggspatial)
library(ggplot2)
library(dplyr)
library(mapdata)
library(mapproj)
library(tidyr)
library(mapplots)
library(caroline)
library(sf)
library(grid)
library(colorspace)
library(tidyverse)
library(magick)
library(magrittr)

#######

data_polar_loc <- read.delim('data_set_for_plot.txt')

####
# optional: filter for taxonomic class of interes
data_polar_loc <- data_polar_loc %>% filter(class !='Bacillariophyceae')



# creating a map of Antarctica

poly <- read_sf("/Users/skq22udu/Documents/Australia_Phytoplankton_biodiversity_data/si_extent_shapefiles/extent_S_200001_polygon_v3.0")

w2 <- maps::map("world",region="Antarctica", fill=TRUE, plot=FALSE) %>%
  st_as_sf(coords=c("long", "lat"), crs=4326, group=TRUE, fill=TRUE) %>% 
  st_transform(st_crs(poly))

# create a world map
world <- map_data("world")

# monthyear # location # numspecies # 
make_plot <- function(month_year) {
  antmap <- ggplot(
    world, 
    aes(x=long, y=lat, group=group, bg = 'white')
  ) + geom_polygon(fill = 'grey')
  
  M <- antmap + theme(
    panel.background = element_rect(fill = 'white'), 
    panel.border = element_rect(colour = 'black', fill = NA)
  ) + coord_map(
    "ortho", 
    orientation=c(-90, 0, 0), 
    ylim = c(-70,-55),
    xlim = c(50,155)
  )
  
  # Need to get the scale to be uniform between replicate plots
  
  data_polar_loc2 <- data_polar_loc %>% filter(monthyear == month_year,occurrenceStatus == 'PRESENT') %>% 
    select(c('occurrenceStatus', 'species', 'monthyear', 'location'))%>% 
    group_by(location) %>%
    unique() %>%
    summarize(n = n()) %>% 
    mutate(lat = as.numeric(str_remove(location,',[0-9]+')), lon = as.numeric(str_remove(location,'-[0-9]+,'))) %>%
    ungroup()
  
  grob <- grobTree(textGrob(gsub("_", "-", as.character(month_year)), x=0.05,  y=0.85, hjust=0,
                            gp=gpar(fontsize=13)))
  plot_out <- M +
    ggspatial::geom_spatial_tile(data = data_polar_loc2, crs = 4326, aes(x = lon, y = lat, fill = n), color = NA, inherit.aes = F)+
    theme()+
    labs(y = "Latitude", x = "Longitude",
         title = element_text("Australian Continous Plankton recorder: \nSpecies richness in the Southern Ocean from 2016 - 2021"))+
    coord_sf(crs = 4326, 
             ylim = c(-70,-55),
             xlim = c(50,155))+
    scale_fill_continuous_diverging(palette = "Purple-Green", mid = 10, limits=c(0, 20), name = "Species richness") +
    annotation_custom(grob)
  return(plot_out)
}


year_month_to_yearmonth <- function(month_year) {
  tmp <- month_year %>% str_split("_")
  y <- tmp[[1]][1]
  m <- tmp[[1]][2]
  if (str_length(m) == 1) {
    m <- paste("0", m, sep = "")
  }
  return(paste(y,m, sep = ""))
}

# plotting sea ice extent on top of Antarctica and biodiversity data

make_plot_fr <- function(month_year) {
  
  shapefilepath <- paste("/Users/skq22udu/Documents/Australia_Phytoplankton_biodiversity_data/si_extent_shapefiles/extent_S_", year_month_to_yearmonth(month_year), "_polygon_v3.0", sep = '')
  poly_a <- read_sf(shapefilepath)
  
  len <- dim(poly_a)[[1]][1]
  poly_a <- poly_a[0:(len-1),]
  
  ans <- make_plot(month_year) + geom_sf(data=w2, fill = "grey", inherit.aes = F) + 
    geom_sf(data=poly_a[], fill = "white", inherit.aes = F) +
    theme(
      panel.background = element_rect(fill = 'white'), 
      panel.border = element_rect(colour = 'black', fill = NA)) + 
    coord_sf(crs = 4326,
             ylim = c(-70,-55),
             xlim = c(50,155)
    )
  
  return(ans)
}

make_plot_fr("2021_3")

dates <- c("2016_1",  "2017_11", "2017_12", "2018_1",  "2018_10", "2018_11",
           "2018_12", "2019_1",  "2019_11", "2021_2",  "2021_3" )


for(i in 1:length(dates)){
  select <- dates[i]
  p <- plot(make_plot_fr(select))
  ggsave(paste(select, 'image2.png'))
}


list.files(path='/Users/skq22udu/Documents/Australia_Phytoplankton_biodiversity_data', pattern = '*2.png', full.names = TRUE) %>% 
  image_read() %>% # reads each path file
  image_join() %>% # joins image
  image_animate(fps=1) %>% # animates, can opt for number of loops
  image_write("Second_gif.gif") # write to current dir
