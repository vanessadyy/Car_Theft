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

# Set data directory and read raw data
fd <- paste0(dirname(rstudioapi::getActiveDocumentContext()$path), "/../")  
setwd(fd)
raw_data <- read_csv("./data/raw_data/raw_data.csv")
names(raw_data)
#### Clean data ####
# Only variables of interest are retained. Please refer to the paper for the list of variables of interest and reasons.
# Only records occurred after 2014 were retained
# Any records with missing data were excluded
cleaned_data <-
  raw_data %>%
  select(X_id,	OCC_DATE,	OCC_YEAR,	OCC_MONTH,	
         OCC_DAY,	OCC_DOW,	OCC_HOUR,	DIVISION,	
         PREMISES_TYPE,	UCR_CODE,	OFFENCE,	
         LONG_WGS84,	LAT_WGS84) %>%
  filter(OCC_YEAR > 2013,
         OCC_YEAR != "None") %>%
  mutate(
    OCC_YEAR = as.numeric(OCC_YEAR),
    OCC_DAY = as.numeric(OCC_DAY)) %>%
    drop_na()

#### Save data ####
write_csv(cleaned_data, "./data/analysis_data/analysis_data.csv")

str(cleaned_data)
