library(jsonlite)
library(dplyr)
library(tidyverse)
library(tibble)
json_data <- fromJSON(paste(readLines("data_downloaded/2024_2_1x30.json")))

influencer_names <- names(json_data$stored)  
dates <- names(json_data$stored[[influencer_names[1]]])  

InfXDate <- crossing(influencer_names,dates) ## Cartesian product between InfluencersName and date

total <- tibble()
# TODO: optimize using the cartesian product
for(nome in influencer_names){
  for(d in dates){
    dummy <- tibble(
      influencer = nome,
      day = d,
      followers = as.vector(json_data$stored[[nome]][[d]]$data$user_followers,mode='list')
    )
    total<- rbind(total,dummy)
    print(length(as.vector(json_data$stored[[nome]][[d]]$data$user_followers[[1]]$username,mode='list'))) ##works
  }
}


# FIX: plotting simple stats 
# total %>%
#   group_by(da,n) %>%
#   summarise ( totali = len(val)) %>%
  