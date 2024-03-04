#this file sets up the ACS data for general employment data,
#rather than disability-specific employment data

#set the folder with my data as the working directory
setwd("/Users/mforbes/OneDrive - RAND Corporation/Documents/Classes/Quantitative Practicum/data/ACS data")

#the data in this folder contains employment and disability data at the county
#level for counties with populations over 65,000
#source on why these counties have to have populations over 65,000: https://www.census.gov/content/dam/Census/library/publications/2020/acs/acs_general_handbook_2020_ch03.pdf

#Each year of data is contained in a separate excel file, so need to merge together

#Create a list of the files in this folder
ACS_files <- list.files()

#Create a for-loop that cycles through each of these files
#I used starter code from here: https://statisticsglobe.com/r-write-read-multiple-csv-files-for-loop
for(i in 1:length(ACS_files)) { 
  print(ACS_files[i])
  if(endsWith(ACS_files[i], "Data.csv")) {
    temp <- read.csv(ACS_files[i], skip = 1, header = TRUE, sep = ",")
    #extract the columns that I want
    temp_subsetted <- temp[ , c(2, 23, 41, 59)]
    #create a variable equal to the data's year
    the_year <- substring(ACS_files[i], first=8, last=11)
    print(the_year)
    #attached the year to the front of the column names
    #colnames(temp_subsetted) <- paste(the_year, colnames(temp_subsetted), sep = ".")
    temp_subsetted['Year'] <- the_year
    colnames(temp_subsetted)[1] <- 'County_Name'
    colnames(temp_subsetted)[2] <- 'Employed_NonDisabled'
    colnames(temp_subsetted)[3] <- 'Unemployed_NonDisabled'
    colnames(temp_subsetted)[4] <- 'Not_LF_NonDisabled'
    
    temp_subsetted <- reshape(data=temp_subsetted, varying=c('Employed_NonDisabled','Unemployed_NonDisabled','Not_LF_NonDisabled'), v.name=c("value"), times=c('Employed_NonDisabled','Unemployed_NonDisabled','Not_LF_NonDisabled') , idvar="County_Name", direction="long" )
     
    #have the first dataset be the base, then merge everything onto this base
    if(i == 2){
      ACS_nondis_data <- temp_subsetted
    } else {
      ACS_nondis_data <- rbind(ACS_nondis_data, temp_subsetted )
    }
  }
}


ACS_Employed_NonDisabled <- subset(ACS_nondis_data, time == "Employed_NonDisabled")
colnames(ACS_Employed_NonDisabled)[4] <- 'Employed_NonDisabled_Count'
ACS_Employed_NonDisabled$time <- NULL

ACS_Unemployed_NonDisabled <- subset(ACS_nondis_data, time == "Unemployed_NonDisabled")
colnames(ACS_Unemployed_NonDisabled)[4] <- 'Unemployed_NonDisabled_Count'
ACS_Unemployed_NonDisabled$time <- NULL

ACS_Not_LF_NonDisabled <- subset(ACS_nondis_data, time == "Not_LF_NonDisabled")
colnames(ACS_Not_LF_NonDisabled)[4] <- 'Not_LF_NonDisabled_Count'
ACS_Not_LF_NonDisabled$time <- NULL

ACS_nondis_merged <- merge(ACS_Employed_NonDisabled, ACS_Unemployed_NonDisabled, by = c("County_Name", "Year"))
ACS_nondis_merged <- merge(ACS_nondis_merged, ACS_Not_LF_NonDisabled, by = c("County_Name", "Year"))

#Create percent in LF variable
#This is equal to (employed + unemployed)/(employed+unemployed+not_in_LF)
ACS_nondis_merged$NonDisabled_Percent_LF <- (ACS_nondis_merged$'Employed_NonDisabled_Count' + ACS_nondis_merged$'Unemployed_NonDisabled_Count')/(ACS_nondis_merged$'Employed_NonDisabled_Count' + ACS_nondis_merged$'Unemployed_NonDisabled_Count'+ ACS_nondis_merged$'Not_LF_NonDisabled_Count')
colnames(ACS_nondis_merged)[6] <- 'NonDisabled_Percent_LF'
ACS_nondis_merged$Employment_Rate_NonDisabled <- ACS_nondis_merged$'Employed_NonDisabled_Count' / (ACS_nondis_merged$'Employed_NonDisabled_Count' + ACS_nondis_merged$'Unemployed_NonDisabled_Count')

#Create region and subregion variables to help with working with maps in other file
#the region=state, subregion=county
#these should both be lower case
#also trim leading whitespace
ACS_nondis_merged$subregion <- trimws(tolower(sapply(strsplit(ACS_nondis_merged$County_Name, ","), "[", 1)))
ACS_nondis_merged$region <- trimws(tolower(sapply(strsplit(ACS_nondis_merged$County_Name, ","), "[", 2)))

#removing the trailing " county" from subregion name
ACS_nondis_merged$subregion <- gsub(' county', '', ACS_nondis_merged$subregion)

#add ' county' back to 'baltimore city county'
ACS_nondis_merged$subregion[ACS_nondis_merged$subregion=='baltimore city'] <- 'baltimore city county'

#Create just 2022 version of the data
ACS_nondis_merged_2022 <- subset(ACS_nondis_merged, Year == 2022)

#Create just 2010 version of the data
ACS_nondis_merged_2010 <- subset(ACS_nondis_merged, Year == 2010)

#Create version that shows the change from 2010 to 2022
ACS_nondis_merged_change <- merge(ACS_nondis_merged_2022, ACS_nondis_merged_2010, by=c("subregion", "region")) 
ACS_nondis_merged_change$LF_change_NonDis <- ACS_nondis_merged_change$NonDisabled_Percent_LF.x - ACS_nondis_merged_change$NonDisabled_Percent_LF.y
ACS_nondis_merged_change$Employment_rate_change_NonDis <- ACS_nondis_merged_change$Employment_Rate_NonDisabled.x - ACS_nondis_merged_change$Employment_Rate_NonDisabled.y

#Create dataframe that compares the changes in employment and LF rates between disabled and non-disabled
ACS_combined <- merge(ACS_nondis_merged_change, ACS_all_data_merged_change, by = c("subregion", "region"))
ACS_combined$Employment_rate_change_ratio <- ACS_combined$Employment_rate_change / ACS_combined$Employment_rate_change_NonDis
ACS_combined$LF_change_ratio <- ACS_combined$LF_change / ACS_combined$LF_change_NonDis

#Create dataframe that computes 2022 gap between nondisabled and disabled
ACS_2022_combined <- merge(ACS_nondis_merged_2022, ACS_all_data_merged_2022, by = c("subregion", "region"))
ACS_2022_combined$Employment_Rate_Gap <-  ACS_2022_combined$Employment_Rate_NonDisabled - ACS_2022_combined$Employment_Rate_Disabled
ACS_2022_combined$LF_Rate_Gap <- ACS_2022_combined$NonDisabled_Percent_LF - ACS_2022_combined$Disabled_Percent_LF