# Elisa / Start: 1/24/24 / Last update: 1/31/24
# Relationship between mineral deposits, processing level, and conflict
# Clear previous session
rm(list = ls())

#Set working directory
setwd("C:/Users/yoshiara/OneDrive - RAND Corporation/Desktop/max's class/")

#Max suggested uploads
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
print(unique(deposit$country))
africa <- read.csv*ad
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