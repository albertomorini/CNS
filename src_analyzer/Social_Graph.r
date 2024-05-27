library(jsonlite)
library(dplyr)
library(tidyverse)
library(tibble)
library(ggplot2)
library(igraph)


json_data <- fromJSON(paste(readLines("msc/rightWingMoc.json")))
#json_data <- fromJSON(paste(readLines("msc/influencersFollowersMorckUp.json")))

left_data <- fromJSON(paste(readLines("msc/leftWingMoc.json")))
right_data <- fromJSON(paste(readLines("msc/rightWingMoc.json")))

influencer_names <- unique(json_data$influencer) 

left_influencer_names <- unique(left_data$influencer) 
right_influencer_names <- unique(right_data$influencer) 
    
# Create a data frame with influencer names and their follower lists
total <- data.frame(
  influencer = json_data$influencer,
  followerList = I(json_data$followerList)  # Use I() to prevent conversion of lists to strings
)

left_total <- data.frame(
  influencer = left_data$influencer,
  followerList = I(left_data$followerList)  # Use I() to prevent conversion of lists to strings
)

right_total <- data.frame(
  influencer = right_data$influencer,
  followerList = I(right_data$followerList)  # Use I() to prevent conversion of lists to strings
)

full_total <- rbind(left_total, right_total)
full_influencer_names <- union(left_influencer_names, right_influencer_names)

get_followers <- function (data_total, influencer_name) {
    data_total %>%
    filter(influencer == influencer_name) %>%
    pull(followerList) %>%
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


create_san <- function() {  
  ## gets data.frame = [influencer | follower]
  total_transformed <- total %>% 
    unnest(cols = followerList) %>%
    select(influencer, followerList) %>%
    rename(influencer = influencer, follower = followerList) %>%
    filter(follower != "")

  nodes <- unique(data.frame(total_transformed$influencer, total_transformed$follower))  


  
  ## create graph, add lables and create device to display it
  my_san <- graph_from_data_frame(nodes, directed = FALSE)
  

  ## Label all
  #V(my_san)$label <- V(my_san)$name
  ## Label inlfuencers only
  V(my_san)$label <- ifelse(names(V(my_san)) %in% influencer_names, names(V(my_san)), NA)

  ## Set vertex colors and sizes based on whether they are influencers
  V(my_san)$color <- ifelse(names(V(my_san)) %in% influencer_names, "red", "blue")
  V(my_san)$size <- ifelse(names(V(my_san)) %in% influencer_names, 2, 0.5)
  

  ## Adjust edge width
  E(my_san)$width <- 0.000001
  # Set edge color with opacity
  edge_color <- adjustcolor("black", alpha.f = 0.05)  # Set edge opacity and color
  E(my_san)$color <- edge_color

  ## Set Fruchterman-Reingold layout for better separation of clusters
  #layout <- layout_with_fr(my_san)

  ## Use Kamada-Kawai layout for a tighter grouping of clusters
  layout <- layout_with_kk(my_san)

  ## Mnimize node overlap
  layout <- layout.norm(layout, xmin=-5, xmax=5, ymin=-5, ymax=5)


  ## Create display device for graph (use png for testing)
  #svg(filename="san_graph.svg", width=100, height=100)
  png(filename="san_graph.png", width=1000, height=1000)
  
  
  plot(
    my_san,
    main = "graph label",
    vertex.label = V(my_san)$label,
    vertex.size = V(my_san)$size,
    vertex.color = V(my_san)$color,
    vertex.label.cex = 1.5,  # Adjust label size
    vertex.label.color = "#9200CC",  
    #vertex.label = ifelse(degree(my_san) > 1, V(my_san)$label, NA),  ## label based on node degree
    vertex.size = 1,
    edge.width = 1.5,
    edge.width = E(my_san)$width,  # Edge width
    edge_color = E(my_san)$color,
    #vertex.color = c("cyan", "tomato")[1 + names(V(my_san)) %in% influencer_names],
    layout = layout,
    rescale = TRUE,
    asp = 0  # Aspect ratio to fit the plot area
    ) 
  dev.off() # shut-off display device
  
}


create_double_san <- function() {


  ## gets data.frame = [influencer | follower]
  total_transformed <- full_total %>% 
    unnest(cols = followerList) %>%
    select(influencer, followerList) %>%
    rename(influencer = influencer, follower = followerList) %>%
    filter(follower != "")

  nodes <- unique(data.frame(total_transformed$influencer, total_transformed$follower))  

    ## create graph, add lables and create device to display it
  my_san <- graph_from_data_frame(nodes, directed = FALSE)


## Set vertex colors based on influencer sets
V(my_san)$color <- ifelse(names(V(my_san)) %in% left_influencer_names, "blue",
                          ifelse(names(V(my_san)) %in% right_influencer_names, "red", "black"))

## Set vertex sizes based on influencer sets
V(my_san)$size <- ifelse(names(V(my_san)) %in% left_influencer_names, 2,
                         ifelse(names(V(my_san)) %in% right_influencer_names, 2, 0.5))

## Set vertex labels for influencers only
V(my_san)$label <- ifelse(names(V(my_san)) %in% c(left_influencer_names, right_influencer_names), names(V(my_san)), NA)



## Adjust edge width
E(my_san)$width <- 0.000001
# Set edge color with opacity
## Set edge color based on linked influencers
edge_colors <- ifelse(ends(my_san, E(my_san))[,1] %in% left_influencer_names, "blue", "red")

edge_color <- adjustcolor(edge_colors, alpha.f = 0.05)  # Set edge opacity and color
E(my_san)$color <- edge_color

## Set Fruchterman-Reingold layout for better separation of clusters
#layout <- layout_with_fr(my_san)

## Use Kamada-Kawai layout for a tighter grouping of clusters
layout <- layout_with_kk(my_san)

## Mnimize node overlap
layout <- layout.norm(layout, xmin=-5, xmax=5, ymin=-5, ymax=5)

## Create display device for graph
png(filename="combined_san_graph.png", width=1000, height=1000)

plot(
  my_san,
  main = "Graph Label",
  vertex.label = V(my_san)$label,
  vertex.size = V(my_san)$size,
  vertex.color = V(my_san)$color,
  vertex.label.cex = 1.5,
  vertex.label.color = "#048100",
  edge.width = 1.5,
  edge.width = E(my_san)$width,
  edge_color = E(my_san)$color,
  layout = layout,
  rescale = TRUE,
  asp = 0
)
dev.off()

}

## debug 


#x_followers <- get_followers(total, "huffpost")
#y_followers <- get_followers(total, "huffpost")

#salton <- salton_index(x_followers, y_followers)

# Create the Salton index matrix
salton_matrix <- salton_index_matrix(full_total, full_influencer_names)

#create_san()
#create_double_san()