library(jsonlite)
library(dplyr)
library(tidyverse)
library(tibble)
library(ggplot2)
json_data <- fromJSON(paste(readLines("data_downloaded/merged.json")))

influencer_names <- names(json_data$stored)  
dates <- names(json_data$stored[[influencer_names[1]]])   

InfXDate <- as_tibble(crossing(influencer_names,dates)) ## Cartesian product between InfluencersName and date

## for cartesian correlation (Influencer : day) we put the list of the nickname of that day
total <- InfXDate %>%
  as_tibble %>%
  rowwise() %>%
  mutate (followers = list(json_data$stored[[influencer_names]][[dates]]$data$user_followers[[1]]$username)) %>%
  select (influencer = influencer_names, day = dates,followers)

##TODO: remove the duplicate? HOW?
## foreach in array searching the previous array to remove it?

# # 
# ggplot(total, aes(x = day, y = length(followers), group=influencer, colour=influencer))+
# geom_line(size=1.2)+
# scale_color_manual(values=c("black", "#d8ce15","red","pink","blue"))+
# labs(x = "Days",
#      y = "Amount of followers",
#      colour = "Influencers")+
# theme_minimal()+
# theme(
#   axis.text.x = element_text(angle=70)
# )+
# ggtitle("Number of followers", "TODO: inserire il mese")

#   


# 
# marco<-total %>%
#   as_tibble %>%
#   rowwise() %>%
#   summarise(u= influencer) %>%
#   mutate (a = list(followers$username)) %>%
#   select(u,a)