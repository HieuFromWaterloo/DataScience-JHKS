########## COURSE 3 - WEEK 1 #########

# 4 Things you should have:
# 1. raw data
# 2. tidy data
# 3. always report preprocessing steps
# 4. A code book desribing each var and its val/unit in the tidy dataset
#    (saved in textfile, study design on how2collect data)

# Processing script SHOULD NOT HAVE any params


# >>>> DOWNLOAD FILES <<<<<<

# ------------- #
# Set/get dir
# relative: setwd("./data"), set("../") - 1 dir up
# abs: setwd("put exact path here") - in windows: "C:\\dir\\data"

# ------------- #
# check if a dir already exist or not then create new dir

if (!file.exists("data")) {
    dir.create("data")
}

# ------------- #
# download.file() - params: url, destfile, method
# copy the link address of the download featyres on the web
fileurl = "link to download.com here"
download.file(fileurl, destfile = "./data/downloaded.csv", method = "curl")
# only specify "curl" method when secure https is used and when using a mac

# date downloaded
dateDownloaded = date()

# >>>> READING LOCAL FILES <<<<<<

# > read.table() <
# the most flexible but it reads data into ram so big data can cause problems
# it requires more params relative to:
# - read.csv()
# - read.csv2()

camData = read.table("./data/cam.csv", sep = ",", header = T)
head(camData)

# NOTEs:
# - quote: tell R wheather there are any quoted values, quoted=""means no quotes
#   the biggest trouble with reading flat files are quotation marks ` or " 
#   in data values, setting quotes="" often solves this

# - na.string: set the character that rep a missing value

# - nrows: how many rows to read the file

# - skip: num of rows to skip

# >>>> READING EXCEL FILES <<<<<<
library(xlsx)

if(!file.exists("data")) {
    dir.create("data")
}

fileurl = "link to download.com here"
download.file(fileurl, destfile = "./data/downloaded.xlsx", method = "curl")
dateDownloaded = date()

colidx = 2:3
rowidx = 1:4
camData = read.xlsx("./data/downloaded.xlsx", sheetIndex=1, header=T)
camData = read.xlsx("./data/downloaded.xlsx", sheetIndex=1, header=T,
                    rowIndex=rowidx, colIndex=colidx)

# ADDITIONAL PACKAGE TO MANIPULATE EXCEL FILES: XLConnect & XLConnect vignette


# >>>> READING XML (extensive markup language) FILES <<<<<<

# Tags correspond to general labels
# - start tag: <section>
# - end tag: </section>
# - empty tag: <line-break />

# Elements are specific examples of tags:
# - <Greeting> Hello, world </Greeting>

# Attributes are components of the labels:
# - <img src="hq2n.jpg", alt="instructor"/>
# - <step number="3"> Connect A to B </step>

library(XML) # just use selenium web driver, less work
filurl = "http://www.hq2n.com/xml/simple.xml"
doc = xmlTreeParse(fileurl, useInternal = T)
rootNode = xmlRoot(doc)
xmlName(rootNode)
##### REVIEW NEEEDED: long ass video #########

# >>>> READING JSON: light weight data storage <<<<<<
library(jsonlite)
jsonData = fromJSON("https:/api.github.com/")
names(jsonData) # output a bunch of columns of a data frames

names(jsonData$owner)
# can drill down even more:
names(jsonData$owner$login)

# convert to json
myjson = toJSON(iris, pretty=T) # pretty = ez2read
cat(myjson)

# json back to dataframe
iris2 = fromJSON(myjson)
head()

# >>>> data.table() --> written in C, much faster than data.frame <<<<<<

library(data.table)

# create a df w 3 cols
df = data.frame(x=rnorm(9), y=rep(c("a","b","c"), each=3), z=rnorm(9))
head(df,3)

# create a df with data.table()
dt = data.table(x=rnorm(9), y=rep(c("a","b","c"), each=3), z=rnorm(9))
head(dt,5)

# check all data tables in memory
tables()

# SUBSETTING >>>>>
# subset row
dt[2,] # 2nd row: 1: 0.4049634 a -1.359834
dt[c(2,3)] # get 2nd and 3rd row

# filter by vals
dt[dt$y=="a",]

# subset 2nd and 3rd cols
dt[, c(2,3)]

# APPLY FUNCTIONS TO COLS >>>>>
# get the mean and sum of the cols
dt[,list(mean(x),sum(z))] 
#          V1       V2
# 1: 0.5196954 -2.44389

# count the numbers of each unique value under a col
dt[,table(y)]
# a b c 
# 3 3 3 

# ADD new col with functions >>>>>
dt[,w:=z^2] # new features as sq(z)

# NOTE: whenever we do this, R will create 2 copies of this in memeory
# big dataset it will cause memory problems

# SO MAKE SURE TO USE the function `.copy()` to keep the original data
dt.copy = copy(dt) 
# now we can manipulate this copy verion the original wont change

#
dt[,m:= {tmp=(x+z); log2(tmp+5)}]
# 1. assign temporary var: tmp = x+z
# 2. output: log2(tmp+5)

#
dt[,a:=x>0] # col a where return T/F

#
dt[, b:=mean(x+w), by=a] # its like aggregated mean
# take the mean of x+w, groupby variable a

# >>>> SPECIAL VARIABLES: allow us to do shit very fast
set.seed(123)
dt = data.table(x=sample(letters[1:3], 1E5, T))
# letters[1:3] - a,b,c
# 1E5 = 10k
# T: with replacement

# count number of a,b,c using `.N`
dt[, .N, by=x]

# set keys >>>>>
setkey(dt,x) # set the key to be var x
dt['a'] # without being like dt[dt$x=='a',], which is slower

# USE `KEY` to facilitate JOIN >>>>
dt1 = data.table(x=c('a','a','b','dt1'), y=1:4)
dt2 = data.table(x=c('a','b','dt2'), z=5:7)
setkey(dt1,x); setkey(dt2,x)
merge(dt1,dt2)
# x y z
# 1: a 1 5
# 2: a 2 5
# 3: b 3 6

# >>>>> READ and WRITE in data.table() are MUCH FASTER

write.table()
read.table()

# read more about data table functions: melt, dcast


######## QUIZ #1 ###########
# fread url requires curl package on mac 
# install.packages("curl")

library(data.table)
housing <- data.table::fread("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv")

# VAL attribute says how much property is worth, .N is the number of rows
# VAL == 24 means more than $1,000,000
housing[VAL == 24, .N]

### 
fileUrl <- "http://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FDATA.gov_NGAP.xlsx"
download.file(fileUrl, destfile = paste0(getwd(), '/getdata%2Fdata%2FDATA.gov_NGAP.xlsx'), method = "curl")

dat <- xlsx::read.xlsx(file = "getdata%2Fdata%2FDATA.gov_NGAP.xlsx", sheetIndex = 1, rowIndex = 18:23, colIndex = 7:15)
sum(dat$Zip*dat$Ext,na.rm=T)

###
library("XML")
fileURL<-"https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml"
doc <- XML::xmlTreeParse(sub("s", "", fileURL), useInternal = TRUE)
rootNode <- XML::xmlRoot(doc)

zipcodes <- XML::xpathSApply(rootNode, "//zipcode", XML::xmlValue)
xmlZipcodeDT <- data.table::data.table(zipcode = zipcodes)
xmlZipcodeDT[zipcode == "21231", .N]
