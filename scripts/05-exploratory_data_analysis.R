#### Preamble ####
# Purpose: First try of modeling car theft data from open data Toronto
# Author: Yiyue Deng
# Date: 12/01/2024
# Contact: yiyue.deng@mail.utoronto.ca
# License: MIT
# Pre-requisites: Packages under workspace setup must be installed
# Pre-requisites: 02-download_data.R and 03-clean_data.R must have been run
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

#### data transformations####
monthly_counts_all <- analysis_data %>%
  mutate(
    YEARMONTH = format(OCC_DATE, "%Y-%m")  # Extract year and month in "YYYY-MM" format
  ) %>%
  group_by(YEARMONTH) %>%
  summarise(Crime_Count = n(), .groups = "drop") %>%
  mutate(
    time = as.numeric(as.Date(paste0(YEARMONTH, "-01"))),
    action = ifelse(time >= as.numeric(as.Date("2024-01-01")),1,0))
write_csv(monthly_counts_all,"./data/analysis_data/monthly_counts_all.csv")

####simple poisson regression####
poisson_model_all <- glm(
  Crime_Count ~ time +action,
  family = poisson(link = "log"),
  data = monthly_counts_all
)

kable(summary(poisson_model_all)$coefficients)
kable(confint(poisson_model_all))


#####prediction####

monthly_counts_all <- monthly_counts_all %>%
  mutate(
    Predicted_Count = predict(poisson_model_all, type = "response")
  )

##### Plot actual vs. predicted counts####

ggplot(monthly_counts_all, aes(x = as.Date(time))) +
  geom_line(aes(y = Crime_Count, color = "Actual", linetype = "Actual"), size = 1) + # Actual counts
  geom_line(aes(y = Predicted_Count, color = "Predicted", linetype = "Predicted"), size = 1) + # Predicted counts
  scale_color_manual(values = c("Actual" = "blue", "Predicted" = "red")) + # Define line colors
  scale_linetype_manual(values = c("Actual" = "solid", "Predicted" = "dashed")) + # Define line types
  labs(
    title = "Time Trends of Car Theft Crime Counts in Toronto",
    x = "Time",
    y = "Car Theft Crime Count",
    color = "Type", # Legend title for color
    linetype = "Type" # Legend title for linetype
  ) +
  theme_minimal() +
  theme(legend.position = "right")


# Calculate dispersion statistic
dispersion_stat <- sum(residuals(poisson_model_all, type = "pearson")^2) / poisson_model_all$df.residual
dispersion_stat
# diagnostics
par(mfrow = c(2, 2)) # Set up plotting space
plot(poisson_model_all)

#rootogram#
rootogram(poisson_model_all)

#### Save model ####
saveRDS(
  poisson_model_all,
  file = "./models/first_model.rds"
)


