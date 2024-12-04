#### Preamble ####
# Purpose: Tests the structure and validity of the simulated car theft data of Toronto 
# Author: Yiyue Deng
# Date: 12/01/2024
# Contact: yiyue.deng@mail.utoronto.ca
# License: MIT
# Pre-requisites: Packages under workspace setup must be installed
# Pre-requisites: 00-simulate_data.R must have been run
# Refer to https://github.com/vanessadyy/Car_Theft for more details


#### Workspace setup ####
# Load the necessary libraries
library(tidyverse)     # For data manipulation and visualization
library(rstudioapi)    # For retrieving the file path dynamically

#### Read simulated data ####
# Dynamically set the working directory to the parent folder of the current script
fd <- paste0(dirname(rstudioapi::getActiveDocumentContext()$path), "/../")  
setwd(fd)

# Load the simulated data from the specified directory
analysis_data <- read_csv("./data/simulated_data/simulated_data.csv")

# Test if the data was successfully loaded
if (exists("analysis_data")) {
  message("Test Passed: The dataset was successfully loaded.") # Confirm successful loading
} else {
  stop("Test Failed: The dataset could not be loaded.") # Error if data not loaded
}

#### Test data ####

# Check if the dataset has 100 rows
if (nrow(analysis_data) == 100) {
  message("Test Passed: The dataset has 100 rows.") # Confirm row count matches
} else {
  stop("Test Failed: The dataset does not have 100 rows.") # Error for mismatched row count
}

# Check if the dataset has 13 columns
if (ncol(analysis_data) == 13) {
  message("Test Passed: The dataset has 13 columns.") # Confirm column count matches
} else {
  stop("Test Failed: The dataset does not have 13 columns.") # Error for mismatched column count
}

# Check if all values in the 'X_id' column are unique
if (n_distinct(analysis_data$X_id) == nrow(analysis_data)) {
  message("Test Passed: All values in 'X_id' are unique.") # Confirm uniqueness of IDs
} else {
  stop("Test Failed: The 'X_id' column contains duplicate values.") # Error for duplicates
}

# Check if the 'DIVISION' column contains only valid Toronto police division names
valid_DIVISION <- c("D11", "D12", "D13", "D14", "D22", "D23", "D31", "D32", "D33", 
                    "D41", "D42", "D43", "D51", "D52", "D53", "D54", "D55")

if (all(analysis_data$DIVISION %in% valid_DIVISION)) {
  message("Test Passed: The 'DIVISION' column contains only valid Toronto police division names.")
} else {
  stop("Test Failed: The 'DIVISION' column contains invalid Toronto police division names.")
}

# Check if the 'OFFENCE' column contains only valid crime types of car theft cases
valid_OFFENCE <- c("Theft From Motor Vehicle Over", "Theft From Motor Vehicle Under")

if (all(analysis_data$OFFENCE %in% valid_OFFENCE)) {
  message("Test Passed: The 'OFFENCE' column contains only valid crime types of car theft cases.")
} else {
  stop("Test Failed: The 'OFFENCE' column contains invalid crime types of car theft cases.")
}

# Check if the 'PREMISES_TYPE' column contains only valid location types
valid_PREMISES_TYPE <- c("Apartment", "Commercial", "Educational", "House", "Other", "Outside", "Transit")

if (all(analysis_data$PREMISES_TYPE %in% valid_PREMISES_TYPE)) {
  message("Test Passed: The 'PREMISES_TYPE' column contains only valid location types.")
} else {
  stop("Test Failed: The 'PREMISES_TYPE' column contains invalid location types.")
}

# Check if 'OCC_DATE' is within the specified date range
if (all(analysis_data$OCC_DATE >= as.Date("2014-01-01") & analysis_data$OCC_DATE <= as.Date("2024-09-30"))) {
  message("Test Passed: The 'OCC_DATE' column contains only dates between 2014-01-01 and 2024-09-30.")
} else {
  stop("Test Failed: The 'OCC_DATE' column contains dates outside the range 2014-01-01 to 2024-09-30.")
}

# Check if there are any missing values in the dataset
if (all(!is.na(analysis_data))) {
  message("Test Passed: The dataset contains no missing values.") # Confirm no missing data
} else {
  stop("Test Failed: The dataset contains missing values.") # Error for missing data
}


