library("dplyr")
library("tidyr")


# read test data set 
getwd()

features <- read.table("UCI HAR Dataset 2/features.txt", col.names = c("n","functions"))
activities <- read.table("UCI HAR Dataset 2/activity_labels.txt", col.names = c("code", "activity"))
subject_test <- read.table("UCI HAR Dataset 2/test/subject_test.txt", col.names = "subject")
x_test <- read.table("UCI HAR Dataset 2/test/X_test.txt", col.names = features$functions, row.names = )
y_test <- read.table("UCI HAR Dataset 2/test/y_test.txt", col.names = "code")
subject_train <- read.table("UCI HAR Dataset 2/train/subject_train.txt", col.names = "subject")
x_train <- read.table("UCI HAR Dataset 2/train/X_train.txt", col.names = features$functions)
y_train <- read.table("UCI HAR Dataset 2/train/y_train.txt", col.names = "code")

# merge codes to observations for train and test 
X <- rbind(x_train, x_test)
Y <- rbind(y_train, y_test)
# merge subjects to observations and codes for train and test
subject <- rbind(subject_train, subject_test)
# merge train and test
fullset <- cbind(subject, Y, X)

# select only containing mean or std
meansd <- select(fullset, subject, code, contains("mean"), contains("std"))

# Change codes to activities
distinct(meansd, code)
meansd$code <- recode(meansd$code, 
                      "1" = "WALKING",
                      "2" = "WALKING_UPSTAIRS",
                      "3" = "WALKING_DOWNSTAIRS",
                      "4" = "SITTING",
                      "5" = "STANDING",
                      "6" = "LAYING")

# Label data set with descriptive variable names 
names(meansd)[2] <- "activity"
names(meansd) <- names
names(meansd) <- gsub("Acc", "Accelerometer", names)
names(meansd) <- gsub("Gyro", "Gyroscope", names)
names(meansd) <- gsub("BodyBody", "Body", names)
names(meansd) <- gsub("Mag", "Magnitude", names)
names(meansd) <- gsub("^t", "Time", names)
names(meansd) <- gsub("^f", "Frequency", names)
names(meansd) <- gsub("tBody", "TimeBody", names)
names(meansd) <- gsub("-mean()", "Mean", names, ignore.case = T) 
#ignore.case pattern = T means pattern matching is not case sensitive
names(meansd) <- gsub("-std()", "STD", names, ignore.case = T)
names(meansd) <- gsub("-freq", "Frequency", names, ignore.case = T)
names(meansd) <- gsub("angle", "Angle", names)
names(meansd) <- gsub("gravity", "Gravity", names)

Data_set_mean_sd <- meansd

# Create second independently tidy dataset with the avergae of each variable
# for each activity and each subject 

# Average each activity for each subject 
 
Averages <- meansd %>% 
  group_by(subject, activity) %>% 
  summarise_all(mean)

write.csv(Averages, file = "Final_data.csv", row.names = F) 


