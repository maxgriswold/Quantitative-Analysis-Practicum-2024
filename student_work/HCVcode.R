## Title: LA County HCV Data Analysis

## load data
Yr2021 <- read.csv("C:/Users/asizemor/Desktop/DisData/Yr2021.csv", header=TRUE)
Yr2022 <- read.csv("C:/Users/asizemor/Desktop/DisData/Yr2022.csv", header=TRUE)
Yr2020 <- read.csv("C:/Users/asizemor/Desktop/DisData/Yr2020.csv", header=TRUE)
Yr2019 <- read.csv("C:/Users/asizemor/Desktop/DisData/Yr2019.csv", header=TRUE)
Yr2018 <- read.csv("C:/Users/asizemor/Desktop/DisData/Yr2018.csv", header=TRUE)
Yr2017 <- read.csv("C:/Users/asizemor/Desktop/DisData/Yr2017.csv", header=TRUE)
LAZips <- read.csv("C:/Users/asizemor/Desktop/DisData/LAZips.csv", header=TRUE)
SAFMR <- read.csv("C:/Users/asizemor/Desktop/DisData/SAFMR.csv", header=TRUE)

## remove gsl columns from annual data
Yr2022$gsl <- NULL
Yr2021$gsl <- NULL
Yr2020$gsl <- NULL
Yr2019$gsl <- NULL
Yr2018$gsl <- NULL
Yr2017$gsl <- NULL

## remove state columns from annual data
Yr2022$state <- NULL
Yr2021$state <- NULL
Yr2020$state <- NULL
Yr2019$state <- NULL
Yr2018$state <- NULL
Yr2017$state <- NULL

## remove latitude columns from annual data
Yr2022$latitude <- NULL
Yr2021$latitude <- NULL
Yr2020$latitude <- NULL
Yr2019$latitude <- NULL
Yr2018$latitude <- NULL
Yr2017$latitude <- NULL

## remove longitude columns from annual data
Yr2022$longitude <- NULL
Yr2021$longitude <- NULL
Yr2020$longitude <- NULL
Yr2019$longitude <- NULL
Yr2018$longitude <- NULL
Yr2017$longitude <- NULL

## add year value to all annual data so they can be merged)
Yr2017$year = 2017
Yr2018$year = 2018
Yr2019$year = 2019
Yr2020$year = 2020
Yr2021$year = 2021
Yr2022$year = 2022

## merge annual data
Allyrs <- rbind(Yr2017, Yr2018, Yr2019, Yr2020, Yr2021, Yr2022)

## remove rows with summary data from all HUD programs by zip
Allyrs[-which(Allyrs$program_label=='Summary of All HUD Programs')]

## remove non-LA zips
#  make sure zip codes are labeled using same column name in both Allyrs & LAZips
names(Allyrs)[names(Allyrs) == "entities"] <- "ZIP"
# merge Allys & LAZips by ZIP so non-LA zips are excluded
LAyrs <- merge(Allyrs,LAZips['ZIP'])

## Remove rows with all HUD Program summary data
LAyrs <- subset.data.frame(LAyrs, program==3)
nrow(LAyrs)
# note: count of rows used to confirm that non-LA zips were removed. LAyrs reduced from 3321 to 1651 rows

## load package for graphing
library(ggplot2)
library(dplyr)

## Create line graph of voucher usage by zip code in LA from 2017 t0 2022 using select zips
selected_zipcodes <- c("90001", "90002", "90003")
filtered_data <- LAyrs[LAyrs$ZIP %in% selected_zipcodes, ]

# Aggregate the data
agg_data <- filtered_data %>%
  group_by(year, ZIP) %>%
  summarize(total_units = sum(total_units))

# Create the multiline chart
ggplot(agg_data, aes(x = year, y = total_units, color = ZIP, group = ZIP)) +
  geom_line() +
  labs(title = "Housing Voucher Usage by Selected Zip Codes (2017-2019)",
       x = "Year",
       y = "Number of Vouchers Used",
       color = "Zip Code") +
  theme_minimal()

## Create line graph of voucher usage by zip code in LA from 2017 t0 2022 using all zips
agg_data <- LAyrs %>%
  group_by(year, ZIP) %>%
  summarize(total_units = sum(total_units))

# Create the multiline chart for all zip codes
ggplot(agg_data, aes(x = year, y = total_units, color = ZIP, group = ZIP)) +
  geom_line() +
  labs(title = "Housing Voucher Usage by All Zip Codes (2017-2019)",
       x = "Year",
       y = "Number of Vouchers Used",
       color = "Zip Code") +
  theme_minimal()
