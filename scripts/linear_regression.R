# author: Almas
# date: 2020-03-15

"This script takes the cleaned data, filters it and runs linear regression on it
Usage: clean.R --filename=<name_of_file> 
"-> doc


## Libraries
suppressPackageStartupMessages(library(tidyverse))
suppressPackageStartupMessages(library(broom))
suppressPackageStartupMessages(library(glue))
suppressPackageStartupMessages(library(docopt))
suppressPackageStartupMessages(library(cowplot))
library(here)

#Functions: 
opt <- docopt(doc)
## Load Data and Filter out Low Health 
main <- function(filename){

dataset <- read_csv(here("data",filename))
dataset <- as.data.frame(dataset) 
dataset <- dataset %>%
  filter(!(health==1))
 write_csv(dataset,here("data","filtered_cleaned.csv"))
lm_mod_alc <- lm(dataset$final_grade~dataset$workday_alc*dataset$weekend_alc)
lm_plots(lm_mod_alc)
saveRDS(lm_mod_alc, here("data","lm_model_alc.RDS"))
print(glue("Successful! Linear model saved in " ,here("data"), " folder under lm_model_alc.RDS"))
}


## QQplot and Residuals vs Fitted Plot
## This produces a qqplot of the residuals and a residuals vs fitted values plot
## @param lm_model is a linear regression model 
lm_plots <- function(lm_model){
 png(filename = here("images","residual_fitted_plot.png"))
  plots <- plot(lm_model,1,main="Residual vs Fitted Plot for the Alcohol Linear Model")
  png(filename = here("images","residual_plot_qq.png"))
  plots <- plot(lm_model,2, main="QQPlot of the residuals for the Alcohol Linear Model")
}


##tests
main(opt$filename)
