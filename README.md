# Getting-and-Cleaning-Data-Course-Project


##### Created by Ronald Hensbergen  
As part of the course Getting and Cleaning Data  
which is again part of the Data Science Specialization

The code file is the `run_analysis.R` file and contains the following parts:  
1. Initialization (like loading packages, clean up the current environment (!) and create some constants for later use)  
1. Download of the zip file  
1. Read all the files that need to be connected to the main file later  
1. Read the features file that needs to be linked to the col.names later  
1. Read the test and train files (X-files) with fread, as normal read.table crashes with memory issues  
1. Combine all the data (test and train) and previously loaded files into 1 file  
1. 
