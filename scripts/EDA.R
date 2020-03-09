# author: Almas
# date: 2020-03-08

"This script performs EDA and produces some plots 
Usage: EDA.R --folder_path=<folder>
"-> doc

#Libraries
suppressPackageStartupMessages(library(tidyverse))
suppressPackageStartupMessages(library(glue))
suppressPackageStartupMessages(library(docopt))
suppressPackageStartupMessages(library(corrplot))
suppressPackageStartupMessages(library(purrr))
library(here)

#Functions: 
opt <- docopt(doc)

main <- function(folder){
  #Read data
  data <- read_csv(here("data","cleaned_data.csv"))
  data <- as.data.frame(data) # This is important as script is not automatically converting this(prob w/ ggsave)
  student_cor(data,folder)
  boxplots_variables(data,folder)
  density_plot(data,folder)
  print(glue("Success! The plots have been created in the ",folder," folder"))
}

# This is a function to make a correllogram of all the variables in the Portugese student survey to see associations between various variables like final grades and alcohol
# @param data= input data as csv
# @param folder= path of folder to save the image
student_cor <- function(data,folder) {
  stu_cor <- data%>%
  select_if(is.numeric) %>% # select numeric values
  sapply(as.double) %>% # convert to double
  cor() # run correlation
stu_cor<- round(stu_cor,2)
png(height=800, width=800,filename = here(folder,"Correllogram.png"),type="cairo")
corr <- corrplot(stu_cor, 
                 type="upper", 
                 method="color",
                 tl.srt=45, 
                 tl.col = "blue",
                 diag = FALSE)+
  title( "Correllogram of all Variables in the Portugese Student Survey")
                 
dev.off()
}

# This is a function to make a boxplot between Final grades and potential confounding variables like "Sex","Parental Status","Family Support","Maternal Education","Health",
# and variables of interest like Weekend and Workday alcohol use
# @param data= input data as csv
# @param folder= path of folder to save the image
boxplots_variables <- function(data,folder){
  label=c("Sex","Parental Status","Family Support","Maternal Education","Health","Weekend Alcohol","Workday Alcohol")
  variables= c("sex","parent_status","fam_support","mom_edu","health","weekend_alc","workday_alc")
  plts <- function(varit,label){
    data %>%
      ggplot(aes(y=final_grade,x=as.factor(data[,varit]))) +
      geom_boxplot()+
      labs(title=glue("Final Grades vs ",label),x=label)+
      theme_bw()
  }
  plts2 <- map2(variables,label,~plts(.x,.y))
  filenames <- map(label,~glue("Final Grade vs ",.x,".png")) 
  walk2(.y=filenames,.x=plts2, ~ggsave(filename=.y, plot=.x, path=here(folder),width = 20, height = 20, units = "cm"))
}

#This is a function that looks at the distribution of grades through a density plot
# @param data= input data as csv
# @param folder= path of folder to save the image
density_plot <- function(data,folder){
  density <- data %>%
  ggplot(aes(x=final_grade)) +
  geom_density()+
  ggtitle("Spread of Final Grades")
  ggsave(density, filename=here(folder,"density_plot_grades.png"),width = 20, height = 20, units = "cm")+
    theme_bw()

}
##tests
main(opt$folder_path)