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
#### Data Transformations ####
# Prepare a dataset with monthly counts of car thefts
monthly_counts_all <- analysis_data %>%
  mutate(
    YEARMONTH = format(OCC_DATE, "%Y-%m")  # Extract year and month in "YYYY-MM" format
  ) %>%
  group_by(YEARMONTH) %>%
  summarise(Crime_Count = n(), .groups = "drop") %>% # Count the number of crimes per month
  mutate(
    time = as.numeric(as.Date(paste0(YEARMONTH, "-01"))), # Convert the monthly date to numeric for modeling
    action = ifelse(time >= as.numeric(as.Date("2024-01-01")), 1, 0) # Create an indicator for pre- and post-action plan periods
  )
write_csv(monthly_counts_all, "./data/analysis_data/monthly_counts_all.csv") # Save the processed data

#### Simple Poisson Regression ####
# Fit a Poisson regression model to examine the effect of time and action on crime counts
poisson_model_all <- glm(
  Crime_Count ~ time + action, # Crime count as a function of time and action
  family = poisson(link = "log"), # Use the Poisson family with a log link
  data = monthly_counts_all
)

# Display the model's coefficients and confidence intervals
kable(summary(poisson_model_all)$coefficients)
kable(confint(poisson_model_all))

##### Prediction #####
# Add predicted counts from the model to the dataset
monthly_counts_all <- monthly_counts_all %>%
  mutate(
    Predicted_Count = predict(poisson_model_all, type = "response") # Predict crime counts based on the model
  )

##### Plot Actual vs. Predicted Counts ####
# Visualize the actual and predicted crime counts over time
ggplot(monthly_counts_all, aes(x = as.Date(time))) +
  geom_line(aes(y = Crime_Count, color = "Actual", linetype = "Actual"), size = 1) + # Actual counts
  geom_line(aes(y = Predicted_Count, color = "Predicted", linetype = "Predicted"), size = 1) + # Predicted counts
  scale_color_manual(values = c("Actual" = "blue", "Predicted" = "red")) + # Set colors for actual and predicted lines
  scale_linetype_manual(values = c("Actual" = "solid", "Predicted" = "dashed")) + # Set line types for actual and predicted lines
  labs(
    title = "Time Trends of Car Theft Crime Counts in Toronto", # Chart title
    x = "Time", # X-axis label
    y = "Car Theft Crime Count", # Y-axis label
    color = "Type", # Legend title for color
    linetype = "Type" # Legend title for line type
  ) +
  theme_minimal() +
  theme(legend.position = "right") # Position the legend to the right of the chart

# Calculate dispersion statistic
# Compute dispersion to check for overdispersion in the Poisson model
dispersion_stat <- sum(residuals(poisson_model_all, type = "pearson")^2) / poisson_model_all$df.residual
dispersion_stat # Display the dispersion statistic

# Diagnostics
# Generate diagnostic plots to evaluate the model
par(mfrow = c(2, 2)) # Arrange the plotting space for four diagnostic plots
plot(poisson_model_all) # Create diagnostic plots for residuals, leverage, and QQ

# Rootogram
# Visualize the goodness of fit using a rootogram
rootogram(poisson_model_all)

#### Save Model ####
# Save the fitted model to an RDS file for future use
saveRDS(
  poisson_model_all, # The fitted Poisson regression model
  file = "./models/first_model.rds" # File path for saving the model
)
