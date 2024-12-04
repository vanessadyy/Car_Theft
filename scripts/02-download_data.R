#### Preamble ####
# Purpose: Downloads and saves the data from Open Data Toronto
# Author: Yiyue Deng
# Date: 12/01/2024
# Contact: yiyue.deng@mail.utoronto.ca
# License: MIT
# Pre-requisites: Packages under workspace setup must be installed
# This script is used to download data for a follow-up study of the Canadian government’s National Action Plan to Combat Car Theft
# Refer to https://github.com/vanessadyy/Car_Theft for more details

#### Workspace setup ####
library(opendatatoronto)
library(tidyverse)
library(rstudioapi)

#### Download data ####
# Retrieve metadata for the specified dataset using its unique package ID
package <- show_package("1fc65d1e-7dae-4766-98dd-3b172e40a089")
package  # View metadata to confirm the package details

# Get all resources associated with the package
resources <- list_package_resources("1fc65d1e-7dae-4766-98dd-3b172e40a089")

# Filter resources to identify only those in CSV format, which are typically non-geospatial data
# "datastore_resources" will hold only the CSV data resources from the package
datastore_resources <- filter(resources, tolower(format) %in% c('csv'))

# Load the first resource from the datastore as an example or sample dataset
# "data" will contain the actual data from the first resource in CSV format
data <- filter(datastore_resources, row_number() == 1) %>% get_resource()
data  # View the loaded dataset to verify the structure and content

#### Save data ####
# Set the working directory dynamically to the parent folder of the current script
fd <- paste0(dirname(rstudioapi::getActiveDocumentContext()$path), "/../")  
setwd(fd)

# Save the loaded dataset to a local directory in CSV format
write_csv(data, "./data/raw_data/raw_data.csv")
