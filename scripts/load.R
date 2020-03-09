# author: Almas
# date: 2020-03-08

"This script loads the Portugese High School Survey data for a Portugese language class from a public URL and saves it to a folder 

Usage: load.R --data_url=<url_to_raw_data_file> 
  "-> doc

#Libraries
suppressPackageStartupMessages(library(tidyverse))
suppressPackageStartupMessages(library(docopt))
library(here)

#Functions: 
opt <- docopt(doc)

main <- function(data_url) {
  #Read file
  data <- read.csv(data_url, sep = ";")
  #Save File
  write.csv(data,here("data","student_port_survey.csv"))
  #Print Message
  print("Success! Data has been loaded and saved in the data folder")
}
main(opt$data_url)
