library(jsonlite)
library(dplyr)
library(purrr)
library(tidyverse)

json_data <- fromJSON(paste(readLines("data_downloaded/2024_2_1x30.json")))

influencer_names <- names(json_data$stored)  
dates <- names(json_data$stored[[influencer_names[1]]])  

# extract user_followers data
extract_data <- function(name, date) {
  data <- json_data$stored[[name]][[date]]$data$user_followers
  if (!is.null(data)) {
    message(paste(name, "--", date))
    print(data)
  } else {
    message(paste("No data for", name, "on", date))
  }
}

# combinazioni of names and dates
name_date_combinations <- expand.grid(name = influencer_names, date = dates)

# funzione per ogni combinazione
# invisibly return .x  # used for its side effects
walk2(name_date_combinations$name, name_date_combinations$date, extract_data)

#print(name_date_combinations)