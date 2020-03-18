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
|[Final Report-HTML](https://github.com/STAT547-UBC-2019-20/team11_akhan/Final_report.html)|Final Report HTML doc|_completed_|March 17/20|
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
       

### Running the whole pipeline with Make

1. With a clean repository, to run the whole pipeline

    make all
    
2. Clean up the results from the scripts and start fresh:

    make clean

### Running each script with Make itself:

    # Download the data:
    make data/student_port_survey.csv
    
    # Clean and wrangle the data
    make data/cleaned_data.csv
    
    # Perform Basic EDA and generate some interesting plots
    make images/Correllogram.png images/Final_Grade_vs_Workday_Alcohol.png images/Final_Grade_vs_Weekend_Alcohol.png images/Final_Grade_vs_Health.png images/Final_Grade_vs_Maternal_Education.png images/Final_Grade_vs_Family_Support.png images/Final_Grade_vs_Parental_Status.png images/Final_Grade_vs_Sex.png images/density_plot_grades.png
    
    # Run linear regression and generate some plots
    make images/residual_fitted_plot.png images/residual_plot_qq.png data/lm_model_alc.RDS docs/filtered_cleaned.csv
    
     #Knit the final report
     make Final_report.html Final_report.pdf

### Running each Script without using Make:
 Run the following scripts (in order) with the appropriate arguments specified:

        # Download data
        Rscript scripts/load.r --data_url="https://github.com/STAT547-UBC-2019-20/data_sets/raw/master/student-por.csv"
        
        # Clean and wrangle the data
        Rscript scripts/clean.R --data_input="data/student_port_survey.csv"  --filename="cleaned_data"
        
        # Perform Basic EDA and generate some interesting plots
        Rscript scripts/EDA.R --folder_path="images"
        
        # Run linear regression and generate some plots
        Rscript scripts/linear_regression.R --filename="cleaned_data.csv"
        
        #Knit the final report
         Rscript scripts/knit.R --finalreport_name="Final_report.Rmd"
        
