#### Preamble ####
# Purpose: Simulates a dataset of car theft records
# Author: Yiyue Deng
# Date: 12/01/2024
# Contact: yiyue.deng@mail.utoronto.ca
# License: MIT
# Pre-requisites: Packages under workspace setup must be installed
# This script simulates a dataset that looks like a subset of car theft data from open data Toronto
# Refer to https://github.com/vanessadyy/Car_Theft for more details

#### Workspace setup ####
# Load the necessary library
library(tidyverse) # For data manipulation and visualization
Sys.setlocale("LC_ALL", "en_US.UTF-8") # Set locale to ensure compatibility with date and text formats
set.seed(853) # Set random seed for reproducibility

#### Simulate data of size sim_size ####
# Define the size of the simulated dataset
sim_size <- 100

# Create a simulated dataset with specified fields
simulated_data <- tibble(
  # Generate random dates between 2014-01-01 and 2024-09-30
  OCC_DATE = as.Date("2014-01-01") + sample(0:(as.Date("2024-09-30") - as.Date("2014-01-01")), sim_size, replace = TRUE),
  
  # Extract year, month, and day from OCC_DATE
  OCC_YEAR = as.integer(format(OCC_DATE, "%Y")),
  OCC_MONTH = as.integer(format(OCC_DATE, "%m")),
  OCC_DAY = as.integer(format(OCC_DATE, "%d")),
  
  # Get the day of the week (e.g., Monday, Tuesday)
  OCC_DOW = weekdays(OCC_DATE),
  
  # Generate random hour of the day (0-23)
  OCC_HOUR = sample(0:23, sim_size, replace = TRUE),
  
  # Randomly assign one of the predefined police divisions
  DIVISION = sample(c("D11", "D12", "D13", "D14", "D22", "D23", "D31", "D32", "D33", 
                      "D41", "D42", "D43", "D51", "D52", "D53", "D54", "D55"), sim_size, replace = TRUE),
  
  # Generate random longitude within Toronto's geographic bounds
  LONG_WGS84 = runif(sim_size, -79.64, -79.12),
  
  # Generate random latitude within Toronto's geographic bounds
  LAT_WGS84 = runif(sim_size, 43.59, 43.85),
  
  # Randomly assign one of the premise types
  PREMISES_TYPE = sample(c("Apartment", "Commercial", "Educational", "House", "Other", "Outside", "Transit"), sim_size, replace = TRUE),
  
  # Randomly assign UCR codes (2142 or 2134)
  UCR_CODE = sample(c(2142, 2134), sim_size, replace = TRUE),
  
  # Assign offense type based on UCR code
  OFFENCE = ifelse(UCR_CODE == 2142, "Theft From Motor Vehicle Under", "Theft From Motor Vehicle Over")
)

# Order the simulated dataset by OCC_DATE and add a unique identifier (X_id)
simulated_data <- simulated_data[order(simulated_data$OCC_DATE),] %>%
  mutate(X_id = 1:sim_size) # Assign unique row ID

#### Save data ####
# Define the file directory relative to the current script location
fd <- paste0(dirname(rstudioapi::getActiveDocumentContext()$path), "/../")  
setwd(fd) # Set the working directory

# Save the simulated dataset as a CSV file
write_csv(simulated_data, "./data/simulated_data/simulated_data.csv")
