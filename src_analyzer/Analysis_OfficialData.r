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
      followers = as.vector(json_data$stored[[nome]][[d]]$data$user_followers,mode='list') ##TODO: keep just the username
    )
    total<- rbind(total,dummy)
    #print(length(as.vector(json_data$stored[[nome]][[d]]$data$user_followers[[1]]$username,mode='list'))) ##works
  }
}


ff = function(influencer,day,followers){
    tmp <- total %>%
    as_tibble %>%
    rowwise() %>%
    mutate (tt = length(followers$username)) %>%
    sort_by(day) %>%
    select(influencer,day,tt)
    # TODO: remove duplicated followers 
    # select(influencer, day,length(tt))
  

    # 
    ggplot(tmp, aes(x = day, y = tt, group=influencer, colour=influencer))+
      geom_line(size=1.2)+
      scale_color_manual(values=c("black", "#d8ce15"))+
      labs(x = "Days",
           y = "Amount of followers",
           colour = "Influencers")+
      theme_minimal()+
      theme(
        axis.text.x = element_text(angle=70)
      )+
      ggtitle("Number of followers", "TODO: inserire il mese")
   
}

ff(total$influencer, total$day, total$followers)

  # select(influencer,day, )





marco<-total %>%
  as_tibble %>%
  rowwise() %>%
  summarise(u= influencer) %>%
  mutate (a = list(followers$username)) %>%
  select(u,a)