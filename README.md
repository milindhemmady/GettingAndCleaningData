# README - Getting and Cleaning Data

## Summary

This project allows creating a "clean" data set from the 'UCI HAR Dataset'. Full description is available at:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Data for the project is available at:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

The script "run_analysis.R" merges different subsets of this data into one single data set named "mergeddata". It then summarizes the "mergeddata" to calculate average values of each measurement variable for each activity and each subject to create a new data set named "tidydata". The "tidydata" data set is extracted to CSV file "tidydata.txt" with "SPACE" as column separator. 

## Detail

Before executing the script please make sure the current working directory is set correctly and contains "run_analysis.R" script. Download and unzip the data in current working directory. It should create a sub-folder "UCI HAR Dataset".

To generate tidy data, execute the R script in the working directory where the 'UCI HAR Dataset' folder is located:

    run_analysis.R

The script will create the tidy data file "tidydata.txt" in the working directory. 

The script executes the following steps:

1. Sets variables Data Folder and Data Sources.
2. Load list of the activities.
3. Load list of measurements in variable "features" and create logical vector for filtering mean and standard deviation columns, widths to extract the filtered columns and descriptive names for measurements.
4. Defines function "getcleandataset" to 
    1. Load the individual data files for activity (y data), subject (subject data) and measurements (x data). 
    2. Filter the measurements to select only mean and standard deviation columns. 
    3. Combine the variables into single data set. 
4. Use "getcleandataset" and merges observations for training and test sets into one data set "mergeddata".
5. Create another derived data set "tidydata" with average values of each measurement variable for each activity and each subject.
6. Write "tidydata" to CSV file "tidydata.txt" with "SPACE" as column separator. 

## Dependencies

The script uses the following R libraries which need to be installed:

* dplyr

## Functions

**getcleandataset**

The function loads a subset of the 'UCI HAR Dataset' (i.e. "train" and 
"test" subsets).

* The function loads a subset of the data set. The steps are:
    1. load activities, assign descriptive labels (convert into a factor variable)
    2. load subjects
    3. load mearurements table selecting only the std/mean columns 
    4. combine the columns of subset to create clean data set

## Output

The script generates output file "tidydata'txt" that contains the desired clean data set. See CodeBook.md for data set details. 
