# Script to Combine the 2018 and 2021 Data
# Last Updated 28 February 2024


library(tidyverse)
library(dplyr)
library(maps)
library(reshape2)
library(randplot)
#source("randplot/rand-pal.R")
#source("randplot/randplot.R")
#source("randplot/theme-rand.R")


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
variables = c("NFCSID", "year", "race", "sex", "region", "division", "state", "agegroup", "gigwork", "overdraw",
              "retirement_loan", "hardship_withdraw", "late_mortgage", "card_balance", "card_min", "card_late",
              "card_limit", "card_advance", "card_balance", "late_std_debt", "auto_title", "payday",
              "collections", "toomuchdebt", "lt50k", "income", "wgt_n2")

nfcs_2012_unemp = subset(nfcs_2012_unemp, select = variables)
nfcs_2015_unemp = subset(nfcs_2015_unemp, select = variables)
nfcs_2018_unemp = subset(nfcs_2018_unemp, select = variables)
nfcs_2021_unemp = subset(nfcs_2021_unemp, select = variables)


# Combine Datasets
nfcs_unemp = rbind(nfcs_2012_unemp, nfcs_2015_unemp, nfcs_2018_unemp, nfcs_2021_unemp)


# Conduct Past Analysis

# Make a graph of getting a sidegig by race
nfcs_unemp %>%
  group_by(race) %>%
  summarize(percent_gigwork = weighted.mean(gigwork, wgt_n2)) %>%
  ggplot(aes(x = race, y = percent_gigwork)) +
  geom_bar(stat = 'identity', position = 'dodge')


# Good proof of concept, let's do all of the variables of interest now
table = nfcs_unemp %>%
  group_by(race) %>%
  summarize(gigwork = weighted.mean(gigwork, wgt_n2, na.rm=T),
            overdraw = weighted.mean(overdraw, wgt_n2, na.rm=T),
            retirement_loan = weighted.mean(retirement_loan, wgt_n2, na.rm=T),
            late_mortgage = weighted.mean(late_mortgage, wgt_n2, na.rm=T),
            card_balance = weighted.mean(card_balance, wgt_n2, na.rm=T),
            card_min = weighted.mean(card_min, wgt_n2, na.rm=T),
            card_late = weighted.mean(card_late, wgt_n2, na.rm=T),
            card_limit = weighted.mean(card_limit, wgt_n2, na.rm=T),
            late_std_debt = weighted.mean(late_std_debt, wgt_n2, na.rm=T),
            collections = weighted.mean(collections, wgt_n2, na.rm=T),
            toomuchdebt = weighted.mean(toomuchdebt, wgt_n2, na.rm=T),
            auto_title = weighted.mean(auto_title, wgt_n2, na.rm=T),
            payday = weighted.mean(payday, wgt_n2, na.rm=T))

# Now transform that table so that we can graph it nicely
graph = reshape2::melt(table, id.vars = c("race"))


# Graph
ggplot(graph, aes(x = variable, y = value, fill = race, label=scales::percent(value, accuracy=1))) +
  geom_bar(stat = 'identity', position = 'dodge', color = RandGrayPal[2]) +
  geom_text(size = 3, color = RandGrayPal[2], position = position_dodge(width=.9), vjust = 1.5) +
  xlab("") +
  scale_x_discrete(labels=c("gigwork" = "Take Up\nGigwork", 
                            "overdraw" = "Overdraw Account", 
                            "retirement_loan" = "Borrow From\nRetirement Account",
                            "late_mortgage" = "Late Mortgage\nPayment",
                            "card_balance" = "Carry Credit\nCard Balance",
                            "card_min" = "Only Pay Credit\nCard Minimum",
                            "card_late" = "Late Credit\nCard Payment",
                            "card_limit" = "Exceed Credit\nLimit",
                            "late_std_debt" = "Late Student\nDebt Payment",
                            "collections" = "Contacted by\nCollections",
                            "toomuchdebt" = "Strongly Agree\nHave Too Much\nDebt",
                            "auto_title" = "Take Out Auto\nTitle Loan",
                            "payday" = "Take Out\nPayday Loan")) +
  ylab("Percent Indicating the Following Financial Behavior or Outcome") +
  labs(title = "Non-White Unemployed More Likely to Use Alternative Financial Services, Take Up Gigwork",
       subtitle = "Unemployed Percent Engaging in the Following Financial Behaviors",
       caption = "Source: 2021 National Financial Capability Study, FINRA") +
  scale_fill_manual(values = RandCatPal) +
  theme_rand() +
  theme(axis.line.x = element_blank(),
        axis.line.y = element_blank(),
        axis.title = element_text(size=10),
        axis.text = element_text(size=8),
        plot.title = element_text(size=12),
        plot.subtitle = element_text(face="italic", size=10),
        plot.caption = element_text(size = 6),
        panel.grid.major.y = element_line(color = RandGrayPal[2]),
        panel.grid.major.x = element_blank())


# Can I produce the same figure just with an analysis by income category instead
table2 = nfcs_unemp %>%
  group_by(income) %>%
  summarize(gigwork = weighted.mean(gigwork, wgt_n2, na.rm=T),
            overdraw = weighted.mean(overdraw, wgt_n2, na.rm=T),
            retirement_loan = weighted.mean(retirement_loan, wgt_n2, na.rm=T),
            late_mortgage = weighted.mean(late_mortgage, wgt_n2, na.rm=T),
            card_balance = weighted.mean(card_balance, wgt_n2, na.rm=T),
            card_min = weighted.mean(card_min, wgt_n2, na.rm=T),
            card_late = weighted.mean(card_late, wgt_n2, na.rm=T),
            card_limit = weighted.mean(card_limit, wgt_n2, na.rm=T),
            late_std_debt = weighted.mean(late_std_debt, wgt_n2, na.rm=T),
            collections = weighted.mean(collections, wgt_n2, na.rm=T),
            toomuchdebt = weighted.mean(toomuchdebt, wgt_n2, na.rm=T),
            auto_title = weighted.mean(auto_title, wgt_n2, na.rm=T),
            payday = weighted.mean(payday, wgt_n2, na.rm=T))

table2$income = factor(table2$income, levels = c("Less than $25,000", "$25,000 to $50,000", "$50,000 to $100,000", "more than $100,000"))
graph2 = reshape2::melt(table2, id.vars = c("income"))

ggplot(graph2, aes(x = variable, y = value, fill = income, label=scales::percent(value, accuracy=1))) +
  geom_bar(stat = 'identity', position = 'dodge', color = RandGrayPal[2]) +
  geom_text(size = 3, color = RandGrayPal[2], position = position_dodge(width=.9), vjust = 1.5) +
  xlab("") +
  scale_x_discrete(labels=c("gigwork" = "Take Up\nGigwork", 
                            "overdraw" = "Overdraw Account", 
                            "retirement_loan" = "Borrow From\nRetirement Account",
                            "late_mortgage" = "Late Mortgage\nPayment",
                            "card_balance" = "Carry Credit\nCard Balance",
                            "card_min" = "Only Pay Credit\nCard Minimum",
                            "card_late" = "Late Credit\nCard Payment",
                            "card_limit" = "Exceed Credit\nLimit",
                            "late_std_debt" = "Late Student\nDebt Payment",
                            "collections" = "Contacted by\nCollections",
                            "toomuchdebt" = "Strongly Agree\nHave Too Much\nDebt",
                            "auto_title" = "Take Out Auto\nTitle Loan",
                            "payday" = "Take Out\nPayday Loan")) +
  ylab("Percent Indicating the Following Financial Behavior or Outcome") +
  labs(title = "Lower-Income Unemployed More Likely to Use Alternative Financial Services, Take Up Gigwork",
       subtitle = "Unemployed Percent Engaging in the Following Financial Behaviors",
       caption = "Source: 2021 National Financial Capability Study, FINRA") +
  scale_fill_manual(values = RandCatPal) +
  theme_rand() +
  theme(axis.line.x = element_blank(),
        axis.line.y = element_blank(),
        axis.title = element_text(size=10),
        axis.text = element_text(size=8),
        plot.title = element_text(size=12),
        plot.subtitle = element_text(face="italic", size=10),
        plot.caption = element_text(size = 6),
        panel.grid.major.y = element_line(color = RandGrayPal[2]),
        panel.grid.major.x = element_blank())


# Do the same thing with a binary income variable
table2 = nfcs_unemp %>%
  group_by(lt50k) %>%
  summarize(gigwork = weighted.mean(gigwork, wgt_n2, na.rm=T),
            overdraw = weighted.mean(overdraw, wgt_n2, na.rm=T),
            retirement_loan = weighted.mean(retirement_loan, wgt_n2, na.rm=T),
            late_mortgage = weighted.mean(late_mortgage, wgt_n2, na.rm=T),
            card_balance = weighted.mean(card_balance, wgt_n2, na.rm=T),
            card_min = weighted.mean(card_min, wgt_n2, na.rm=T),
            card_late = weighted.mean(card_late, wgt_n2, na.rm=T),
            card_limit = weighted.mean(card_limit, wgt_n2, na.rm=T),
            late_std_debt = weighted.mean(late_std_debt, wgt_n2, na.rm=T),
            collections = weighted.mean(collections, wgt_n2, na.rm=T),
            toomuchdebt = weighted.mean(toomuchdebt, wgt_n2, na.rm=T),
            auto_title = weighted.mean(auto_title, wgt_n2, na.rm=T),
            payday = weighted.mean(payday, wgt_n2, na.rm=T))

graph2 = reshape2::melt(table2, id.vars = c("lt50k"))

ggplot(graph2, aes(x = variable, y = value, fill = as.factor(lt50k), label=scales::percent(value, accuracy=1))) +
  geom_bar(stat = 'identity', position = 'dodge', color = RandGrayPal[2]) +
  geom_text(size = 3, color = RandGrayPal[2], position = position_dodge(width=.9), vjust = 1.5) +
  xlab("") +
  scale_x_discrete(labels=c("gigwork" = "Take Up\nGigwork", 
                            "overdraw" = "Overdraw Account", 
                            "retirement_loan" = "Borrow From\nRetirement Account",
                            "late_mortgage" = "Late Mortgage\nPayment",
                            "card_balance" = "Carry Credit\nCard Balance",
                            "card_min" = "Only Pay Credit\nCard Minimum",
                            "card_late" = "Late Credit\nCard Payment",
                            "card_limit" = "Exceed Credit\nLimit",
                            "late_std_debt" = "Late Student\nDebt Payment",
                            "collections" = "Contacted by\nCollections",
                            "toomuchdebt" = "Strongly Agree\nHave Too Much\nDebt",
                            "auto_title" = "Take Out Auto\nTitle Loan",
                            "payday" = "Take Out\nPayday Loan")) +
  ylab("Percent Indicating the Following Financial Behavior or Outcome") +
  labs(title = "Lower-Income Unemployed More Likely to Use Alternative Financial Services, Take Up Gigwork",
       subtitle = "Unemployed Percent Engaging in the Following Financial Behaviors",
       caption = "Source: 2021 National Financial Capability Study, FINRA") +
  scale_fill_manual(values = RandCatPal) +
  theme_rand() +
  theme(axis.line.x = element_blank(),
        axis.line.y = element_blank(),
        axis.title = element_text(size=10),
        axis.text = element_text(size=8),
        plot.title = element_text(size=12),
        plot.subtitle = element_text(face="italic", size=10),
        plot.caption = element_text(size = 6),
        panel.grid.major.y = element_line(color = RandGrayPal[2]),
        panel.grid.major.x = element_blank())

# Let's construct a couple of glm models for different otucomes we expect to be large by race

summary(glm(payday ~ race + income + region + sex + agegroup + as.factor(year), 
            data = nfcs_unemp, family = "binomial"))

summary(glm(auto_title ~ race + income + region + sex + agegroup + as.factor(year), 
            data = nfcs_unemp, family = "binomial"))

summary(glm(gigwork ~ race + income + region + sex + agegroup + as.factor(year), 
            data = nfcs_unemp, family = "binomial"))

summary(glm(overdraw ~ race + income + region + sex + agegroup + as.factor(year), 
            data = nfcs_unemp, family = "binomial"))

summary(glm(retirement_loan ~ race + income + region + sex + agegroup + as.factor(year), 
            data = nfcs_unemp, family = "binomial"))

summary(glm(card_late ~ race + income + region + sex + agegroup + as.factor(year), 
            data = nfcs_unemp, family = "binomial"))

summary(glm(card_limit ~ race + income + region + sex + agegroup + as.factor(year), 
            data = nfcs_unemp, family = "binomial"))

summary(glm(card_min ~ race + income + region + sex + agegroup + as.factor(year), 
            data = nfcs_unemp, family = "binomial"))

summary(glm(late_std_debt ~ race + income + region + sex + agegroup + as.factor(year), 
            data = nfcs_unemp, family = "binomial"))

summary(glm(collections ~ race + income + region + sex + agegroup + as.factor(year), 
            data = nfcs_unemp, family = "binomial"))

summary(glm(toomuchdebt ~ race + income + region + sex + agegroup + as.factor(year), 
            data = nfcs_unemp, family = "binomial"))


# Run Same Regressions Without Regions
summary(glm(payday ~ race + income + sex + agegroup + as.factor(year), 
            data = nfcs_unemp, family = "binomial"))

summary(glm(auto_title ~ race + income + sex + agegroup + as.factor(year), 
            data = nfcs_unemp, family = "binomial"))

summary(glm(gigwork ~ race + income + sex + agegroup + as.factor(year), 
            data = nfcs_unemp, family = "binomial"))

summary(glm(overdraw ~ race + income + sex + agegroup + as.factor(year), 
            data = nfcs_unemp, family = "binomial"))

summary(glm(retirement_loan ~ race + income + sex + agegroup + as.factor(year), 
            data = nfcs_unemp, family = "binomial"))

summary(glm(card_late ~ race + income + sex + agegroup + as.factor(year), 
            data = nfcs_unemp, family = "binomial"))

summary(glm(card_limit ~ race + income + sex + agegroup + as.factor(year), 
            data = nfcs_unemp, family = "binomial"))

summary(glm(card_min ~ race + income + sex + agegroup + as.factor(year), 
            data = nfcs_unemp, family = "binomial"))

summary(glm(late_std_debt ~ race + income + sex + agegroup + as.factor(year), 
            data = nfcs_unemp, family = "binomial"))

summary(glm(collections ~ race + income + sex + agegroup + as.factor(year), 
            data = nfcs_unemp, family = "binomial"))

summary(glm(toomuchdebt ~ race + income + sex + agegroup + as.factor(year), 
            data = nfcs_unemp, family = "binomial"))


# Plot by Race and Year?
table3 = nfcs_unemp %>%
  group_by(race, year) %>%
  summarize(gigwork = weighted.mean(gigwork, wgt_n2, na.rm=T),
            overdraw = weighted.mean(overdraw, wgt_n2, na.rm=T),
            retirement_loan = weighted.mean(retirement_loan, wgt_n2, na.rm=T),
            late_mortgage = weighted.mean(late_mortgage, wgt_n2, na.rm=T),
            card_balance = weighted.mean(card_balance, wgt_n2, na.rm=T),
            card_min = weighted.mean(card_min, wgt_n2, na.rm=T),
            card_late = weighted.mean(card_late, wgt_n2, na.rm=T),
            card_limit = weighted.mean(card_limit, wgt_n2, na.rm=T),
            late_std_debt = weighted.mean(late_std_debt, wgt_n2, na.rm=T),
            collections = weighted.mean(collections, wgt_n2, na.rm=T),
            toomuchdebt = weighted.mean(toomuchdebt, wgt_n2, na.rm=T),
            auto_title = weighted.mean(auto_title, wgt_n2, na.rm=T),
            payday = weighted.mean(payday, wgt_n2, na.rm=T))

graph3 = reshape2::melt(table3, id.vars = c("race", "year"))

vars = c("payday", "auto_title", "card_late", "overdraw")

ggplot(subset(graph3, variable %in% vars), aes(x = year, y = value, color = variable)) +
  geom_line(aes(linetype = race)) +
  geom_point() +
  xlab("") +
  ylab("Percent Indicating Each Financial Behavior or Outcome") +
  labs(title = "Minority Unemployed More Likely to Use Alternative Financial Services, Take Up Gigwork",
       subtitle = "Unemployed Percent Engaging in the Following Financial Behaviors",
       caption = "Source: 2012-2021 National Financial Capability Study, FINRA") +
  scale_color_manual(values = RandCatPal) +
  theme_rand() +
  theme(axis.line.x = element_blank(),
        axis.line.y = element_blank(),
        axis.title = element_text(size=10),
        axis.text = element_text(size=8),
        plot.title = element_text(size=12),
        plot.subtitle = element_text(face="italic", size=10),
        plot.caption = element_text(size = 6),
        panel.grid.major.y = element_line(color = RandGrayPal[2]),
        panel.grid.major.x = element_blank())

# Rerun Regression Models w/ State Effects
summary(glm(payday ~ race + income + state + sex + agegroup + as.factor(year), 
            data = nfcs_unemp, family = "binomial"))

summary(glm(auto_title ~ race + income + state + sex + agegroup + as.factor(year), 
            data = nfcs_unemp, family = "binomial"))

summary(glm(gigwork ~ race + income + state + sex + agegroup + as.factor(year), 
            data = nfcs_unemp, family = "binomial"))

summary(glm(overdraw ~ race + income + state + sex + agegroup + as.factor(year), 
            data = nfcs_unemp, family = "binomial"))

summary(glm(retirement_loan ~ race + income + state + sex + agegroup + as.factor(year), 
            data = nfcs_unemp, family = "binomial"))

summary(glm(card_late ~ race + income + state + sex + agegroup + as.factor(year), 
            data = nfcs_unemp, family = "binomial"))

summary(glm(card_limit ~ race + income + state + sex + agegroup + as.factor(year), 
            data = nfcs_unemp, family = "binomial"))

summary(glm(card_min ~ race + income + state + sex + agegroup + as.factor(year), 
            data = nfcs_unemp, family = "binomial"))

summary(glm(late_std_debt ~ race + income + state + sex + agegroup + as.factor(year), 
            data = nfcs_unemp, family = "binomial"))

summary(glm(collections ~ race + income + state + sex + agegroup + as.factor(year), 
            data = nfcs_unemp, family = "binomial"))

summary(glm(toomuchdebt ~ race + income + state + sex + agegroup + as.factor(year), 
            data = nfcs_unemp, family = "binomial"))


# Create State-Level Measures and Try to Map If Possible
state_data = nfcs_unemp %>%
  group_by(state) %>%
  summarize(gigwork = weighted.mean(gigwork, wgt_n2, na.rm=T),
            overdraw = weighted.mean(overdraw, wgt_n2, na.rm=T),
            retirement_loan = weighted.mean(retirement_loan, wgt_n2, na.rm=T),
            late_mortgage = weighted.mean(late_mortgage, wgt_n2, na.rm=T),
            card_balance = weighted.mean(card_balance, wgt_n2, na.rm=T),
            card_min = weighted.mean(card_min, wgt_n2, na.rm=T),
            card_late = weighted.mean(card_late, wgt_n2, na.rm=T),
            card_limit = weighted.mean(card_limit, wgt_n2, na.rm=T),
            late_std_debt = weighted.mean(late_std_debt, wgt_n2, na.rm=T),
            collections = weighted.mean(collections, wgt_n2, na.rm=T),
            toomuchdebt = weighted.mean(toomuchdebt, wgt_n2, na.rm=T),
            auto_title = weighted.mean(auto_title, wgt_n2, na.rm=T),
            payday = weighted.mean(payday, wgt_n2, na.rm=T))

usa = map_data('state')

state_data$state = tolower(state_data$state)

us_data = left_join(usa, state_data, by = join_by(region == state))

ggplot(data = us_data, aes(x = long, y = lat, fill = payday, group = group)) +
  geom_polygon(color = 'white') +
  coord_fixed(1.3) +
  theme_void()

ggplot(data = us_data, aes(x = long, y = lat, fill = auto_title, group = group)) +
  geom_polygon(color = 'white') +
  coord_fixed(1.3) +
  theme_void()

ggplot(data = us_data, aes(x = long, y = lat, fill = overdraw, group = group)) +
  geom_polygon(color = 'white') +
  coord_fixed(1.3) +
  theme_void()


# Can we try to create a state-level disparity measure and compare it
state_race_data = nfcs_unemp %>%
  group_by(state,race) %>%
  summarize(gigwork = weighted.mean(gigwork, wgt_n2, na.rm=T),
            overdraw = weighted.mean(overdraw, wgt_n2, na.rm=T),
            retirement_loan = weighted.mean(retirement_loan, wgt_n2, na.rm=T),
            late_mortgage = weighted.mean(late_mortgage, wgt_n2, na.rm=T),
            card_balance = weighted.mean(card_balance, wgt_n2, na.rm=T),
            card_min = weighted.mean(card_min, wgt_n2, na.rm=T),
            card_late = weighted.mean(card_late, wgt_n2, na.rm=T),
            card_limit = weighted.mean(card_limit, wgt_n2, na.rm=T),
            late_std_debt = weighted.mean(late_std_debt, wgt_n2, na.rm=T),
            collections = weighted.mean(collections, wgt_n2, na.rm=T),
            toomuchdebt = weighted.mean(toomuchdebt, wgt_n2, na.rm=T),
            auto_title = weighted.mean(auto_title, wgt_n2, na.rm=T),
            payday = weighted.mean(payday, wgt_n2, na.rm=T))

state_race_data = dcast(melt(state_race_data, id.vars=c("state", "race")), state~variable+race)

state_race_data$gigwork_disp = (state_race_data$`gigwork_Non-White` - state_race_data$`gigwork_White, non-Hispanic`) / state_race_data$`gigwork_Non-White`
state_race_data$overdraw_disp = (state_race_data$`overdraw_Non-White` - state_race_data$`overdraw_White, non-Hispanic`) / state_race_data$`overdraw_Non-White`
state_race_data$card_late = (state_race_data$`card_late_Non-White` - state_race_data$`card_late_White, non-Hispanic`) / state_race_data$`card_late_Non-White`
state_race_data$auto_title_disp = (state_race_data$`auto_title_Non-White` - state_race_data$`auto_title_White, non-Hispanic`) / state_race_data$`auto_title_Non-White`
state_race_data$payday_disp = (state_race_data$`payday_Non-White` - state_race_data$`payday_White, non-Hispanic`) / state_race_data$`payday_Non-White`


state_race_data$state = tolower(state_data$state)

us_disp_data = left_join(usa, state_race_data, by = join_by(region == state))

ggplot(data = us_disp_data, aes(x = long, y = lat, fill = payday_disp, group = group)) +
  geom_polygon(color = 'white') +
  coord_fixed(1.3) +
  theme_void()

ggplot(data = us_disp_data, aes(x = long, y = lat, fill = auto_title_disp, group = group)) +
  geom_polygon(color = 'white') +
  coord_fixed(1.3) +
  theme_void()

ggplot(data = us_disp_data, aes(x = long, y = lat, fill = overdraw_disp, group = group)) +
  geom_polygon(color = 'white') +
  coord_fixed(1.3)+
  theme_void()

ggplot(data = us_disp_data, aes(x = long, y = lat, fill = overdraw_disp, group = group)) +
  geom_polygon(color = 'white') +
  coord_fixed(1.3)+
  theme_void()

ggplot(data = us_disp_data, aes(x = long, y = lat, fill = gigwork_disp, group = group)) +
  geom_polygon(color = 'white') +
  coord_fixed(1.3)+
  theme_void()
