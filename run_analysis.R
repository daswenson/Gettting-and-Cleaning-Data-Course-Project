library(dplyr)
library(reshape2)

# Checking if data already exists
if (!file.exists("Datazip.zip")){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileURL, "Datazip.zip", method="curl")
}  

# Checking if folder exists
if (!file.exists("UCI HAR Dataset")) { 
  unzip("datazip.zip") 
}


# loading activity and featyre labels
activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt",
                             col.names = c("act_code", "activity"))
features <- read.table("UCI HAR Dataset/features.txt",
                       col.names = c("n","functions"))

# loading train and test with subject
Xtest <- read.table("UCI HAR Dataset/test/X_test.txt",
                     col.names = features$functions )
Ytest <-  read.table("UCI HAR Dataset/test/y_test.txt", col.names = "act_code")
sub_test <- read.table("UCI HAR Dataset/test/subject_test.txt",
                       col.names = "subject")

Xtrain <- read.table("UCI HAR Dataset/train/X_train.txt", 
                      col.names = features$functions)
Ytrain <- read.table("UCI HAR Dataset/train/Y_train.txt",
                      col.names = "act_code")
sub_train <- read.table("UCI HAR Dataset/train/subject_train.txt",
                            col.names = "subject")

# Merging train and test

xbind <- rbind(Xtrain, Xtest)
ybind <- rbind(Ytrain, Ytest)
Sub_bind <- rbind(sub_train,sub_test)


# extracting only mean and sd for each measurement

colwanted <- grep(".*mean.*|.*std.*", features[,2])
xwant <- xbind[colwanted]
merged_data <- cbind(Sub_bind, ybind, xwant)

#use descriptive names for activities in dataset
merged_data$act_code <- activityLabels[merged_data$act_code, 2]

name_change <- features[colwanted,2]
name_change <-gsub("-mean()", "Mean", name_change, ignore.case = TRUE)
name_change <-gsub("-std()", "STD", name_change, ignore.case = TRUE)
name_change <-gsub("^t", "Time", name_change)
name_change <-gsub("^f", "Frequency", name_change)

colnames(merged_data) <- c("Subject", "Activity", name_change)


# create independent data set with tidy data
merged_data$Activity <- factor(merged_data$Activity, levels = activityLabels[,1], labels = activityLabels[,2])
merged_data$Subject <- as.factor(merged_data$Subject)

melted_data <- melt(merged_data, id = c("Subject", "Activity"))
finaldata <- dcast(melted_data, Subject + Activity ~ variable, mean)

write.table(finaldata,"FinalData.txt",row.names = FALSE, quote=FALSE)
