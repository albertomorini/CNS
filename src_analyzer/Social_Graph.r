library(jsonlite)
library(dplyr)
library(tidyverse)
library(tibble)
library(ggplot2)



#OSS: there are duplicated user for the same influencer (for different days)
# therefore -> some follower nodes have degree > 1
json_data <- fromJSON(paste(readLines("data_downloaded/2024_2_1x30.json")))
#json_data <- fromJSON(paste(readLines("msc/influencersFollowersMorckUp.json")))



influencer_names <- names(json_data$stored)
dates <- names(json_data$stored[[influencer_names[1]]])

total <- tibble()
for (name in influencer_names){
  for (d in dates){
    dummy <- tibble(
      influencer = name,
      day = d,
      followers = sapply(json_data$stored[[influencer]][[day]]$data$user_followers, function(x) x$username) # vector of usernames as strings ("user1", ..., "user n")
    )
    total <- rbind(total, dummy)
  }
}

# create SAN
nodes <- data.frame(total$influencer["huffpost"], total$followers)
# View(nodes)

library(igraph) # load here and then detach otherwise error with $ and vectors
my_san <- graph_from_data_frame(nodes, directed = FALSE)
# View(my_san)

# add lables
V(my_san)$label <- V(my_san)$name

# TODO format graphical aspects of plotted san
plot(
  my_san,
  main = "graph label",
  vertex.label = ifelse(degree(my_san) == 4, V(my_san)$label, NA),
  vertex.size = 1,
  edge.width = 1.5,
  vertex.color = c("cyan", "tomato")[1 + names(V(my_san)) %in% influencer_names],
  ) 
detach(package:igraph)
