# Looking at 2022 State-Level UI Restrictions and Trying to do Some Basic Mapping
# Last updated 12 February 2023


library(tidyverse)
library(maps)
library(mapdata)


# Load state-level map data and create test map
state = map_data('state')

ggplot(data = state, aes(x=long, y=lat, fill=region, group=group)) +
  geom_polygon(color="white") +
  guides(fill=F)


# Should now be able to read in and merge our data
policies = read_csv("State Level UI Qualifying Rules.csv")

map_data = left_join(state, policies, by = join_by(region == state))


# Now see if we can map the minimum average amount needed to qualify by state
ggplot(data = map_data, aes(x=long, y=lat, fill=quarterly_rate, group=group)) +
  geom_polygon(color='white')
ggplot(data = map_data, aes(x=long, y=lat, fill=min_bp_wage, group=group)) +
  geom_polygon(color='white')


# Can also map if the states have an alternative or extended budge period
ggplot(data = map_data, aes(x=long, y=lat, fill=alt_bp_type, group=group)) +
  geom_polygon(color='white')


# Can we combine the two graphs above by constructing state labels?
state_labels = map_data %>%
  group_by(region) %>%
  summarise(long = mean(long),
            lat = mean(lat))

state_labels = left_join(state_labels, policies, by = join_by(region==state))

ggplot(data = map_data, aes(x=long, y=lat, fill=quarterly_rate, group=group)) +
  geom_polygon(color='white') +
  geom_label(data = state_labels, aes(x=long, y=lat, label=alt_bp_type), inherit.aes=F, size=2)

ggplot(data = map_data, aes(x=long, y=lat, color=alt_bp_type, fill=quarterly_rate, group=group)) +
  geom_polygon()

# Can also look at min high quarter wages and base period multiplier
map_data$hq_update = ifelse(map_data$min_hq_wage==0, NA, map_data$min_hq_wage)

ggplot(data = map_data, aes(x=long, y=lat, fill=hq_update, group=group)) +
  geom_polygon(color='white')

ggplot(data = map_data, aes(x=long, y=lat, fill=as.factor(bp_multiplier), group=group)) +
  geom_polygon(color='white')