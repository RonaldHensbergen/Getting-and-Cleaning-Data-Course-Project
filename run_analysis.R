#WARNING: I cleanup beforehand and afterwards the environment. 
#Don't run if you want to keep some of your objects

#load necessary packages
library(dplyr)
library(tidyr)
library(data.table)

#cleanup environment
rm(list=ls())

#constants for later use
urlzipfile <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
zipfile <- "./data/smartphones.zip"
testfile <- "UCI HAR Dataset/test/X_test.txt"
trainfile <- "UCI HAR Dataset/train/X_train.txt"
testlabel <- "UCI HAR Dataset/test/y_test.txt"
trainlabel <- "UCI HAR Dataset/train/y_train.txt"
testsubject <- "UCI HAR Dataset/test/subject_test.txt"
trainsubject <- "UCI HAR Dataset/train/subject_train.txt"
activitylabels <- "UCI HAR Dataset/activity_labels.txt"
features <- "UCI HAR Dataset/features.txt"

if(!file.exists("./data")){dir.create("./data")}
download.file(urlzipfile,zipfile)

#get labels files to combine them later with 
#cbind and rbind with the test of the data
testlabels <- read.table(unzip(zipfile  = zipfile, files = testlabel),
                col.names="activityid")
trainlabels <- read.table(unzip(zipfile = zipfile, files = trainlabel),
                col.names="activityid")

testsubjects <- read.table(unzip(zipfile = zipfile, files = testsubject),
                           col.names="subjectid")
trainsubjects <- read.table(unzip(zipfile = zipfile, files = trainsubject),
                           col.names="subjectid")

features <- read.table(unzip(zipfile = zipfile, files = features), sep=" ",
                col.names = c("featureid", "featurename"),
                stringsAsFactors =  FALSE)$featurename #prepare feature columns

#read the test set (normal read.table gives memory issues)
test<-fread(unzip(zipfile=zipfile,files=testfile), sep= " ", 
            col.names=features, check.names = TRUE)
names(test)<-make.unique(names(test))
test <- test %>% mutate(set="test")

#read the training set
train<-fread(unzip(zipfile=zipfile,files=trainfile), sep= " ", 
             col.names=features, check.names = TRUE)
names(train)<-make.unique(names(train))
train <- train %>% mutate(set="train")

#combine everything together in 1 data frame
combineddata <- cbind(rbind(testsubjects,trainsubjects), 
                      rbind(testlabels,trainlabels),
                      rbind(test,train))

#start tidying up the data:
#get rid of features other than mean and std
#gather features into variable rows
#split up the variables into feature, function (mean and std) 
#and direction (X,Y,Z)
#separate first character as the type feature
combineddata<-combineddata %>% 
        select(subjectid, activityid, set, 
               contains("mean()"), contains("std()")) %>%
        gather(variable, value,
               -subjectid,-activityid,-set) %>%
        separate(variable,c("feature","statisticalfunction","direction")) %>%
        separate(feature,c("typecode","feature"),sep=1) #%>%
        #mutate(if(type == 't') {type = 'time'}
        #              else if(type == 'f') {type = 'frequency'})

#mutate (as above) didn't work, so I'll do it the dirty way
typetemp<-data.frame(typecode = c('t','f'),type = c('time','frequency') )

#prepare further breakup of the feature column
#as the BodyBody feature part isn't explicitly explained, I'll leave this in 
#accelerationtype column
featuretemp<-data.frame(feature = c('BodyAcc','GravityAcc','BodyAccJerk',
                                'BodyGyro','BodyGyroJerk','BodyAccMag',
                                'GravityAccMag','BodyAccJerkMag','BodyGyroMag',
                                'BodyGyroJerkMag','BodyBodyAccJerkMag',
                                'BodyBodyGyroMag','BodyBodyGyroJerkMag'),
           accelerationtype = c('Body','Gravity','Body','Body','Body','Body',
                                'Gravity','Body','Body','Body','BodyBody',
                                'BodyBody','BodyBody'),
           accelerometer = c(TRUE,TRUE,TRUE,FALSE,FALSE,TRUE,TRUE,TRUE,FALSE,
                             FALSE,TRUE,FALSE,FALSE),
           jerk = c(FALSE,FALSE,TRUE,FALSE,TRUE,FALSE,FALSE,TRUE,FALSE,TRUE,
                    TRUE,FALSE,TRUE),	
           magnitude = c(FALSE,FALSE,FALSE,FALSE,FALSE,TRUE,TRUE,TRUE,TRUE,
                         TRUE,TRUE,TRUE,TRUE),	
           gyroscope = c(FALSE,FALSE,FALSE,TRUE,TRUE,FALSE,FALSE,FALSE,TRUE,
                         TRUE,FALSE,TRUE,TRUE))

#dimension table for activities
activitytemp <- read.table(unzip(zipfile = zipfile, files = activitylabels),
                         sep=" ", col.names = c("activityid","activityname")) 

#merge data together and a final select
combineddata<-combineddata %>% merge(typetemp,by='typecode') %>%
        merge(featuretemp,by='feature') %>%
        merge(activitytemp,by='activityid') %>%
        select(subjectid:direction,activity=activityname,type:gyroscope,value)

groupeddata <- combineddata %>% 
        group_by(type, accelerationtype,
                 statisticalfunction, direction, accelerometer, jerk, 
                 magnitude, gyroscope, activity, subjectid) %>% 
        summarise(mean(value))

if(!file.exists("./export")){dir.create("./export")}
write.table (groupeddata,"./export/summary.txt", row.names = FALSE)
#cleanup
rm(list=setdiff(ls(), c("combineddata", "groupeddata")))