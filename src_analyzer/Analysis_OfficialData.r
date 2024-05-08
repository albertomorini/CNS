library(jsonlite)
library(tibble)

json_source <- fromJSON(paste(readLines("data_downloaded/2024_2_1x30.json")))

influencers_names<-strsplit(names(json_source$stored),"[[:space:]]")  ## lista con soli i nomi degli influencer
days_list<- strsplit(names(json_source$stored[[1]]),"[[:space:]]") ## lista con tutte le date (del primo utente, ma sono uguali per ognuno)

df <- data.frame(a=influencers_names,b=days_list) # DO NOT WORK


# for(name in influencers_names){
#   for (d in days_list){
#     df <- data.frame(
#       nome = c(name),
#       data = json_source$stored[[name]][[d]]$data$user_followers
#     )
#     
#   }
# }

