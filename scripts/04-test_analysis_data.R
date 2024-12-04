#### Preamble ####
# Purpose: Tests the structure and validity of the download and cleaned car theft data of Toronto 
# Author: Yiyue Deng
# Date: 12/01/2024
# Contact: yiyue.deng@mail.utoronto.ca
# License: MIT
# Pre-requisites: Packages under workspace setup must be installed
# Pre-requisites: 02-download_data.R and 03-clean_data.R must have been run
# Refer to https://github.com/vanessadyy/Car_Theft for more details


#### Workspace setup ####
library(tidyverse)
library(rstudioapi)

#### read data ####
fd <- paste0(dirname(rstudioapi::getActiveDocumentContext()$path), "/../")  
setwd(fd)
analysis_data <- read_csv("./data/analysis_data/analysis_data.csv")

#### Test data ####
# Check if the dataset has 13 columns
# Ensures that the dataset structure includes exactly 13 columns as expected.
if (ncol(analysis_data) == 13) {
  message("Test Passed: The dataset has 13 columns.")
} else {
  stop("Test Failed: The dataset does not have 13 columns.")
}

# Check if all values in the 'X_id' column are unique
# Verifies that each record has a unique identifier to prevent duplication errors.
if (n_distinct(analysis_data$X_id) == nrow(analysis_data)) {
  message("Test Passed: All values in 'X_id' are unique.")
} else {
  stop("Test Failed: The 'X_id' column contains duplicate values.")
}

# Check if the 'DIVISION' column contains only valid Toronto police division names
# Ensures that the division names in the dataset match the expected list of valid names.
valid_DIVISION <- c("D11", "D12", "D13", "D14", "D22", "D23", "D31", "D32", "D33", 
                    "D41", "D42", "D43", "D51", "D52", "D53", "D54", "D55")
if (all(analysis_data$DIVISION %in% valid_DIVISION)) {
  message("Test Passed: The 'DIVISION' column contains only valid Toronto police division names.")
} else {
  stop("Test Failed: The 'DIVISION' column contains invalid Toronto police division names.")
}

# Check if the 'OFFENCE' column contains only valid crime types of car theft cases
# Validates that the offence types match the predefined categories for car theft cases.
valid_OFFENCE <- c("Theft From Motor Vehicle Over", "Theft From Motor Vehicle Under")
if (all(analysis_data$OFFENCE %in% valid_OFFENCE)) {
  message("Test Passed: The 'OFFENCE' column contains only valid crime types of car theft cases.")
} else {
  stop("Test Failed: The 'OFFENCE' column contains invalid crime types of car theft cases.")
}

# Check if the 'PREMISES_TYPE' column contains only valid location types
# Ensures that all entries in the 'PREMISES_TYPE' column match the expected set of valid premise types.
valid_PREMISES_TYPE <- c("Apartment", "Commercial", "Educational", "House", "Other", "Outside", "Transit")
if (all(analysis_data$PREMISES_TYPE %in% valid_PREMISES_TYPE)) {
  message("Test Passed: The 'PREMISES_TYPE' column contains only valid location types.")
} else {
  stop("Test Failed: The 'PREMISES_TYPE' column contains invalid location types.")
}

# Check if 'OCC_DATE' is between 2014-01-01 and 2024-09-30
# Validates that all occurrence dates fall within the expected date range.
if (all(analysis_data$OCC_DATE >= as.Date("2014-01-01") & analysis_data$OCC_DATE <= as.Date("2024-09-30") )) {
  message("Test Passed: The 'OCC_DATE' column contains only dates between 2014.01.01 to 2024.09.30.")
} else {
  stop("Test Failed: The 'OCC_DATE' column contains dates outside the range 2014.01.01 to 2024.09.30.")
}

# Check if there are any missing values in the dataset
# Confirms that no cells in the dataset contain missing (NA) values.
if (all(!is.na(analysis_data))) {
  message("Test Passed: The dataset contains no missing values.")
} else {
  stop("Test Failed: The dataset contains missing values.")
}
