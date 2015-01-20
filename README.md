---
title: "README.md"
output: html_document
---
## Description
This repository contains the work required for session 10 of the Coursera class "Getting and Cleaning Data" from January of 2015.
The key files in this repository are: 
  - run_analysis.R (An R script which cleans a given dataset and produces a new tidy datset as a result.)
  - README.md   (This file, which describes the work performed, including details about the implementation of the run_analysis.R script   
  - codeBook.md (A markdown document describing the data produced by run_analysis.R)
  
'''
This script was written to satisfy the following project requirements:

You should create one R script called run_analysis.R that does the following. 

    1. Merges the training and the test sets to create one data set.
    2. Extracts only the measurements on the mean and standard deviation for each measurement. 
    3. Uses descriptive activity names to name the activities in the data set
    4. Appropriately labels the data set with descriptive variable names. 
    5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
'''

As hinted at in the specification, there are actually two datasets in the archive.  One for training and the other for testing.  The datasets are further broken up into three parts: a subject file, which simply lists which subject is associated with each row of the data; an "X" part which provides the rows of measured and calculated variables, and the "y" part which reveals the activity that was being performed for row. To be complete, each of the corresponding parts of the two datasets will be joined with rbind() and then the parts will be assembled with cbind(). (Other orders are possible.)

## Execution
This script is standalone and takes no arguments.  To use is, open an R or RStudio console, change directory to the location that contains the script and the zip archive "getdata_projectfiles_UCI HAR Dataset.zip" and type 'source("run_analysis.R")'

## Theory of operation
While the script meets all of the requirements, it does not necessarily perform all of the steps in the given order.  Some parts were taken out of order, and some undescribed activites were introduced as a matter of pragmatic programming.

### Assumptions and dependencies
There is a some abiguity in the specification.  In particular item #2 does not make it explicit which fields of the datasets should be included in the final product.  Based on the README.txt file showing several functions that were used to define variables in the source datasets, it was concluded that only the two had the exact names of 'mean()' and 'std()' would be extracted, but not others that only matched partially. (In particular any meanFreq() results were excluded.) Also, a conclusion was reached that the frequency based variables, which were calculated from measurements by use of a fourier transform, were to far removed from the idea of a direct measurement to be considered measurments themselves.  As such they were excluded from resultant dataset as well. (Guidence to this affect can be found in the 'what columns are measurements on the mean and standard deviation' section of the discussion forum entry that can be found here: https://class.coursera.org/getdata-010/forum/thread?thread_id=49 )

To make supporting alternate conclusions that those in the preceding paragraph, the script begins by defining a variable called 'rematch' which contains the regular expression that is used to select the variables from the source datasets.  Alternate values are easily constructed, and two other possibilities are defined in the comments of the script.

The run_analysis script expects the zip-archive containing data to present in its current directory, and to be named "getdata_projectfiles_UCI HAR Dataset.zip".

### Preamble
After importing the dplyr library and defining the rematch variable, the script defines two functions, the first is a small utility function called "rmrf" which provided equivalent functionality to the unix command "rm -rf" and is used for cleaning up files and directories that may not be of interest.

The second function defined by the script is called "run_analysis". It takes a single argument, which is the regular expression used to select the columns. This function is responsible for all of the heavy lifting of this project.  The work was encapsulated into a function in order to keep temporary variables short lived, and to enable the use of the script to get a data.frame that could be accessed directly, instead of reading from the output file. Although in this case, the execution of the script will simply call the run_analysis function and then write the data out.

### preparing to and then reading the data
The run_analysis script has the name of the zip archive explicitly coded. The first thing the script does is to remove any old copies of the unzipped data and then unzip the archive into a fresh directory.  For debugging convience, the top level directory is then renamed, changing spaces to underscores. (Because directories with spaces in them are not user-friendly on non-windows systems.)

Next, in support of requirement #4, the names of the variables are read in from the file 'features.txt' and stored in a data.frame named 'features'.  These names will be passed to the read.table() call that gets the training data. The names as read are not valid column names, however the script takes advantage of the fact that read.table() will modify the names by changing any illegal characters to periods. 

At this point the script reads the training data by making three calls to read.table(), one each for the files "X_train.txt", "y_train.txt", and "subject_train.txt", which are found in the sub-directory "UCI_HAR_Dataset/train". The result of these read.table calls are stored in variables called X_train, y_train and subject_train. The call the reads X_train sets the col.names parameter to the values found in features, and also sets the column classes to 'numeric'. The calls that read y_train and subject_train have only one column of data each, these are given names of 'activity' and 'subject' respectively.

The column names on the X_train data are now better than the names originally read in, but still somewhat messy because they contain some redundant and trailing periods.  Before reading more data, the script uses gsub calls to clean up the names and re-apply the cleaned up names to the X_train data.frame. 

Then the test data is read in in a manner that is nearly identical to the read the training data, producing data.frames names 'X_test', 'y_test' and 'subject_test'. The key exception here is that the column names for X_test are copied directly from X_train.
  
  # Where the data is found

  
  # Two correcsponding sets of files for the training and test sets. 

  # Read the names of the variables in the measurements sets, this is used
  # to satisfy requirment #3 of the assignment, but for convience it is done early
  # using the col.names parameter the two data file are read.  
  features <- read.table("UCI_HAR_Dataset/features.txt",stringsAsFactors=FALSE)

  # Read the X, y, and subject training data. For the X_training data, set the column names 
  # from the "features" vector. Note that the names of the columns will be slightly different, 
  # because retable conversts non-standard characters (like '(', ')', and '-') get converted to '.' 



  # Clean up the the varible names "nice" in the X_train data, by reducing multiple periods to a single one,
  # and trimming any '.' that appears at the end of the name.  
  # So, what was originally 'tBodyAcc-mean()-X' became 'tBodyAcc.mean...X' and is now be 'tBodyAcc.mean.X'
  # These are the descriptive names called for in requirment #3, and easily matched back to the original dataset.

  
  # Get the X, y, and subject test data. Reuse the names from X_train for X_test because they are already clean. 


  # combine the test and training X datasets per requirement #1 by appending one to the other

  
  # merge subject test and training tables together per requirement #1 by appending one to the other. 
 # in the same order as above.

  # Read the file with activity numbers to names map


  # create a data.frame by merging activity vectors together, AND turn the numbers into lables by
  # using the values from activity_names table. The column name will be 'activity'.


  # Discard the undesirable columns by only taking columns with names that include either "mean" or "std"


  # Combine the subjecrts, activities and X_Data into a single data-frame, this concludes all steps up to #4.

  # Clean up the order, just because it's nice.


  # Group the data by subject and activity


  # Then run summarize_each over the grouped set to calculate the mean of each of the columns.
 
               
}

