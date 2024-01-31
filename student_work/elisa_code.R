# Elisa / Start: 1/24/24 / Last update: 1/31/24
# Relationship between mineral deposits, processing level, and conflict
# Clear previous session
rm(list = ls())

#Set working directory
setwd("C:/Users/yoshiara/OneDrive - RAND Corporation/Desktop/max's class/")

#Max suggested commands
getwd()
list.files()

#Read in USGS mineral deposit data (world)
deposit <-read.csv("deposit.csv")

#Read in mining project data (Africa only)
mining <-read.csv("africapowerminingprojectsdatabase.csv")

#Read in conflict data (Africa only)
acled <- read.csv("1997-01-01-2024-01-01-Eastern_Africa-Middle_Africa-Northern_Africa-Southern_Africa-Western_Africa.csv")

#What variables do I have?
ls(acled)
ls(deposit)
ls(mining)

#Make some dataframes -- (this was just me trying to understand dfs--not useful)
df_acled <- data.frame(
  acled$event_id_cnty, 
  acled$year, 
  acled$event_type, 
  acled$country,
  acled$event_type,
  acled$latitude,
  acled$longitude)


df_deposit <- data.frame(
  deposit$gid,
  deposit$dep_name,
  deposit$country,
  deposit$commodity,
  deposit$latitude,
  deposit$longitude)

df_mining <- data.frame(
  mining$Property.Name,
  mining$Country,
  mining$Commodity,
  mining$Status,
  mining$Extent.of.Processing,
  mining$Project.Inception..Year.,
  mining$Mine.Location)

#Generate new dataframes of deposits and conflicts for Africa only
#Africa deposits
print(unique(deposit$country))

africa <- read.csv("africa.csv")

mineral_deposits_africa <- left_join(deposit, africa, by = "country")

# Remove rows with missing continent values
mineral_deposits_africa <- subset(mineral_deposits_africa, !is.na(continent))

#Africa conflict/ACLED
ls(acled)
print(unique(acled$region))
#Shoot, realized that ACLED data is already for Africa only

# Make a world map showing where mineral deposits are located.
# QUESTIONS -- how can I change the size and color of the dots based on deposit size and mineral type?
# NEXT STEPS -- do this but just for African countries.
# Install and load required packages
install.packages(c("leaflet", "leaflet.extras"))
library(leaflet)
library(leaflet.extras)
install.packages("rnaturalearth")
library(rnaturalearth)
library(sf)

# Create a leaflet map
map <- leaflet() %>%
  setView(lng = 0, lat = 0, zoom = 2)  # Set initial view to the world

# Remove rows with missing coordinates
deposit <- deposit[complete.cases(deposit), ]

# Assign a CRS to mineral_data (WGS84)
deposit_sf <- st_as_sf(deposit, coords = c("longitude", "latitude"), crs = 4326)

# Add country borders to the map
countries <- ne_countries(scale = "medium", returnclass = "sf")
countries <- st_transform(countries, crs = st_crs(deposit_sf))  # Transform to the same CRS as mineral_data_sf
map <- addPolygons(
  map,
  data = countries,
  color = "gray",  # Border color
  weight = 1,      # Border weight
  fillOpacity = 0  # No fill for country borders
)

# Add circles to the map
for (i in seq(nrow(deposit_sf))) {
  map <- addCircles(
    map,
    data = deposit_sf[i, , drop = FALSE],
    radius = 500,  # Adjust the radius as needed
    color = "blue",  # Set a single color for all circles
    fill = TRUE,
    fillOpacity = 0.2
  )
}

# Display the map
map

# Trying to summarize the number of conflict events by year within 20 miles of a mineral deposit in africa by year
# Install and load necessary packages
install.packages("dplyr")
library(sf)
library(dplyr)
library(geosphere)

#Set working directory
setwd("C:/Users/yoshiara/OneDrive - RAND Corporation/Desktop/max's class/")


#Read in USGS mineral deposit data (world)
deposit <-read.csv("deposit.csv")

#Read in conflict data (Africa only)
acled <- read.csv("1997-01-01-2024-01-01-Eastern_Africa-Middle_Africa-Northern_Africa-Southern_Africa-Western_Africa.csv")

#Generate new dataframe of deposits for Africa only (currently a global dataset)
#Africa deposits
print(unique(deposit$country))

africa <- read.csv("africa.csv")

mineral_deposits_africa <- left_join(deposit, africa, by = "country")

# Remove rows with missing continent values
mineral_deposits_africa <- subset(mineral_deposits_africa, !is.na(continent))


# Create sf objects with geometry
acled_sf <- st_as_sf(acled, coords = c("longitude", "latitude"))
africa_deposit_sf <- st_as_sf(mineral_deposits_africa, coords = c("longitude", "latitude"))

# Add buffer around mineral deposits
deposit_buffered <- st_buffer(africa_deposit_sf, dist = 20 * 1609.34)  # 20 miles to meters

# Perform spatial join
joined_data <- st_join(acled_sf, deposit_buffered, join = st_within)


# Group by deoist ID (gid) and year (from the conflict/ACLED data), summarize the count of conflict events
result <- joined_data %>%
  group_by(gid, year) %>%
  summarise(Num_Conflict_Events = n())

# Print or inspect the result
print(result)