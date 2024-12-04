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

####quasi-likelihood poisson regression####
poisson_model_all2 <- glm(Crime_Count ~ time +action,
                          family = quasipoisson(),
                          data = monthly_counts_all)

kable(summary(poisson_model_all2)$coefficients)
kable(confint(poisson_model_all2))



###prediction###
monthly_counts_all <- monthly_counts_all %>%
  mutate(
    Predicted_Count2 = predict(poisson_model_all2, type = "response")
  )



##### Plot actual vs. predicted counts####

ggplot(monthly_counts_all, aes(x = as.Date(time))) +
  geom_line(aes(y = Crime_Count, color = "Actual", linetype = "Actual"), size = 1) + # Actual counts
  geom_line(aes(y = Predicted_Count2, color = "Predicted", linetype = "Predicted"), size = 1) + # Predicted counts
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

# diagnostics
par(mfrow = c(2, 2)) # Set up plotting space
plot(poisson_model_all2)


#### Save model ####
saveRDS(
  poisson_model_all2,
  file = "./models/second_model.rds"
)


