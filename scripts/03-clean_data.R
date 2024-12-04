#### Preamble ####
# Purpose: Cleans the raw car theft data
# Author:  Yiyue Deng
# Date: 12/01/2024
# Contact: yiyue.deng@mail.utoronto.ca
# License: MIT
# Pre-requisites: Packages under workspace setup must be installed
# This script is used to clean raw car theft data downloaded directly from open data Toronto
# Refer to https://github.com/vanessadyy/Car_Theft for more details

#### Workspace setup ####
library(tidyverse)
library(rstudioapi)
library(janitor)

#### Set data directory and read raw data ####
# Dynamically set the working directory to the parent folder of the current script
fd <- paste0(dirname(rstudioapi::getActiveDocumentContext()$path), "/../")  
setwd(fd)

# Read the raw data from the specified path
raw_data <- read_csv("./data/raw_data/raw_data.csv")

# Check the column names of the raw data to confirm structure and available variables
names(raw_data)

#### Clean data ####
# Data cleaning steps include:
# 1. Retaining only the variables of interest for analysis.
# 2. Filtering records to include only those that occurred after 2014.
# 3. Removing any records with missing data.
cleaned_data <-
  raw_data %>%
  select(
    # Select only these columns from the raw data
    X_id,  # Unique identifier for each record
    OCC_DATE,  # Date of the occurrence
    OCC_YEAR,  # Year of the occurrence
    OCC_MONTH,  # Month of the occurrence
    OCC_DAY,  # Day of the month when the occurrence happened
    OCC_DOW,  # Day of the week of the occurrence
    OCC_HOUR,  # Hour of the day for the occurrence
    DIVISION,  # Police division where the occurrence was reported
    PREMISES_TYPE,  # Type of premises where the occurrence took place
    UCR_CODE,  # Uniform Crime Reporting code
    OFFENCE,  # Type of offence reported
    LONG_WGS84,  # Longitude coordinate of the occurrence
    LAT_WGS84  # Latitude coordinate of the occurrence
  ) %>%
  filter(
    # Retain only records from years after 2013
    OCC_YEAR > 2013,
    OCC_YEAR != "None"  # Exclude records with invalid year values
  ) %>%
  mutate(
    # Convert OCC_YEAR and OCC_DAY to numeric format for consistency
    OCC_YEAR = as.numeric(OCC_YEAR),
    OCC_DAY = as.numeric(OCC_DAY)
  ) %>%
  drop_na()  # Remove any rows with missing values in the selected columns

#### Save data ####
# Save the cleaned dataset to the specified location for analysis
write_csv(cleaned_data, "./data/analysis_data/analysis_data.csv")

# Display the structure of the cleaned data to verify column types and content
str(cleaned_data)
