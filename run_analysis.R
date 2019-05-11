
install.packages("dplyr")
library("dplyr")


filename <- "dataZip.zip"

#Checking if file is already downloaded and downloading it if it wasn't

if (!file.exists(filename)){
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileURL, filename)#, method="curl")
}

# Checking if above file was unzipped already

if (!file.exists("UCI HAR Dataset")) { 
  unzip(filename) 
}


#features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","functions"))
#activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))




##1 - Merges the training and the test sets to create one data set.

#Activities Labels
activitiesLabels <- read.table("UCI HAR Dataset/activity_labels.txt")
colnames(activitiesLabels) <- c("code", "activity")

#Features
features <- read.table("UCI HAR Dataset/features.txt")
colnames(features) <- c("n","functions")

#Merging x
xTrain <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
xTest <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
x <- rbind(xTrain, xTest)

#Merging y
yTrain <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")
yTest <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")
y <- rbind(yTrain, yTest)

#Merging Subject
subjectTrain <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
subjectTest <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
subject <- rbind(subjectTrain, subjectTest)

#Merging all together
dataMerged <- cbind(subject, y, x)


#2 - Extracts only the measurements on the mean and standard deviation for each measurement.

tidyData <- dataMerged %>% select(subject, code, contains("mean"), contains("std"))

#3 - Uses descriptive activity names to name the activities in the data set

tidyData$code <- activitiesLabels[tidyData$code, 2]

#4 - Appropriately labels the data set with descriptive variable names.

names(tidyData)[2] = "activity"
names(tidyData)<-gsub("Acc", "Accelerometer", names(tidyData))
names(tidyData)<-gsub("Gyro", "Gyroscope", names(tidyData))
names(tidyData)<-gsub("BodyBody", "Body", names(tidyData))
names(tidyData)<-gsub("Mag", "Magnitude", names(tidyData))
names(tidyData)<-gsub("^t", "Time", names(tidyData))
names(tidyData)<-gsub("^f", "Frequency", names(tidyData))
names(tidyData)<-gsub("tBody", "TimeBody", names(tidyData))
names(tidyData)<-gsub("-mean()", "Mean", names(tidyData), ignore.case = TRUE)
names(tidyData)<-gsub("-std()", "STD", names(tidyData), ignore.case = TRUE)
names(tidyData)<-gsub("-freq()", "Frequency", names(tidyData), ignore.case = TRUE)
names(tidyData)<-gsub("angle", "Angle", names(tidyData))
names(tidyData)<-gsub("gravity", "Gravity", names(tidyData))

#5 - From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

tidy <- tidyData %>% group_by(subject, activity) %>% summarise_all(funs(mean))
write.table(tidy, "tidy.txt", row.name=FALSE)











