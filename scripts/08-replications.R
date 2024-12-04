#### Preamble ####
# Purpose: Replicated tables and figures of descriptive analysis
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
library(sf)

#### Read data ####
fd <- paste0(dirname(rstudioapi::getActiveDocumentContext()$path), "/../")  
setwd(fd)
analysis_data <- read_csv("./data/analysis_data/analysis_data.csv")

### quarterly trend histogram###
quarterly_counts <- analysis_data %>%
  mutate(
    YEARQUARTER = paste0(format(OCC_DATE, "%Y"), "-Q", ceiling(as.numeric(format(OCC_DATE, "%m")) / 3))  # Extract year and quarter
  ) %>%
  group_by(YEARQUARTER) %>%
  summarise(Crime_Count = n(), .groups = "drop") %>%
  mutate(
    time = as.numeric(as.Date(paste0(substr(YEARQUARTER, 1, 4), "-", (as.numeric(substr(YEARQUARTER, 7, 7)) - 1) * 3 + 1, "-01"))),
    action = ifelse(time >= as.numeric(as.Date("2024-01-01")), 1, 0)
  )

ggplot(quarterly_counts, aes(x = YEARQUARTER, y = Crime_Count)) +
  geom_col(fill = "steelblue", color = "black") +
  labs(
    title = "Histogram of quarterly Count of Car Theft Cases",
    x = "Month",
    y = "Number of Cases"
  ) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

### sf plot ###
division_sf <- st_as_sf(analysis_data %>% filter(OCC_YEAR==2024, OCC_MONTH=="September"), coords = c("LONG_WGS84", "LAT_WGS84"), crs = 4326) %>%
  group_by(DIVISION) %>%
  summarise(geometry = st_combine(geometry)) %>%
  st_cast("POLYGON")
ggplot(data = division_sf) +
  geom_sf(aes(fill = factor(DIVISION)), color = "black") +
  scale_fill_viridis_d(name = "Division ID") +
  labs(title = "Division Map", x = "Longitude", y = "Latitude") +
  theme_minimal()

### premises type linechart ###
table_data <- table(analysis_data$PREMISES_TYPE, analysis_data$OCC_YEAR)
df_table <- as.data.frame(table_data)
colnames(df_table) <- c("PREMISES_TYPE", "OCC_YEAR", "Count")
df_table$OCC_YEAR <- as.numeric(as.character(df_table$OCC_YEAR))
ggplot(df_table, aes(x = OCC_YEAR, y = Count, color = PREMISES_TYPE, group = PREMISES_TYPE)) +
  geom_line(size = 1) +
  geom_point(size = 2) +
  labs(
    title = "Trends by Premises Type Over Years",
    x = "Year",
    y = "Count of Cases",
    color = "Premises Type"
  ) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

### OFFENCE linechart ###
offence_table <- table(analysis_data$OFFENCE, analysis_data$OCC_YEAR)
df_offence <- as.data.frame(offence_table)
colnames(df_offence) <- c("OFFENCE", "OCC_YEAR", "Count")
df_offence$OCC_YEAR <- as.numeric(as.character(df_offence$OCC_YEAR))
ggplot(df_offence, aes(x = OCC_YEAR, y = Count, color = OFFENCE, group = OFFENCE)) +
  geom_line(size = 1) +
  geom_point(size = 2) +
  labs(
    title = "Trends by Offence Type Over Years",
    x = "Year",
    y = "Count of Cases",
    color = "Offence Type"
  ) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

### DOW barchart ###
ggplot(analysis_data, aes(x = OCC_DOW)) +
  geom_bar(fill = "steelblue", color = "black") +
  labs(
    title = "Occurrences by Day of the Week",
    x = "Day of the Week",
    y = "Number of Occurrences"
  ) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

### DAY barchart ###
ggplot(analysis_data, aes(x = OCC_DAY)) +
  geom_bar(fill = "steelblue", color = "black") +
  labs(
    title = "Occurrences by Day of the Month",
    x = "Day of the Month",
    y = "Number of Occurrences"
  ) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
