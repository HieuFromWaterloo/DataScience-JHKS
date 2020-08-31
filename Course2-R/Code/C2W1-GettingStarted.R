# checking which dir we are in
getwd()

# change wd: setwd(dir = )

# check files in dir: dir()

# use ls to check all the functions in the dir

# load the saved file into R using: source("mycode.R")

# sequence
x = 1:20
x

# everything inside a VECTOR has to be the same object type: str, numeric, complex, etc
# A LIST: can contain multiple object types

x = list(1,"a", T, 1 + 4i) # elemtn of list has double brackets around them

x = c(1:10) # from 1 to 10 incluvive
x = vector("numeric" , length = 10)

# check which class:
class(X) # = python: type(x)

# convert type:
as.numeric(x)
as.character(x)
as.logical(x) #0 is false, everything else is true
as.integer(x)

############ MATRIX ##############

m = matrix(1:10, nrow = 2, ncol = 5)

# check matrix attribute:
attributes(m)

# check dim:
dim(m)

# change dim: dim(m) = c(5,2)

x = 1:3
y = 4:6

# cbind: combine cols
cbind(x,y)

# rbind: combine rows
rbind(x,y)

################# FACTOR #####################
# categorical or ordinal ranking 
x =  factor(c('yes', 'yes', 'no'), levels = c("yes", "no"))

# count each factor
table(x)

# unclass to check encoding and levels
unclass(x)

######### Missing values ###################
# .nan is a subset of .na so use is.na()
x = c(1,2,NaN, NA)
is.na(x) # [1] FALSE FALSE  TRUE  TRUE
is.nan(x) # [1] FALSE FALSE  TRUE FALSE

########## DATA FRAME ######################
x = data.frame(foo = 1:4, bar = c(T,T,F,F))
x
nrow(x)
ncol(x)

################### Names Attributes ###############
# vector
x = 1:3
names(x) = c("a", "b", "c")


# list
x = list(a = 1, b = 2, c = 3)

# matrix
m = matrix(1:4, nrow=2, ncol = 2)
dimnames(m) = list(c("a","b"), c("c", "d")) # row names: a, b, col names: c,d
m


################# REading tabular Data ###################

# READ:
# read.table() default sep by space
# read.csv() default sep by ,
# readLines: reading lines of a textfile
# source(): reading in R code files (inverse of dump)
# dget(): reading in R code files (inverse of dput)
# load(): reading a saved workspace
# unserialize(): reading single R objects in binary form

# WRITE:
# write.table()
# write.csv()
# writeLines()
# dump
# dput
# save
# serialize()

##################  READING LARGE DATASET #############
# Before reading into 1M rows of data, make sure to just read in like 5 rows then
# get the schema and apply the rest in order to save memory

tmpdf = read.table("dir", nrows = 5)
# get schema
classes = sapply(tmpdf, class) # python: df.apply(lambda x: class(X))
# read all
df = read.table("dir", colClasses = classes)
# this way R does not have to go through all rows to figure out he format
# 1.5M rows with 120 cols ---> 1.35GB of RAM required


################## TEXTUAL DATA FORMAT ################

# using functions like `dump` and `dput` to output textual data because they
# preserve the metadata so we will not have to specify over again

# longer live and easy to fix if there are corruptions
# works nicely with git version control tracker
# DOWN: not very space efficient. they takes lots of space so compression is required

# >`dput`: So the dput function, essentially writes R code, 
# which can be used to reconstruct an R object.
y =  data.frame(a = 1, b = "a")
dput(y, file = "dput_y.R")
new_y = dget("dput_y.R") # get back the df

# > dump: dump function is a lot like dget however, the difference is that dget can 
# only be used on a single R object. Whereas dump can be used on multiple R objects.

x='foo'
y =  data.frame(a = 1, b = "a")
dump(c("x", "y"), file = "data.R") # output both x and y object into a file
# remove the objects then reconstruct
rm(x,y)
# use `source` to reconstruct
source("data.R")
y # get back the data frame
x # get back x = "foo"


################# CONNECTING R WITH OUTSIDE WORLD ###########

# file: opens connection to a file
# gzfile: opens connect to a compressed file with gzip
# bzfile: _______________________________________ bzip2
# url: _________________ to a webpage

con = gzfile("compressedfile.gz") # open connection
x = readLines(con, 10) # read the first 10 lines

con = url("url.com", "r")
x = readLines(con)
head(x)


#################### Subsetting LIST/VECTOR ####################

# > single [ : we slice a list and get back an object of the same class as the original
# can be used to select more than 1 elements

x = c(1:10)
x[1] # [1] 1
x[1:4] # [1] 1 2 3 4
x[x > 1] # [1]  2  3  4  5  6  7  8  9 10
# can also assign conditional vector
u = x > 1
x[u]
# everthing return as a integer
class(x)


# > double [[ or $ : can only be used to extract a SINGLE element in a list or dataframe
# the class of the returned object may or may not be a list or a dataframe

## subseting a list >>>>>
x = list(foo=1:4, bar = 0.6, baz = "hello")
x[1] = x["foo"] # $foo \n [1] 1 2 3 4
x[[1]] = x$foo  # x[["foo"]] [1] 1 2 3 4

## Extracting multiple elements in a list ===> use SINGLE [
x[c(1,3)] # get the 1st and the 3rd column

## Extract subset of SEQUENCE of a LIST ====> use double [[
x = list(a = list(10,12,14), b = c(3.14, 2.81))

# extract 14
x[[c(1,3)]] # OR
x[[1]][[3]]
x$a[[3]]

# extract 3.14
x[[c(2,1)]] # OR
x[[2]][[1]]
x$b[[1]]


############## SUBSETTING MATRIX ###########
x = matrix(1:6, nrow=2, ncol=3)
# USE SINGLE [ to access row and col

# extract 1st row
x[1,] # [1] 1 3 5

# extract 2nd row, 1st col
x[2, 1] # [1] 2

# extract 2nd col only
x[, 2] # [1] 3 4

# IF: wanna reserve the dimension then set drop = False

x[, 2, drop=F] 
#       [,1]
# [1,]    3
# [2,]    4

x[1,,drop=F]
#       [,1] [,2] [,3]
# [1,]    1    3    5

################# PARTIAL MATCHING: [[ and $ ################
x = list(aaab = 1:5)
x$a # default partial match so it will return: [1] 1 2 3 4 5 OR
x[["a", exact = F]]


################ REMOVING NA VALUES #################

# logical is.na()
x = c(1,2,NA,4,NA,5)
x[!is.na(x)] # [1] 1 2 4 5

# complete.case(x,y)
y = c("a","b", NA, "d", "e", NA)

good = complete.cases(x,y) #x,y must be the same length

x[good] # ONLY SELECT POSN WHERE BOTH VECTOR ARE NOT NA: [1] 1 2 4
y[good] # [1] "a" "b" "d"


# DATAFRAME: complete.cases()
df
good = complete.cases(df)
# we do not want any row to contain NA
gooddf = df[good, ][1:6, ] # take first 6 rows

#################### VECTORIZED OPERATIONS ##################

# VECTOR:
x = 1:4; y=6:9

# elemenbt wise:
x+y
x*y
x/y

# MATRIX:
x = matrix(1:4, 2,2); y = matrix(rep(10,4), 2,2) # rep = repeats 10 4x

# TRUE matrix multiplication
x %*%y




