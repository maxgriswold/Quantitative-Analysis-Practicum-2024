# Identify possible treated units for AV proposal
# Max Griswold
# 1/3/24

rm(list = ls())

library(data.table)
library(plyr)
library(sf)
library(ggplot2)

# Use LEMAS series data to determine which LEAs potentially implemented a new 
# community-policing program between 2000 and 2020:

lemas_2000 <- fread("./data/lemas/2000/lemas_2000.tsv", quote = "", sep = "\t")
lemas_2020 <- fread("./data/lemas/2020/lemas_2020.tsv", quote = "", sep = "\t")

# Process LEMAS 2000. I used the codebooks in the datafolder to figure out
# these variables.

# Subset to relevant variables, then rename variables 

# NOTE: LEMAS 2000 and 2020 use different ID variables to identify agencies. We can 
# instead uniquely identify departments using state & agency name.

lemas_2000 <- lemas_2000[, .(V1, V7, V72, V138, V337)]

setnames(lemas_2000, names(lemas_2000), c("state", "agency_name", "num_fte_staff",
                                          "community_policing_plan", "community_policing_unit"))

# Add survey year to dataframe
lemas_2000[, year := 2000]

# Recode values so it now indicates the existence or non-existence of a community-policing plan
lemas_2000[, community_policing_plan := mapvalues(community_policing_plan, c(0, 1, 2, 3), c(NA, 1, 0, 0))]

# I'm reverse the coding  this variable so I can measure increases in community policing initiatives
# between 2000 & 2020.
lemas_2000[, community_policing_unit := mapvalues(community_policing_unit, 0:4, c(NA, 3:0))]

# Recode state to state-abbreviations to match LEMAS 2020

state_recode <- fread("./data/helper/state_recode.csv")
lemas_2000[, state := mapvalues(state, sort(unique(lemas_2000$state)), state_recode$state_abbrev)]
lemas_2000[, lemas_id := sprintf("%s, %s", agency_name, state)]

# Process LEMAS 2020:

lemas_2020 <- lemas_2020[, .(STATE, AGENCYNAME, ZIP, ORI9, TOTFTEMP_2019, FDBK_CRIME, FDBK_NHOOD, FDBK_PERFRM, CP_CAC, CP_PLAN, CP_CPACAD, ISSU_ADDR_CP)]

setnames(lemas_2020, names(lemas_2020), c("state", "agency_name", "zip_code", "ori", "num_fte_staff", 
                                          "community_feedback_crime_problems", "community_feedback_resources",
                                          "community_feedback_agency_performance", "community_advisory_committee",
                                          "community_policing_plan", "citizen_policy_academy", "community_policing_unit"))

lemas_2020[, lemas_id := sprintf("%s, %s", agency_name, state)]
lemas_2020[, year := 2020]

# Replace all missing codes with NA:
lemas_2020[lemas_2020 == -8] <- NA
lemas_2020[lemas_2020 == -9] <- NA

# Recodes based off codebook provided by ICPSR (see folder for LEMAS)
lemas_2020[, community_feedback_crime_problems := mapvalues(community_feedback_crime_problems, c(1, 2), c(1, 0))]
lemas_2020[, community_feedback_resources := mapvalues(community_feedback_resources, c(1, 2), c(1, 0))]
lemas_2020[, community_feedback_agency_performance := mapvalues(community_feedback_agency_performance, c(1, 2), c(1, 0))]
lemas_2020[, community_advisory_committee := mapvalues(community_advisory_committee, c(1, 2), c(1, 0))]
lemas_2020[, community_policing_plan := mapvalues(community_policing_plan, c(1, 2), c(1, 0))]
lemas_2020[, citizen_policy_academy := mapvalues(citizen_policy_academy, c(1, 2), c(1, 0))]

lemas_2020[, community_policing_unit := mapvalues(community_policing_unit, 1:5, c(3, 2, 1, 0, 0))]

# Unfortunately, LEMAS 2000 & 2020 use slightly different agency names
# (for example, 2000 calls Yakima, "Yakima Police Dept", while 2020 calls it "Yakima Police Department")
# So modify names to better match:

lemas_2000[, lemas_id := gsub("SHERIFF DEPARTMENT", "SHERIFF'S DEPARTMENT", lemas_id)]
lemas_2000[, lemas_id := gsub("SHERIFF OFFICE", "SHERIFF'S DEPARTMENT", lemas_id)]
lemas_2000[, lemas_id := gsub("POLICE DEPT", "POLICE DEPARTMENT", lemas_id)]

# There is technically a difference between sheriff offices and departments (offices 
# are not a part of county government). However, both LEMAS series refers to the same
# office/department using the language interchangeably, as does the DOJ OJP
# LEA location data. Perhaps these departments are changing over time. But for the
# purpose of merging, let's erase the distinction.
lemas_2020[, lemas_id := gsub("SHERIFF'S OFFICE", "SHERIFF'S DEPARTMENT", lemas_id)]

# Subset each survey to LEAs that exist in both:
common_lea <- intersect(lemas_2000$lemas_id, lemas_2020$lemas_id)
common_zip <- lemas_2020[lemas_id %in% common_lea, .(zip_code, lemas_id)]

hold_vars <- c("lemas_id", "year", "num_fte_staff", 
               "community_policing_plan", "community_policing_unit")

# Hold onto variables which exist in both datasets
lemas_2000_sub <- lemas_2000[lemas_id %in% common_lea, hold_vars, with = F]
lemas_2020_sub <- lemas_2020[lemas_id %in% common_lea, hold_vars, with = F]

# Combine the two series
lemas_change <- rbind(lemas_2000_sub, lemas_2020_sub)

# Reshape dataset wide
lemas_change <- dcast(lemas_change, lemas_id ~ year, value.var = hold_vars[3:5])

lemas_change <- setDT(join(lemas_change, common_zip, by = "lemas_id", type = "left"))

lemas_change[, change_community_policing_unit := community_policing_unit_2020 - community_policing_unit_2000]
lemas_change[, change_community_policing_plan := community_policing_plan_2020 - community_policing_plan_2000]

# Make variable values readable within the figure
lemas_change[, change_community_policing_plan := mapvalues(change_community_policing_plan, -1:1, c("Removed CP plan", "No change", "Made CP plan"))]
lemas_change[, change_community_policing_unit := mapvalues(change_community_policing_unit, -3:3, 
                                                           c(rep("Less resources", 3), "No change", rep("More resources", 3)))]

# Remove locations which are NA for both variables:
lemas_change <- lemas_change[!(is.na(change_community_policing_unit) & is.na(change_community_policing_plan))]

# Remove two locations with NA or 0 for FTE staff:
lemas_change <- lemas_change[!(is.na(num_fte_staff_2020)|(num_fte_staff_2020 == 0))]

# Bin department sizes for map comparison (made decision on cutpoints by  
# investigating quantiles)
lemas_change[, num_fte_bin := cut(num_fte_staff_2020, 
                                  breaks = c(1, 101, 251, 1001, 60000),
                                  labels = c("1 - 100", "101 - 250", 
                                             "251 - 1000", "1000+"),
                                  include.lowest = T)]

# Zip code addresses are uniquely identifying for agencies. So we can use this and Census
# TIGER files to create a map, rather than try hassling with CSLLEA from DOJ - OJP (which
# would need to be geocoded).

# Tiger file is too big to put in the repo so I'm putting this here in case
# someone wanted to replicate this script.

# File is ~500mb so depending on internet speed, may take some time on your machine.
tiger_zip <- "https://www2.census.gov/geo/tiger/TIGER2020/ZCTA5/tl_2020_us_zcta510.zip"

# R times out too quickly on requests. So provide a little more time
options(timeout = 240)

grab_tiger <- function(tiger){
  
  temp <- tempfile()
  download.file(tiger, temp)
  temp_shape <- tempfile()
  unzip(temp, exdir = temp_shape)
  
  df <- st_read(dsn = temp_shape)
  return(df)
  
}

zip_loc <- grab_tiger(tiger_zip)
setDT(zip_loc)

zip_loc <- zip_loc[, .(ZCTA5CE10, geometry)]
setnames(zip_loc, "ZCTA5CE10", "zcta")

#Remove leading zeros from zip codes:
zip_loc[, zcta := as.numeric(zcta)]

# Files won't be a perfect match since census zipcodes (ZCTA) are slightly different
# than USPS zipcodes in LEMAS. So I grabbed a crosswalk file we can use:
zip_to_zcta <- fread("./data/helper/zip_zcta_cw.csv")
setnames(zip_to_zcta, "ZIP_CODE", "zip_code")

zip_loc <- join(zip_loc, zip_to_zcta, by = "zcta", type = "left")

lemas_change <- st_as_sf(join(lemas_change, zip_loc, by = "zip_code", type = "left"))

# Standardize department sizes by using points instead of polygons for
# zip codes:
lemas_change <- st_centroid(lemas_change)

# Get state boundaries to make plot more readable:
bounds <- st_read(dsn = "./data/helper/state_bounds")

# Keep to continental USA
remove <- c("Commonwealth of the Northern Mariana Islands", "United States Virgin Islands",
            "Alaska", "Hawaii", "Guam", "Puerto Rico", "American Samoa")

bounds <- bounds[!(bounds$NAME %in% remove),]
map_colors <- c('#d4515f','#6c91bb','#d691c1')

p <- ggplot() +
      geom_sf(data = bounds, fill = "#ebeae9", color = "#7e7e7d", size = 1, alpha = 0.9) +
      geom_sf(data = lemas_change, aes(color = change_community_policing_unit, size = num_fte_bin), alpha = 0.7) +
      scale_color_manual(na.value = 'transparent', na.translate = F,
                         values = map_colors) +
      scale_size_discrete(range = c(1, 4)) +
      coord_sf(xlim = c(-125, -67), ylim = c(24, 50)) +
      theme_void() +
      labs(color = "Change to community policing services", 
           size = "Department size (FTE staff)") +
      guides(size = guide_legend(nrow = 1, byrow = T, order = 2),
             color = guide_legend(nrow = 1, byrow = T, order = 1)) +
      theme(legend.position = "bottom",
            legend.direction = "vertical",
            legend.box = "vertical",
            legend.title.align = 0,
            plot.title = element_text(hjust = 0),
            legend.text = element_text(family = 'serif', size = 12))

ggsave(p, filename = "lemas_possible_treated.pdf", device = "pdf", 
       bg = "transparent", width = 11.7, height = 8.3, units = "in")
