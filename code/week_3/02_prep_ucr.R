# Prep UCR
# Max Griswold
# 12/28/23

rm(list = ls())

library(data.table)

# Load concatennated files from Jacob Kaplan

# https://www.openicpsr.org/openicpsr/project/100707/version/V17/view
# https://www.icpsr.umich.edu/web/ICPSR/studies/35158

ucr <- fread("ucr_1960_2020_offenses_known.csv")

# Remove territories or years before 2009
ucr <- ucr[!(state %in% c("", "guam", "canal zone", "puerto rico"))]
ucr <- ucr[year >= 2009,]

keep_vars <- c("ori", "geoid", "year", "state", "crosswalk_agency_name",
               "number_of_months_missing", "actual_assault_total", "population")

# Reconstruct geoid from fips codes. Only hold onto the first six characters
# for GEOID, which correspond to census-place (essentially, we're upscaling more
# granular geographies to be at the census-place level). Make sure to include
# leading zeros so that fips place code is always six characters
ucr[, fips_place_code := formatC(fips_place_code, width = 5,
                                 format = "d", flag = "0")]

ucr[, geoid := paste0(fips_state_code, fips_place_code)]
ucr[, geoid := sub("^(\\d{6})", "\\1", geoid)]

ucr <- ucr[, keep_vars, with = F]

# Remove locations missing a geoid or agency_name
ucr <- ucr[(!((geoid %like% "NA")|crosswalk_agency_name == ""))]

# Remove LEAs w/ 11+ months missing
ucr <- ucr[number_of_months_missing < 11]

# Collapse counts by year, census-place, crime-type. Also aggregate number of LEAs informing
# counts, along with cumulative months missing:
ucr[, number_of_reporting_agencies := .N, by = c("geoid", "year")]

# Reduce crime counts to those by census-place rather than by agency:
ucr[, actual_assault_total := sum(.SD$actual_assault_total, na.rm = T), by = c("geoid", "year")]
ucr[, population := sum(.SD$population, na.rm = T), by = c("geoid", "year")]

ucr <- setDT(unique(ucr[, .(geoid, year, population, actual_assault_total, 
                            number_of_months_missing, number_of_reporting_agencies)]))

# Convert counts to rates
ucr[, assault_rate_100k := (actual_assault_total/population)*100000]

# Remove small area populations:
ucr <- ucr[population >= 10000,]

write.csv(ucr, "ucr_prepped.csv", row.names = F)

# Find a reasonable distribution to match UCR for design analysis:
plot(density(ucr$assault_rate_100k))

# A gamma would probably work alright here. 
lines(density(rgamma(length(ucr$assault_rate_100k), shape = 1.18, scale = 805)), col = 'red')

# Not perfect but close enough for design investigation.