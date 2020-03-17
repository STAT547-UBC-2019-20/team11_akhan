# author: Almas K.
# date: March 17/20

.PHONY: all clean

# All target
all: Final_report.html Final_report.pdf
# download data
data/student_port_survey.csv: scripts/load.R
	Rscript scripts/load.R --data_url="https://github.com/STAT547-UBC-2019-20/data_sets/raw/master/student-por.csv"

# clean data
data/cleaned_data.csv: scripts/clean.R data/student_port_survey.csv
	Rscript scripts/clean.R --data_input="data/student_port_survey.csv" --filename="cleaned_data"

# EDA
images/Correllogram.png images/Final_Grade_vs_Workday_Alcohol.png images/Final_Grade_vs_Weekend_Alcohol.png images/Final_Grade_vs_Health.png images/Final_Grade_vs_Maternal_Education.png images/Final_Grade_vs_Family_Support.png images/Final_Grade_vs_Parental_Status.png images/Final_Grade_vs_Sex.png images/density_plot_grades.png: scripts/EDA.R data/cleaned_data.csv
	Rscript scripts/EDA.R --folder_path="images"

# linear model
images/residual_fitted_plot.png images/residual_plot_qq.png data/lm_model_alc.RDS docs/filtered_cleaned.csv: scripts/linear_regression.R
	Rscript scripts/linear_regression.R --filename="cleaned_data.csv"
# Knit report
Final_report.html Final_report.pdf: images/Correllogram.png images/Final_Grade_vs_Workday_Alcohol.png images/Final_Grade_vs_Weekend_Alcohol.png images/Final_Grade_vs_Health.png images/Final_Grade_vs_Maternal_Education.png images/Final_Grade_vs_Family_Support.png images/Final_Grade_vs_Parental_Status.png images/Final_Grade_vs_Sex.png images/density_plot_grades.png data/cleaned_data.csv images/residual_fitted_plot.png images/residual_plot_qq.png data/lm_model_alc.RDS Final_report.Rmd scripts/knit.R 
	Rscript scripts/knit.R --finalreport_name="Final_report.Rmd"

clean:
	rm -f data/*
	rm -f images/*
	rm -f Final_report.html
	rm -f Final_report.pdf