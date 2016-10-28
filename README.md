# Getting-and-Cleaning-Data-Course-Project

##README

##### Created by Ronald Hensbergen  
As part of the course Getting and Cleaning Data  
which is again part of the Data Science Specialization

The code file is the `run_analysis.R` file and contains the following parts:  
1. Initialization (like loading packages, clean up the current environment (!) and create some constants for later use)  
2. Download of the zip file  
3. Read all the files that need to be connected to the main file later  
4. Read the features file that needs to be linked to the col.names later  
5. Read the test and train files (X-files) with fread, as normal read.table crashes with memory issues  
6. Combine all the data (test and train) and previously loaded files into 1 file  
7. Tidy up the data by selecting only mean and std  
8. Gather features into rows  
9. Separate features into different parts  
10. Merge different parts into combined data

I decided not to create a dimension table for the features, as I couldn't figure out of these really belong to each other.

No other action is required than to open the `run_analysis.R` file, select all of it and click Run.
