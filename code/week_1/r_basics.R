# Demonstrate basics of R
# Quantitative Analysis Practicum 2024
# Max Griswold
# 1/8/2024

# This is a comment

# Addition
2+2

# Subtraction
4 - 2

# Multiplication
4*2

# Division
8/2

# Dumb function that adds 5 to a number
f <- function(argument, argument2){
  
  return(argument + argument2)
  
}

# Define a mean function
mean <- function(vector){
  
  sum(vector)/length(vector)
  
}

mean2 <- function(vector){
  
  result <- sum(vector)/length(vector)
  2*result
  
}

v1 <- c(2, 2, 5, 4)
v2 <- c("cat", "dog", "rabbit", "rabbit")

df <- data.frame("Number of animals" = v1,
                 "Animal type" = v2)

# Probability functions
x <- rnorm

# You can use tab-key in  the console to see the rest of a
# package's contents, like tabbing after typing in 
# "stats::"

x <- rnorm(10000)

# We can then plot a distribution
x <- plot(density(x))

