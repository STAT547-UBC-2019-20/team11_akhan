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
lm_scatter_plot(dataset)
saveRDS(lm_mod_alc, here("data","lm_model_alc.RDS"))
print(glue("Successful! Linear model saved in " ,here("data"), " folder under lm_model_alc.RDS"))
}


## QQplot and Residuals vs Fitted Plot
## This produces a qqplot of the residuals and a residuals vs fitted values plot
## @param lm_model is a linear regression model 
lm_plots <- function(lm_model){
 png(filename = here("images","residual_fitted_plot.png"))
  plots <- plot(lm_model,1,main="Residual vs Fitted Plot for the Alcohol Linear Model",sub="")
  png(filename = here("images","residual_plot_qq.png"))
  plots <- plot(lm_model,xlab = "theoretical quantiles",2, main="QQPlot of the residuals for the Alcohol Linear Model",sub = "")
}

## Linear Regression graph:

lm_scatter_plot <- function(data){
  label <- c("Weekend_Alcohol_and Workday_Alcohol")
 plots_scat <- function(label){
   data %>%
     ggplot(aes(x=workday_alc,y=final_grade,col=weekend_alc))+
     geom_point()+
     geom_jitter()+
    geom_smooth(method=lm,se=FALSE)+
     labs(title=glue("Linear Regressio of Final Grades vs ",label),x="Workday_alcohol")+
     theme_bw()}
plts_2 <-  plots_scat(label)
     filenames <- glue("Linear_Reg_Plot_Final_Grade_vs_",label,".png")
    ggsave(filename=filenames, plot=plts_2, path=here("images"),width = 20, height = 20, units = "cm")
 } 



##tests
main(opt$filename)
