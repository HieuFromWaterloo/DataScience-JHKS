# ############## C3W4 - Final Project ###################
# Hieu Quoc Nguyen - 2020/08/19

# Review criteria:
# 1. The submitted data set is tidy.
# 2. The Github repo contains the required scripts.
# 3. GitHub contains a code book that modifies and updates the available codebooks with the data to indicate all the variables and summaries calculated, along with units, and any other relevant information.
# 4. The README that explains the analysis files is clear and understandable.
# 5. The work submitted for this project is the work of the student who submitted it.

# This script will do:
# 1. Merges the train.dfing and the test.df sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names.
# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

# Load Packages and get the Data
library(plyr)
library(reshape2)
sapply(c("data.table", "reshape2"), require, character.only=TRUE, quietly=TRUE)
path = getwd()
url = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, file.path(path, "dataFiles.zip"), method="curl")
unzip(zipfile = "dataFiles.zip")

# activity labels + measurements
actLabels = fread(file.path(path, "UCI HAR Dataset/activity_labels.txt")
                        , col.names = c("Labels", "actName"))

# all the measurements needed
features = fread(file.path(path, "UCI HAR Dataset/features.txt")
                  , col.names = c("index", "measurementNames"))
# look for mean or std
requiredFeatures = grep("(mean|std)\\(\\)", features[, measurementNames])
measurements = features[requiredFeatures, measurementNames]
# get rid of brackets
measurements = gsub('[()]', '', measurements)

# Load train.df datasets
train.df = fread(file.path(path, "UCI HAR Dataset/train/X_train.txt"))[, requiredFeatures, with = FALSE]
# set col names to be the measurements
data.table::setnames(train.df, colnames(train.df), measurements)
# get activities from train.df data
train.dfActivities = fread(file.path(path, "UCI HAR Dataset/train/Y_train.txt")
                         , col.names = c("Activity"))
train.dfSubjects = fread(file.path(path, "UCI HAR Dataset/train/subject_train.txt")
                       , col.names = c("SubjectNo"))
train.df = cbind(train.dfSubjects, train.dfActivities, train.df)

# Load test.df datasets
test.df = fread(file.path(path, "UCI HAR Dataset/test/X_test.txt"))[, requiredFeatures, with = FALSE]
data.table::setnames(test.df, colnames(test.df), measurements)
test.dfActivities = fread(file.path(path, "UCI HAR Dataset/test/Y_test.txt")
                        , col.names = c("Activity"))
test.dfSubjects = fread(file.path(path, "UCI HAR Dataset/test/subject_test.txt")
                      , col.names = c("SubjectNo"))
test.df = cbind(test.dfSubjects, test.dfActivities, test.df)

# merge 
merged_df = rbind(train.df, test.df)

# Labels to actName 
merged_df[["Activity"]] = factor(merged_df[, Activity]
                                 , levels = actLabels[["Labels"]]
                                 , labels = actLabels[["actName"]])
# convert factor
merged_df[["SubjectNo"]] = as.factor(merged_df[, SubjectNo])
merged_df = reshape2::melt(data = merged_df, id = c("SubjectNo", "Activity"))
# get relationshiip, aggration as the mean, and reshape data
merged_df = reshape2::dcast(data = merged_df, SubjectNo + Activity ~ variable, fun.aggregate = mean)
# write output into a textfile
write.table(x = merged_df, file = "tidyData.txt", quote = FALSE)
finalout_info = capture.output(str(merged_df))
# write the output variable summary
write.table(finalout_info, file = "cookbook.txt", sep = ",",
            row.names = TRUE, col.names = NA)

