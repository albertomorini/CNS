library(jsonlite)
library(dplyr)
library(tidyverse)
library(tibble)
library(ggplot2)


#json_data <- fromJSON(paste(readLines("data_downloaded/2024_2_1x30.json")))
json_data <- fromJSON(paste(readLines("msc/influencersFollowersMorckUp.json")))



influencer_names <- names(json_data$stored)  
dates <- names(json_data$stored[[influencer_names[1]]])  

InfXDate <- crossing(influencer_names,dates) ## Cartesian product between InfluencersName and date

total <- tibble()
# TODO: optimize using the cartesian product
for(name in influencer_names){
  for(d in dates){
    dummy <- tibble(
      influencer = name,
      day = d,
      followers = sapply(json_data$stored[[influencer]][[day]]$data$user_followers, function(x) x$username) # vector of usernames as strings ("user1", ..., "user n")
    )
    total<- rbind(total,dummy)

    #print(length(as.vector(json_data$stored[[nome]][[d]]$data$user_followers[[1]]$username,mode='list'))) ##works
  }
}

#View(total)
# total now is a table influencer X day X follower 


# create SAN
nodes <- data.frame(total$influencer, total$followers)
View(nodes)

library(igraph)
my_san <- graph_from_data_frame(nodes, directed = TRUE)
View(my_san)


# add lables
V(my_san)$label <- V(my_san)$name

plot(my_san)
detach(package:igraph)
