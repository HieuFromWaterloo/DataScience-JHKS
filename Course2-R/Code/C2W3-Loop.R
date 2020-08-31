########## LOOP: pdf page 101 ###########

# lapply: loop over a list and apply a function on each element
# ~ map(a function, list)

# sapply: same as lapply but try to simplify the result

# apply: apply a function over the margins of an array

# tapply: apply a function over subsets of a vector

# mapply: multivariate version of lapply - on matrix

# -------------- #
## > lapply <: the input may or maynot be a list but output is always a list
# This function takes three arguments: 
# (1) a list X; (2) a function (or the name of a function) FUN; (3)
# other arguments via its ... argument. 
# If X is not a list, it will be coerced to a list using as.list().

function (X, FUN, ...)
{
  FUN <- match.fun(FUN)
  if (!is.vector(X) || is.object(X))
    X <- as.list(X)
  .Internal(lapply(X, FUN))
}


x <- list(a = 1:5, b = rnorm(10))
lapply(x, mean)

x <- list(a = 1:4, b = rnorm(10), c = rnorm(20, 1), d = rnorm(100, 5))
lapply(x, mean) # output list of 4 elements with single element in a list

# generate uniform rv 4 times
x <- 1:4
lapply(x, runif)
# [[1]]
# [1] 0.02778712
# [[2]]
# [1] 0.5273108 0.8803191
# [[3]]
# [1] 0.37306337 0.04795913 0.13862825
# [[4]]
# [1] 0.3214921 0.1548316 0.1322282 0.2213059

lapply(x, runif, min=0,max =10)

# lapply on ANONYMOUS FUNCTION:

x <- list(a = matrix(1:4, 2, 2), b = matrix(1:6, 3, 2))
# extract the first column of each matrix in the list.
lapply(x, function(elt) { elt[,1] })
# or 
f <- function(elt) {
  elt[, 1]
  }
lapply(x, f)

# -------------- #
# > sapply <: the output is more flexible other than the list like lapply
# If the result is a list where every element is length 1, then a vector is returned
# . If the result is a list where every element is a vector of the same length (> 1), a matrix is returned.
# . If it can't figure things out, a list is returned

x <- list(a = 1:4, b = rnorm(10), c = rnorm(20, 1), d = rnorm(100, 5))
sapply(x, mean)
# a           b         c         d
# 2.500000 -0.251483 1.481246 4.968715

# NOTE: mean(x) wont work, mean only works a numerical vector

# -------------- #
# > apply < 
# Most used to apply a function to rows or cols of a matrix
# can also be used in general arrays: take mean of an array in a matrix
# can write everything in 1 line

x = matrix(rnorm(200), 20, 10) # 20 rows and 10 cols

# apply mean function on each col (2: preserve col, collapse rows):
apply(x, 2, mean) # get back a vector of len 10, 10 means of 10 cols

# apply sum function on each row (1: preserve row, collapse cols):
apply(x, 1, sum) # ________________________20, 20_________20 rows

## NOTE: Specialized functions to calc means and sum (MUCH FASTER than apply)
# rowSums/colSums = apply(x, 1 or 2, sum)
# rowMeans/colMeans = apply(x, 1 or 2, mean)

# apply quantile of rows: get 25th and 75th percentile
apply(x, 1, quantile, probs=c(0.25, 0.75)) # return a matrix

# apply mean on tensors: 2x2x10 matrix
tensor = array(rnorm(2*2*10), c(2,2,10)) # dim = 2x2x10
apply(tensor, c(1,2), mean) # keep 1st and 2nd dim and collapse 3rd dim
# result in a 2x2 matrix

# OR: use rowMeans
rowMeans(tensor, dims = 2) # got the same result as above

# -------------- #
# > mapply < multivariate apply
# we can use mapply on MULTIPLE lists in parallel

# example: instaed of 
list(rep(1,4), rep(2,3), rep(3,2), rep(4,1)) # rep = repeat
# we can do
mapply(rep, 1:4, 4:1)

# 2nd example:
noise = function(n, mean, sd) {
  rnorm(n, mean, sd)
}

# instead of
list(noise(1,1,2), noise(2,2,2), # we want 1 rv with mean 1, 2 w mean 2, etc
     noise(3,3,2),noise(4,4,2),
     noise(5,5,2))

# we can do 
mapply(noise, 1:5, 1:5, 2)

# -------------- #
# > tapply < apply function over subsets of a vector
# we use this when we have factors/groups in our data
str(tapply) # help(tapply)

x = c(rnorm(10), runif(10), rnorm(10, 1))
# create factor
f = gl(3, 10) # there're 3 factors, each contains 10 data points
# tapply
tapply(x, f, mean) # = sapply(split(x, f), mean)
# it will return a list if set simplified to False
tapply(x,f,mean, simplify = F)

# get the range: min and max of the factor
tapply(x, f, range)

# -------------- #
# > split < this is NOT a loop function but
# useful to use with lapply or sapply
# input: vector just like lapply, a factor variable `f`
# output: split the vector x into groups according to `f`
# it always returns the list back

x = c(rnorm(10), runif(10), rnorm(10, 1))
# create factor
f = gl(3, 10) # there're 3 factors, each contains 10 data points
# split: return a list. t-apply return a vector/array
split(x, f)

# t-apply equivalent
lapply(split(x, f), mean)

# load data and try to split dataframe
library(datasets)
head(airquality)

s = split(airquality, airquality$Month) # split by the month
lapply(s, function(x) colMeans(x[,c('Ozone', 'Solar.R', 'Wind')]))

# use sapply to get a simpler output than a list - a matrix is returned
sapply(s, function(x) colMeans(x[,c('Ozone', 'Solar.R', 'Wind')]))

# REMOVE THE NA before calculating the means
sapply(s, function(x) colMeans(x[,c('Ozone', 'Solar.R', 'Wind')],
                               na.rm = T))

# -------------- #
# split: IN MORE THAN ONE LEVELS/FACTORS
# in case where we have: gender, height

x = rnorm(10)
f1 = gl(2,5) # 1 1 1 1 1 2 2 2 2 2 - 2 levels
f2 = gl(5,2) # 1 1 2 2 3 3 4 4 5 5 - 5 levels

# interation factors: combine all the levels
interaction(f1,f2)

# split according to the interactions:
str(split(x, list(f1,f2))) # OR
str(split(x, interaction(f1,f2)))

# note that there can aso empty levels: no obs

# get rid of empty lelvels
str(split(x, list(f1,f2)), drop = T)

# ------------------- #
# DEBUGGING:pdf page 130
printmessage2 <- function(x) {
  + if(is.na(x))
    + print("x is a missing value!")
  + else if(x > 0)
    + print("x is greater than zero")
  + else
    + print("x is less than or equal to zero")
  + invisible(x)
  + }

# Debugging Tools:
# • traceback(): prints out the function call stack after an error occurs; 
# does nothing if there’s no error. So when you have a shit load of functions
# calling each other and theres a bug somewhere. this is useful to track
# which function actually causes the error. HAVE TO USE THI IMMEDICATELY
# AFATER THE ERROR OCCUR

# • debug(): flags a function for “debug” mode which allows you 
# to step through execution of a function one line at a time

# • browser(): suspends the execution of a function wherever 
# it is called and puts the function in debug mode. 
# the function will get called UP TO `browser`, the rest will get skipped

# • trace(): allows you to insert debugging code into a function a 
# specific places. handy when we debug someelse's code

# • recover(): allows you to modify the error behavior so that you 
# can browse the function call stack

