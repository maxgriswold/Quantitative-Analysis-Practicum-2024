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

#create map of 2022 disabled percent in the LF
us_counties %>% 
  left_join(ACS_all_data_merged_2022, by=c('region', 'subregion' )) %>%
  ggplot(aes(x=long,y=lat,group=group, fill=Disabled_Percent_LF)) +
  geom_polygon(size = 0.1) +
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

#create map of 2022-2010 change disabled percent in the LF
us_counties %>% 
  left_join(ACS_all_data_merged_change, by=c('region', 'subregion' )) %>%
  ggplot(aes(x=long,y=lat,group=group, fill=LF_change)) +
  geom_polygon(size = 0.1) +
  #coord_map(projection = "albers", lat0 = 39, lat1 = 45) +
  coord_map(projection = "albers", lat0 = 45, lat1 = 55) +
  #low = "firebrick", high = "dodgerblue4"
  scale_fill_continuous(low = "blue", high = "green")+
  #scale_fill_brewer("Oranges")+
  theme(legend.position="bottom",
        axis.line=element_blank(),
        axis.text=element_blank(),
        axis.ticks=element_blank(),
        axis.title=element_blank(),
        panel.background=element_blank(),
        panel.border=element_blank(),
        panel.grid=element_blank())

#create map of 2022 disabled employment rate
us_counties %>% 
  left_join(ACS_all_data_merged_2022, by=c('region', 'subregion' )) %>%
  ggplot(aes(x=long,y=lat,group=group, fill=Employment_Rate_Disabled)) +
  geom_polygon( size = 0.1) +
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

#create map of 2022-2010 change disabled employment rate
us_counties %>% 
  left_join(ACS_all_data_merged_change, by=c('region', 'subregion' )) %>%
  ggplot(aes(x=long,y=lat,group=group, fill=Employment_rate_change)) +
  geom_polygon( size = 0.1) +
  #coord_map(projection = "albers", lat0 = 39, lat1 = 45) +
  coord_map(projection = "albers", lat0 = 45, lat1 = 55) +
  scale_fill_continuous(low = "blue", high = "green")+
  #scale_fill_brewer("Oranges")+
  theme(legend.position="bottom",
        axis.line=element_blank(),
        axis.text=element_blank(),
        axis.ticks=element_blank(),
        axis.title=element_blank(),
        panel.background=element_blank(),
        panel.border=element_blank(),
        panel.grid=element_blank())

#create map of 2022-2010 disabled employment change relative to non-disabled
#Addressed scale issues by grouping all counties below -5 and above 5
us_counties %>% 
  left_join(ACS_combined, by=c('region', 'subregion' )) %>%
  ggplot(aes(x=long,y=lat,group=group, fill=Employment_rate_change_ratio)) +
  geom_polygon( size = 0.1) +
  #coord_map(projection = "albers", lat0 = 39, lat1 = 45) +
  coord_map(projection = "albers", lat0 = 45, lat1 = 55) +
  scale_fill_continuous(low = "blue", high = "green", limits=c(-5,5))+
  #scale_fill_brewer("Oranges")+
  theme(legend.position="bottom",
        axis.line=element_blank(),
        axis.text=element_blank(),
        axis.ticks=element_blank(),
        axis.title=element_blank(),
        panel.background=element_blank(),
        panel.border=element_blank(),
        panel.grid=element_blank())

#create map of 2022 employment rate gap non-disabled - disabled
us_counties %>% 
  left_join(ACS_2022_combined, by=c('region', 'subregion' )) %>%
  ggplot(aes(x=long,y=lat,group=group, fill=Employment_Rate_Gap)) +
  geom_polygon(size = 0.1) +
  #coord_map(projection = "albers", lat0 = 39, lat1 = 45) +
  coord_map(projection = "albers", lat0 = 45, lat1 = 55) +
  scale_fill_continuous(low = "blue", high = "green", limits=c(-.1,.3))+
  #scale_fill_brewer("Oranges")+
  theme(legend.position="bottom",
        axis.line=element_blank(),
        axis.text=element_blank(),
        axis.ticks=element_blank(),
        axis.title=element_blank(),
        panel.background=element_blank(),
        panel.border=element_blank(),
        panel.grid=element_blank())

#create map of 2022 LF rate gap non-disabled - disabled
us_counties %>% 
  left_join(ACS_2022_combined, by=c('region', 'subregion' )) %>%
  ggplot(aes(x=long,y=lat,group=group, fill=LF_Rate_Gap)) +
  geom_polygon( size = 0.1) +
  #coord_map(projection = "albers", lat0 = 39, lat1 = 45) +
  coord_map(projection = "albers", lat0 = 45, lat1 = 55) +
  scale_fill_continuous(low = "blue", high = "green")+
  #scale_fill_brewer("Oranges")+
  theme(legend.position="bottom",
        axis.line=element_blank(),
        axis.text=element_blank(),
        axis.ticks=element_blank(),
        axis.title=element_blank(),
        panel.background=element_blank(),
        panel.border=element_blank(),
        panel.grid=element_blank())

#create map of 2019 employment rate gap non-disabled - disabled
us_counties %>% 
  left_join(ACS_2019_combined, by=c('region', 'subregion' )) %>%
  ggplot(aes(x=long,y=lat,group=group, fill=Employment_Rate_Gap)) +
  geom_polygon(size = 0.1) +
  #coord_map(projection = "albers", lat0 = 39, lat1 = 45) +
  coord_map(projection = "albers", lat0 = 45, lat1 = 55) +
  scale_fill_continuous(low = "blue", high = "green", limits=c(-.1,.3))+
  #scale_fill_brewer("Oranges")+
  theme(legend.position="bottom",
        axis.line=element_blank(),
        axis.text=element_blank(),
        axis.ticks=element_blank(),
        axis.title=element_blank(),
        panel.background=element_blank(),
        panel.border=element_blank(),
        panel.grid=element_blank())

#create map of 2019 LF rate gap non-disabled - disabled
us_counties %>% 
  left_join(ACS_2019_combined, by=c('region', 'subregion' )) %>%
  ggplot(aes(x=long,y=lat,group=group, fill=LF_Rate_Gap)) +
  geom_polygon(size = 0.1) +
  #coord_map(projection = "albers", lat0 = 39, lat1 = 45) +
  coord_map(projection = "albers", lat0 = 45, lat1 = 55) +
  scale_fill_continuous(low = "blue", high = "green")+
  #scale_fill_brewer("Oranges")+
  theme(legend.position="bottom",
        axis.line=element_blank(),
        axis.text=element_blank(),
        axis.ticks=element_blank(),
        axis.title=element_blank(),
        panel.background=element_blank(),
        panel.border=element_blank(),
        panel.grid=element_blank())


#LF_change_ratio
us_counties %>% 
  left_join(ACS_combined, by=c('region', 'subregion' )) %>%
  ggplot(aes(x=long,y=lat,group=group, fill=LF_change_ratio)) +
  geom_polygon( size = 0.1) +
  #coord_map(projection = "albers", lat0 = 39, lat1 = 45) +
  coord_map(projection = "albers", lat0 = 45, lat1 = 55) +
  scale_fill_continuous(low = "blue", high = "green", limits=c(-5,5))+
  #scale_fill_brewer("Oranges")+
  theme(legend.position="bottom",
        axis.line=element_blank(),
        axis.text=element_blank(),
        axis.ticks=element_blank(),
        axis.title=element_blank(),
        panel.background=element_blank(),
        panel.border=element_blank(),
        panel.grid=element_blank())
