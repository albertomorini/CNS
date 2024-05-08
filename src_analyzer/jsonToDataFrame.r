library(jsonlite)



RIGHT_Video1 <- fromJSON("src_analyzer/mockUp.json")

sample_data <- RIGHT_Video1
output_dataframe <- as.data.frame(sample_data)

print(output_dataframe)