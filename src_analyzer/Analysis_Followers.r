library(jsonlite)
library(dplyr)
library(tidyverse)
library(tibble)
library(ggplot2)
library(anytime)
# json_data <- fromJSON(paste(readLines("src_downloader/test.json")))

# json_data <- fromJSON(paste(readLines("data_downloaded/follower_cleaned.json")))

json_data <- fromJSON(paste(readLines("data_downloaded/+total_followers.json")))


influencer_names <- unique(json_data$influencer)
video_id <- unique(json_data$videoID)
video_dates <- unique(json_data$videoDate)


x<-json_data %>%
  as_tibble() %>%
  rowwise() %>%
  mutate(
    nr = length(followerList)
  ) %>%
  filter( nr < 50) %>%
  arrange(videoDate) %>%
  select(influencer,videoDate,nr) 


ggplot(x, aes(x = videoDate, y = nr, group=influencer, colour=influencer))+
geom_line(size=1.2)+
scale_color_manual(values=c("black", "#d8ce15","red","pink","blue"))+
labs(x = "Days",
     y = "Amount of followers",
     colour = "Influencers")+
theme_minimal()+
  theme(
      axis.text.x = element_text(angle=90)
    )+
ggtitle("Number of followers", "TODO: inserire il mese")
