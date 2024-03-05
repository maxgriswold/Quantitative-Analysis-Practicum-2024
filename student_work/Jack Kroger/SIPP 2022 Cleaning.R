# Script to Read in Already Downloaded 2022 SIPP Data and Clean and Add Relevant Variables
# Last Updated 2 March 2024
# Jack Kroger

library(dplyr)
library(tidyverse)
library(survey)
library(haven)

#Read in Data
sipp_df = readRDS("Data/sipp202212.rds")

# Subset for just those older than 15 (definitional) and type one people
sipp_df = subset(sipp_df, tage>15 & pnum==101)

# The data has 486238 observations, but this includes multiple observations for different people
# We create a unique identifier for each unit by combining the household ID with the person number
sipp_df$persid = paste0(sipp_df$ssuid, sipp_df$pnum)
length(unique(sipp_df$persid))

# Data also exists for three panels in the 2022 SIPP (the 2020, 2021, and 2022 panels)
# For now, we'll keep all three
table(sipp_df$panel)

# Add a New Race Variable
sipp_df$race = NA
sipp_df$race = ifelse(sipp_df$erace==1 & sipp_df$eorigin==2, "White, non-Hispanic", sipp_df$race)
sipp_df$race = ifelse(sipp_df$erace==2 & sipp_df$eorigin==2, "Black, non-Hispanic", sipp_df$race)
sipp_df$race = ifelse(sipp_df$erace==3 & sipp_df$eorigin==2, "Asian, non-Hispanic", sipp_df$race)
sipp_df$race = ifelse(sipp_df$erace==4 & sipp_df$eorigin==2, "Other / More Than One Race", sipp_df$race)
sipp_df$race = ifelse(sipp_df$eorigin==1, "Hispanic", sipp_df$race)

# Add Education Variable
sipp_df$educ = NA
sipp_df$educ = ifelse(sipp_df$eeduc < 39, "Less Than Highschool", sipp_df$educ)
sipp_df$educ = ifelse(sipp_df$eeduc == 39, "Highschool Degree", sipp_df$educ)
sipp_df$educ = ifelse(sipp_df$eeduc > 39 & sipp_df$eeduc < 43, "Some College", sipp_df$educ)
sipp_df$educ = ifelse(sipp_df$eeduc >= 43, "Bachelors Degree", sipp_df$educ)

# Add Sex Marital Status Variable
sipp_df$married = ifelse(sipp_df$ems<=2, 1, 0)
sipp_df$female = ifelse(sipp_df$esex==2, 1, 0)

# We'll also want to use age (tage)

# Add a new State Variable
sipp_df$state_name = factor(as.numeric(sipp_df$tehc_st),
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
                               "Wyoming", "Puerto Rico", "Foreign Country"))

# Will Need to Create a Dummy That Says if The Individual Was Ever Unemployed in the Year
# Also if they ever received EC benefits and their amount
# We'll also want to add on variables for hardship and debt (inability to pay mortgage/rent or utility bills)
# And calculate maximum levels of total debt and credit card debt
table(sipp_df$enjflag) # indicates the presence of a no-job spell during the month n = 194432
table(sipp_df$enj_layoff) # indicates being laidoff at any point in the month n=5359
table(sipp_df$enj_bmonth) # indicates beginning month of time away from work
table(sipp_df$ejb1_awop1) # indicates having any time away from work without pay n=20089
table(sipp_df$ejb1_awopre1) # reasons for being away from work
table(sipp_df$eucany) # received any unemployment comp payments n = 14986
table(sipp_df$euctyp1yn) # received government unemployment comp n = 14122

unique_respondents = as.vector(unique(sipp_df$persid))

#sipp_df$unemployed= NA
#sipp_df$laidoff= NA
#sipp_df$ec_received= NA
#sipp_df$ec_govt= NA
#sipp_df$ec_amount = NA
#sipp_df$income = NA
#sipp_df$mortgage = NA
#sipp_df$utility = NA
#sipp_df$totaldebt = NA
#sipp_df$ccdebt = NA
#sipp_df$unsecuredebt = NA

unemployed = vector("numeric", length(unique_respondents))
laidoff = vector("numeric", length(unique_respondents))
ec_received = vector("numeric", length(unique_respondents))
ec_govt = vector("numeric", length(unique_respondents))
ec_amount = vector("numeric", length(unique_respondents))
income = vector("numeric", length(unique_respondents))
mortgage = vector("numeric", length(unique_respondents))
utility = vector("numeric", length(unique_respondents))
totaldebt = vector("numeric", length(unique_respondents))
ccdebt = vector("numeric", length(unique_respondents))
unsecuredebt = vector("numeric", length(unique_respondents))


for (i in 1:length(unique_respondents)) {
  person = subset(sipp_df, persid == unique_respondents[[i]])
  unemployed[i] = ifelse(1 %in% person$enjflag, 1, 0)
  laidoff[i] = ifelse(1 %in% person$enj_layoff, 1, 0)
  ec_received[i] = ifelse(1 %in% person$eucany, 1, 0)
  ec_govt[i] = ifelse(1 %in% person$euctyp1yn, 1, 0)
  ec_amount[i] = sum(person$tuc1amt, na.rm=T)
  income[i] = sum(person$tftotinc, na.rm=T)
  mortgage[i] = ifelse(1 %in% person$eawbmort, 1, 0)
  utility[i] = ifelse(1 %in% person$eawbgas, 1, 0)
  totaldebt[i] = max(person$tdebt_ast, na.rm=T)
  ccdebt[i] = max(person$tdebt_cc, na.rm=T)
  unsecuredebt[i] = max(person$tdebt_usec, na.rm=T)
  
  print(i)
  #indices = which(sipp_df$persid %in% unique_respondents[i])
  #sipp_df[indices, "unemployed"] = pers_unemployed
  #sipp_df[indices, "laidoff"] = pers_laidoff
  #sipp_df[indices, "ec_received"] = pers_ec_received
  #sipp_df[indices, "ec_govt"] = pers_ec_govt
  #sipp_df[indices, "ec_amount"] = pers_ec_amount
  #sipp_df[indices, "income"] = pers_income
  #sipp_df[indices, "mortgage"] = pers_mortgage
  #sipp_df[indices, "utility"] = pers_utility
  #sipp_df[indices, "totaldebt"] = pers_totaldebt
  #sipp_df[indices, "ccdebt"] = pers_ccdebt
  #sipp_df[indices, "unsecuredebt"] = pers_unsecuredebt
}

# Combine each of these vectors and merge onto the sipp dataframe
yearly_data = data.frame(persid = unique_respondents,
                         unemployed = unemployed,
                         laidoff = laidoff,
                         ec_received = ec_received,
                         ec_govt = ec_govt,
                         ec_amount = ec_amount,
                         income = income,
                         mortgage = mortgage,
                         utility = utility,
                         totaldebt = totaldebt,
                         ccdebt = ccdebt,
                         unsecuredebt = unsecuredebt)

sipp_overall = left_join(sipp_df, yearly_data)

# Finally, we will keep just one selection of individuals, so use just December's data and save as csv
# Now have 17144 observations, 8982 who were unemployed at any time and 654 of whom received UC
sipp_overall = subset(sipp_overall, monthcode==12)
table(sipp_overall$unemployed)
table(sipp_overall$laidoff)

# Read in the Policies to Try to Make an Eligibility Criteria
# Eligibility includes working a job in the year, unemployment duration lasting at least a month, and income threshold
policies = read_csv("Data/State Level UI Qualifying Rules.csv")
sipp_overall$state = tolower(sipp_overall$state_name)
sipp_overall = left_join(sipp_overall, policies)

sipp_overall$quart_income = sipp_overall$income / 4

sipp_overall$unemp_dur = sipp_overall$enj_emonth - sipp_overall$enj_bmonth

sipp_overall$eligible = ifelse(sipp_overall$quart_income > sipp_overall$quarterly_rate &
                                 sipp_overall$unemp_dur>1 &
                                 sipp_overall$ejb1_scrnr==2, 1, 0)

table(sipp_overall$eligible, sipp_overall$unemployed) # Leaves us with 6819 eligible individuals

# Write CSV for Later Data Work
write_csv(sipp_overall, "Data/sipp 2022 consolidated.csv")



# We can also do a bit of survey analysis here, setting up a survey frame and getting descriptive statistics

sipp_design = svrepdesign(data = sipp_overall,
                          weights = ~ wpfinwgt,
                          repweights = "repwgt([1-9]+)",
                          type = "Fay",
                          rho = 0.5)

svymean(~ unemployed, sipp_design, na.rm=T)
svyby(~ unemployed, ~race, sipp_design, svymean, na.rm=T)
weighted.mean(sipp_overall$unemployed, sipp_overall$wpfinwgt)
sipp_overall %>% group_by(race) %>%
  summarise(perc_unemployed = weighted.mean(unemployed, wpfinwgt))

svymean(~ ec_received, sipp_design, na.rm=T)
svyby(~ ec_received, ~race, sipp_design, svymean, na.rm=T)
weighted.mean(sipp_overall$ec_received, sipp_overall$wpfinwgt)
sipp_overall %>% group_by(race) %>%
  summarise(perc_rec_benefits = weighted.mean(ec_received, wpfinwgt))

sub_design = subset(sipp_design, unemployed==1 & eligible==1)

ec_receipt = svyby(~ ec_received, ~race, sub_design, svymean, na.rm=T)
ec_receipt

# We can graph income and total debt and look at them based on unemployment status
ggplot(subset(sipp_overall, income<1000000), aes(x = income, y = ccdebt, color = as.factor(unemployed))) +
  geom_point()

# Look just at those who are unemployed and eligible break out the group who receive UC benefits
sipp_subset = subset(sipp_overall, laidoff==1)

ggplot(subset(sipp_subset, income<1000000), aes(x = income, y = ccdebt, color = as.factor(ec_received))) +
  geom_point()

ggplot(subset(sipp_subset, income<250000 & ccdebt<250000), aes(x = log(income), y = log(ccdebt), color = as.factor(ec_received))) +
  geom_point()

sipp_subset %>% group_by(race) %>%
  summarise(perc_rec_benefits = weighted.mean(ec_received, wpfinwgt),
            amt_benefits = weighted.mean(ec_amount, wpfinwgt))