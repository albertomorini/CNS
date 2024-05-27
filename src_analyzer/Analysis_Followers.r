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


followersHistory<-json_data %>%
  as_tibble() %>%
  rowwise() %>%
  mutate(
    nr = length(followerList)
  ) %>%
  mutate(
    unixDate = as.numeric(as.POSIXct(videoDate)) 
  ) %>%
  filter( nr < 50) %>%
  arrange(videoDate) %>%
  select(influencer,unixDate,nr) 

# 
ggplot(followersHistory, aes(x = unixDate, y = influencer, fill = nr,  height = stat(density))) +
  geom_density_ridges_gradient(scale = 1.2, rel_min_height = 0.01) +
  scale_fill_viridis(name = "Temp. [F]", option = "C") +
  labs(title = 'Impact of a new post', subtitle='Increasing the followers') +
  theme_ipsum() +
  geom_density_ridges(
    aes(point_color = influencer, point_fill = influencer, point_shape = influencer),
    alpha = .2, point_alpha = 1, jittered_points = TRUE
  ) +
  geom_vline(xintercept=c(1707954241,1707773245,1709143040))
  scale_point_color_hue(l = 40) +
  scale_discrete_manual(aesthetics = "point_shape", values = c(21, 22, 23,32,1,24,53,33))
  theme(
    legend.position="none",
    panel.spacing = unit(0.1, "lines"),
    strip.text.x = element_text(size = 8)
  )

####################

video <- fromJSON(paste(readLines("data_downloaded/+total_video.json")))

