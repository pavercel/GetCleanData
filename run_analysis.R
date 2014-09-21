# run_analysis.R 
#---------------------GOAL-----------------------------------------------------------------------
#To collect and clean accelerometer data from the Samsung Galaxy Smartphones dataset
#Merges the training and the test sets to create one data set.
#Extracts only the measurements on the mean and standard deviation for each measurement. 
#Uses descriptive activity names to name the activities in the data set
#Appropriately labels the data set with descriptive variable names. 
#Creates a second, independent tidy data set with the average of each variable for each activity & each subject. 

#Note: Useful coding suggestions were provided by David Hood, in Coursera's 'Getting and Cleaning Data' course
#"David Hood's project FAQ" thread: #https://class.coursera.org/getdata-007/forum/thread?thread_id=49

#----------------------STEP 1 GET DATA---------------------------------------------------
#setwd("~/DataCleaning2/UCI HAR Dataset")
#load the data.table library
library(data.table)

#load training dataset and associated files
trainingdata<-read.table("~/DataCleaning2/UCI HAR Dataset/train/X_train.txt")
trainingsubject<-read.table("~/DataCleaning2/UCI HAR Dataset/train/subject_train.txt")
activitylabels_trn<-read.table("~/DataCleaning2/UCI HAR Dataset/train/y_train.txt")#actually contains activity data not labels

        #----------#check dimensions of training-related files--------------
        #dim(trainingdata) #[1] 7352  561
        #dim(trainingsubject) #[1] 7352    1
        #dim(activitylabels_trn)#[1] 7352    1
        

#load test dataset and associated files
testdata<-read.table("~/DataCleaning2/UCI HAR Dataset/test/X_test.txt")
testsubject<-read.table("~/DataCleaning2/UCI HAR Dataset/test/subject_test.txt")
activitylabels_test<-read.table("~/DataCleaning2/UCI HAR Dataset/test/y_test.txt")


        #----------#check structure of test-related files--------------
        #str(testdata) #'data.frame': 2947 obs. of  561 variables:: [...]
        #str(testsubject) #data.frame': 2947 obs. of  1 variable:[...]
        #str(activitylabels_test) # data.frame': 2947 obs. of  1 variable:[...]
        

#----------------------STEP 2 MERGE DATA---------------------------------------------------
#Merge the training and the test sets to create one data set using rbind()

all_data<-rbind(trainingdata, testdata)
all_subjects<-rbind(trainingsubject, testsubject)
all_labels<-rbind(activitylabels_trn, activitylabels_test)

        #-----check structure of combined dataset------------
        #str(all_data) #data.frame': 10299 obs. of  561 variables:
        #str(all_subjects)#data.frame': 10299 obs. of  1 variable:
        #str(all_labels) #data.frame': 10299 obs. of  1 variable:
      

#------------------STEP 3: Extract Variables with MEAN & STD DEV MEASUREMENTS -----------------------
#Extract only those measurements with the mean and std dev for each measurement
#note the variable names for each column are noted in the 'features.txt' file
#need to read this file in and set the col names in all_data DF equal to the variable names

varnames<-read.csv("~/DataCleaning2/UCI HAR Dataset/features.txt", sep="", header=FALSE)[,2]

        # need to specify col2 (see example from features.txt file below)
        #--------------check variable names loaded in from features.txt----------------
                #> head(varnames)
                #V1                V2
                #1  1 tBodyAcc-mean()-X
                #2  2 tBodyAcc-mean()-Y
        #-------------------------------------------------

#assign col names to all_data
names(all_data)=varnames
head(all_data)

        #-------------confirm col names from feature.txt added to DF----
        #head(all_data)
        #tBodyAcc-mean()-X tBodyAcc-mean()-Y tBodyAcc-mean()-Z 
        #1         0.2885845       -0.02029417        -0.1329051
        #2         0.2784188       -0.01641057        -0.1235202
        #3         0.2796531       -0.01946716        -0.1134617
        #4         0.2791739       -0.02620065        -0.1232826
        #5         0.2766288       -0.01656965        -0.1153619
        #6         0.2771988       -0.01009785        -0.1051373
        #----------------------------------------------------------

#Use grep() to select data for all cols with mean(); repeat for std(); cbind the data

selectmean_cols<-all_data[grep("mean\\(\\)", colnames(all_data), value=TRUE)]
selectstd_cols<-all_data[grep("std\\(\\)", colnames(all_data), value=TRUE)]
selectcols<-cbind(selectmean_cols, selectstd_cols)
        
        #str(selectcols)'data.frame': 10299 obs. of  66 variables:


#------------STEP 4: Clean DATA VARIABLE NAMES & CREATE MEANINGFUL ACTIVITY NAMES------------------

#clean up  names of data variables by removing parentheses & hyphens from col names
names(selectcols)<-gsub("\\(\\)", "", names(selectcols))
names(selectcols)<-gsub("-", "", names(selectcols))

     
#assign descriptive labels based on info in "activity_labels.txt"
all_labels$V1[which(all_labels$V1==1)]<-"walking"
all_labels$V1[which(all_labels$V1==2)]<-"walking upstairs"
all_labels$V1[which(all_labels$V1==3)]<-"walking downstairs"
all_labels$V1[which(all_labels$V1==4)]<-"sitting"
all_labels$V1[which(all_labels$V1==5)]<-"standing"
all_labels$V1[which(all_labels$V1==6)]<-"laying"

#rename col V1 to "activity"
colnames(all_labels)<-"activity"

#make descriptive col header for subjects 
colnames(all_subjects)<-"subject"


#-----------STEP 5: COMBINE the 3 DATAFRAMES containing SUBJECT, ACTIVITY & ACCELEROMENTER DATA -----

#Next, combine the dataframe with the subject and activity labels
combo_data<-cbind(all_subjects, all_labels, selectcols)

        #> dim(combo_data) [1] 10299    68


#-----------STEP 6: CREATE SECOND TIDY DATASET WITH MEAN OF EACH VARIABLE FOR EACH SUBJECT------------

#Specify which variables to calculate, NEED ALL columns but the first 2
variables<-tail(names(combo_data), -2)
        
DT<-data.table(combo_data)
#head(DT)

#the following works for aggregating per subject and activity
tidy_data<-DT[,lapply(.SD, mean), by=c("subject", "activity"), .SDcols=variables]

#order rows by subject_ID
tidy_data2<-tidy_data[order(tidy_data$subject),]

#write tidy_data to an output file
write.table(tidy_data2, file = "./tidy_data.txt", sep="\t", row.names=FALSE)

