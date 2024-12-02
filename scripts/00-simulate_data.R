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
library(tidyverse)
Sys.setlocale("LC_ALL", "en_US.UTF-8")
set.seed(853)



#### Simulate data of size sim_size####
sim_size <- 100
simulated_data <- tibble(
  OCC_DATE = as.Date("2014-01-01") + sample(0:(as.Date("2024-09-30") - as.Date("2014-01-01")), sim_size, replace = TRUE),
  OCC_YEAR = as.integer(format(OCC_DATE, "%Y")),
  OCC_MONTH = as.integer(format(OCC_DATE, "%m")),
  OCC_DAY = as.integer(format(OCC_DATE, "%d")),
  OCC_DOW = weekdays(OCC_DATE),
  OCC_HOUR = sample(0:23, sim_size, replace = TRUE),
  DIVISION = sample(c("D11", "D12", "D13", "D14", "D22", "D23", "D31", "D32", "D33", 
                      "D41", "D42", "D43", "D51", "D52", "D53", "D54", "D55"), sim_size, replace = TRUE),
  LONG_WGS84 = runif(sim_size, -79.64, -79.12),
  LAT_WGS84 = runif(sim_size, 43.59, 43.85),
  PREMISES_TYPE = sample(c("Apartment", "Commercial", "Educational", "House", "Other", "Outside", "Transit"), sim_size, replace = TRUE),
  UCR_CODE = sample(c(2142, 2134), sim_size, replace = TRUE),
  OFFENCE = ifelse(UCR_CODE == 2142, "Theft From Motor Vehicle Under", "Theft From Motor Vehicle Over")
)
simulated_data <- simulated_data[order(simulated_data$OCC_DATE),] %>% mutate (X_id=1:sim_size)

#### Save data ####
fd <- paste0(dirname(rstudioapi::getActiveDocumentContext()$path), "/../")  
setwd(fd)
write_csv(simulated_data, "./data/simulated_data/simulated_data.csv")
