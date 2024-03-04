# Script to Combine the 2012, 2015, 2018 and 2021 NFCS Data
# Last Updated 28 February 2024


# Read in the Data
nfcs_2012 <- read.csv("Data/NFCS 2012 State Data 130503.csv")
nfcs_2015 <- read.csv("Data/NFCS 2015 State Data 160619.csv")
nfcs_2018 <- read.csv("Data/NFCS 2018 State Data 190603.csv")
nfcs_2021 <- read.csv("Data/NFCS 2021 State Data 220627.csv")

# Subset Just for Unemployed Households
nfcs_2012_unemp <- subset(nfcs_2012, A9==7 | A10==7)
nfcs_2015_unemp <- subset(nfcs_2015, A9==7 | A10==7)
nfcs_2018_unemp <- subset(nfcs_2018, A9==7 | A10==7)
nfcs_2021_unemp <- subset(nfcs_2021, J52==1 | A9==7 | A10==7)


# Create 2012 Dummy Variables
nfcs_2012_unemp$gigwork <- NA
nfcs_2012_unemp$overdraw <- ifelse(nfcs_2012_unemp$B4==1, 1, 0)
nfcs_2012_unemp$retirement_loan <- ifelse(nfcs_2012_unemp$C10_2012==1, 1, 0)
nfcs_2012_unemp$hardship_withdraw <- ifelse(nfcs_2012_unemp$C11_2012==1, 1, 0)
nfcs_2012_unemp$late_mortgage <- ifelse(nfcs_2012_unemp$E15==2 | nfcs_2012_unemp$E15==3, 1, 0)
nfcs_2012_unemp$card_balance <- ifelse(nfcs_2012_unemp$F2_2==1, 1, 0)
nfcs_2012_unemp$card_min <- ifelse(nfcs_2012_unemp$F2_3==1, 1, 0)
nfcs_2012_unemp$card_late <- ifelse(nfcs_2012_unemp$F2_4==1, 1, 0)
nfcs_2012_unemp$card_limit <- ifelse(nfcs_2012_unemp$F2_5==1, 1, 0)
nfcs_2012_unemp$card_advance <- ifelse(nfcs_2012_unemp$F2_6==1, 1, 0)
nfcs_2012_unemp$card_balance <- ifelse(nfcs_2012_unemp$F2_2==1, 1, 0)
nfcs_2012_unemp$late_std_debt <- ifelse(nfcs_2012_unemp$G22==1, 1, 0)
nfcs_2012_unemp$auto_title <- ifelse(nfcs_2012_unemp$G25_1>1 & nfcs_2012_unemp$G25_1<6, 1, 0)
nfcs_2012_unemp$payday <- ifelse(nfcs_2012_unemp$G25_2>1 & nfcs_2012_unemp$G25_2<6, 1, 0)
nfcs_2012_unemp$collections <- NA
nfcs_2012_unemp$toomuchdebt <- ifelse(nfcs_2012_unemp$G23==7, 1, 0)
nfcs_2012_unemp$race <- ifelse(nfcs_2012_unemp$A4A_new_w==1, "White, non-Hispanic", "Non-White")
nfcs_2012_unemp$sex <- ifelse(nfcs_2012_unemp$A3==1, "Male", "Female")
nfcs_2012_unemp$educ = NA
nfcs_2012_unemp$educ = ifelse(nfcs_2012_unemp$A5_2012==1, "Less Than HS", nfcs_2012_unemp$educ)
nfcs_2012_unemp$educ = ifelse(nfcs_2012_unemp$A5_2012==2 | nfcs_2012_unemp$A5_2012==3, "HS Grad", nfcs_2012_unemp$educ)
nfcs_2012_unemp$educ = ifelse(nfcs_2012_unemp$A5_2012==4, "Some College", nfcs_2012_unemp$educ)
nfcs_2012_unemp$educ = ifelse(nfcs_2012_unemp$A5_2012==5 | nfcs_2012_unemp$A5_2012==6, "College Grad", nfcs_2012_unemp$educ)
nfcs_2012_unemp$region <- factor(nfcs_2012_unemp$CENSUSREG, 
                                 label = c("Northeast", "Midwest", "South", "West"))
nfcs_2012_unemp$division <- factor(nfcs_2012_unemp$CENSUSDIV, 
                                   label = c("New England", "Mid Atlantic", "E N Central", "W N Central",
                                             "S Atlantic", "E S Central", "W S Central", "Mountain",
                                             "Pacific"))
nfcs_2012_unemp$state <- factor(nfcs_2012_unemp$STATEQ, 
                                label = c("Alabama", "Alaska", "Arizona", "Arkansas", "California",
                                          "Colorado", "Connecticut", "Delaware", "DC", "Florida",
                                          "Georgia", "Hawaii", "Idaho", "Illinois", "Indiana", "Iowa",
                                          "Kansas", "Kentucky", "Louisiana", "Maine", "Maryland",
                                          "Massachusetts", "Michigan", "Minnesota", "Mississippi",
                                          "Missouri", "Montana", "Nebraska", "Nevada", "New Hampshire",
                                          "New Jersey", "New Mexico", "New York", "North Carolina",
                                          "North Dakota", "Ohio", "Oklahoma", "Oregon", "Pennsylvania",
                                          "Rhode Island", "South Carolina", "South Dakota", "Tennessee",
                                          "Texas", "Utah", "Vermont", "Virginia", "Washington", 
                                          "West Virginia", "Wisconsin", "Wyoming"))
nfcs_2012_unemp$agegroup <- factor(nfcs_2012_unemp$A3Ar_w, 
                                   label = c("18-24", "25-34", "35-44", "45-54", "55-64", "65+"))
nfcs_2012_unemp$lt50k <- ifelse(nfcs_2012_unemp$A8<5, 1, 0)
nfcs_2012_unemp$income <- "Less than $25,000"
nfcs_2012_unemp$income <- ifelse(nfcs_2012_unemp$A8==3 | nfcs_2012_unemp$A8==4, "$25,000 to $50,000", nfcs_2012_unemp$income)
nfcs_2012_unemp$income <- ifelse(nfcs_2012_unemp$A8==5 | nfcs_2012_unemp$A8==6, "$50,000 to $100,000", nfcs_2012_unemp$income)
nfcs_2012_unemp$income <- ifelse(nfcs_2012_unemp$A8==7 | nfcs_2012_unemp$A8==8, "more than $100,000", nfcs_2012_unemp$income)
nfcs_2012_unemp$year <- 2012

# Create 2015 Dummy Variables
nfcs_2015_unemp$gigwork <- NA
nfcs_2015_unemp$overdraw <- ifelse(nfcs_2015_unemp$B4==1, 1, 0)
nfcs_2015_unemp$retirement_loan <- ifelse(nfcs_2015_unemp$C10_2012==1, 1, 0)
nfcs_2015_unemp$hardship_withdraw <- ifelse(nfcs_2015_unemp$C11_2012==1, 1, 0)
nfcs_2015_unemp$late_mortgage <- ifelse(nfcs_2015_unemp$E15_2015==2 | nfcs_2015_unemp$E15_2015==3, 1, 0)
nfcs_2015_unemp$card_balance <- ifelse(nfcs_2015_unemp$F2_2==1, 1, 0)
nfcs_2015_unemp$card_min <- ifelse(nfcs_2015_unemp$F2_3==1, 1, 0)
nfcs_2015_unemp$card_late <- ifelse(nfcs_2015_unemp$F2_4==1, 1, 0)
nfcs_2015_unemp$card_limit <- ifelse(nfcs_2015_unemp$F2_5==1, 1, 0)
nfcs_2015_unemp$card_advance <- ifelse(nfcs_2015_unemp$F2_6==1, 1, 0)
nfcs_2015_unemp$card_balance <- ifelse(nfcs_2015_unemp$F2_2==1, 1, 0)
nfcs_2015_unemp$late_std_debt <- ifelse(nfcs_2015_unemp$G35==4 | nfcs_2015_unemp$G35==4, 1, 0)
nfcs_2015_unemp$auto_title <- ifelse(nfcs_2015_unemp$G25_1>1 & nfcs_2015_unemp$G25_1<6, 1, 0)
nfcs_2015_unemp$payday <- ifelse(nfcs_2015_unemp$G25_2>1 & nfcs_2015_unemp$G25_2<6, 1, 0)
nfcs_2015_unemp$collections <- ifelse(nfcs_2015_unemp$G38==1, 1, 0)
nfcs_2015_unemp$toomuchdebt <- ifelse(nfcs_2015_unemp$G23==7, 1, 0)
nfcs_2015_unemp$race <- ifelse(nfcs_2015_unemp$A4A_new_w==1, "White, non-Hispanic", "Non-White")
nfcs_2015_unemp$sex <- ifelse(nfcs_2015_unemp$A3==1, "Male", "Female")
nfcs_2015_unemp$educ = NA
nfcs_2015_unemp$educ = ifelse(nfcs_2015_unemp$A5_2015==1, "Less Than HS", nfcs_2015_unemp$educ)
nfcs_2015_unemp$educ = ifelse(nfcs_2015_unemp$A5_2015==2 | nfcs_2015_unemp$A5_2015==3, "HS Grad", nfcs_2015_unemp$educ)
nfcs_2015_unemp$educ = ifelse(nfcs_2015_unemp$A5_2015==4, "Some College", nfcs_2015_unemp$educ)
nfcs_2015_unemp$educ = ifelse(nfcs_2015_unemp$A5_2015==5 | nfcs_2015_unemp$A5_2015==6 |
                                nfcs_2015_unemp$A5_2015==7, "College Grad", nfcs_2015_unemp$educ)
nfcs_2015_unemp$region <- factor(nfcs_2015_unemp$CENSUSREG, 
                                 label = c("Northeast", "Midwest", "South", "West"))
nfcs_2015_unemp$division <- factor(nfcs_2015_unemp$CENSUSDIV, 
                                   label = c("New England", "Mid Atlantic", "E N Central", "W N Central",
                                             "S Atlantic", "E S Central", "W S Central", "Mountain",
                                             "Pacific"))
nfcs_2015_unemp$state <- factor(nfcs_2015_unemp$STATEQ, 
                                label = c("Alabama", "Alaska", "Arizona", "Arkansas", "California",
                                          "Colorado", "Connecticut", "Delaware", "DC", "Florida",
                                          "Georgia", "Hawaii", "Idaho", "Illinois", "Indiana", "Iowa",
                                          "Kansas", "Kentucky", "Louisiana", "Maine", "Maryland",
                                          "Massachusetts", "Michigan", "Minnesota", "Mississippi",
                                          "Missouri", "Montana", "Nebraska", "Nevada", "New Hampshire",
                                          "New Jersey", "New Mexico", "New York", "North Carolina",
                                          "North Dakota", "Ohio", "Oklahoma", "Oregon", "Pennsylvania",
                                          "Rhode Island", "South Carolina", "South Dakota", "Tennessee",
                                          "Texas", "Utah", "Vermont", "Virginia", "Washington", 
                                          "West Virginia", "Wisconsin", "Wyoming"))
nfcs_2015_unemp$agegroup <- factor(nfcs_2015_unemp$A3Ar_w, 
                                   label = c("18-24", "25-34", "35-44", "45-54", "55-64", "65+"))
nfcs_2015_unemp$lt50k <- ifelse(nfcs_2015_unemp$A8<5, 1, 0)
nfcs_2015_unemp$income <- "Less than $25,000"
nfcs_2015_unemp$income <- ifelse(nfcs_2015_unemp$A8==3 | nfcs_2015_unemp$A8==4, "$25,000 to $50,000", nfcs_2015_unemp$income)
nfcs_2015_unemp$income <- ifelse(nfcs_2015_unemp$A8==5 | nfcs_2015_unemp$A8==6, "$50,000 to $100,000", nfcs_2015_unemp$income)
nfcs_2015_unemp$income <- ifelse(nfcs_2015_unemp$A8==7 | nfcs_2015_unemp$A8==8, "more than $100,000", nfcs_2015_unemp$income)
nfcs_2015_unemp$year <- 2015

# Create 2018 Dummy Variables
nfcs_2018_unemp$gigwork <- ifelse(nfcs_2018_unemp$A40==1, 1, 0)
nfcs_2018_unemp$overdraw <- ifelse(nfcs_2018_unemp$B4==1, 1, 0)
nfcs_2018_unemp$retirement_loan <- ifelse(nfcs_2018_unemp$C10_2012==1, 1, 0)
nfcs_2018_unemp$hardship_withdraw <- ifelse(nfcs_2018_unemp$C11_2012==1, 1, 0)
nfcs_2018_unemp$late_mortgage <- ifelse(nfcs_2018_unemp$E15_2015==2 | nfcs_2018_unemp$E15_2015==3, 1, 0)
nfcs_2018_unemp$card_balance <- ifelse(nfcs_2018_unemp$F2_2==1, 1, 0)
nfcs_2018_unemp$card_min <- ifelse(nfcs_2018_unemp$F2_3==1, 1, 0)
nfcs_2018_unemp$card_late <- ifelse(nfcs_2018_unemp$F2_4==1, 1, 0)
nfcs_2018_unemp$card_limit <- ifelse(nfcs_2018_unemp$F2_5==1, 1, 0)
nfcs_2018_unemp$card_advance <- ifelse(nfcs_2018_unemp$F2_6==1, 1, 0)
nfcs_2018_unemp$card_balance <- ifelse(nfcs_2018_unemp$F2_2==1, 1, 0)
nfcs_2018_unemp$late_std_debt <- ifelse(nfcs_2018_unemp$G35==4 | nfcs_2018_unemp$G35==4, 1, 0)
nfcs_2018_unemp$auto_title <- ifelse(nfcs_2018_unemp$G25_1>1 & nfcs_2018_unemp$G25_1<6, 1, 0)
nfcs_2018_unemp$payday <- ifelse(nfcs_2018_unemp$G25_2>1 & nfcs_2018_unemp$G25_2<6, 1, 0)
nfcs_2018_unemp$collections <- ifelse(nfcs_2018_unemp$G38==1, 1, 0)
nfcs_2018_unemp$toomuchdebt <- ifelse(nfcs_2018_unemp$G23==7, 1, 0)
nfcs_2018_unemp$race <- ifelse(nfcs_2018_unemp$A4A_new_w==1, "White, non-Hispanic", "Non-White")
nfcs_2018_unemp$sex <- ifelse(nfcs_2018_unemp$A3==1, "Male", "Female")
nfcs_2018_unemp$educ = NA
nfcs_2018_unemp$educ = ifelse(nfcs_2018_unemp$A5_2015==1, "Less Than HS", nfcs_2018_unemp$educ)
nfcs_2018_unemp$educ = ifelse(nfcs_2018_unemp$A5_2015==2 | nfcs_2018_unemp$A5_2015==3, "HS Grad", nfcs_2018_unemp$educ)
nfcs_2018_unemp$educ = ifelse(nfcs_2018_unemp$A5_2015==4, "Some College", nfcs_2018_unemp$educ)
nfcs_2018_unemp$educ = ifelse(nfcs_2018_unemp$A5_2015==5 | nfcs_2018_unemp$A5_2015==6 |
                                nfcs_2018_unemp$A5_2015==7, "College Grad", nfcs_2018_unemp$educ)
nfcs_2018_unemp$region <- factor(nfcs_2018_unemp$CENSUSREG, 
                                 label = c("Northeast", "Midwest", "South", "West"))
nfcs_2018_unemp$division <- factor(nfcs_2018_unemp$CENSUSDIV, 
                                   label = c("New England", "Mid Atlantic", "E N Central", "W N Central",
                                             "S Atlantic", "E S Central", "W S Central", "Mountain",
                                             "Pacific"))
nfcs_2018_unemp$state <- factor(nfcs_2018_unemp$STATEQ, 
                                label = c("Alabama", "Alaska", "Arizona", "Arkansas", "California",
                                          "Colorado", "Connecticut", "Delaware", "DC", "Florida",
                                          "Georgia", "Hawaii", "Idaho", "Illinois", "Indiana", "Iowa",
                                          "Kansas", "Kentucky", "Louisiana", "Maine", "Maryland",
                                          "Massachusetts", "Michigan", "Minnesota", "Mississippi",
                                          "Missouri", "Montana", "Nebraska", "Nevada", "New Hampshire",
                                          "New Jersey", "New Mexico", "New York", "North Carolina",
                                          "North Dakota", "Ohio", "Oklahoma", "Oregon", "Pennsylvania",
                                          "Rhode Island", "South Carolina", "South Dakota", "Tennessee",
                                          "Texas", "Utah", "Vermont", "Virginia", "Washington", 
                                          "West Virginia", "Wisconsin", "Wyoming"))
nfcs_2018_unemp$agegroup <- factor(nfcs_2018_unemp$A3Ar_w, 
                                   label = c("18-24", "25-34", "35-44", "45-54", "55-64", "65+"))
nfcs_2018_unemp$lt50k <- ifelse(nfcs_2018_unemp$A8<5, 1, 0)
nfcs_2018_unemp$income <- "Less than $25,000"
nfcs_2018_unemp$income <- ifelse(nfcs_2018_unemp$A8==3 | nfcs_2018_unemp$A8==4, "$25,000 to $50,000", nfcs_2018_unemp$income)
nfcs_2018_unemp$income <- ifelse(nfcs_2018_unemp$A8==5 | nfcs_2018_unemp$A8==6, "$50,000 to $100,000", nfcs_2018_unemp$income)
nfcs_2018_unemp$income <- ifelse(nfcs_2018_unemp$A8==7 | nfcs_2018_unemp$A8==8, "more than $100,000", nfcs_2018_unemp$income)
nfcs_2018_unemp$year <- 2018


# Create 2021 Dummy Variables
nfcs_2021_unemp$gigwork <- ifelse(nfcs_2021_unemp$A40==1, 1, 0)
nfcs_2021_unemp$overdraw <- ifelse(nfcs_2021_unemp$B4==1, 1, 0)
nfcs_2021_unemp$retirement_loan <- ifelse(nfcs_2021_unemp$C10_2012==1, 1, 0)
nfcs_2021_unemp$hardship_withdraw <- ifelse(nfcs_2021_unemp$C11_2012==1, 1, 0)
nfcs_2021_unemp$late_mortgage <- ifelse(nfcs_2021_unemp$E15_2015==2 | nfcs_2021_unemp$E15_2015==3, 1, 0)
nfcs_2021_unemp$card_balance <- ifelse(nfcs_2021_unemp$F2_2==1, 1, 0)
nfcs_2021_unemp$card_min <- ifelse(nfcs_2021_unemp$F2_3==1, 1, 0)
nfcs_2021_unemp$card_late <- ifelse(nfcs_2021_unemp$F2_4==1, 1, 0)
nfcs_2021_unemp$card_limit <- ifelse(nfcs_2021_unemp$F2_5==1, 1, 0)
nfcs_2021_unemp$card_advance <- ifelse(nfcs_2021_unemp$F2_6==1, 1, 0)
nfcs_2021_unemp$card_balance <- ifelse(nfcs_2021_unemp$F2_2==1, 1, 0)
nfcs_2021_unemp$late_std_debt <- ifelse(nfcs_2021_unemp$G35==4 | nfcs_2021_unemp$G35==4, 1, 0)
nfcs_2021_unemp$auto_title <- ifelse(nfcs_2021_unemp$G25_1>1 & nfcs_2021_unemp$G25_1<6, 1, 0)
nfcs_2021_unemp$payday <- ifelse(nfcs_2021_unemp$G25_2>1 & nfcs_2021_unemp$G25_2<6, 1, 0)
nfcs_2021_unemp$collections <- ifelse(nfcs_2021_unemp$G38==1, 1, 0)
nfcs_2021_unemp$toomuchdebt <- ifelse(nfcs_2021_unemp$G23==7, 1, 0)
nfcs_2021_unemp$race <- ifelse(nfcs_2021_unemp$A4A_new_w==1, "White, non-Hispanic", "Non-White")
nfcs_2021_unemp$sex <- ifelse(nfcs_2021_unemp$A50A==1, "Male", "Female")
nfcs_2021_unemp$educ = NA
nfcs_2021_unemp$educ = ifelse(nfcs_2021_unemp$A5_2015==1, "Less Than HS", nfcs_2021_unemp$educ)
nfcs_2021_unemp$educ = ifelse(nfcs_2021_unemp$A5_2015==2 | nfcs_2021_unemp$A5_2015==3, "HS Grad", nfcs_2021_unemp$educ)
nfcs_2021_unemp$educ = ifelse(nfcs_2021_unemp$A5_2015==4, "Some College", nfcs_2021_unemp$educ)
nfcs_2021_unemp$educ = ifelse(nfcs_2021_unemp$A5_2015==5 | nfcs_2021_unemp$A5_2015==6 |
                                nfcs_2021_unemp$A5_2015==7, "College Grad", nfcs_2021_unemp$educ)

nfcs_2021_unemp$region <- factor(nfcs_2021_unemp$CENSUSREG, 
                                 label = c("Northeast", "Midwest", "South", "West"))
nfcs_2021_unemp$division <- factor(nfcs_2021_unemp$CENSUSDIV, 
                                   label = c("New England", "Mid Atlantic", "E N Central", "W N Central",
                                             "S Atlantic", "E S Central", "W S Central", "Mountain",
                                             "Pacific"))
nfcs_2021_unemp$state <- factor(nfcs_2021_unemp$STATEQ, 
                                label = c("Alabama", "Alaska", "Arizona", "Arkansas", "California",
                                          "Colorado", "Connecticut", "Delaware", "DC", "Florida",
                                          "Georgia", "Hawaii", "Idaho", "Illinois", "Indiana", "Iowa",
                                          "Kansas", "Kentucky", "Louisiana", "Maine", "Maryland",
                                          "Massachusetts", "Michigan", "Minnesota", "Mississippi",
                                          "Missouri", "Montana", "Nebraska", "Nevada", "New Hampshire",
                                          "New Jersey", "New Mexico", "New York", "North Carolina",
                                          "North Dakota", "Ohio", "Oklahoma", "Oregon", "Pennsylvania",
                                          "Rhode Island", "South Carolina", "South Dakota", "Tennessee",
                                          "Texas", "Utah", "Vermont", "Virginia", "Washington", 
                                          "West Virginia", "Wisconsin", "Wyoming"))
nfcs_2021_unemp$agegroup <- factor(nfcs_2021_unemp$A3Ar_w, 
                                   label = c("18-24", "25-34", "35-44", "45-54", "55-64", "65+"))
nfcs_2021_unemp$lt50k <- ifelse(nfcs_2021_unemp$A8_2021<5, 1, 0)
nfcs_2021_unemp$income <- "Less than $25,000"
nfcs_2021_unemp$income <- ifelse(nfcs_2021_unemp$A8_2021==3 | nfcs_2021_unemp$A8_2021==4, "$25,000 to $50,000", nfcs_2021_unemp$income)
nfcs_2021_unemp$income <- ifelse(nfcs_2021_unemp$A8_2021==5 | nfcs_2021_unemp$A8_2021==6, "$50,000 to $100,000", nfcs_2021_unemp$income)
nfcs_2021_unemp$income <- ifelse(nfcs_2021_unemp$A8_2021>=7 & nfcs_2021_unemp$A8_2021<=10, "more than $100,000", nfcs_2021_unemp$income)
nfcs_2021_unemp$year <- 2021


# Subset Just for Variables of Interest
variables = c("NFCSID", "year", "race", "sex", "educ", "region", "division", "state", "agegroup", "gigwork", "overdraw",
              "retirement_loan", "hardship_withdraw", "late_mortgage", "card_balance", "card_min", "card_late",
              "card_limit", "card_advance", "card_balance", "late_std_debt", "auto_title", "payday",
              "collections", "toomuchdebt", "lt50k", "income", "wgt_n2")

nfcs_2012_unemp = subset(nfcs_2012_unemp, select = variables)
nfcs_2015_unemp = subset(nfcs_2015_unemp, select = variables)
nfcs_2018_unemp = subset(nfcs_2018_unemp, select = variables)
nfcs_2021_unemp = subset(nfcs_2021_unemp, select = variables)


# Combine Datasets
nfcs_unemp = rbind(nfcs_2012_unemp, nfcs_2015_unemp, nfcs_2018_unemp, nfcs_2021_unemp)