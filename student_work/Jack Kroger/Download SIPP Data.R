## Script to Read in SIPP Data Using the Lodown Package
## Jack Kroger
## Last Updated 28 January 2024


# If not installed, download the lodown package from github
#devtools::install_github("ajdamico/lodown", dependencies=T)

library(lodown)
library(httr)
library(data.table)


# This package will allow us to download survey of income and program participation (SIPP) data which contains information on employment and UC receipt

# Start by downloading the 2022 data
main_tf = tempfile()
main_url = paste0("https://www2.census.gov/programs-surveys/sipp/",
                  "data/datasets/2022/pu2022_csv.zip")
GET(main_url, write_disk(main_tf), progress())
main_csv = unzip(main_tf, exdir = tempdir())

# Convert file to dataframe
sipp_main_dt = fread(main_csv, sep = "|")
sipp_main_df = data.frame(sipp_main_dt)
names(sipp_main_df) = tolower(names(sipp_main_df))


# Do very similar process to get the replicate weights file
rw_tf = tempfile()
rw_url = paste0("https://www2.census.gov/programs-surveys/sipp/",
                "data/datasets/2022/rw2022_csv.zip")
GET(rw_url, write_disk(rw_tf), progress())
rw_csv = unzip(rw_tf, exdir = tempdir())

# Convert file to dataframe
sipp_rw_dt = fread(rw_csv, sep = "|")
sipp_rw_df = data.frame(sipp_rw_dt)
names(sipp_rw_df) = tolower(names(sipp_rw_df))


# Limit to December records for just point-in-time estimates and then merge
#sipp_df = merge(sipp_main_df[sipp_main_df[,'monthcode'] %in% 12,],
#                sipp_rw_df[sipp_rw_df[, 'monthcode'] %in% 12,],
#               by = c('ssuid', 'pnum', 'monthcode', 'spanel', 'swave'))

sipp_df = merge(sipp_main_df, sipp_rw_df, by = c('ssuid', 'pnum', 'monthcode', 'spanel', 'swave'))

# Save files locally
saveRDS(sipp_df, file = "Data/sipp202212.rds", compress=F)