# author: Almas K.
# date: 2020-03-24

"This script is the main file that creates a Dash app.

Usage: app.R
"

# 1. Load libraries
library(dash)
library(dashCoreComponents)
library(dashHtmlComponents)
library(tidyverse)
library(plotly)

# 2. Create Dash instance
app <- Dash$new()

## Assign components to variables
heading_title <- htmlH1('Portugese Highschool Student Survey Dashboard')
## 3. Specify App layout
app$layout(
  htmlDiv(
    list(
      heading_title
    )
  )
)
# 4. Run app
app$run_server(debug=TRUE)