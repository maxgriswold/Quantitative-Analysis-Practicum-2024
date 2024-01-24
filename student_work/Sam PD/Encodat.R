
library("haven")
dataframe <- read_dta('C:/Users/yperezd/OneDrive - RAND Corporation/Desktop/Thesis/Paper2/Data/ENCODAT_2016_2017_Individual.dta')

library("survey")
library("gtsummary")

#Recoding variables
dataframe$di1a <- as.factor(dataframe$di1a)
dataframe$ds2 <- as.factor(dataframe$ds2)

str(dataframe)
#Setting up the weights
weighted_data <- svydesign(id=~id_pers, weights=~ponde_ss, data=dataframe)


svyciprop(~I(di1a==1),design=weighted_data) #Gives you the proportion but just for one value
svyciprop(~I(di1a==2),design=weighted_data) #Gives you the proportion but just for one value
svyciprop(~I(di1a==9),design=weighted_data) #Gives you the proportion but just for one value

num_ever_tried <- svytable(~di1a,design=weighted_data) #Gives you the absolute numbers
prop_ever_tried <- prop.table(num_ever_tried)
prop_ever_tried

tbl_svysummary(
  by = ds2,
  include = c(di1a),
  label = list(di1a ~ "Ever tried"),
  statistic=list(all_categorical()~"{p}%" ), 
  data=weighted_data########
)
