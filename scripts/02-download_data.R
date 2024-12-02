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
# get package
package <- show_package("1fc65d1e-7dae-4766-98dd-3b172e40a089")
package

# get all resources for this package
resources <- list_package_resources("1fc65d1e-7dae-4766-98dd-3b172e40a089")

# identify datastore resources; by default, Toronto Open Data sets datastore resource format to CSV for non-geospatial and GeoJSON for geospatial resources
# here I used csv format data
datastore_resources <- filter(resources, tolower(format) %in% c('csv'))


# load the first datastore resource as a sample
data <- filter(datastore_resources, row_number()==1) %>% get_resource()
data


#### Save data ####
# change the_raw_data to whatever name you assigned when you downloaded it.
fd <- paste0(dirname(rstudioapi::getActiveDocumentContext()$path), "/../")  
setwd(fd)
write_csv(data, "./data/raw_data/raw_data.csv") 
