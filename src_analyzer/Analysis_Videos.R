# Video engagement

library(jsonlite)
library(dplyr)
library(tidyverse)
library(tibble)
library(ggplot2)
library(RColorBrewer)
library(fmsb)

json_data <- fromJSON(paste(readLines("data_downloaded/+total_video.json")))

totalEngagements <- json_data %>%
  as_tibble() %>%
  filter(!is.null(username)) %>%
  group_by(username) %>%
  summarise(totalView = sum(view_count), totalShare = sum(share_count), totalLikes = sum(like_count), totalComments = sum(comment_count))
  #select (username= username,  totalView) 
 

tmp <- as_data_frame(matrix(totalEngagements$totalView,totalEngagements$totalShare,totalEngagements$totalLikes), ncol=5)

# Make a stacked barplot--> it will be in %!
radarchart(totalEngagements,axistype=1 , 
           #custom polygon
           pcol=colors_border , pfcol=colors_in , plwd=4 , plty=1,
           #custom the grid
           cglcol="grey", cglty=1, axislabcol="grey", caxislabels=seq(0,20,5), cglwd=0.8,
           #custom labels
           vlcex=0.8 
)

  