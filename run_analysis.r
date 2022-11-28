library(plyr)
if(!file.exists("./getcleandata")){dir.create("./getcleandata")}
fileurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileurl, destfile = "/Users/gurpreetsingh/Downloads/projectdataset.zip")
unzip(zipfile = "./getcleandata/projectdataset.zip", exdir = "./getcleandata")
#1.Merge the training and test datasets
##Reading training datasets
x_train <- read.table("/Users/gurpreetsingh/Downloads/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("/Users/gurpreetsingh/Downloads/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("/Users/gurpreetsingh/Downloads/UCI HAR Dataset/train/subject_train.txt")

##Reading test datasets
x_test <- read.table("/Users/gurpreetsingh/Downloads/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("/Users/gurpreetsingh/Downloads/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("/Users/gurpreetsingh/Downloads/UCI HAR Dataset/test/subject_test.txt")

##Reading feature vector
features <- read.table("/Users/gurpreetsingh/Downloads/UCI HAR Dataset/features.txt")

##Reading activity labels
activityLabels = read.table("/Users/gurpreetsingh/Downloads/UCI HAR Dataset/activity_labels.txt")

#Assigning variable names
colnames(x_train) <- features[,2]
colnames(y_train) <- "activityID"
colnames(subject_train) <- "subjectID"

colnames(x_test) <- features[,2]
colnames(y_test) <- "activityID"
colnames(subject_test) <- "subjectID"

colnames(activityLabels) <- c("activityID", "activityType")

##Merging all datasets into one set
alltrain <- cbind(y_train, subject_train, x_train)
alltest <- cbind(y_test, subject_test, x_test)
finaldataset <- rbind(alltrain, alltest)

#2.Extracting only the measurements on the mean and sd for each measurement

#Reading column names
colNames <- colnames(finaldataset)
#Create vector for defining ID, mean, and sd
mean_and_std <- (grepl("activityID", colNames) |grepl("subjectID", colNames) |grepl("mean..", colNames) |grepl("std...", colNames)
)
setforMeanandStd <- finaldataset[ , mean_and_std == TRUE]

##Use descriptive activity names
setWithActivityNames <- merge(setforMeanandStd, activityLabels,by = "activityID",all.x = TRUE)

#4.Label the data set with descriptive variable names
##Already done 
# 5. Creating a second,  independent tidy data set with the avg of each variable for each activity and subject
##Making a second tidy data set
tidySet <- aggregate(. ~subjectID + activityID, setWithActivityNames, mean)
tidySet <- tidySet[order(tidySet$subjectID, tidySet$activityID), ]

##Writing second tidy data set into a txt file
write.table(tidySet, "tidy.txt", row.names = FALSE)
