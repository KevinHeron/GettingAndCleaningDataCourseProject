Data Source
===========
More information on the dataset can be found at 
[http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones).
The actual data can be found here:
[https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip).
With the zip file is a codebook called `features_info.txt` as well as a 
`README.txt` that may provide more information on the input data. 

*This codebook* deals specifically with modifications to that data in general, 
and the steps to the resulting `tidy.txt` table specifically.

Part One
========
*Merges the training and test sets to create one data set*. 

The resultant 
dataset, called `part1_df` in R was formed in part by following the dimensions
of the datasets and the directions provided by [https://drive.google.com/file/d/0B1r70tGT37UxYzhNQWdXS19CN1U/view?usp=sharing](https://drive.google.com/file/d/0B1r70tGT37UxYzhNQWdXS19CN1U/view?usp=sharing).

After the source data file was downloaded and unzipped, the directory where the data files 
were was renamed from `UCI HAR Dataset` to `har_data` for brevity.

`har_data` contained several files including: 

* `har_data/features.txt             `
* `har_data/activity_labels.txt      `
* `har_data/train/subject_train.txt  `
* `har_data/train/y_train.txt        `
* `har_data/train/X_train.txt        `
* `har_data/test/subject_test.txt    `
* `har_data/test/y_test.txt          `
* `har_data/test/X_test.txt          `

The data was read in and `rbind`ed with `test` data on top and `train`
data on the bottom (e.g., `x_all <- rbind(x_test, x_train)`.
Then the data was `cbind`ed like so: `part1_df <- cbind(subject_all, y_all, x_all)`.

Part Two
========
*Extracts only the measurements on the mean and standard deviation for each measurement*.

I extracted the fields with mean and standard deviation using the
`grep` function. Note that `features.txt` had the names and the names
were previously set in part one (as outlined in the accompanying R script). The
features are adequately described in `feature_info.txt`.

`select` fields with names which match the regex 
`".*Mean.*|.*Std.*|activity|subject"`. Note that `ignore.case = TRUE` with
`grep`.

Part Three
==========
*Uses descriptive activity names to name the activities in the data set.*

`activity_labels.txt` contains the activity labels that correspond to each
activity code. For example:

* 1 is WALKING
* 2 is WALKING_UPSTAIRS
* 3 is WALKING_DOWNSTAIRS
* 4 is SITTING
* 5 is STANDING
* 6 is LAYING

`merge` this data to `part2_df` and set the activity code field to NULL.
In other words: `part3_df <- merge(part2_df, activity_labels); part3_df$activity <- NULL`.

Part Four
========
*Appropriately labels the dataset with descriptive names.*

After reviewing the documentation that comes with the source data, 
modify field names so that they are clearer.

* names(part4_df) %<>% gsub("Acc", "Accelerometer", .)
* names(part4_df) %<>% gsub("Gryo", "Gyroscope", .)
* names(part4_df) %<>% gsub("^t|\\(t", "Time", .)
* names(part4_df) %<>% gsub("^f|Freq\\(\\)", "Freq", .)
* names(part4_df) %<>% gsub("mean|mean\\(\\)", "Mean", .)
* names(part4_df) %<>% gsub("std\\(\\)", "StdDev", .)
* names(part4_df) %<>% gsub("gravity", "Gravity", .)

Part Five
=========
*Create and independent tidy data set with the average of each activity and each subject.*

Using the `plyr` framework, split apart the data from part 4 (`part4_df`)
by subject and activity and apply the mean function to the numeric columns.
The resultant dataset has a unique record for each subject and activity pair and
each variable/field is distinct; hence, the `part5_df` is tidy. 

`part5_df` is written to `output/tidy.txt` as a tab separated text file.

`tidy.txt` Variables
====================
The `tidy.txt` variables are listed below. `subject` and `activity` refer to
an individual and the activity being measured. For instance, subject 1 and 
walking refer to measurements specific to subject one and walking.

Outside of these fields, the variables have been averaged. 
The capital letters `X`,`Y`, `Z` are directional indicators from a 3-axial
signaler within a smartphone, which captured linear acceleration and
angular velocity at a constant rate of 50Hz. 

Sensor signals (accelerometer and gyroscope) were pre-processed by 
applying noise filters and then sampled in fixed-width sliding windows
of 2.56 sec and 50% overlap (128 readings/window). The gravitational force
is assumed to have only low frequency components, therefore a filter with 
0.3 Hz cutoff frequency was used. From each window, a vector of features
 was obtained by calculating variables from the time and frequency domain.


* "subject"                                      
* "activity"                                     
* "TimeBodyAccelerometerMeanX"                   
* "TimeBodyAccelerometerMeanY"                   
* "TimeBodyAccelerometerMeanZ"                   
* "TimeBodyAccelerometerStdDevX"                 
* "TimeBodyAccelerometerStdDevY"                 
* "TimeBodyAccelerometerStdDevZ"                 
* "TimeGravityAccelerometerMeanX"                
* "TimeGravityAccelerometerMeanY"                
* "TimeGravityAccelerometerMeanZ"                
* "TimeGravityAccelerometerStdDevX"              
* "TimeGravityAccelerometerStdDevY"              
* "TimeGravityAccelerometerStdDevZ"              
* "TimeBodyAccelerometerJerkMeanX"               
* "TimeBodyAccelerometerJerkMeanY"               
* "TimeBodyAccelerometerJerkMeanZ"               
* "TimeBodyAccelerometerJerkStdDevX"             
* "TimeBodyAccelerometerJerkStdDevY"             
* "TimeBodyAccelerometerJerkStdDevZ"             
* "TimeBodyGyroMeanX"                            
* "TimeBodyGyroMeanY"                            
* "TimeBodyGyroMeanZ"                            
* "TimeBodyGyroStdDevX"                          
* "TimeBodyGyroStdDevY"                          
* "TimeBodyGyroStdDevZ"                          
* "TimeBodyGyroJerkMeanX"                        
* "TimeBodyGyroJerkMeanY"                        
* "TimeBodyGyroJerkMeanZ"                        
* "TimeBodyGyroJerkStdDevX"                      
* "TimeBodyGyroJerkStdDevY"                      
* "TimeBodyGyroJerkStdDevZ"                      
* "TimeBodyAccelerometerMagMean"                 
* "TimeBodyAccelerometerMagStdDev"               
* "TimeGravityAccelerometerMagMean"              
* "TimeGravityAccelerometerMagStdDev"            
* "TimeBodyAccelerometerJerkMagMean"             
* "TimeBodyAccelerometerJerkMagStdDev"           
* "TimeBodyGyroMagMean"                          
* "TimeBodyGyroMagStdDev"                        
* "TimeBodyGyroJerkMagMean"                      
* "TimeBodyGyroJerkMagStdDev"                    
* "FreqBodyAccelerometerMeanX"                   
* "FreqBodyAccelerometerMeanY"                   
* "FreqBodyAccelerometerMeanZ"                   
* "FreqBodyAccelerometerStdDevX"                 
* "FreqBodyAccelerometerStdDevY"                 
* "FreqBodyAccelerometerStdDevZ"                 
* "FreqBodyAccelerometerMeanFreqX"               
* "FreqBodyAccelerometerMeanFreqY"               
* "FreqBodyAccelerometerMeanFreqZ"               
* "FreqBodyAccelerometerJerkMeanX"               
* "FreqBodyAccelerometerJerkMeanY"               
* "FreqBodyAccelerometerJerkMeanZ"               
* "FreqBodyAccelerometerJerkStdDevX"             
* "FreqBodyAccelerometerJerkStdDevY"             
* "FreqBodyAccelerometerJerkStdDevZ"             
* "FreqBodyAccelerometerJerkMeanFreqX"           
* "FreqBodyAccelerometerJerkMeanFreqY"           
* "FreqBodyAccelerometerJerkMeanFreqZ"           
* "FreqBodyGyroMeanX"                            
* "FreqBodyGyroMeanY"                            
* "FreqBodyGyroMeanZ"                            
* "FreqBodyGyroStdDevX"                          
* "FreqBodyGyroStdDevY"                          
* "FreqBodyGyroStdDevZ"                          
* "FreqBodyGyroMeanFreqX"                        
* "FreqBodyGyroMeanFreqY"                        
* "FreqBodyGyroMeanFreqZ"                        
* "FreqBodyAccelerometerMagMean"                 
* "FreqBodyAccelerometerMagStdDev"               
* "FreqBodyAccelerometerMagMeanFreq"             
* "FreqBodyBodyAccelerometerJerkMagMean"         
* "FreqBodyBodyAccelerometerJerkMagStdDev"       
* "FreqBodyBodyAccelerometerJerkMagMeanFreq"     
* "FreqBodyBodyGyroMagMean"                      
* "FreqBodyBodyGyroMagStdDev"                    
* "FreqBodyBodyGyroMagMeanFreq"                  
* "FreqBodyBodyGyroJerkMagMean"                  
* "FreqBodyBodyGyroJerkMagStdDev"                
* "FreqBodyBodyGyroJerkMagMeanFreq"              
* "angleTimeBodyAccelerometerMeanGravity"        
* "angleTimeBodyAccelerometerJerkMeanGravityMean"
* "angleTimeBodyGyroMeanGravityMean"             
* "angleTimeBodyGyroJerkMeanGravityMean"         
* "angleXGravityMean"                            
* "angleYGravityMean"                            
* "angleZGravityMean"
