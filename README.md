Project: Getting and Cleaning Data
==================================

This README was created with common-sense and tips from 
[SO: how to write a good README](http://stackoverflow.com/questions/2304863/how-to-write-a-good-readme).

Purpose
=======
The purpose of this project is to demonstrate ability collecting, working with,
and cleaning a data set. The ultimate goal is to create a tidy dataset that
takes the average for each activity and each subject.
In this case, the original dataset is the 
*Human Activity Recognition Using Smartphones Dataset*, Version 1.0.

Usage
=====
Initial information was read into the software R version 3.2.3 on a Windows 
machine, with the packages `marittr_1.5`, `plyr_1.8.3`, and `downloader_0.4`
explicitly attached.

Data was read in and merged in accordance with the project guide found at
[https://drive.google.com/file/d/0B1r70tGT37UxYzhNQWdXS19CN1U/view?usp=sharing](https://drive.google.com/file/d/0B1r70tGT37UxYzhNQWdXS19CN1U/view?usp=sharing).
 
An R script called `run_analysis.R` can be sourced to produce this outcome
in the specified working directory of the user. 

Steps
=====
Please note the steps are noted in commented sections of `run_analysis.R` and
more detail may be found in the codebook. The steps or parts of this analysis are:

1. Merge the training and test datasets to create one dataset. 
2. Extract only the measurements on the mean and standard deviation for each measurement. 
3. Use descriptive activity names to name the activities.
4. Appropriately labels the data set with descriptive variable names.
5. From the dataset create a second independent tidy dataset with the average of each variable for each activity and subject.

Output
======
After the `run_analysis.R` has been completely sourced, a file named
`tidy.txt` will be placed in the sub-directory "output" along with a file of
the R session `get_and_clean_tidy.RData`. Please note that each of the 
parts/steps enumerated in the above section have been saved to a `data.frame`
with an appropriate name. For instance, `part1_df` is the result of the 
completion of step 1; `part2_df` is the result of the completion of 
step 2; and so on. This is done for the convenience of reviewers.

`tidy.txt` is a tidy data frame and has one record for the each subject *and* activity
and one column for the mean of each variable. More information on this 
table can be found in the codebook of this repository.


