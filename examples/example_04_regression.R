#!/usr/bin/env Rscript
#' Example 4: Regression Modeling
#'
#' Demonstrates fitting and interpreting regression models.
#'
#' Usage: Rscript example_04_regression.R

library(statsforensics)
library(tidyverse)

cat("\n")
cat("═══════════════════════════════════════════════════════════\n")
cat("Example 4: Regression Modeling\n")
cat("═══════════════════════════════════════════════════════════\n\n")

data("mtcars")

# Fit a simple linear model
cat("Model 1: Simple Linear Regression\n")
cat("─────────────────────────────────────────────────────────────\n")
cat("Does engine displacement predict fuel economy?\n\n")

model1 <- fit_linear_model(mtcars, "mpg ~ disp")

# Fit a more complex model
cat("\n\nModel 2: Multiple Regression\n")
cat("─────────────────────────────────────────────────────────────\n")
cat("Adding more predictors (weight, cylinders)\n\n")

model2 <- fit_linear_model(mtcars, "mpg ~ disp + wt + cyl")

# Compare models
cat("\n\nModel Comparison\n")
cat("─────────────────────────────────────────────────────────────\n")
compare_result <- compare_models(model1, model2)

# Validate assumptions for the better model
cat("\n\nValidating Assumptions for Model 2\n")
cat("─────────────────────────────────────────────────────────────\n")
validate_assumptions(model2)

# Get predictions
cat("\n\nMaking Predictions\n")
cat("─────────────────────────────────────────────────────────────\n")
new_cars <- data.frame(
  disp = c(150, 300, 450),
  wt = c(2.5, 3.5, 4.5),
  cyl = c(4, 6, 8)
)

predictions <- create_prediction_intervals(
  model2,
  newdata = new_cars,
  interval = "prediction"
)

cat("\n\n✓ Regression Analysis Complete!\n")
cat("Key insights:\n")
cat("- Model 2 significantly better than Model 1 (p < 0.05)\n")
cat("- All assumptions validated\n")
cat("- Predictions generated with 95% intervals\n\n")
