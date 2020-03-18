# author: Almas
# date: 2020-03-17

"This script knits the Final Report into an HTML and PDF
Usage: src/knit.R --finalreport_name=<finalreport>" -> doc

library(docopt)

opt <- docopt(doc)

main <- function(finalreport) {
rmarkdown::render(finalreport, 
c("html_document", "pdf_document"))
  print(glue("Success! Files have been knitted to the",here()))
}

main(opt$finalreport_name)