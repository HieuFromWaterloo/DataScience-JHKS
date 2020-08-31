###############################################
# > str() < = python summary() & .info()
# summary(vector) = pd.describe()
# str() output is more compact than summary()

###############################################
# > SIMMULATION: pdf pg 146 <

# • d for density (PDF)
# • r for random number generation
# • p for cumulative distribution (CDF) P(X <= c)
# • q for quantile function (inverse CDF)

# NOTE: always set seed when gen random var
set.seed(1)

dnorm(x, mean = 0, sd = 1, log = FALSE)
# lower tail = T: evaluate wrt to the left tail P(X <= C)
# lower tail = F: use upper tail, eval P(X > c)
pnorm(q, mean = 0, sd = 1, lower.tail = TRUE, log.p = FALSE)
qnorm(p, mean = 0, sd = 1, lower.tail = TRUE, log.p = FALSE)
rnorm(n, mean = 0, sd = 1)


#################### pg 148

## Always set your seed!
set.seed(20)
## Simulate predictor variable
x <- rnorm(100)
## Simulate the error term
e <- rnorm(100, 0, 2)
## Compute the outcome via the model
y <- 0.5 + 2 * x + e
summary(y)
plot(x, y)


# gen poisson
set.seed(1)
x <- rnorm(100)
log.mu <- 0.5 + 0.3 * x
y <- rpois(100, exp(log.mu))
summary(y)
plot(x, y)

######### RANDOM SAMPLE ########
set.seed(1)
sample(1:10, 4) # samoke 4 number from 1 to 10
sample(letters, 5) # sample letters
sample(1:10, replace = TRUE) # sample with replacement


############################ R PROFILER: pg 140 ########################
# R comes with a profiler to help you optimize your code 
# and improve its performance
# It is a systematic way to examine how much time is spent in different 
# parts of a program

# PRINCIPLES
# desgin and get shit work BEOFRE optimize
# premature optimization is the root of all evil
# measure (collect data), DO NOT GUESS

# ---------------------- #
# > system.time() = %%time < useful for smaller program

# • user time: time charged to the CPU(s) for this expression
# • elapsed time - “wall clock” time, the amount of time that passes 
#   for you as you’re sitting there

# • elapsed time may be smaller than the user time if your machine 
#   has multiple cores/processors
# And so you can think about of it is, but basically the elapsed time 
# was multiplied times two, because it was being executed on two different CPUs. So the amount of time that the user, the CPU spent working on your program was actually more than the amount of time that you spent waiting for it to
hilbert <- function(n) {
  + i <- 1:n
  + 1 / outer(i - 1, i, "+")
  }
x <- hilbert(1000)
system.time(svd(x))
# user system elapsed
# 1.035 0.255 0.462

# • elapsed time may be greater than the user time if the CPU spends 
#   a lot of time waiting around
system.time(readLines("http://www.jhsph.edu"))
# user system elapsed
# 0.004 0.002 0.431
# Most of the time in this expression is spent waiting for the connection 
# to the web server and waiting for the data to travel back to my computer. 
# This doesn’t involve the CPU and so the CPU simply waits around for 
# things to get done. Hence, the user time is small.


# time longer function:
system.time({
  + n <- 1000
  + r <- numeric(n)
  + for(i in 1:n) {
    + x <- rnorm(n)
    + r[i] <- mean(x)
    }
  })

# ---------------------- #
# > Rprof < 
# DO NOT USE system.time() AND Rprof together

# turn on profiler with:
Rprof() 
# turn off profiler:
Rprof(NULL) 

# > summaryRprof() < summerize output of Rprof()
# function tabulates the R profiler output and calculates how much
# time is spent in which function

# • “by.total” divides the time spend in each function by the total run time
# • “by.self” does the same as “by.total” but first subtracts out time spent 
#    in functions above the current function in the call stack. 
#    I personally find this output to be much more useful.







