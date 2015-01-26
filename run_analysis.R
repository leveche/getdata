library("data.table")
library("reshape2")

xtrain	<- read.table("./train/X_train.txt")
xtest	<- read.table("./test/X_test.txt")
ytrain	<- read.table("./train/y_train.txt")
ytest	<- read.table("./test/y_test.txt")
strain	<- read.table("./train/subject_train.txt")
stest	<- read.table("./test/subject_test.txt")
alabels	<- read.table("./activity_labels.txt" )
features<- read.table("./features.txt" )

# merge datasets
subject 	<- rbind(stest, strain)
colnames(subject) <- 'subject'

# add labels
activity <- rbind(ytest, ytrain)
activity <- merge(activity, alabels, by=1)$V2

# meaningful column names
x <- rbind(xtest, xtrain)
colnames(x) <- features$V2

# select only the mean and stdev from the combined dataset
combined <- cbind(subject, activity, x[grep('mean|std',colnames(x))])

# melt the combined dataset
Z = melt(combined, id.vars = c('subject', 'activity'))
tidydata = dcast(Z, subject + activity ~ variable, mean)

# write out tidy data
write.table(tidydata, file="tidy.txt", row.names = FALSE)
