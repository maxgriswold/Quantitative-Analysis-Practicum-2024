#Exploring hospital concentration data
#I'm still exploring different market concentration data posted on OpenICPSR
#My goal is to have some U.S. market concentration at a state or ideally
#even more local level.
#Preferably, this would be across industries, but I can focus on one particular
#industry if that is more useful.

#This Rfile explores this data a bit

###EXploring hospital dataset: #Quite a bit of data on hospitals, such as this one: https://www.openicpsr.org/openicpsr/project/120834/version/V1/view?path=/openicpsr/120834/fcr:versions/V1/Replication_Public/Data/Processed/Publicly-Available/HCRIS-hospital-characteristics.dta&type=file

#Step 1: load data, which comes as a Stata dta
#need to have package "haven" installed
#uncomment below line if not already installed:
#install.packages(haven)

library(haven)
#set the folder with my data as the working directory
setwd("/Users/mforbes/OneDrive - RAND Corporation/Documents/Classes/Quantitative Practicum/data")
hospital_data <- read_dta("HCRIS hospital characteristics.dta")

#hmm, this data seems to describe characteristics like number of beds and percent
#of patients on medicaid
#Other data in the folder is marked as proprietary


#let's try a different dataset

###Exploring national employment dataset: https://www.openicpsr.org/openicpsr/project/116581/version/V1/view?path=/openicpsr/116581/fcr:versions/V1/Data
#Here is the paper this data was used for: https://pubs.aeaweb.org/doi/pdfplus/10.1257/mic.20190029
#It has country, county, and ZIP code graphs on page 315! Seems promising.

#Data on the OpenICPSR is a little disorganized, and there's lots of files
#Like on this page: https://www.openicpsr.org/openicpsr/project/116581/version/V1/view?flag=follow&path=/openicpsr/116581/fcr:versions/V1/Data/Census/raw/2012&type=folder&pageSelected=1&pageSize=10&sortOrder=(?title)&sortAsc=true
#What do these files contain?

#Let's explore one
#It's in the form .dat
#Can use read.table function to read in the data
#I think this is how I use the function in this setting, since the data is separated
#by | and has a header
industry_data <- read.table("EC1231SR2.dat", header = TRUE, sep = '|')
#Works! This dataset has industry concentrations across the US at industry level
#There is a geocode ID but seems to be the same for the entire dataset
#Let's confirm that
unique(industry_data$GEO_ID)
#Yup, but since there are several geo columns in the data, maybe a different file
#has smaller geographic levels


#I see now that the OpenICPSR page has a ReadMe file. Probably would have been a good
#idea to start there.
#Link: https://www.openicpsr.org/openicpsr/project/116581/version/V1/view?path=/openicpsr/116581/fcr:versions/V1/README.txt&type=file
#The ReadMe describes what all the code and files are, but it is not super descriptive
#However, one code file creates all the tables. I can see what data was used to create
#the graph on page 315 (Figure 2) and work backwards to find the data that was used.

#The code is Stata code. It seems like the data used to make the graph is in the 
#census/rdc_extract folder, titled "share trends.csv".
#This file is aggregated market concentrations over time at the ZIP code, county, and 
#national level. Interesting, but I would prefer unaggregated. I'll try next examining
#the code that made this file.

#The ReadMe states that the Census_Data_Processing.do file creates the "share trends.csv" file.

#From what I can tell from looking at that do file and the ReadMe, the concentration
#microdata is confidential and can only be accessed at "Federal Statistical Research Data Centers"
#One of these is located at UCLA and RAND students/faculty can gain access, but
#I probably don't this for this project.

#For this project, I'll have to stick with national data and the aggregated state, county, and ZIP 
#code data.



