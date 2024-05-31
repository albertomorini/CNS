library(jsonlite)
library(dplyr)
library(tidyverse)
library(tibble)
library(ggplot2)
library(anytime)
library(hrbrthemes)
library(ggridges)
library(viridis)

json_data <- fromJSON(paste(readLines("data_downloaded/+total_followers.json")))

influencer_names <- unique(json_data$influencer)
video_id <- unique(json_data$videoID)
video_dates <- unique(json_data$videoDate)


library(lubridate)


followersHistory<-json_data %>%
  as_tibble() %>%
  rowwise() %>%
  mutate(
    nr = length(followerList),
    time = ymd_hms(videoDate,tz=Sys.timezone()),
     time2 = as.numeric(as.POSIXct(videoDate)) 
  ) %>%
  filter(
    influencer %in% c('aocinthehouse','repbowman','clarksonlawson','real.benshapiro','huffpost'),
    time2>0
  ) %>%
  arrange(videoDate) %>%
  select(influencer,time,time2,nr) 


video <- fromJSON(paste(readLines("data_downloaded/+total_video.json")))
video <- video %>%
  filter(username=='aocinthehouse')
# influencer %in% c('aocinthehouse','repbowman','clarksonlawson','real.benshapiro','huffpost')

ggplot(followersHistory, aes(x = time, y = influencer, fill = nr)) +
  geom_density_ridges_gradient(scale = 1.2, rel_min_height = 0.01) +
  labs(title = 'Impact of a new post', subtitle='Increasing the followers') +
  theme_ridges(grid = TRUE, center = TRUE) +
  geom_vline(xintercept=c(video$create_time))+
  scale_point_color_hue(l = 40) +
  scale_discrete_manual(aesthetics = "point_shape", values = c(21, 22, 23,32,1,24,53,33))
  theme(
    legend.position="none",
    panel.spacing = unit(0.1, "lines"),
    strip.text.x = element_text(size = 8)
  )
  
  
  # geom_density_ridges_gradient(jittered_points = FALSE, quantile_lines = 
  #                                FALSE, quantiles = 2, scale=0.9, color='white') +
  #   
  #                color = "red") +
  #   scale_y_discrete(expand = c(0.01, 0)) +
  #   theme_ridges(grid = FALSE, center = TRUE)

####################


  

  
