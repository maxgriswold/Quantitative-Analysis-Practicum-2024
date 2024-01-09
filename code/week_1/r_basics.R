# Demonstrate basics of R
# Quantitative Analysis Practicum 2024
# Max Griswold
# 1/8/2024

# A good starting point for any R script is to clear out all available
# memory from previous work sessions. You can do this with the following
# command:

rm(list = ls())

# "rm" removes anything in the parantheses, "list" indicates the
# current memory environment for R, and "ls()" is a function
# that prints out all objects in memory for R. Once you run this
# code, you can see on the right side of the screen that the "Environment
# is empty"

# "#" comments a line of code. When a line of code is commented out, then 
# anything appearing on that line will not be executed
# This is typically used for documentation purposes but can be useful 
# for debugging.

# Comments work best when they either describe complicated code
# in plain detail or offer intuition behind code that is not
# immediately clear from reading it.

# In general, try to write code which looks like normal
# language To do this, choose names for variables and
# functions which make sense. If you write a long name
# for a variable or function, you can always use the tab-key
# while writing something out to finish a long variable
# name.

# For example, if I have the following variable 
#(copy code below into the console, then press "enter"
an_extremely_verbose_variable_that_only_a_sesquipedalian_would_want_to_use <- 2

# In the future, if I start writing in the console "an_ext", then press the tab-key, 
# the rest of the variable name should pop up.

# I find it to be a good practice to set a working directory for each script, 
# where I'll keep all files required for that script to run properly. You can
# put any windows filepath as a directory, if you can access that file on your
# machine. You can right-click files on your computer to get a filepath address.

setwd("C:/users/")

# There are functions in R to navigate your machine and manipulate files. For now,
# let's just look at our working directory and see what files are in that folder.

getwd()
list.files()

# The "<-" assigns a name to an object, then stores
# it in memory. Other scripting languages use "=" to do this, which
# is also permissible in R but not considered the standard method for
# assigning objects due to "house style" (but you can if you want)
# You can typically see what an object contains using
# a "print" command

x <- "Hello"

print(x)

# R is a functional language by nature so we can do all the usual mathematical
# operations on R objects, using R like a calculator. 

x <- 7

# Calcuate X raised to a power
print(x^2)
print(x*725682)

# Divide
print((x/3))

# Use more complicated math functions
print(factorial(x))
print(sqrt(x))
print(log(x))

# This one is a little more esoteric: a modulo operator
# This provides the remainder from a division operation
print(x%%3)

# We can also create vectors and perform vector operations on them.
# "c()" creates a vector and it can hold any object, not just numeric values.

x <- c(1, 2, 3)
print(x)

x <- c(1, 2, "cat")
print(x)

x <- c(1, 2, 3)

x*3
x^2

# R also has objects for lists, which are less useful for statistical operations
# but can be invaluable for programatic problems.

x <- list("cat", "dog", "pig")
print(x)

# We can see specific items in list and pull them out as well:
x[[2]]

# A common use for lists  are for-loops. Loops create a new variable
# to hold a specific item being looped over (in the below, we pull 
# a new-defined "item" out of the "x" list above)

# We also can use conditional-statements (like "if"), to only perform an operation
# if when a condition is met)

for (item in x){
  if (item == "cat"){
    print("This is a cat!")
  }else{
    print(
      "This is definitely not a cat")
  }
}

# In R, for most cases, the syntax for a "for" loop is pretty long and hard to
# to read. So R provides a wrapper function called the "apply" family to do a similar 
# function but using a single line of code.

# Let's make a list, which contains three vectors. The first one
# I set the values directly, in the second I create a sequence of numbers
# between 1 and 10, for all values spaced 0.02 apart. In the last example,
# I take 100 random values from a normal distribution
x <- list(c(4, 7, 8, 9, 10, 2384, 1293845), 
          seq(1, 10, 0.02), 
          rnorm(100))

# For an apply statement, we'll use each item in a list and apply the second
# argument to that item. So the below takes each vector in x and adds all the
# values together
lapply(x, sum)

help(lapply)

# We can define arbitrary functions in R to do whatever we want, given the
# provided arguments. For readability, you can put a "return" command,
# indicating exactly what you want the function to send back to you. However,
# you could also leave this out and R will return the result of whatever
# code was executed last in a function

# Function that adds two numbers together
adder <- function(argument, argument2){
  
  return(argument + argument2)
  
}

# Take the mean of a vector
meaner <- function(vector){
  
  sum(vector)/length(vector)
  
}

# Take the mean of a vector and double it
mean_doubler <- function(vector){
  
  result <- sum(vector)/length(vector)
  2*result
  
}

# A key aspect of R (and any programming language for that matter) is external
# packages. These are pieces of importable code, designed for specific 
# computing purposes by other researchers. For example, the "psych" package has functions for 
# common analysis in psychology and the "boot" package has streamlined tools
# for conducting bootstraps. There's thousands of packages and they're all
# stored on the "CRAN" (Comprehensive R Archive Network), hosted by universites
# around the world. Each package has to keep meticulous documentation, which 
# can be quite helpful.

#https://cran.r-project.org/web/packages/data.table/index.html

# We can add new packages using the install.packages function. Let's add
# in a package which reads data quickly into R.

install.packages("data.table")

# Load an installed package - this imports all functions so we can
# start using them. Usually, all imports are put at the very beginning
# of your code, after something like "rm(list = ls())

library(data.table)

# We'll load a dataset into R using the "fread" (fast-reader) function
# from the data.table package. We can see what functions are in a package using
# the "::" notation below. It's a good practice to always check the help 
# documentation on a function before using it, to make sure it will behave
# the way you expect and ensuring the default arguments are sensible.

data.table::fread
help(fread)

# For the below to work correctly, you need to replace the "path/to/file"
# with the filepath for wherever you downloaded the class Github page:
github_repo_location <- "C:/path/to/where/I/stored/the/repo"

# You can add two pieces of text together using the paste command. I typically
# only use the paste0 comand to do this, which doesn't add spaces between words:
data_path <- paste0(github_repo_location, "/data/state_firearm_denials_2000_2014.csv")

df <- fread(data_path)

print(df)

# We can see an object's type by using "class". This can be useful for debugging.
# The below should tell us the df is a "data.frame"

class(df)

# Let's explore our data a little bit. "summary" is a particularly useful
# function to get a sense of how the data is distributed, what missingness
# exists, and the type of each variable:

summary(df)

# We could also make our own data.table using probability functions. This can
# be really useful for simulating methods and testing out functions. In the below,
# I get random samples form a normal distribution and poisson distribution. I also
# randomly sample from a vector which has a few different values in it (100 draws,
# with replacement)
df_random <- data.table("normal_dist" = rnorm(100, mean = 5, sd = 2),
                        "poisson_dist" = rpois(100, lambda = 50),
                        "sample_dist" = sample(c(1, 5, 7, 9, "blue", "red"), 
                                               size = 100, replace = T))

print(df_random)

# We could also download a dataset directly from the web. The below dataset
# was taken from Connecticut open data on accidental drug related deaths:

# https://data.ct.gov/Health-and-Human-Services/Accidental-Drug-Related-Deaths-2012-2022/rybz-nyjw/about_data

# You can often get a link to these files by right-clicking on a download link on a webpage,
# then copying the address into R.

df_online <- fread("https://data.ct.gov/api/views/rybz-nyjw/rows.csv?accessType=DOWNLOAD")

# We can pull out columns to use as vectors using the "$" function, then calculate
# summary statistics for those variables.

x <- df$firearm_homicide_rate
print(x)

mean(x)
sd(x)

quantile(x)
quantile(x, probs = c(0, 0.05, 0.25, 0.5, 0.75, 0.95, 1))

unique(df$state)

# One of R's huge advantages over other programming languages, especially for
# academic purposes, is it's plotting functions. It's super easy to visualize 
# data using just a few simple commands. For interim products and published work,
# I prefer to use the package "ggplot2" but for initial data exploration,
# the plotting package included with R is very useful.

hist(x)
plot(density(x))

plot(df$year, df$firearm_homicide_rate)

# Not the most useful plot -let's do some simple data.table operations to get
# the mean of the firearm homicide rate, across states by year.

# Some examples of a few simple operations we could perform within a data.table:
# These only work on files read in using the "fread" command or created using
# "data.table". 

# Anything before the first "," queries the data. Anything performed after
#  first "," does an operation on a column.
df[state == "Illinois", mean(firearm_homicide_rate)]
df[state %in% c("Illinois", "Indiana"), sd(firearm_homicide_rate)]

# Row queries can use boolean operations for more expressive searches:
# ("&" = and, "|" = or, "!" = not).

# Query all rows between 2001 and 2003, then take a mean of the cocaine death rate:
df[year >= 2001 & year <= 2003, mean(cocaine_death_rate)]

# If our vector contains na values, then we might want to ignore these
# when taking a mean
df[year >= 2001 & year <= 2003, mean(cocaine_death_rate, na.rm = T)]

# A more complicated query below. This reads: "Give me the mean cocaine death rate for all years past 2005
# except 2013 and without including missing values:
df[(year >= 2005 & year != 2013) & (!is.na(cocaine_death_rate)), 
   mean(cocaine_death_rate)]

# We can also create new columns in the data.table using the setter operation: ":="
df[, cocaine_firearm_death_rate := firearm_homicide_rate + cocaine_death_rate]

df[, state_year := paste(state, year)]
df$state_year

# Now, let's make a column for mean firearm homicide rate. We can use another "," 
# to perform an operation, subset by another variable. So the below code takes the
# mean firearm homicide rate, ignoring na values, and calculates that mean for
# each year
df[, firearm_homicide_rate_year_mean := mean(firearm_homicide_rate, na.rm = T), by = "year"]

# We can plot a scatter for that new variable within each year:
plot(df$year, df$firearm_homicide_rate_year_mean)

# We can add a linear regression prediction to the above plot:
#"abline" adds an arbitray line, while "lm" runs a linear model.
# Inside "lm", we specify an R formula for a model single regression
# specification (y ~ x)

abline(lm(firearm_homicide_rate ~ year, data = df))

# Combining some of the previous tools,  we can build a simple function to plot 
# the distribution of variables in our dataset, 
# using lapply on column names to get the distribution of each one.

plot_var_distribution <- function(colname){
  
  # Double subscripts is another way of extracting columns
  # from a data.table, in addition to "$", similar to taking items out of 
  # a list
  col <- df[[colname]]
  
  print(
    plot(density(col, na.rm = T),
         main = colname,
         xlab = colname,
         ylab = "density")
  )
  
  # Using paste again:
  return_value <- paste("Finished", colname)
  
  return(return_value)
}

#"names" function gets a list of column-names from a dataset:
names(df)

# A more complicated command below. I'm using "names" to get a list of the column-names
# in my dataframe. Then, I'm using the brackets to subset columns to just the
# ones that are numeric. To do that, I'm using his command "3:length(names(df))" to
# get the numbers 3 through the total number of columns in the dataset.
numeric_cols <- names(df)[3:length(names(df))]

#Let's also remove a specific column that's not numeric from the above list.
# "!" means not and gets the opposite of whatever is in the parantheses. So
# The below command reads: Give me all columns but only if the column name is not
# equal to poc_type or state_year
numeric_cols <- numeric_cols[!(numeric_cols %in%  c("poc_type", "state_year"))]

# In addition to "length", we can get the dimensions of a matrix or data.table
# using "dim
length(df)
dim(df)

#Let's open up a pdf, apply our function on the subset columns, then close the
#pdf.
pdf("df_denial_var_distributions.pdf")
lapply(numeric_cols, plot_var_distribution)
dev.off()

# This should create a new file on your machine that you can open and look at:

list.files()

# We could look at that model above in more detail, by saving the model object
model <- lm(data = df, formula = "firearm_homicide_rate ~ year")
summary(model)

#We can get y-hats using the "predict" function
preds <- predict(model)

plot(df$firearm_homicide_rate, preds)

#Or plot the model residuals:
res <- resid(model)

plot(preds, res)

