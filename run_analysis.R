# Step 0: Setup  and Read Data --------------------------------------------

wd <- readline("please type the working directory path -- with forward \n 
                slashes and no quotes, eg:                             \n 
                C:/Users/Kevin/Desktop/my_wd -- below                  \n")
                
# Or set your own working directory
setwd(wd)

# if(!require(pacman)){install.packages("pacman"); library(pacman)}
# p_load(downloader, plyr, magrittr) 

library(downloader)
library(plyr)
library(magrittr)


options(stringsAsFactors = FALSE)

# Download original data files
www <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download(www, destfile = "har_data.zip")
unzip("har_data.zip")
file.rename("UCI HAR Dataset", "har_data") 

# Step 1: Merge Training and test sets ------------------------------------

# Reading data into R 
feature_names          <- read.table("har_data/features.txt") 
activity_labels        <- read.table("har_data/activity_labels.txt") 
names(activity_labels) <- c("activity", "activity_desc") ## useful later...
# Train data
subject_train          <- read.table("har_data/train/subject_train.txt") 
y_train                <- read.table("har_data/train/y_train.txt") 
x_train                <- read.table("har_data/train/X_train.txt") 
# Test Data
subject_test           <- read.table("har_data/test/subject_test.txt") 
y_test                 <- read.table("har_data/test/y_test.txt") 
x_test                 <- read.table("har_data/test/X_test.txt") 
  
# Rowbinding/some name work
subject_all            <- rbind(subject_test, subject_train)
names(subject_all)     <- "subject"          
y_all                  <- rbind(y_test, y_train) 
names(y_all)           <- "activity"          
x_all                  <- rbind(x_test, x_train)
names(x_all)           <- feature_names[ , 2]            ## Add field names
# Column binding
part1_df               <- cbind(subject_all, y_all, x_all)

dim(part1_df)

# Part 2: Extracts only the Measurements on the mean and sd ---------------
#   for each measurement --------------------------------------------------

part2_df <- part1_df

wanted <- grep(".*Mean.*|.*Std.*|activity|subject",
               names(part2_df), 
               ignore.case=TRUE, 
               value = TRUE)

part2_df <- part2_df[ , names(part2_df) %in% wanted]

dim(part2_df)

# Part 3: Use Descriptive activity record labels --------------------------

part3_df          <- merge(part2_df,  ## see part one for naming 
                   activity_labels)  

part3_df$activity <- NULL             ## now only activity_desc is in df
                                      ## done to have 2 activity fields in
                                      ## one df.

sort(names(part3_df))

dim(part3_df)

# Part 4: Appropriately label the data set with descriptive variabe names--

part4_df <- part3_df

# "word" changes (todo, make one pipeline)
names(part4_df)   %<>% gsub("Acc", "Accelerometer", .)
names(part4_df)   %<>% gsub("Gryo", "Gyroscope", .)
names(part4_df)   %<>% gsub("^t|\\(t", "Time", .)
names(part4_df)   %<>% gsub("^f|Freq\\(\\)", "Freq", .)
names(part4_df)   %<>% gsub("mean|mean\\(\\)", "Mean", .)
names(part4_df)   %<>% gsub("std\\(\\)", "StdDev", .)
names(part4_df)   %<>% gsub("gravity", "Gravity", .)

# non word changes
names(part4_df)   %<>% gsub("-", "", .) 
# names(part4_df) %<>% gsub("-", "_", .) ## turned off in favor of above
names(part4_df)   %<>% gsub(",|\\(", "", .)
# names(part4_df) %<>% gsub(",|\\(", "_", .) ## turned off in favor of above
names(part4_df)   %<>% gsub("\\)", "", .)

# Change CamelCase to lower snake_case, turned off
# names(part4_df) %<>% 
#   gsub("([a-z])([A-Z])", "\\1_\\L\\2", ., perl = TRUE) %>%
#   tolower

# remove underscores
names(part4_df) %<>% gsub("_", "", .)

names(part4_df)

# Step/Part 5: Create a 2nd, independent tidy df with average  ------------
#   of each variable for each activity and each subject -------------------

part5_df <- part4_df

lapply(part5_df, class) %>% unlist %>% unname ## just eyebballing classes


part5_df$subject %<>% as.factor
part5_df$activity %<>% as.factor

part5_df <- ddply(part5_df, c("subject", "activity"),  numcolwise(mean))

dim(part5_df)

# House cleaning and writing to a tidy output -----------------------------

rm(list=setdiff(ls(), grep("^part", ls(), value = TRUE)))

dir.create("output")
write.table(part5_df, "output/tidy.txt", row.names = FALSE, sep = "\t")

save.image("output/get_and_clean_tidy.RData")
