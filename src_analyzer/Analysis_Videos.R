# Video engagement

library(jsonlite)
library(dplyr)
library(tidyverse)
library(tibble)
library(ggplot2)



json_data <- fromJSON(paste(readLines("data_downloaded/video_total.json")))

totalView <- json_data %>%
  as_data_frame() %>%
  filter(!is.null(username)) %>%
  group_by(username) %>%
  # mutate(totalView = sum(view_count)) %>%
  summarise(totalView = sum(view_count))
  select (username, totalView) 
 


totalShare <- json_data %>%
  as_data_frame() %>%
  filter(!is.null(username)) %>%
  group_by(username) %>%
  summarise(totalShare = sum(share_count))
  select(username,totalShare) %>%
  sort_by(totalShare)
  