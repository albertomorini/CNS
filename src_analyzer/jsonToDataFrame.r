library(jsonlite)



mockUpJson <- fromJSON("src_analyzer/mockUp.json")

sample_data <- mockUpJson
output_dataframe <- as.data.frame(sample_data)

print(output_dataframe)