# Gettting-and-Cleaning-Data-Course-Project

This is the course project for the Getting and Cleaning Data Coursera course.
The R script, `run_analysis.R`, does the following:

1. Download the dataset if it does not already exist in the working directory
2. Load the activity and feature labels
3. Loads the training, test, and subject datasets
4. Merges the training and testing datasets
5. Extracts only the columns with the mean or standard deviation and
  merges everything
6. Changes the names of variables to be more descriptive
7. Creates a tidy dataset that consists of the average value of each
   variable for each subject and activity pair.