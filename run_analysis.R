# This script assumes that the zipfile with the raw data is in the current directory.

# define some conviences variables:

# A function to recursively remove a directory and its contents. (equivalent to "rm -rf" on unix systems)
rmrf <- function(dirname) {
  if (file.exists(dirname)) {
    fl<-list.files(dirname,recursive=TRUE)  # Get a list of files in the directory
    fl<-sub('^',paste(dirname,'/'),fl)      # prepend the directory name
    unlink(fl)                              # remove those files
    unlink(dirname,recursive=TRUE)          # and now remove the directories
  }
}


#
# Unzip and Read the data from the files.
#

#read_data <- function() {
  # first remove any prior version so of the unzipped data, in case it was modified.
  rmrf("UCI HAR Dataset")
  rmrf("UCI_HAR_Dataset")
  
  # unzip the raw data
  unzip("getdata_projectfiles_UCI HAR Dataset.zip", overwrite=TRUE)
  
  # rename the directories that had spaces in their names and substitute underscores for those spaces.
  # This is done for the convience of users that have unix-like systems that will find spaces awkward
  # to deal with.
  
  file.rename("UCI HAR Dataset","UCI_HAR_Dataset")
  
  # Where the data is found
  train_dir <- "UCI_HAR_Dataset/train/"
  test_dir <- "UCI_HAR_Dataset/test/"
  
  # Two correcsponding sets of files for the training and test sets. 
  train_files <- list.files(train_dir)
  test_files <- list.files(test_dir)
  
  # Read the names of the variables in the measurements sets
  features <- read.table("UCI_HAR_Dataset/features.txt",stringsAsFactors=FALSE)

  # Read the file with activity numbers to names map
  activities <- read.table("UCI_HAR_Dataset/activity_labels.txt",stringsAsFactors=TRUE,col.names=c("id","labels"))
  

  # Get the training data
  X_train <- read.table(paste0(train_dir,"X_train.txt"),colClasses="numeric",col.names=features$V2)
  y_train <- read.table(paste0(train_dir,"y_train.txt"),col.names="activity")
  subj_train <- read.table(paste0(train_dir,"subject_train.txt"),col.names="subject")



  
  # Make the varible names "nice"
  names(X_train) <- gsub("\\.+",'.',names(X_train))
  names(X_train) <- gsub("\\.$",'',names(X_train))
  
  # Get the test data, reuse the names from X_Train.
  X_test <- read.table(paste0(test_dir,"X_test.txt"),colClasses="numeric",col.names=names(X_train))
  y_test <- read.table(paste0(test_dir,"y_test.txt"),col.names="activity")
  subj_test <- read.table(paste0(test_dir,"subject_test.txt"),col.names="subject")

  # combine the test and training datasets
  X_data <- rbind(X_test,X_train)
  
  # merge subject tables together
  subjects <- rbind(subj_train,subj_test)

  # merge the activities tables together and change to labels using the activities table (vector) 
  y <- data.frame(activity=activities$labels[c(y_train[[1]],y_test[[1]])])

  # Filter out the undesirable columns by looking for columns with names that include "mean" or "std"
  X_data <- X_data[,grepl('mean|std',names(X_data))]

  # Add columns for the subject and the activity.
  X_data <- cbind(subjects,y,X_train)
  
#}