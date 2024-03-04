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
      ACS_all_data <- rbind(ACS_all_data, temp_subsetted )
    }
  }
}

#The above created a dataset that has repeated observations per county per year
#I want one observation per county per year
#Solution: divide the above data by the time variable, and then merge

ACS_Employed_Disabled <- subset(ACS_all_data, time == "Employed_Disabled")
colnames(ACS_Employed_Disabled)[4] <- 'Employed_Disabled_Count'
ACS_Employed_Disabled$time <- NULL

ACS_Unemployed_Disabled <- subset(ACS_all_data, time == "Unemployed_Disabled")
colnames(ACS_Unemployed_Disabled)[4] <- 'Unemployed_Disabled_Count'
ACS_Unemployed_Disabled$time <- NULL
  
ACS_Not_LF_Disabled <- subset(ACS_all_data, time == "Not_LF_Disabled")
colnames(ACS_Not_LF_Disabled)[4] <- 'Not_LF_Disabled_Count'
ACS_Not_LF_Disabled$time <- NULL

ACS_all_data_merged <- merge(ACS_Employed_Disabled, ACS_Unemployed_Disabled, by = c("County_Name", "Year"))
ACS_all_data_merged <- merge(ACS_all_data_merged, ACS_Not_LF_Disabled, by = c("County_Name", "Year"))

#Create percent in LF variable
#This is equal to (employed + unemployed)/(employed+unemployed+not_in_LF)
ACS_all_data_merged$Disabled_Percent_LF <- (ACS_all_data_merged$'Employed_Disabled_Count' + ACS_all_data_merged$'Unemployed_Disabled_Count')/(ACS_all_data_merged$'Employed_Disabled_Count' + ACS_all_data_merged$'Unemployed_Disabled_Count'+ ACS_all_data_merged$'Not_LF_Disabled_Count')
colnames(ACS_all_data_merged)[6] <- 'Disabled_Percent_LF'

#Create region and subregion variables to help with working with maps in other file
#the region=state, subregion=county
#these should both be lower case
#also trim leading whitespace
ACS_all_data_merged$subregion <- trimws(tolower(sapply(strsplit(ACS_all_data_merged$County_Name, ","), "[", 1)))
ACS_all_data_merged$region <- trimws(tolower(sapply(strsplit(ACS_all_data_merged$County_Name, ","), "[", 2)))

#removing the trailing " county" from subregion name
ACS_all_data_merged$subregion <- gsub(' county', '', ACS_all_data_merged$subregion)

#add ' county' back to 'baltimore city county'
ACS_all_data_merged$subregion[ACS_all_data_merged$subregion=='baltimore city'] <- 'baltimore city county'

#Create just 2022 version of the data
ACS_all_data_merged_2022 <- subset(ACS_all_data_merged, Year == 2022)

#Create just 2010 version of the data
ACS_all_data_merged_2010 <- subset(ACS_all_data_merged, Year == 2010)

