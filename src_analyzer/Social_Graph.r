library(jsonlite)
library(dplyr)
library(tidyverse)
library(tibble)
library(ggplot2)

json_data <- fromJSON(paste(readLines("data_downloaded/2024_5_17x40.json")))

get_followers <- function (data_total, influencer_name) {
    data_total %>%
    filter(influencer == influencer_name) %>%
    pull(followers) %>%
    unlist() %>%
    unique()
}


salton_index <- function (x_followers, y_followers) {
  # works with numerical and lexical vectors
  
  intersection_size <- length(intersect(x_followers, y_followers))
  
  # Calculate the degree of nodes x and y
  k_x <- length(x_followers)
  k_y <- length(y_followers)
  
  salton_index <- intersection_size / sqrt(k_x * k_y)
  
  return(salton_index)
}


salton_index_matrix <- function(data_total, influencer_names) {
  n <- length(influencer_names)
  salton_matrix <- matrix(0, nrow = n, ncol = n)
  rownames(salton_matrix) <- influencer_names
  colnames(salton_matrix) <- influencer_names
  
  for (i in 1:n) {
    x_name <- influencer_names[i]
    x_followers <- get_followers(data_total, x_name)
    for (j in 1:n) {
      y_name <- influencer_names[j]
      y_followers <- get_followers(data_total, y_name)
      salton_matrix[i, j] <- salton_index(x_followers, y_followers)
    }
  }
  return(salton_matrix)
}

#create_san <- function() {

  influencer_names <- names(json_data$stored)  
  dates <- names(json_data$stored[[influencer_names[1]]])   
  InfXDate <- as_tibble(crossing(influencer_names,dates)) ## Cartesian product between InfluencersName and date
  
  ## for cartesian correlation (Influencer : day) we put the list of the nickname of that day
  total <- InfXDate %>%
    as_tibble %>%
    rowwise() %>%
    mutate (followers = list(json_data$stored[[influencer_names]][[dates]]$data$user_followers[[1]]$username)) %>%
    select (influencer = influencer_names, day = dates,followers)

  ## gets data.frame = [influencer | follower]
  total_transformed <- total %>% 
    unnest(cols = followers) %>%
    select(influencer, followers) %>%
    rename(influencer=influencer, follower = followers)
  
  nodes <- unique(data.frame(total_transformed$influencer, total_transformed$follower))  
  
  
  library(igraph) # load here and then detach otherwise error with $ and vectors
  
  # create graph, add lables and create device to display it
  my_san <- graph_from_data_frame(nodes, directed = FALSE)
  V(my_san)$label <- V(my_san)$name
  #svg(filename="san_graph.svg", width=100, height=100)
  png(filename="san_graph.png", width=1000, height=1000)
  
  
  plot(
    my_san,
    main = "graph label",
    #vertex.label = ifelse(degree(my_san) > 1, V(my_san)$label, NA),  #remove follower lables
    vertex.size = 1,
    edge.width = 1.5,
    vertex.color = c("cyan", "tomato")[1 + names(V(my_san)) %in% influencer_names],
    ) 
  detach(package:igraph)
  dev.off() # shut-off display device
  
#}


## debug 

# try it out salton index
x_followers <- get_followers(total, "huffpost")
y_followers <- get_followers(total, "huffpost")

salton <- salton_index(x_followers, y_followers)

# Create the Salton index matrix
salton_matrix <- salton_index_matrix(total, influencer_names)

# Print the Salton index matrix
print(salton_matrix)

#create_san()