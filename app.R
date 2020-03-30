# author: Almas K.
# date: 2020-03-24

"This script is the main file that creates a Dash app.

Usage: app.R
"
#command to add dash app in Rstudio viewer:
  # rstudioapi::viewer("http://127.0.0.1:8050")
# 1. Load libraries
library(dash)
library(dashCoreComponents)
library(dashHtmlComponents)
library(tidyverse)
library(plotly)
library(here)

# 2. Create Dash instance
app <- Dash$new()

#Load the data:

data <- read_csv(here("data","cleaned_data.csv"))
## Assign components to variables
heading_title <- htmlH1('Portugese Highschool Student Survey Dashboard')
data_cols<- colnames(data)
xaxisKey <- tibble(label = c("Sex", "Age","Urban or Rural","Family Size","Parental Status","Mom's Education Status","Dad's Education Status","Mom's Job", "Dad's Job","Guardian","School Travel Time","Study Time","Number of Failures","School Support","Family Support","Extra Paid Classes","Extracurriculars","Attended Preschool","Wants Higher Education","Home Internet","Romantic Relations","Family Relations","Free Time","Goes Out with Frieds","Workday Alcohol", "Weekend Alcohol","Health Status","Number of Absences"),
                   value = data_cols[1:28])
numfactKey <- tibble(label = c("Age","Mom's Education Status","Dad's Education Status","School Travel Time","Study Time","Number of Failures","Family Relations","Free Time","Goes Out with Frieds","Workday Alcohol", "Weekend Alcohol","Health Status","Number of Absences"),
                     value =c(data_cols[2],data_cols[6:7],data_cols[11:13],data_cols[22:28]))
binfactKey <- tibble(label = c("Sex","Urban or Rural","Family Size","Parental Status","Guardian","School Support","Family Support","Extra Paid Classes","Extracurriculars","Attended Preschool","Wants Higher Education","Home Internet","Romantic Relations"),
                     value =c(data_cols[1],data_cols[3:5],data_cols[10],data_cols[14:21]))
## Make plots:
make_plot1 <- function(vars="workday_alc",grade = "final_grade") {
  # gets the label matching the column value
  factor_lab<- xaxisKey$label[xaxisKey$value==vars]
  glab <- if_else(grade=="final_grade","Final Grade",
                  if_else(grade=="t1_grade","Term 1 Grade",
                          "Term 2 Grade"))
  # add a ggplot
  plot <- data%>% 
    ggplot(aes(x=!!sym(vars),y=!!sym(grade))) + 
    theme_bw() +
    geom_boxplot() + 
    labs(x =factor_lab,
         y = glab) + 
    ggtitle(paste0("Spread of ",glab," by ",factor_lab))
  
  plot <-  ggplotly(plot)
}
make_plot2 <- function(grade = "final_grade") {
  glab <- if_else(grade=="final_grade","Final Grade",
                  if_else(grade=="t1_grade","Term 1 Grade",
                          "Term 2 Grade"))
  # add a ggplot
  plot <- data%>% 
    ggplot(aes(x=!!sym(grade))) + 
    theme_bw() +
    geom_bar() + 
    labs(x =glab,
         y="Number of students") + 
    ggtitle(paste0("Spread of ",glab, " Overalll"))
  
  plot <-  ggplotly(plot) }

make_plot3 <- function(vars="workday_alc") {
  factor_lab<- xaxisKey$label[xaxisKey$value==vars]
 
  # add a ggplot
  plot <- data%>% 
    ggplot(aes(x=!!sym(vars))) + 
    theme_bw() +
    geom_bar() + 
    labs(x =factor_lab,
         y="Number of students") + 
    ggtitle(paste0("Number of students in  ",factor_lab, " factor overalll"))
  
  plot <-  ggplotly(plot) }

make_plot4 <- function(vars="workday_alc",grade="final_grade",colour="sex") {
  factor_lab<- numfactKey$label[numfactKey$value==vars]
  glab <- if_else(grade=="final_grade","Final Grade",
                  if_else(grade=="t1_grade","Term 1 Grade",
                          "Term 2 Grade"))
  colour_lab<- binfactKey$label[binfactKey$value==colour]
  # add a ggplot
  plot <- data%>% 
    ggplot(aes(x=!!sym(vars),y=!!sym(grade),col=!!sym(colour))) +
    geom_point()+
    geom_jitter()+
    theme_bw() +
    geom_smooth(method=lm, se=FALSE) + 
    labs(x =factor_lab,
         y=glab) + 
    ggtitle(paste0("Linear Regression-",factor_lab," vs ",glab))
  
  plot <-  ggplotly(plot) }


graph_1 <-  dccGraph(id='boxplot',figure = make_plot1())
graph_2 <-  dccGraph(id='histogram',figure = make_plot2())
graph_3 <-  dccGraph(id='vars_bar',figure = make_plot3())
graph_4 <-  dccGraph(id='lin_reg',figure = make_plot4())

## Dropdowns: 

varsDropdown1 <- dccDropdown(
  id = "dropdown1",
  options = map(
    1:nrow(xaxisKey), function(i){
      list(label=xaxisKey$label[i], value=xaxisKey$value[i])
    }),
  value = "workday_alc"
)


varsDropdown2 <- dccDropdown(
  id = "dropdown2",
  options = map(
    1:nrow(numfactKey), function(i){
      list(label=numfactKey$label[i], value=numfactKey$value[i])
    }),
  value = "workday_alc"
)

  

varsDropdown3 <- dccDropdown(
  id = "dropdown3",
  options = map(
    1:nrow(binfactKey), function(i){
      list(label=binfactKey$label[i], value=binfactKey$value[i])
    }),
  value = "sex"
)


## Radio Buttons
grade_button <- dccRadioItems(
  id = 'grade_choice',
  options = list(list(label = 'Final Grade', value = 'final_grade'),
                 list(label = 'Term 2 Grade', value = 't2_grade'),
                 list(label = 'Term 1 Grade', value = 't1_grade')),
  value = 'final_grade'
)
## 3 Specify App layout
app$layout(
  htmlDiv(
    list(
      heading_title,
      htmlLabel("Pick a factor"),
      varsDropdown1,
      htmlLabel("Pick the grade to plot by"),
      grade_button,
      graph_1,
      graph_2,
      graph_3,
      htmlLabel("Pick the Factor(x) to plot by"),
      varsDropdown2,
      htmlLabel("Pick the Factor to colour by"),
      varsDropdown3,
      graph_4
      
    )
  )
)

## 4. App callback
app$callback(
  output = list(id='boxplot', property='figure'),
  params = list(input(id='dropdown1', property='value'),
                input(id='grade_choice',property = 'value')),
  function(factor_val,grade) {
    make_plot1(factor_val,grade)}
)
app$callback(
  output = list(id='histogram', property='figure'),
  params = list(input(id='grade_choice', property='value')),
  function(grade) {
    make_plot2(grade)}
)

app$callback(
  output = list(id='vars_bar', property='figure'),
  params = list(input(id='dropdown1', property='value')),
  function(factor_val) {
    make_plot3(factor_val)}
)

app$callback(
  output = list(id='lin_reg', property='figure'),
  params = list(input(id='dropdown2', property='value'),
                input(id='grade_choice', property='value'),
                input(id='dropdown3', property='value')),
  function(factor_val,grade,colour) {
    make_plot4(factor_val,grade,colour)}
)
#5. Run App
app$run_server(debug=TRUE)