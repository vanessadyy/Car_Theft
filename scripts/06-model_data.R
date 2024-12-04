#### Preamble ####
# Purpose: Second modeling process of paper analyzing car theft data from open data Toronto
# Author: Yiyue Deng
# Date: 12/01/2024
# Contact: yiyue.deng@mail.utoronto.ca
# License: MIT
# Pre-requisites: Packages under workspace setup must be installed
# Pre-requisites: 02-download_data.R, 03-clean_data.R and 05-exploratory_data_analysis.R must have been run
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
monthly_counts_all <- read_csv("./data/analysis_data/monthly_counts_all.csv")


#read previous model#
poisson_model_all <- readRDS(  file = "./models/first_model.rds"
)
#### Quasi-Likelihood Poisson Regression ####
# Fit a Quasi-Poisson regression model to account for overdispersion
poisson_model_all2 <- glm(
  Crime_Count ~ time + action, # Model crime count as a function of time and action
  family = quasipoisson(), # Use Quasi-Poisson family to handle overdispersion
  data = monthly_counts_all # Use the processed dataset
)

# Display the model's coefficients and confidence intervals
kable(summary(poisson_model_all2)$coefficients) # Show regression coefficients
kable(confint(poisson_model_all2)) # Show confidence intervals for the coefficients

### Prediction ###
# Add predicted counts from the Quasi-Poisson model to the dataset
monthly_counts_all <- monthly_counts_all %>%
  mutate(
    Predicted_Count2 = predict(poisson_model_all2, type = "response") # Predict crime counts
  )

##### Plot Actual vs. Predicted Counts ####
# Visualize the actual and predicted crime counts over time using the Quasi-Poisson model
ggplot(monthly_counts_all, aes(x = as.Date(time))) +
  geom_line(aes(y = Crime_Count, color = "Actual", linetype = "Actual"), size = 1) + # Actual counts
  geom_line(aes(y = Predicted_Count2, color = "Predicted", linetype = "Predicted"), size = 1) + # Predicted counts
  scale_color_manual(values = c("Actual" = "blue", "Predicted" = "red")) + # Set line colors
  scale_linetype_manual(values = c("Actual" = "solid", "Predicted" = "dashed")) + # Set line types
  labs(
    title = "Time Trends of Car Theft Crime Counts in Toronto", # Chart title
    x = "Time", # X-axis label
    y = "Car Theft Crime Count", # Y-axis label
    color = "Type", # Legend title for color
    linetype = "Type" # Legend title for linetype
  ) +
  theme_minimal() +
  theme(legend.position = "right") # Position the legend on the right

# Diagnostics
# Generate diagnostic plots for the Quasi-Poisson model
par(mfrow = c(2, 2)) # Arrange plotting space for four diagnostic plots
plot(poisson_model_all2) # Create diagnostic plots for residuals, leverage, and QQ

#### Save Model ####
# Save the fitted Quasi-Poisson regression model to an RDS file for future use
saveRDS(
  poisson_model_all2, # The fitted Quasi-Poisson regression model
  file = "./models/second_model.rds" # File path for saving the model
)
