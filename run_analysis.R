
library(dplyr)

#Function to read file from the given loclation 
readFile<-function(filename) read.delim(filename, header=FALSE, sep="")

#Function to consolidate the different columns available into one
getConsolidatedDf<- function(reading, columnHeaders, subjectid, activity){
  names(reading)<-columnHeaders
  requiredCols<-grep(names(reading),pattern = "std\\(\\)|mean\\(\\)", value=TRUE)
  reading<-reading[,requiredCols]
  reading<-cbind(activity, reading)
  reading<-cbind(subjectid, reading)
}

# Reading the activity and features files
activity_labels<-readFile("activity_labels.txt")
features<-readFile("features.txt")[[2]]

#Reading the files belonging to test
testReadings<-readFile("./test/X_test.txt")
testSubjects<-scan("./test/subject_test.txt")
testActivity<-scan("./test/y_test.txt")
#Consolidating the test data
testData<-getConsolidatedDf(testReadings, features, testSubjects, testActivity)

#Reading the files belonging to train
trainReadings<-readFile("./train/X_train.txt")
trainSubjects<-scan("./train/subject_train.txt")
trainActivity<-scan("./train/y_train.txt")
#Consolidating the train data
trainData<-getConsolidatedDf(trainReadings, features, trainSubjects, trainActivity)

#Merging test andd train datasets into one
finalDf<-rbind(testData, trainData)

#Using descriptive activity names for the activity column
finalDf$activity<-factor(finalDf$activity, activity_labels[[1]], activity_labels[[2]])

#Using appropriate labels for the variable names
header<-sapply(strsplit(names(finalDf),split = "-"), function(e) paste(e[2],e[1], "along",e[3], sep="-"))
names(finalDf)<-gsub("\\(\\)|\\-along\\-NA||NA\\-", "", header)

#Peforming mean on all the columns
aggregatedDf<-finalDf%>%group_by(subjectid,activity)%>%summarise_all(.funs = mean)

#Writing the data into output
write.table(aggregatedDf, "tidy_aggregated_data.txt")


