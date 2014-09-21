#CODEBOOK FOR run_analysis.R

##Codebook Overview

This codebook describes the variables, the dataset, and the experimental design that was used to collect and clean accelerometer data from the Samsung Galaxy Smartphone dataset.

##Dataset
The dataset used in this study contains accelerometer and gyroscope data collected from Samsung Galaxy S smartphones from 30 volunteers. The data was recorded for each subject as they performed six daily activities (i.e., walking, walking upstairs, walking downstairs, sitting, standing and laying). The dataset contains a total of 10,299 observations for 561 variables.

*A complete description of the dataset can be found at: (http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones) 

*The data for the project was downloaded from: 
(https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) 

*An overview of the relationship between the Samsung dataset files along with helpful processing tips was provided by David Hood, Coursera: Getting and Cleaning Data Course, discussion thread: (https://class.coursera.org/getdata-007/forum/thread?thread_id=49)


##Overview of Processing Steps

1. Download the project data (see URL above). 
2. Merge the training and the test sets to create one data set.
3. Extract only the measurements on the mean and standard deviation for each measurement. 
4. Create descriptive activity names to name the activities in the data set
5. Label the data set with descriptive variable names. 
6. Create a second, independent tidy data set with the average of each variable for each activity and each subject. 


##Data Transformation Approaches and Processing Notes

1.	The following training-related files are needed to assemble and process the training data (Note: the corresponding ‘test’-related files were needed to process the test data):

    a)  (X_train.txt) contains the measurement data for the training set
    
    b)  (subject_train.txt) contains the subject identifiers for the training set
    
    c)  ('y_train.txt) contains the training labels (i.e., activity codes)
    
    d)  (features.txt) contains the names for the measurement variables.

2.	First, load the training dataset and associated files(noted above); next, load test dataset and associated test files.
3.	Merge the training and the test datasets using rbind() as follows: merge the measurement data from the test and training files; merge the subject data from the test and training files; and merge the activity data from the test and training data files.
4.    The variable names for each column in the merged measurement dataframe are located in the (features.txt) file. Read this file in and set the colnames to the variable names in this file.
5.	Next, extract only those measurements containing the mean() and std dev() for each measurement using grep(), then cbind () the data.
6. Clean up the variable names according to the tidy data heuristics by removing parentheses & hyphens from col names, and using lowercase letters when possible. (Note: the capitalization was left in the measurement variable names because changing to all lower case would reduce readability).
7.	Combine the 3 dataframes that contain the measurement data, subject data and activity data into a single dataframe using cbind().
8.	To create the second tidy dataset, first specify which measurement variables are needed to calculate the mean of each variable (i.e., don’t need the first two columns which contain the subject and activity label).
9.	Use lapply to calculate the mean of the measurement variables and aggregate the results by subject, then activity.
10.	Order the rows by subject ID.
11.	Write the tidy_data dataset to an output file using write.table()


###The following transformations in the variable names were made:

  *the parentheses and hyphens were removed from the measurement variable names.
  *descriptive labels were assigned to activities by replacing the activity code with the name (e.g., 1 = “walking”)
  *a descriptive col header was created for activity 
  *a descriptive col header was created for subjects
