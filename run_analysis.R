#loads package
library(dplyr)

# Reading test data
trainingsubjects <- read.table(file.path("UCI HAR Dataset", "train", "subject_train.txt"))
trainingvalues <- read.table(file.path("UCI HAR Dataset", "train", "X_train.txt"))
trainingactivities <- read.table(file.path("UCI HAR Dataset", "train", "y_train.txt"))
testsubjects <- read.table(file.path("UCI HAR Dataset", "test", "subject_test.txt"))
testvalues <- read.table(file.path("UCI HAR Dataset", "test", "X_test.txt"))
testactivities <- read.table(file.path("UCI HAR Dataset", "test", "y_test.txt"))

#labels
activities <- read.table(file.path("UCI HAR Dataset", "activity_labels.txt"))

#column names
colnames(activities) <- c("activityid", "activitylabel")

#assigns name to features data
features <- read.table(file.path("UCI HAR Dataset", "features.txt"))

#combine the tables
training <- cbind(trainingsubjects, trainingvalues, trainingactivities)
test <- cbind(testsubjects, testvalues, testactivities)
maintable <- rbind(training, test)

#column names - combined table
colnames(maintable) <- c("subject", features[, 2], "activity")

usedcolumns <- grepl("mean|sd|subject|activity", colnames(maintable))
maintable <- maintable[, usedcolumns]

#puts the names of the factors instead of the values
maintable$activity <- factor(maintable$activity, levels = activities[, 1], labels = activities[, 2])

#cleaning - column 
colnames(maintable) <- gsub("^f", "frequencydomain", colnames(maintable))
colnames(maintable) <- gsub("^t", "timedomain", colnames(maintable))


#group by
maintable2 <- group_by(maintable, subject, activity)

#mean
finaltable <- summarise_each(maintable2,list(mean = mean))

#exports table
write.table(finaltable, "tidy_data.txt", row.names = FALSE)
