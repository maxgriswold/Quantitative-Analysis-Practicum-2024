#This file uses the ACS_all_data_merged data to create a county-level map

#install and load necessary packages
#install.packages('tidyverse')
#install.packages('devtools') 
library('tidyverse')
library('devtools')

#For this section, I used the following website as a guide: https://datavizpyr.com/how-to-make-us-state-and-county-level-maps-in-r/

# Loading map data
us_counties <- map_data("county")

p <- ggplot(data = us_counties,
            mapping = aes(x = long, y = lat,
                          group = group, fill = subregion))

p + geom_polygon(color = "gray90", size = 0.1) +
  coord_map(projection = "albers", lat0 = 39, lat1 = 45) +
  guides(fill = FALSE)+
  theme(axis.line=element_blank(),
        axis.text=element_blank(),
        axis.ticks=element_blank(),
        axis.title=element_blank(),
        panel.background=element_blank(),
        panel.border=element_blank(),
        panel.grid=element_blank())

#merge on our ACS data to the county map data
#ACS_all_data_merged_2022$Disabled_Percent_LF <- as.numeric(ACS_all_data_merged_2022$Disabled_Percent_LF)
#ACS_all_data_merged_2022$Disabled_Percent_LF <- apply(ACS_all_data_merged_2022$Disabled_Percent_LF, 2,            # Specify own function within apply
                    #function(x) as.numeric(x))

#Merge ACS_all_data_merged_2022 onto us_counties data
#us_counties_2022 <- merge(us_counties, ACS_all_data_merged_2022, by=c('region', 'subregion' ))

us_counties %>% 
  left_join(ACS_all_data_merged_2022, by=c('region', 'subregion' )) %>%
  ggplot(aes(x=long,y=lat,group=group, fill=Disabled_Percent_LF)) +
  geom_polygon(color = "gray90", size = 0.1) +
  #coord_map(projection = "albers", lat0 = 39, lat1 = 45) +
  coord_map(projection = "albers", lat0 = 45, lat1 = 55) +
  scale_fill_continuous(type = "viridis")+
  #scale_fill_brewer("Oranges")+
  theme(legend.position="bottom",
        axis.line=element_blank(),
        axis.text=element_blank(),
        axis.ticks=element_blank(),
        axis.title=element_blank(),
        panel.background=element_blank(),
        panel.border=element_blank(),
        panel.grid=element_blank())

# #I will be using the package described on this page: https://urban-institute.medium.com/how-to-create-state-and-county-maps-easily-in-r-577d29300bb2
# devtools::install_github('UrbanInstitute/urbnmapr')



# #I will be using the built-in maps found in the tidyverse package
# # Loading map data
# counties <- map_data("county")
# # 
# # #I used the county-map function defined here: https://www.geeksforgeeks.org/how-to-create-state-and-county-maps-easily-in-r/
# #  Function to plot maps using in-built map data
# map <- function(x,y,dataset,fill_column){
#   p <- ggplot(data = dataset,
#                mapping = aes(x = x, y = y, group = group, fill = fill_column))
#   p + geom_polygon() + guides(fill = FALSE)
#  }
# # 
# # US counties by subregion with latitude and longitude
# map(counties$long,counties$lat,counties,counties$subregion) +
#   coord_map("albers",  lat0 = 45.5, lat1 = 29.5)
