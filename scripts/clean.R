# author: Almas
# date: 2020-03-08

"This script cleans up the raw data by renaming columns, and removing unwanted columns 

Usage: clean.R --data_input=<location_of_file> --filename=<output>
"-> doc

#Libraries
suppressPackageStartupMessages(library(tidyverse))
suppressPackageStartupMessages(library(glue))
suppressPackageStartupMessages(library(docopt))
library(here)

#Functions: 
opt <- docopt(doc)

main <- function(data_input,filename){
  #Read file
  dat <- read.csv(data_input)
  #Drop column with numbers
  dat <- dat %>% select(-X)
  dat <- rename_columns(dat)
  dat <- keep_useful(dat)
  write_csv(dat,here("data",glue(filename,".csv")))
  print(glue("Success! Data has been cleaned and saved in the ",here("data"), " folder under ",filename,".csv"))
}
#This function renames the ambiguously named G1,G2,G3 columns and other columns
# @param dat is a input csv file

rename_columns <- function(dat){
  dat %>%
    dplyr::rename(t1_grade=G1,t2_grade=G2,final_grade=G3,mom_job=Mjob,
           dad_job=Fjob,weekend_alc=Walc,workday_alc=Dalc,mom_edu=Medu,dad_edu=Fedu,parent_status=Pstatus,
           family_relations=famrel,fam_support=famsup) 
}

# This function removes the not useful address and school columns 
# @param dat is a input csv file
keep_useful <- function(dat){
  dat %>%
    select(-address,-school)
}

##tests
main(opt$data_input,opt$filename)
