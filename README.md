##README 

##Getting and Cleaning Data Course Project


##Project Overview

The run_analysis.R script was created to collect, process, and clean accelerometer data from a Samsung Galaxy Smartphone dataset. Specifically, this script will merge the Samsung training and the test datasets into a single dataset and subsequently extract only those variables that contain measurement data relating to the mean and standard deviation for each measurement variable. Next, the average of the selected measurement variables for each subject and each activity and will be calculated and returned as an independent, tidy data set in a new file called tiny_data.txt.  

#Dataset
A complete description of the dataset can be found at: (http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones) 

The data for the project can be found at: 
(https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) 

A complete description of the variables and data processing steps can be found in the ‘runAnalysis_Codebook.md’ file.


#Peer Review of Output
To view the tidy_data.txt output in R Studio:

1.	Download tidy_data.txt 
2.	In the R studio menu, go to > Tools > Import dataset > From Text File>tidy_data.txt >Import
(Note: accept defaults (i.e., header = yes; tab separator) for import)


#Running the run_Analysis.R script
1.	Download the zip file with the project data and unzip (parent folder = ‘UCI HAR Dataset’).
2.	Download the run_Analysis.R source file into the ‘UCI HAR Dataset’ folder.
3.	Set working directory using setwd() to this parent folder.
4.	Run source(“run_analysis.R”).


#Dependencies
  The run_Analysis.R script relies on the data.table library. 

