# Alberto - 28 April 2024
library("rjson")

#TODO: uniformare i dati dei vari set in un unico JSON
LEFT_Comments <- fromJSON(paste(readLines("data_downloaded/set1/LEFT_comments.json")))



dummy_AllComments <- LEFT_Comments$stored ## All the data of the file
for(tmpSlot in dummy_AllComments){ # We downloaded data in bunch of 100 comments (so for every slot)
  for(comment in tmpSlot$data$comments){ # Single comment
    if(comment$text!=""){ #just filtering the property TO OPTIMIZE - do not remember how
      print(comment$text)
    }
  }
}



