# This script assumes that the zipfile with the raw data is in the current directory.
library(dplyr)

# 'rematch' holds the regular expression that will be used to pick which variables are included from 
# the orginal datasets that are to be carried over into the final product.
# This regular expression only selects variables that wear created using the mean() and std() functions
# as described in the original README.txt file, but not others such as meanFreq(), because that is how I
# have interpretted the assignment text.  Furthermore, only variables in the time domain (prefixed by 't') 
# are included, because I am not considering the the frequency domain variables to be measurements because they
# are derrived by performing fourier transform on the measurements and as such are too far separated from the
# idea of being a measurment.  Other interpretations could also be valid, and would be easily supported by
# changing the value of rematch to 'mean\\(\\)|std\\(\\)' or 'mean|std', for example. 
#
# See the section on 'what columns are measurements on the mean and standard deviation' in the discussion forum
# Here:  https://class.coursera.org/getdata-010/forum/thread?thread_id=49 for further support of this idea.
rematch <- '^t.*mean\\(\\)|^t.*std\\(\\)'

# A function to recursively remove a directory and its contents. (equivalent to "rm -rf" on unix systems)
rmrf <- function(dirname) {
  if (file.exists(dirname)) {
    fl<-list.files(dirname,recursive=TRUE)  # Get a list of files in the directory
    fl<-sub('^',paste(dirname,'/'),fl)      # prepend the directory name
    unlink(fl)                              # remove those files
    unlink(dirname,recursive=TRUE)          # and now remove the directories
  }
}

run_analysis <- function(rematch) {
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
  
  # Read the names of the variables in the measurements sets, this is used
  # to satisfy requirment #3 of the assignment, but for convience it is done early
  # using the col.names parameter the two data file are read.  
  features <- read.table("UCI_HAR_Dataset/features.txt",stringsAsFactors=FALSE)

  # Read the X, y, and subject training data. For the X_training data, set the column names 
  # from the "features" vector. Note that the names of the columns will be slightly different, 
  # because retable conversts non-standard characters (like '(', ')', and '-') get converted to '.' 
  X_train <- read.table(paste0(train_dir,"X_train.txt"),colClasses="numeric",col.names=features$V2)
  y_train <- read.table(paste0(train_dir,"y_train.txt"),col.names="activity")
  subj_train <- read.table(paste0(train_dir,"subject_train.txt"),col.names="subject")

  # Clean up the the varible names "nice" in the X_train data, by reducing multiple periods to a single one,
  # and trimming any '.' that appears at the end of the name.  
  # So, what was originally 'tBodyAcc-mean()-X' became 'tBodyAcc.mean...X' and is now be 'tBodyAcc.mean.X'
  # These are the descriptive names called for in requirment #3, and easily matched back to the original dataset.
  names(X_train) <- gsub("\\.+",'.',names(X_train))
  names(X_train) <- gsub("\\.$",'',names(X_train))
  
  features$clean = names(X_train)
  
  # Get the X, y, and subject test data. Reuse the names from X_train for X_test because they are already clean. 
  X_test <- read.table(paste0(test_dir,"X_test.txt"),colClasses="numeric",col.names=names(X_train))
  y_test <- read.table(paste0(test_dir,"y_test.txt"),col.names="activity")
  subj_test <- read.table(paste0(test_dir,"subject_test.txt"),col.names="subject")

  # combine the test and training X datasets per requirement #1 by appending one to the other
  X_data <- rbind(X_train,X_test)
  
  # merge subject test and training tables together per requirement #1 by appending one to the other. 
  subjects <- rbind(subj_train,subj_test)  # in the same order as above.

  # Read the file with activity numbers to names map
  activity_names <- read.table("UCI_HAR_Dataset/activity_labels.txt",stringsAsFactors=TRUE,col.names=c("id","labels"))

  # create a data.frame by merging activity vectors together, AND turn the numbers into lables by
  # using the values from activity_names table. The column name will be 'activity'.
  activities <- data.frame(activity=activity_names$labels[c(y_train[[1]],y_test[[1]])])

  # Discard the undesirable columns by only taking columns with names that include either "mean" or "std"
  X_data <- X_data[,grepl(rematch,names(X_data))]

  # Combine the subjecrts, activities and X_Data into a single data-frame, this concludes all steps up to #4.
  X_data <- cbind(subjects,activities,X_data)

  # Clean up the order, just because it's nice.
  X_data <- arrange(X_data,subject,activity)

  # Group the data by subject and activity
  grouped_X <- group_by(X_data,subject,activity)

  # Then run summarize_each over the grouped set to calculate the mean of each of the columns.
  summarise_each(grouped_X,funs(mean))
               
}

tidy_uci <- run_analysis()
write.table(tidy_uci,"tidy_UCI_HAR.txt",row.names=FALSE)

#for (i in grep(rematch,features$V2)) {
#  x <- paste0(stri_pad(features$clean[[i]],29,side="right"),"| ","mean of the ",features$V2[[i]]," values, from the original dataset, for the given subject and activity\n")
#  cat(x)
#}

