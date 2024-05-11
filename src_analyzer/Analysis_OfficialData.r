library(jsonlite)
library(dplyr)
library(tidyverse)
library(tibble)
library(ggplot2)
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

    #print(length(as.vector(json_data$stored[[nome]][[d]]$data$user_followers[[1]]$username,mode='list'))) ##works
  }
}

# total %>%
#   filter(length(followers)>50) %>%
#   select(influencer, day) 


# ggplot() + 
#   geom_point(data=total,aes(x = day, y = influencer, fill = length(followers)),
#              pch=21, size=9, colour=NA) +
#   geom_polygon(data = total, 
#                mapping=aes(x=day, 
#                            y=influencer, 
#                            colour = "red"),
#                alpha=0) 


  
# dc<-total %>%
#   group_by(influencer,day,length(followers[[1]]$username))

total %>%
  select(influencer, day, length(followers[[1]]$username))

  # select(influencer,day, )

# ggplot(total, aes(x = day, y = length(followers[[1]]$username), group=influencer, colour=influencer))+
#   geom_line(size=1.2)+
#   scale_color_manual(values=c("black", "#d8ce15"))+
#   labs(x = "Days",
#        y = "Amount of followers",
#        colour = "Influencers")+
#   theme_minimal()+
#   theme(
#     axis.text.x = element_text(angle=70)
#   )+
#   ggtitle("Anni & Etnie", "Le vittime divise per etnia negli anni")