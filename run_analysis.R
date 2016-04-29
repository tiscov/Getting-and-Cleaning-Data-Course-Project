##Getting and Cleaning Data Course Project
##script performing the analysis as described in the instructions of the project.

##Preliminaries: 
      ##download original data file and unzip it
if(!file.exists(".\\dataproj")){dir.create(".\\dataproj")}
fileUrl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url = fileUrl, destfile = ".\\dataproj\\project-data.zip")
setwd(".\\dataproj")
unzip("project-data.zip") ##the set of data are then in a directory called "UCI HAR Dataset"

      ##load package(s) we need 
library(dplyr)

##1')Create the training and test dataframes (including "id" and "activities")
      ##Extract the names of variables of test and train sets from the 
      ##downloaded data

      features<-read.table(".\\UCI HAR Dataset\\features.txt", colClasses = "character")
      varnames<-features[[2]]  #extract vector of variable names 

      ##Create the training set data frame 

      trainset<- read.table(".\\UCI HAR Dataset\\train\\X_train.txt", col.names = varnames, colClasses = "numeric")
      trainlab<-read.table(".\\UCI HAR Dataset\\train\\y_train.txt", col.names="activity")
      trainid<-read.table(".\\UCI HAR Dataset\\train\\subject_train.txt", col.names="id")
      training<- cbind(trainid, trainlab, trainset)
      
      ##Create the test set data frame

      testset<- read.table(".\\UCI HAR Dataset\\test\\X_test.txt", col.names = varnames, colClasses = "numeric" )
      testlab<-read.table(".\\UCI HAR Dataset\\test\\y_test.txt", col.names="activity")
      testid<-read.table(".\\UCI HAR Dataset\\test\\subject_test.txt", col.names="id")
      test<- cbind(testid, testlab, testset)
      

##1)Merge the training and the test sets to create one data set.

data<-rbind(training, test) ##we obtain a data frame of dimensions 10299x563

##2)Extract only the measurements on the mean and standard deviation 
##for each measurement (and not the "meanFreq"!)

z <- grepl("id|activity|mean\\.|std\\.",names(data))  
msdata <- data[,z]   ##we obtain a data frame of dimensions 10299x68

##3)Use descriptive activity names to name the activities in the data set
      ##Exctract activity labels from downloaded data

      activitynames<- read.table(".\\UCI HAR Dataset\\activity_labels.txt", colClasses ="character")
      activitynames<- activitynames[,2]
      
      ##Format the activity names: lowar case and no "_"
      j<-1; 
      for(j in 1:length(activitynames)){
            a <- activitynames[j]
            a <- tolower(a)
            activitynames[j]<-gsub("_","", a)
            j<-j+1
      }

      ##Change the activity number in the data frame obtained in the previous 
      ##step with descriptive names of the activities.
      i<-1; 
      for(i in 1:length(activitynames)){
      msdata$activity<- sub(i, activitynames[[i]], msdata$activity)
      i<-i+1
      }



##4)Appropriately labels the data set with descriptive variable names.
## Do it recursively, for each i-th variable name (except 'id' (i=1) and "activity" (i=2))
## In the new names are inserted few blank spaces only for readability 
      i<-3;
      for(i in 3:length(names(msdata))){
            w<- names(msdata)[i] ##extract the variable name into a temp object
            w<- gsub("\\.","",w) ##erase non-letter character in the variable name (appearing as a ".")
            
            ##change the beginning of the variable name (either unprocessed of Fast Fourier Transform)
            w<- sub("^t","",w)
            w<- sub("^f","FFT of ",w)
            
            ##change the 
            w<- sub("BodyAcc","linearbodyacceleration",w)
            w<- sub("GravityAcc","bodygravityacceleration",w)
            w<- sub("BodyGyro","bodyangularvelocity",w)
            w<- sub("Jerk","Jerksignal",w)
            w<- sub("Mag","Magnitude",w)
            w<- sub("Body","",w) ##erase doubles (that appears in some variable names)
            
            w<- sub("std"," stdeviationvalue ",w)
            w<- sub("mean"," meanvalue ",w)
            
            if(grepl("X$|Y$|Z$",w)){
                  w<- sub("X$","Xaxis",w)
                  w<- sub("Y$","Yaxis",w)
                  w<- sub("Z$","Zaxis",w)
            }
            names(msdata)[i]<- w ## set the new variable name
      }
      
##5)From the data set in previous step, create a second, independent tidy 
##data set with the average of each variable for each activity and each 
##subject.
      
      ##(optional) order by activity (6) and subject (30) (hence 6x30=180 levels)
      msdata<- msdata %>% arrange(activity, id)
      
      ##group by activity and subject
      grpdata<- msdata %>% group_by(activity, id)

      ## create the data set
      finaldataset <- grpdata %>% summarise_each(funs(mean)) 
      
      
      finaldataset ##this is the final data set, of dimension 180x68
      
##write the finaldataset, on a text file called "finaldataset.txt" in the 
## ".\\data" directory created at the beginning of this script
write.table(finaldataset, file=".\\finaldataset.txt", sep=" ", row.names = FALSE)
      