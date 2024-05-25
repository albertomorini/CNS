# Video engagement

library(jsonlite)
library(dplyr)
library(tidyverse)
library(tibble)
library(ggplot2)



all_comments <- fromJSON(paste(readLines("data_downloaded/comments_test.json")))


tmp <- all_comments$stored$data$comments
print(paste(tmp[[13]]$video_id))