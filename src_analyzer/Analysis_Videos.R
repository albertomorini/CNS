# Video engagement

library(jsonlite)
library(dplyr)
library(tidyverse)
library(tibble)
library(ggplot2)
library(RColorBrewer)
library(fmsb)

json_data <- fromJSON(paste(readLines("data_downloaded/+total_video.json")))

totalEngagements <- json_data %>%
  as_tibble() %>%
  filter(!is.null(username)) %>%
  group_by(username) %>%
  summarise(totalView = sum(view_count), totalShare = sum(share_count), totalLikes = sum(like_count), totalHashtag=sum(length(unique(hashtag_names))), totalComments = sum(comment_count))
  


totalLeftWing <- totalEngagements %>%
  as_tibble() %>%
  filter(
    username %in% c("huffpost","aocinthehouse",'thedailybeast','repbowman')
  ) %>%
  summarise(
    totalView = sum(totalView),
    totalShare = sum(totalShare),
    totalLikes = sum(totalLikes),
    totalComments = sum(totalComments),
    totalHashtag = sum(totalHashtag)
  ) 

totalRightWing <- totalEngagements %>%
  as_tibble() %>%
  filter(
    ! username %in% c("huffpost","aocinthehouse",'thedailybeast','repbowman')
  ) %>%
  summarise(
    totalView = sum(totalView),
    totalShare = sum(totalShare),
    totalLikes = sum(totalLikes),
    totalComments = sum(totalComments),
    totalHashtag = sum(totalHashtag)
  ) 

totalDivided <- bind_rows(totalLeftWing, totalRightWing)

totalDivided <- totalDivided %>%
  mutate(
    views = (totalView / 100),
    shares = (totalShare/100),
    likes = (totalLikes/100),
    comments = (totalComments/100),
    NrHashtag = totalHashtag
  ) %>%
  select(views, shares, likes, comments, NrHashtag)

totalDivided <- rbind(rep(10000,5) , rep(0,5) , totalDivided)

colors_border=c( "blue", "red" )
colors_in=c( rgb(0.2,0.5,0.5,0.4), rgb(0.8,0.2,0.5,0.4) , rgb(0.7,0.5,0.1,0.4) )

radarchart(totalDivided,axistype=1 ,
           #custom polygon
           pcol=colors_border , pfcol=colors_in , plwd=2 , plty=1,
           #custom the grid
           cglcol="grey", cglty=1, axislabcol="grey", caxislabels=seq(0,100,5), cglwd=0.8,
           #custom labels
           vlcex=0.8
)

legend(-2.3,1,
       legend=c("Left wing","Right wing"),
       col=c("blue","red"),
       lty=c(1,2))

# TODO: remember to add the dimension normalized - le views sono in ordine di 100mila


tmp <- matrix(c(totalEngagements$totalView,totalEngagements$totalShare, totalEngagements$totalLikes,totalEngagements$totalComments, totalEngagements$totalHashtag), nrow=length(totalEngagements$username))
colnames(tmp) <- c("views","shares","likes","comments","hashtag")
rownames(tmp) <- totalEngagements$username


traspost4Barplot <- t(tmp)
rownames(traspost4Barplot) <- c("views","shares","likes","comments","hashtag")
colnames(traspost4Barplot) <- totalEngagements$username

# create color palette:
library(RColorBrewer)
coul <- brewer.pal(5, "Pastel1") 

# barplot(traspost4Barplot, 
#         col=coul , 
#         border="black", 
#         space=0.1, 
#         font.axis=1.5, 
#         xlab="influencer",
#         ylab="engagement"
# )

## TODO: da portare in percentuale???