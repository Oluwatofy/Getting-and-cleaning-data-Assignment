# Creating a directory
if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "./data/UCI", method = "curl")
# Unziping the downloaded folder
if(!file.exists("UCI HAR Dataset")){
  unzip("./data/UCI")
}
# Assigning column names
features <- read.table("UCI HAR Dataset/features.txt", col.names = c("no","functions"))
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("activity_code", "activity"))
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "activity_code")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "activity_code")

library(dplyr)
# Merging the data sets
X <- rbind(x_train, x_test)
Y <- rbind(y_train, y_test)
Subject <- rbind(subject_train, subject_test)
Merged_Data <- cbind(Subject, Y, X)

# selecting only the measurement for the mean and standard deviation for the merged data set
Tidydata <-  Merged_Data %>% select(subject, activity_code, contains("mean"), contains("std"))

# Descriptive activity names were used to name the activities in the data set
activity <- Tidydata$activity

# The data set were approraitely labeled with descriptive variable names
names(Tidydata)[2] = "activity"
names(Tidydata)<-gsub("Acc", "Accelerometer", names(Tidydata))
names(Tidydata)<-gsub("Gyro", "Gyroscope", names(Tidydata))
names(Tidydata)<-gsub("BodyBody", "Body", names(Tidydata))
names(Tidydata)<-gsub("Mag", "Magnitude", names(Tidydata))
names(Tidydata)<-gsub("^t", "Time", names(Tidydata))
names(Tidydata)<-gsub("^f", "Frequency", names(Tidydata))
names(Tidydata)<-gsub("tBody", "TimeBody", names(Tidydata))
names(Tidydata)<-gsub("-mean()", "Mean", names(Tidydata), ignore.case = TRUE)
names(Tidydata)<-gsub("-std()", "STD", names(Tidydata), ignore.case = TRUE)
names(Tidydata)<-gsub("-freq()", "Frequency", names(Tidydata), ignore.case = TRUE)

#A second,independent tidy dataset (Indy_data) with the average of each variable for each activity and each subject
Indy_Data <- Tidydata %>%  group_by(subject, activity) %>% summarise_all(funs(mean))
write.table(Indy_Data, "Indy_Data.txt", row.name=FALSE)