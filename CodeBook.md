Getting and Cleaning Data course project (1st May 2016): Code Book

* Details on the original data the analysis is run on:

Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

Website of the original project, with a detailed description of the measures recorded and other sampling informations.

Accessed on April 2016 as a zip file via the url: 
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

* Description of the original data: 

- 30 volunteers (labeled from 1 to 30) performed a certain number of times six activities (labeled: WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING). 

- Using a smartphone they wear during the experiments, their linerar acceleration and angular momentum (each of which with respect to the three axis: X,Y,Z) were measured.

- other measures where obtained from these latter, by applyiong different functions (mean, std, ...) and transformations (FFT,...) on them. Finally, there are 561 different measures for each session of each activity of each participant (the names of the corresponding measurements are stored in a text file named "features.txt").

-The participants are divided randomly into two groups, and the data of the participants are accordingly saved into two different file directories: "training" (containing the measures of 21 participants) and "test" (containing the measures of the remaining 9 participants)


* Description of the tidy data set "finaldataset" obtained by running the script "run_analysis.R"

For each participant (variable "id" from 1 to 30) 
and for each activity (variable "activity" : "walking", "walkingupstairs", "walkingdownstairs", "sitting", "standing", "laying")
is given the mean of the different measures of the repeated experiments.

- Are considered only the variables 

bodylinearacceleration X|Y|Zaxis
gravitylinearacceleration X|Y|Zaxis
bodyangularvelocoty X|Y|Zaxis

as well as estimated variables

FFT (Fast Fourier Transform)
Jerksignal (time derivative)
Magnitude (using the Euclidean norm)
meanvalue
stdeviationvalue

-> this give us a data frame of dimension (30x6)X68= 180X68


* Description of the script: 
(explanation of the different variables appearing in the script and the steps for cleaning the original data and obtain the "finaldataset")

      0) Prelinaries: 
            -download the original data into a new "dataproj" directory
            - change the working directory to "dataproj", where the data file has been downloaded
            - unzip the downloaded file
      All the original data to be accessed is then in the directory "dataproj\\UCI HAR Dataset"
      
            - load the necessary packages for the analysis
            
      1') Create the training and test dataframes (including "id" and "activities")
            - Extract the names of variables of test and train sets from the downloaded file (data frame "features"), and store them into a character vector "varnames" (of length 561)
            
            -Create a training data frame:
            i) read the trainingset data and assign it to the temporaty variable "trainset"; set the columns names to be the elements of "varnames"; 
            ii) read the activity_labels for this set of observations, and assign to a variable "trainlab" (to be a character vector);
            iii) read the subject_training for this set of observations and assign it to a variable "trainid"
            iv) merge "trainid", "trainlab" and "trainset" using column bind, to obtain a complete data frame "training" with all the informations and variables. The dimensio of "training" is 7352X563 
            
            -Create a test data frame (analogously: steps i)--iv)). The data frame "test" obtained has dimensions 2947X563
            
      1) Merge (using row bind) the "training" and "test" data frames. Assign the result to variable "data": is is a data frame of dimensions 10299X563
      
      2)Extract only the measurements with "mean()" and "std()" in the variable name (keeping the "id" and "activity columns, and excluding "meanFreq"!)
      Store the result in a data frame called "msdata". Its dimension is 10299X68
      
      3)Use descriptive activity names to name the activities in the data set
            -Exctract activity labels from downloaded data, and store them in a variable called "activitynames". Make it a character vector (of length 6)
            - For each element, using a loop, format the activity names: lowar case and no "_" and store the result again in "activitynames"
            - Using a loop from 1 to 6, change the 1:6 values of the "activity" column in "msdata" with corresponding descriptive names.
      
      4) Appropriately labels the data set with descriptive variable names. Do it recursively, for each i-th variable name (except 'id' (i=1) and "activity" (i=2)). In the new names are inserted few blank spaces only for readability 
      [ e.g. "BodyAcc" is changed in "bodylinearacceleration"
            "GravityAcc" is changed in "gravitylinearacceleration"
            "BodyGyro" is changed in "bodyangularvelocity"
            etc.
      See 'Description of the tidy data set' above for the new names of the considered varaibles
      ]
      
      5)From "msdata" create a second, independent tidy data set "finaldataset" with the average of each variable for each activity and each subject.
      - (optional) sort "msdata" by "activity" and "id" (in this order)
      - define a new data frame "grpdata", where "msdata" is grouped by "activity" and "id"
      - using summarize_each() function on "grpdata" to create "finaldataset", with the average of each measure with respect to activity and subject.
      
      6) save the obtained dataset "finaldataset" in a text file, " "-separated.
      