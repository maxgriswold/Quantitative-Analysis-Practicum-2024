#set the folder with my data as the working directory
setwd("/Users/mforbes/OneDrive - RAND Corporation/Documents/Classes/Quantitative Practicum/data/ACS data")

#the data in this folder contains employment and disability data at the county
#level for counties with populations over 65,000
#source on why these counties have to have populations over 65,000: https://www.census.gov/content/dam/Census/library/publications/2020/acs/acs_general_handbook_2020_ch03.pdf

#Each year of data is contained in a separate excel file, so need to merge together

#Create a list of the files in this folder
ACS_files <- list.files()

#Create empty dataframe to append data to
#This dataframe will contain all relevant ACS data at county-level per year
#ACS_all_data <- dataframe()

#Create a for-loop that cycles through each of these files
#I used starter code from here: https://statisticsglobe.com/r-write-read-multiple-csv-files-for-loop
for(i in 1:length(ACS_files)) { 
  print(ACS_files[i])
  if(endsWith(ACS_files[i], "Data.csv")) {
    temp <- read.csv(ACS_files[i], skip = 1, header = TRUE, sep = ",")
    #extract the columns that I want
    temp_subsetted <- temp[ , c(2,9,27, 45)]
    #create a variable equal to the data's year
    the_year <- substring(ACS_files[i], first=8, last=11)
    print(the_year)
    #attached the year to the front of the column names
    #colnames(temp_subsetted) <- paste(the_year, colnames(temp_subsetted), sep = ".")
    temp_subsetted['Year'] <- the_year
    colnames(temp_subsetted)[1] <- 'County_Name'
    colnames(temp_subsetted)[2] <- 'Employed_Disabled'
    colnames(temp_subsetted)[3] <- 'Unemployed_Disabled'
    colnames(temp_subsetted)[4] <- 'Not_LF_Disabled'
    
    temp_subsetted <- reshape(data=temp_subsetted, varying=c('Employed_Disabled','Unemployed_Disabled','Not_LF_Disabled'), v.name=c("value"), times=c('Employed_Disabled','Unemployed_Disabled','Not_LF_Disabled') , idvar="County_Name", direction="long" )
    
    #have the first dataset be the base, then merge everything onto this base
    if(i == 2){
      ACS_all_data <- temp_subsetted
    } else {
      #ACS_all_data <- merge(ACS_all_data, temp_subsetted, by = "Geographic.Area.Name")
      ACS_all_data <- rbind(ACS_all_data, temp_subsetted )
    }
  }
}




#reshape into long
#use "ACS_all_data[varname] <-" to rename variables dynamically

#ACS_all_data_long <- reshape(data=ACS_all_data, varying=, idvar="Geographic.Area.Name", direction="long")

# j <- 2
# k <- 3
# l <- 4
# 
# for(i in 2010:2022) {
# 
#   percent_in_LF <- paste0(i, "percent_in_LF")
#   ACS_all_data$percent_in_LF <- (ACS_all_data[, c(j)] + ACS_all_data[, c(k) ]) / (ACS_all_data[, c(j)] + ACS_all_data[, c(k)] + ACS_all_data[, c(l)] )
#   j <- j + 3
#   k <- k + 3
#   l <- l + 3
# }




