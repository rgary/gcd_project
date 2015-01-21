---
title: "CodeBook.md"
output: html_document
---
## Description

The dataset presented in the file 'tidyUCI_HAR.txt' is a distillation of some files found in the zip archive 'getdata_projectfiles_UCI HAR Dataset.zip'[1]. There are several files containing raw data from the experiments and two datasets ("training" and "test") that consist of values derrived from the raw data. The training and test datasets are structurally identical and vary only in the number of rows and the specific values stored in each. Each of these datasets is made up of three files, one each that contains the subject, the data (X values), and the activity-labels (y values). 

The collection and preprocessing of the original data is described in the excerpt from the original README.txt[1]:

```
The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data.

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. See 'features_info.txt' for more details.

For each record it is provided:
======================================

- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
- Triaxial Angular velocity from the gyroscope.
- A 561-feature vector with time and frequency domain variables.
- Its activity label.
- An identifier of the subject who carried out the experiment.
```

Furthermore, the features in the original dataset are described in the file "features_info.txt"[1] this way:

```
Feature Selection 
=================

The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

tBodyAcc-XYZ
tGravityAcc-XYZ
tBodyAccJerk-XYZ
tBodyGyro-XYZ
tBodyGyroJerk-XYZ
tBodyAccMag
tGravityAccMag
tBodyAccJerkMag
tBodyGyroMag
tBodyGyroJerkMag
fBodyAcc-XYZ
fBodyAccJerk-XYZ
fBodyGyro-XYZ
fBodyAccMag
fBodyAccJerkMag
fBodyGyroMag
fBodyGyroJerkMag

The set of variables that were estimated from these signals are: 

mean(): Mean value
std(): Standard deviation
mad(): Median absolute deviation 
max(): Largest value in array
min(): Smallest value in array
sma(): Signal magnitude area
energy(): Energy measure. Sum of the squares divided by the number of values. 
iqr(): Interquartile range 
entropy(): Signal entropy
arCoeff(): Autorregresion coefficients with Burg order equal to 4 
correlation(): correlation coefficient between two signals
maxInds(): index of the frequency component with largest magnitude
meanFreq(): Weighted average of the frequency components to obtain a mean frequency
skewness(): skewness of the frequency domain signal 
kurtosis(): kurtosis of the frequency domain signal 
bandsEnergy(): Energy of a frequency interval within the 64 bins of the FFT of each window.
angle(): Angle between to vectors.

Additional vectors obtained by averaging the signals in a signal window sample. These are used on the angle() variable:

gravityMean
tBodyAccMean
tBodyAccJerkMean
tBodyGyroMean
tBodyGyroJerkMean

The complete list of variables of each feature vector is available in 'features.txt'
```
The run_analysis.R script ignores the raw data and operates only on the training and test datasets to combine the two sets into one, and to merge the multiple parts in different files into a single file.  The resulting dataset is culled to eliminate any variables that are not calculated mean or standard deviations of the raw data measurements. Finally the reduced dataset is grouped by subject and activity and a mean value of the kept values is presented.  These are the values that are stored in tidyUCI_HAR.txt in a form that is consistant with tidy data principles.

The reduced tidy dataset provides data on 30 subjects performing 6 activities for a total of 180 rows. (not counting the headers)

Each row of the tidyUCI_HAR dataset consisist of the observed values of several values for a single subject performing a single activity. The columns of the dataset contain the variables described in the table below. The order of the table entries below matches the column order in the dataset.

## Variables present
Col Num | Tidy Variable Name | Units | Description | Variable Name in Source Dataset 
----|----------------|-------|---|------
1|subject |   | The subject number, an integer from 1-30 | &nbsp; 
2|activity |  |  A textual description of the subjects' activity, mapped from the file 'activity_labels.txt': 1=WALKING, 2=WALKING_UPSTAIRS, 3=WALKING_DOWNSTAIRS, 4=SITTING, 5=STANDING, 6=LAYING | &nbsp; 
3|tBodyAcc.mean.X | g &nbsp;&nbsp;&nbsp;&nbsp; Note^1^| Mean of X axis body acceleration. | tBodyAcc-mean()-X
4|tBodyAcc.mean.Y | g | Mean of Y axis body acceleration. | tBodyAcc-mean()-Y
5|tBodyAcc.mean.Z | g | Mean of Z axis body acceleration. | tBodyAcc-mean()-Z
6|tBodyAcc.std.X | g | Mean of standard deviations of X axis body acceleration. | tBodyAcc-std()-X
7|tBodyAcc.std.Y | g | Mean of standard deviations of Y axis body acceleration. | tBodyAcc-std()-Y
8|tBodyAcc.std.Z | g | Mean of standard deviations of Z axis body acceleration. | tBodyAcc-std()-Z
9|tGravityAcc.mean.X | g | Mean of X axis gravity acceleration. | tGravityAcc-mean()-X
10|tGravityAcc.mean.Y | g | Mean of Y axis gravity acceleration. | tGravityAcc-mean()-Y
11|tGravityAcc.mean.Z | g | Mean of Z axis gravity acceleration. | tGravityAcc-mean()-Z
12|tGravityAcc.std.X | g | Mean of standard deviations of X axis gravity acceleration. | tGravityAcc-std()-X
13|tGravityAcc.std.Y | g | Mean of standard deviations of Y axis gravity acceleration. | tGravityAcc-std()-Y
14|tGravityAcc.std.Z | g | Mean of standard deviations of Z axis gravity acceleration. | tGravityAcc-std()-Z
15|tBodyAccJerk.mean.X | g/sec Note^2^ | Mean of X axis body acceleration jerk. | tBodyAccJerk-mean()-X
16|tBodyAccJerk.mean.Y | g/sec | Mean of Y axis body acceleration jerk. | tBodyAccJerk-mean()-Y
17|tBodyAccJerk.mean.Z | g/sec | Mean of Z axis body acceleration jerk. | tBodyAccJerk-mean()-Z
18|tBodyAccJerk.std.X | g/sec | Mean of standard deviations of X axis body acceleration jerk. | tBodyAccJerk-std()-X
19|tBodyAccJerk.std.Y | g/sec | Mean of standard deviations of Y axis body acceleration jerk. | tBodyAccJerk-std()-Y
20|tBodyAccJerk.std.Z | g/sec | Mean of standard deviations of Z axis body acceleration jerk. | tBodyAccJerk-std()-Z
21|tBodyGyro.mean.X | rad/sec | Mean of X axis body gyroscope (angular velocity). | tBodyGyro-mean()-X
22|tBodyGyro.mean.Y | rad/sec | Mean of Y axis body gyroscope (angular velocity). | tBodyGyro-mean()-Y
23|tBodyGyro.mean.Z | rad/sec | Mean of Z axis body gyroscope (angular velocity). | tBodyGyro-mean()-Z
24|tBodyGyro.std.X | rad/sec | Mean of standard deviations of X axis body gyroscope (angular velocity). | tBodyGyro-std()-X
25|tBodyGyro.std.Y | rad/sec | Mean of standard deviations of Y axis body gyroscope (angular velocity). | tBodyGyro-std()-Y
26|tBodyGyro.std.Z | rad/sec | Mean of standard deviations of Z axis body gyroscope (angular velocity). | tBodyGyro-std()-Z
27|tBodyGyroJerk.mean.X | rad/sec^3^ Note^3^| Mean of X axis body gyroscope jerk. | tBodyGyroJerk-mean()-X
28|tBodyGyroJerk.mean.Y | rad/sec^3^ | Mean of Y axis body gyroscope jerk. | tBodyGyroJerk-mean()-Y
29|tBodyGyroJerk.mean.Z | rad/sec^3^ | Mean of Z axis body gyroscope jerk. | tBodyGyroJerk-mean()-Z
30|tBodyGyroJerk.std.X | rad/sec^3^ | Mean of standard deviations of X axis body gyroscope jerk. | tBodyGyroJerk-std()-X
31|tBodyGyroJerk.std.Y | rad/sec^3^ | Mean of standard deviations of Y axis body gyroscope jerk. | tBodyGyroJerk-std()-Y
32|tBodyGyroJerk.std.Z | rad/sec^3^ | Mean of standard deviations of Z axis body gyroscope jerk. | tBodyGyroJerk-std()-Z
33|tBodyAccMag.mean | g | Mean of body accelation magnitudes. | tBodyAccMag-mean()
34|tBodyAccMag.std | g | Mean of standard deviations of body accelation magnitudes. | tBodyAccMag-std()
35|tGravityAccMag.mean | g | Mean of mean gravity magnitudes. | tGravityAccMag-mean()
36|tGravityAccMag.std | g | Mean of standard deviations of mean gravity magnitudes. | tGravityAccMag-std()
37|tBodyAccJerkMag.mean | g/sec | Mean of body jerk magnitudes. | tBodyAccJerkMag-mean()
38|tBodyAccJerkMag.std | g/sec | Mean of standard deviations of body jerk magnitudes. | tBodyAccJerkMag-std()
39|tBodyGyroMag.mean | rad/sec | Mean of body gyroscope magnitudes. | tBodyGyroMag-mean()
40|tBodyGyroMag.std | rad/sec | Mean of standard deviations of body gyroscope magnitudes. | tBodyGyroMag-std()
41|tBodyGyroJerkMag.mean | rad/sec^3^ | Mean of body gyroscope jerk magnitudes. | tBodyGyroJerkMag-mean()
42|tBodyGyroJerkMag.std | rad/sec^3^ | Mean of standard deviations of body gyroscope jerk magnitudes. | tBodyGyroJerkMag-std()

#### Notes on Units in the Variable Table

Note^1^ - As described in the original README.txt, 'g' represents "standard gravity units". 

Note^2^ - The units for Acceleration Jerk are not specified in the original dataset but based on the angular velocity being radians/second, it has been presumed that all time is measured in seconds, so the units for jerk would but would most likely be g/sec.

Note^3^ - The units for Gyroscopic Jerk are not specified in the oritinal dataset, but assuming time is measured in seconds, then angular jerk, as the second derrivative of velocity would most likely be rad/sec^2.  It is somewhat surprising that the dataset is reporting angular velocity and angular jerk, but not angular acceleration.  

## References
Details on the original work can be found in the following publication [1]:

[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

The data and work description are also available online here:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones



