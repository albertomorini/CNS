library(jsonlite)
library(dplyr)
library(tidyverse)
library(tibble)
library(ggplot2)
library(anytime)
library(hrbrthemes)
library(ggridges)
library(viridis)
library(geomtextpath)
library(lubridate)


json_data <- fromJSON(paste(readLines("data_downloaded/+total_followers.json")))

influencer_names <- unique(json_data$influencer)
video_id <- unique(json_data$videoID)
video_dates <- unique(json_data$videoDate)

# creating the dataset
followersHistory<-json_data %>%
  as_tibble() %>%
  rowwise() %>%
  mutate(
    nr = length(followerList),
    time = ymd_hms(videoDate,tz=Sys.timezone())
  ) %>%
  filter(
    influencer %in% c('aocinthehouse','repbowman','clarksonlawson','real.benshapiro','huffpost'),
  ) %>%
  arrange(videoDate) %>%
  select(influencer,time,nr) 


############################################################




# ## GENERALE ANDAMENTO DI TUTTI GLI INFLUENCERS
# followersHistory %>%
#   filter(
#     nr>0 ##remove the zero just to create a line in the right time span
#   ) %>%
# ggplot(aes(x = time, y = nr, color = influencer)) +
#   labs(
#     title="Content impact"
#   )+
#   xlab("Time")+
#   ylab("New followers")+
#   geom_point() +
#   geom_labelsmooth(aes(label = influencer), fill = "white",
#                    method = "lm", formula = y ~ x, se=FALSE,
#                    size = 3, linewidth = 0.8, boxlinewidth = 0.2) +
#   theme_bw() + guides(color = 'none') # remove the legend
# 
# 



### In depth su qualche influencer ricavato da prima -> repbowman è curioso, anche real.benshapiro

influencerDepth <- c('real.benshapiro', 'aocinthehouse')

video <- fromJSON(paste(readLines("data_downloaded/+total_video.json")))
videoRight <- video %>%
  filter(username =='real.benshapiro')
videoLeft <- video %>%
  filter(username =='aocinthehouse')
# influencer %in% c('aocinthehouse','repbowman','clarksonlawson','real.benshapiro','huffpost')

# 

boh <-followersHistory %>%
  filter(
    influencer %in% influencerDepth
  ) %>%
  ggplot( aes(x = time, y = influencer, fill = nr)) +
  geom_density_ridges_gradient(scale = 1.2, rel_min_height = 0.01) +
  labs(title = 'Impact of a new post', subtitle='Increasing the followers',) +
  theme_ridges(grid = TRUE, center = TRUE) +
  geom_vline(xintercept=c(videoRight$create_time),linetype = "dashed", color="red")+
  geom_vline(xintercept=c(videoLeft$create_time),linetype = "dashed", color="blue")+
  theme_bw() +
  scale_point_color_hue(l = 40) +
  scale_discrete_manual(aesthetics = "point_shape", values = c(21, 22,23,32,1,224,253,33))



# annotate(geom="text", x="2019", y=1600, label="Breonna Taylor", color="#BD0026",size=4.5)+ 
#   annotate(geom="point", x="2020", y=1570, color="#BD0026")+
#   
