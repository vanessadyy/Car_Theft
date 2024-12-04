#### Preamble ####
# Purpose: Add covariates of premises type, offence and division, separately, to second model of 
# paper analyzing car theft data from open data Toronto
# Author: Yiyue Deng
# Date: 12/01/2024
# Contact: yiyue.deng@mail.utoronto.ca
# License: MIT
# Pre-requisites: Packages under workspace setup must be installed
# Pre-requisites: 02-download_data.R, 03-clean_data.R must have been run
# Refer to https://github.com/vanessadyy/Car_Theft for more details


#### Workspace setup ####
library(rstudioapi)
library(MASS)
library(tidyverse)
library(topmodels)
library(knitr)

#### Read data ####
fd <- paste0(dirname(rstudioapi::getActiveDocumentContext()$path), "/../")  
setwd(fd)
analysis_data <- read_csv("./data/analysis_data/analysis_data.csv")


####quasi-likelihood poisson regression with premises type####
monthly_counts_PREMISES_TYPE <- analysis_data %>%
  mutate(
    YEARMONTH = format(OCC_DATE, "%Y-%m")  # Extract year and month in "YYYY-MM" format
  ) %>%
  group_by(YEARMONTH,PREMISES_TYPE) %>%
  summarise(Crime_Count = n(), .groups = "drop") %>%
  mutate(
    time = as.numeric(as.Date(paste0(YEARMONTH, "-01"))),
    action = ifelse(time >= as.numeric(as.Date("2024-01-01")),1,0))
poisson_model_PREMISES_TYPE <- glm(
  Crime_Count ~ time+PREMISES_TYPE +action,
  family = quasipoisson(),
  data = monthly_counts_PREMISES_TYPE
)
kable(summary(poisson_model_PREMISES_TYPE)$coefficients)
kable(confint(poisson_model_PREMISES_TYPE))

####quasi-likelihood poisson regression with offence type####
monthly_counts_OFFENCE <- analysis_data %>%
  mutate(
    YEARMONTH = format(OCC_DATE, "%Y-%m")  # Extract year and month in "YYYY-MM" format
  ) %>%
  group_by(YEARMONTH,OFFENCE) %>%
  summarise(Crime_Count = n(), .groups = "drop") %>%
  mutate(
    time = as.numeric(as.Date(paste0(YEARMONTH, "-01")))  ,
    action = ifelse(time >= as.numeric(as.Date("2024-01-01")),1,0))
poisson_model_OFFENCE <- glm(
  Crime_Count ~ time+OFFENCE +action,
  family = quasipoisson(),
  data = monthly_counts_OFFENCE
)
kable(summary(poisson_model_OFFENCE)$coefficients)
kable(confint(poisson_model_OFFENCE))

####quasi-likelihood poisson regression with division number####
monthly_counts_DIVISION <- analysis_data %>%
  mutate(
    YEARMONTH = format(OCC_DATE, "%Y-%m")  # Extract year and month in "YYYY-MM" format
  ) %>%
  group_by(YEARMONTH,DIVISION) %>%
  summarise(Crime_Count = n(), .groups = "drop") %>%
  mutate(
    time = as.numeric(as.Date(paste0(YEARMONTH, "-01")))  ,
    action = ifelse(time >= as.numeric(as.Date("2024-01-01")),1,0))
poisson_model_DIVISION <- glm(
  Crime_Count ~ time+DIVISION +action,
  family = quasipoisson(),
  data = monthly_counts_DIVISION
)
kable(summary(poisson_model_DIVISION)$coefficients)
kable(confint(poisson_model_DIVISION))


#### Save model ####
saveRDS(
  poisson_model_PREMISES_TYPE,
  file = "./models/second_model_with_premisestype.rds"
)

saveRDS(
  poisson_model_OFFENCE,
  file = "./models/second_model_with_offence.rds"
)

saveRDS(
  poisson_model_DIVISION,
  file = "./models/second_model_with_division.rds"
)

