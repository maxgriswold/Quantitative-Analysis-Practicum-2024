#set the folder with my data as the working directory
setwd("/Users/mforbes/OneDrive - RAND Corporation/Documents/Classes/Quantitative Practicum/data/ACS data")

#Go into the folder that contains ACS data
#setwd("ACS data")

#Create a list of the files in this folder
ACS_files <- list.files()

#Create empty dataframe to append data to
ACS_all_data <- dataframe()

#Create a for-loop that cycles through each of these files
#I used starter code from here: https://statisticsglobe.com/r-write-read-multiple-csv-files-for-loop
for(i in 1:length(ACS_files)) { 
  print(ACS_files[i])
  if(endsWith(ACS_files[i], "Data.csv")) {
    temp <- read.csv(ACS_files[i], skip = 1, header = TRUE, sep = ",")
    #temp_subsetted <- temp[ , c("Geographic.Area.Name", "Estimate..Total...Not.in.labor.force...With.a.disability.")]
    temp_subsetted <- temp[ , c(2,9,27, 45)]  
    
    if(i == 2){
      ACS_all_data <- temp_subsetted
    } else {
      ACS_all_data <- merge(ACS_all_data, temp_subsetted, by = "Geographic.Area.Name")
    }
  }
}
