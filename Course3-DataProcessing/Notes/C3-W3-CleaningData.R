###########  C3W3 - CLEANING THE DATA ###### 
# NOTE: W2 materials are all about getting data from apis and i prefer doing this
# with python

# > SUBSETTING < ############
set.seed(13435)
#sample(1:5) ---> [1] 2 1 3 5 4
X = data.frame("var1"=sample(1:5), "var2"=sample(6:10), "var3"=sample(11:15))
X = X[sample(1:5),] # shuffle the row
X$var2[c(1,3)] = NA # set row 1 and 3 to be NA
X

##
X[(X$var1 <=3 & X$var3 > 11),] # OR OPERATOR: "|"

# > SORT < ############
sort(X$var1) # This only returns the values vector
X[sort(X$var1),] # this will sort then return the dataframe

sort(X$var1, decreasing = T)
## leave NA values to last
sort(X$var2, na.last = T)

# > ARANGE (same) WITH PLYR  < ############
library(plyr)
arrange(X, var1) # ascending rder by default
arrange(X, desc(var1))

# > ADDING COL/ROW  < ############
X$var4 = rnorm(5)
Y = cbind(X, rnorm(5)) # cbind: add a col to X
Z = rbind(X, rnorm(5)) # rbind: add a row

########################################################
# > Summarize  < ############

head(X,3)
tail(X,3)
summary(X) # df.describe()
str(X) # df.info()

## quantile
quantile(X$var1, na.rm = T)
quantile(X$var3, probs = c(0.25,0.5,0.75))

## count unique values for each value in a col
table(X$var1m useNA = "ifany") # useNA: also count howmany na values

## Co-occurance matrix:
table(X$var1, X$var2)

## check for missing values
sum(is.na(X$var2))

## check if theres any na
any(is.na(X$var2)) # return Bool

## check if all are NA
all(X$var1 > 0)

## check sum across col and rows
colSums(is.na(X)) # count num of na in each col

##
all(colSums(is.na(X)) == 0) # False bc var2 has 2 NAs

## filter by values in a cols
table(X$var1 %in% c("1")) # count how many that has value of 1
# FALSE  TRUE 
# 4     1 
table(X$var1 %in% c("1", "2")) # either of this will be count
# FALSE  TRUE 
# 3     2 

## Filter data frame
X[X$var1 %in% c("1"),]

# > Cross Tabs  < ############
data("UCBAdmissions")
df  = as.data.frame(UCBAdmissions)
summary(df)

## find out the relationship between how many male & female being admitted
## USEFUL!!!!
xt = xtabs(Freq ~ Gender + Admit, data = df)
xt

#                 Admit
# Gender   Admitted Rejected
# Male       1198     1493
# Female      557     1278

# OR can break down by ALL variable
xt = xtabs(Freq ~ ., data = df)

# GET SIZE OF THE DATA in bytes or Mb
object.size(X)
print(object.size(X), units = "Mb")


########################################################
# > CREATE NEW VARIABLES: FEATURE ENGINEER  < ############

# Getting some data from the web
if(!file.exists("./data")) {
    dir.create("./data")
}
fileurl = "https://data.baltimorecity.gov/api/views/k5ry-ef3g/rows.csv?accessType=DOWNLOAD"
download.file(fileurl, destfile = "./data/restaurants.csv", method="curl")
restData = read.csv("./data/restaurants.csv")

## CREATE SEQUENCE: for indices #####
s1 = seq(1,10,by=2) # 
s2 = seq(1,10, length=3)
x = c(1,3,8,25,100)
seq(along=x) # to get all the indices of x

## get restaurant near me
restData$nearMe = restData$neighborhood %in% c("Roland Park", "Homeland")
table(restData$nearMe)

## Create Binary var #####
restData$zipWrong = ifelse(restData$zipCode < 0, T, F) # np.where(cond, true, false)
table(restData$zipWrong, restData$zipCode < 0)
#       FALSE TRUE
# FALSE  1326    0
# TRUE      0    1


## CUT quantitative into quantiles then count #####
restData$zipGroups = cut(restData$zipCode, breaks = quantile(restData$zipCode))
table(restData$zipGroups) # count how many zipcodes falls into each quantile range
table(restData$zipGroups, restData$zipGroups) # co occurence matrix

## EASIER CUTTING WITH Hmisc
library(Hmisc)
restData$zipGroups = cut2(restData$zipCode, g=4) # break zip into 4 groups
# according to 4 quantiles
tabe

## CREATING FACTOR VAR ###
restData$zcf = factor(restData$zipCode)
restData$zcf[1:10]

## 
yesno = sample(c("y","n"), size=10, replace = T)
yesnofac = factor(yesno, levels=c("y","n"))
relevel(yesnofac, ref="y")
# [1] n n n n n n y n y y
# Levels: y n
# change to numeric representation
as.numeric(yesnofac)  # [1] 2 2 2 2 2 2 1 2 1 1

## Create new df with new var with `mutate` #####
library(plyr)
# create a new df with new var zipGroups without using $zipGroups
restData2 = mutate(restData, zipGroups=cut2(zipCode,g=4))


# SOME COMMON TRANSFORMATION ######################
abs()
sqrt()
ceiling()
floor()
round(x, digits = n)
signif(x, digits=n) # signif(3.475) = 3.5
cos(x); sin(x)
log(x); log2(x);log10(x)
exp(x)



