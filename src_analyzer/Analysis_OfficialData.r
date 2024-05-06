# Alberto - 28 April 2024
library("rjson")
library("dplyr")



## COMMENT
# RIGHT_Comments1 <- fromJSON(paste(readLines("data_downloaded/set1/RIGHT_comments.json")))
# RIGHT_Comments2 <- fromJSON(paste(readLines("data_downloaded/set2/RIGHT_comments.json")))
# RIGHT_Comments3 <- fromJSON(paste(readLines("data_downloaded/set3/RIGHT_comments.json")))
# RIGHT_Comments4 <- fromJSON(paste(readLines("data_downloaded/set4/RIGHT_comments.json")))

# total <- c(RIGHT_Comments1$stored, RIGHT_Comments2$stored, RIGHT_Comments3$stored, RIGHT_Comments4$stored)

# RIGHT_CommentsCleaned <- list()
# for(tmpSlot in total){
#   for(comment in tmpSlot$data$comments){ # Single comment
#     if(comment$text!=""){ #just filtering the property TO OPTIMIZE - do not remember how
#       RIGHT_CommentsCleaned<-c(RIGHT_CommentsCleaned,comment)
#     }
#   }
# }


# -----
#Test for video

RIGHT_Video1 <- fromJSON(paste(readLines("data_downloaded/set1/RIGHT_video.json")))
RIGHT_Video2 <- fromJSON(paste(readLines("data_downloaded/set2/RIGHT_video.json")))
RIGHT_Video3 <- fromJSON(paste(readLines("data_downloaded/set3/RIGHT_video.json")))
RIGHT_Video4 <- fromJSON(paste(readLines("data_downloaded/set4/RIGHT_video.json")))

RIGHT_TotalVideo <- c(RIGHT_Video1$stored, RIGHT_Video2$stored, RIGHT_Video3$stored, RIGHT_Video4$stored);

RIGHT_VideoCleaned <- list()

vc <- list()
sc <- list()
for(tmpSlot in RIGHT_TotalVideo){
  for(video in tmpSlot$data$videos){ # Single comment
    vc <- c(vc,video$view_count)
    sc <- c(sc,video$share_count)
     #RIGHT_VideoCleaned <- c(RIGHT_VideoCleaned,video)
  }
}

dt <- data_frame(viewCount=vc,shareCount=sc)

  group_by(viewCount) %>%
  summarise(n=n())
