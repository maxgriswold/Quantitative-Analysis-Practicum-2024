## Script to Load SIPP Data Saved From Lodown and Analyze Using Survey Package
## Jack Kroger
## Last Updated 29 January 2024


library(tidyverse)
library(survey)


#Read in Data
sipp_df = readRDS("Data/sipp202212.rds")


# Construct the survey design
sipp_design = svrepdesign(data = sipp_df,
                          weights = ~ wpfinwgt,
                          repweights = "repwgt([1-9]+)",
                          type = "Fay",
                          rho = 0.5)


# We're able to (relatively easily) recode variables of interest - I'll just do state name for now
sipp_design = update(sipp_design,
                     state_name = factor(as.numeric(tehc_st),
                                         levels = c(1L, 2L, 4L, 5L, 6L, 8L, 9L, 10L, 11L,
                                                    12L, 13L, 15L, 16L, 17L, 18L, 19L, 20L,
                                                    21L, 22L, 23L, 24L, 25L, 26L, 27L, 28L,
                                                    29L, 30L, 31L, 32L, 33L, 34L, 35L, 36L,
                                                    37L, 38L, 39L, 40L, 41L, 42L, 44L, 45L,
                                                    46L, 47L, 48L, 49L, 50L, 51L, 53L, 54L,
                                                    55L, 56L, 60L, 61L),
                                         labels = c("Alabama", "Alaska", "Arizona", "Arkansas",
                                                    "California", "Colorado", "Connecticut", "Delaware",
                                                    "DC", "Florida", "Georgia", "Hawaii", "Idaho", "Illinois",
                                                    "Indiana", "Iowa", "Kansas", "Kentucky", "Louisiana", "Maine",
                                                    "Maryland", "Massachusetts", "Michigan", "Minnesota", "Mississippi", "Missouri",
                                                    "Montana", "Nebraska", "Nevada", "New Hampshire", "New Jersey", "New Mexico",
                                                    "New York", "North Carolina", "North Dakota", "Ohio", "Oklahoma", "Oregon",
                                                    "Pennsylvania", "Rhode Island", "South Carolina", "South Dakota", "Tennessee",
                                                    "Texas", "Utah", "Vermont", "Virginia", "Washington", "West Virginia", "Wisconsin",
                                                    "Wyoming", "Puerto Rico", "Foreign Country")),
                     unemployed = ifelse(ejb1_awop1==1, 1, 0),
                     receive_ec = ifelse(eucany==1, 1, 0))


# Can Now Generate Some Rough Statistics For Being Unemployed at Any Time by Race
svyby(~ unemployed, ~erace, sipp_design, svymean, na.rm=T)

# Also for Receiving Unemployment Compensation At Any Time
svyby(~ receive_ec, ~erace, sipp_design, svymean, na.rm=T)


# Can take a subset of just the unemployed workers and recalculate receipt
sub_sipp_design = subset(sipp_design, unemployed==1)

svyby(~ receive_ec, ~erace, sub_sipp_design, svymean, na.rm=T)
