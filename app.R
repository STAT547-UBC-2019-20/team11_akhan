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
data_cols<- colnames(data)

graph_1 <-  dccGraph(id='boxplot',figure = make_plot1())
graph_2 <-  dccGraph(id='histogram',figure = make_plot2())
graph_3 <-  dccGraph(id='vars_bar',figure = make_plot3())


## Dropdowns: 
xaxisKey <- tibble(label = c("Sex", "Age", "Family Size","Parental Status","Mom's Education Status","Dad's Education Status","Mom's Job", "Dad's Job","Guardian","School Travel Time","Study Time","Number of Failures","School Support","Family Support","Extra Paid Classes","Extracurriculars","Attended Preschool","Wants Higher Education","Home Internet","Romantic Relations","Family Relations","Free Time","Goes Out with Frieds","Workday Alcohol", "Weekend Alcohol","Health Status","Number of Absences"),
                   value = data_cols[1:27])
varsDropdown1 <- dccDropdown(
  id = "dropdown1",
  options = map(
    1:nrow(xaxisKey), function(i){
      list(label=xaxisKey$label[i], value=xaxisKey$value[i])
    }),
  value = "workday_alc"
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
      graph_3
      
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
#5. Run App
app$run_server(debug=TRUE)