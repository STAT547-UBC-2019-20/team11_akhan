# team11_akhan
This is a project repo for group 11 in the course of Stat 547. Here I will be working with student survey data from a Portugese school. This project is broken down into 6 milestones and there will be two major themes, the first is an analysis pipeline and the second is the creation of a dashboard using the same dataset.

## Directory Structure:

1. data: contains all the relevant data in .csv format (raw and processed), as well as metadata in .txt format
2. docs: contains .Rmd scripts and the draft report
3. images: contains the figures created by the R scripts in png format
4. scripts: contains the relevant R scripts 

### Docs Table of Contents-Milestones
Below is my table of contents for the milestones:
|Name of milestone|Description|Status|Date completed|
|---|---|---|---|
|[Milestone 1](https://github.com/STAT547-UBC-2019-20/team11_akhan/blob/master/docs/milestone_1/Milestone-1-Project-Desc.md)|Dataset EDA, and research|_completed_|March 3,2020
|[Milestone 2](https://github.com/STAT547-UBC-2019-20/team11_akhan/blob/master/docs/milestone_2/Milestone_2-draft.md)|Basic Draft Report and R scripts|_completed_|March 9,2020

## Usage:
To completely reproduce the steps for analysis do the following:

1. Clone this repo
2. Ensure the following packages are installed:

       - ggplot
       - dplyr
       - docopt
       - purrr
       - corrplot
       - tidyverse
       - here
       - glue
       

3. Run the following scripts (in order) with the appropriate arguments specified:

        # Download data
        Rscript scripts/load.r --data_url="https://github.com/STAT547-UBC-2019-20/data_sets/raw/master/student-por.csv"
        
        # Clean and wrangle the data
        Rscript scripts/clean.R --data_input="data/student_port_survey.csv"  --filename="cleaned_data"
        
        # Perform Basic EDA and generate some interesting plots
        Rscript scripts/EDA.R --folder_path="images"
        
