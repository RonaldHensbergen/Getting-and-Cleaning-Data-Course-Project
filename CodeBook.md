# Getting-and-Cleaning-Data-Course-Project

##CodeBook

##### Created by Ronald Hensbergen  
As part of the course Getting and Cleaning Data which is again part of the Data Science Specialization

This file explains all the columns of the resulting tables from this final project and how they are created.  

###Table combineddata
*  subjectid: a numerical value taken from the subject_test and subject_train files. Since the data is anonimized, no further information is available from the subjects.
*  set: character value 'test' means its originated from the test set (test/X_test.txt), train means its from the train set (train/X_train.txt)
*  statisticalfunction: character value this comes from the features.txt file, where it is separated from as mean and std.
*  direction: character value this comes from the features.txt file, where it is separated from as X, Y and Z.
*  activity: numerical value the names come directly from the activity_labels.txt file, where the combineddata was merged with via its id.
*  type: character value this comes from the features.txt file, where it was separated as t and f (first character of the feature), then it was translated as time and feature to make it readable.
*  accelerationtype: character value this comes from the features.txt file, where it was separated as Body, BodyBody and Gravity. Only Body and Gravity were described in the feature_info.txt file, so BodyBody might be separated or described differently at a later notice.
*  jerk: logical value this comes from the features.txt file, to describe if the original feature was derived in time to obtain Jerk signals (to measure the rate of change of acceleration)
*  magnitude: logical value. This comes from the features.txt file, to describe if the original feature was derived as the magnitude using the Euclidean norm.
* gyroscope: logical value. This comes from the features.txt file, to describe if the original feature was derived using a gyroscope.
* value: originated from the test and train sets. This is the actual measured value.
