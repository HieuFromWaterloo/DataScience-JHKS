########### IF ELSE #############

# reapeat: execute infinite loop
# break: breaking execuation
# next: skip an iteration
# return: exit a function

if(<condition 1>) {
  # do sth
} else if(<condition 2>) {
  # do sth
} else {
  # do sth
}

# OR just do if(condition) {# do sth} in case we have nothing else

############ FOR LOOP ##########

for(i in 1:10){
  print(i)
}


x = c("a","b", "c","d")

# for i in range(len(x)) equivalent with `seq_along`
for(i in seq_along(x)) {
  print(x[i])
}

for(letter in x) {
  print(letter)
}

# MATRIX >>>
# loop through rows & cols: `seq_len()`
x = matrix(1:6,2,3)

for(rw in seq_len(nrow(x))) { # for every row in the matrix
  for(cl in seq_len(ncol(x))) { # for every col a row
    print(x[rw,cl])
  }
}

############### WHILE ##################
count = 0
while(count < 10){
  print(count)
  count = count + 1
}

# simple random walk
z = 5

while(z >= 3 && z <=10){
  print(z)
  coin = rbinom(1,1,0.5) # binomial dist
  
  if(coin == 1) {
    z = z + 1
  } else {
    z = z - 1
  }
}

############ REPEAT, NEXT, BREAK ############
# repeat is usually used to run algo convergence test. however its generally better to 
# used predefined range for more effective computation (what if an algo never converge)
# which leads to an infinite loop running forever

# REPEAT
x0 = 1
tol = 1e-8

repeat {
  x1 = computeEstimate()
  
  if(abs(x1 - x0) < tol) {
    break
  } else {
    x0 = x1
  }
}


# NEXT
for(i in 1:100) {
  if(i <= 20) {
    next
  }
  # skip the first 20 iters and do sth here
}

######################## FUNCTION ############################

# USeful function feature in statistics: functions in R are `1st class object`
# which means we can pass a function as an arg into another function
# function can be nested (can defn a function inside a function)

# functions take in arguements which can be matched partially or exactly both in term
# of character and positional level

# to check function arguments:
args(<a_function>)

add_func = function(x,y) {
  x + y # we do not need to write return x + y
}

above10 = function(x, n = 10) { # set n = 10 by default
  # takes in a list: x = 1:20
  use = x > n
  x[use]
}

col_mean = function(df, removeNA = T) {
  # take in a dataframe and return the avg of the col
  # set remove NA before calculating mean to be True
  num_col = ncol(df)
  
  # init a vector with 0s with length of number of cols
  means = numeric(num_col)
  
  for(i in 1:num_col) {
    means[i] = mean(df[,i], na.rm = removeNA)
  }
  #retrurn the means
  means
}

x = 1:10
sd(x)

# >> SPECIAL ARGUMENT: "..." used for: 
# 1. extension purposes
myplot = function(x, y, type="l", ...) {
  plot(x, y, type=type, ...)
  # the "..." is used to preserve every other default settings
  # built in the plot() function
}

# 2. equivalent as python def function(a,b,arg*) when we do not know exactly
# how many argument will be passed into a function


# NOTE: when specify arguments AFTER "...", we MUST EXPLICITLY specify exactly wha
# the args are. BECAUSE IT CANT DO PARTIAL MATCH
args(paste) # function (..., sep = " ", collapse = NULL, recycle0 = FALSE)
paste("a", "b", sep = ":") # [1] "a:b"
# THE FOLLOWING WONT WORK:
paste("a","b", se=":") # [1] "a b :"

################# LEXICAL SCOPING: similar to python ###############
search() # give the order of packages being loaded

# Check the scoping of a function
ls(environment((square))) # "n", "pow"

# Get variable value in an env
get("n", environment(square)) # 2

# CONSEQUENCES OF LEXICAL SCOPING
# - all objects must be stored in memory even a very small object
# - all functions must carry a pointer to their respective definding env, which 
#   could be anywhere


#################### SCOPING - OPTIMIZATION EXAMPLE ############
# optim(), nlm() and optimize() --> mle
# Optimization in R minimize function (default), so make sure to use neg log likelihood

make_NegLogLike = function(data, fixed=c(F,F)) {
  # fixed: whether or not we wanna fix the params
  params = fixed
  function(p) { # construct the objective function
    params[!fixed] = p
    mu = params[1]
    sigma = params[2]
    a = -0.5*length(data)*log(2*pi*sigma^2)
    b = -0.5*sum((data-mu)^2) / (sigma^2)
    -(a+b) # return the -neg log for normal distribution
  }
}

set.seed(1)
normals = rnorm(100,1,2)
nLL = make_NegLogLike(normals)
# nLL
# check all the free variables:
ls(environment(nLL)) # data, fixed and params

# start optimize
optim(c(mu=0,sigma=1), nLL)$par
# mu    sigma 
# 1.218239 1.787343


# fixing sigma = 2 and optimiza mu
nLL = make_NegLogLike(normals, c(F,2))
optimize(nLL, c(-1,3))$minimum # 1.217775

# fixing mu = 1
nLL = make_NegLogLike(normals, c(1,F))
optimize(nLL, c(1e-6, 10))$minimum # 1.800596

# Plotting it
nLL = make_NegLogLike(normals, c(1,F))
x = seq(1.5,1.9,len=100)
y = sapply(x, nLL)
plot(x, exp(-(y - min(y))), type="l")

nLL = make_NegLogLike(normals, c(F,2))
x = seq(0.5,1.5,len=100)
y = sapply(x, nLL)
plot(x, exp(-(y - min(y))), type="l")

############ DATE TIME ###############
# Date: represented by Date class
# Date is stored internally as the number of days since 1970-01-01
# before this date will be negative number of days
x = as.Date("1970-01-01")
x
# use unclass to show number of days:
unclass(x) # 0 day since 1970-01-01, and 1 day since 1970-01-02
unclass(as.Date('1970-01-02'))

# Time: ______________ POSIXct or POSIXlt class
# Time _____________________________________ seconds since ________
# weekdays(), months(), and quaters()
x = Sys.time()
x # "2020-07-31 11:04:10 EDT"

# POSIXct: very large integer storing number of seconds since 1970-01-01
p = as.POSIXct(x)
unclass(p) # WE CANNOT APPLY THE LIST OPERATOR LIKE $ here

# POSIXlt
p = as.POSIXlt(x)
names(unclass(p))
p$min
#[1] "sec"    "min"    "hour"   "mday"   "mon"    "year"   "wday"   "yday"  
#[9] "isdst"  "zone"   "gmtoff"

# FORMATING DATE TIME STRING: `?strptime` used to look up how to format
datestring = c("January 10,2020 10:40", "March 25, 2020 15:00")
x = strptime(datestring, "%B %d, %Y %H:%M")
x
class(x) # "POSIXlt" "POSIXt"

# OPERATIONS in DATE TIME
# note: we need them to be the same object types: Date and Date,
# strptime and strptime
x = as.POSIXlt(as.Date("2012-01-01"))
x # "2012-01-01 UTC"
# convert to POSIXlt
y =  strptime("9 January 2011 11:40:21", "%d %b %Y %H:%M:%S") 
y
x-y # Time difference of 356.3053 days

# use POSIXct to calculate difference in minutes/hour/sec
