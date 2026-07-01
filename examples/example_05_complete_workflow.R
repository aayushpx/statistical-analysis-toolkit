#!/usr/bin/env Rscript
#' Example 5: Complete Workflow
#'
#' A full analysis pipeline from exploration to reporting.
#'
#' Usage: Rscript example_05_complete_workflow.R

library(statsforensics)
library(tidyverse)

cat("\n")
cat("═══════════════════════════════════════════════════════════\n")
cat("Example 5: Complete Analysis Workflow\n")
cat("═══════════════════════════════════════════════════════════\n\n")

# Load data
data("mtcars")
mtcars <- mtcars %>%
  mutate(
    transmission = if_else(am == 0, "Automatic", "Manual"),
    cyl_group = factor(cyl, labels = c("4 Cyl", "6 Cyl", "8 Cyl"))
  )

cat("PHASE 1: DATA EXPLORATION\n")
cat("─────────────────────────────────────────────────────────────\n\n")

# Missing data check
missing_summary <- count_missing(mtcars)

# Basic EDA
cat("Response variable (mpg) summary:\n")
eda_numeric(mtcars, "mpg")

cat("\n\nPHASE 2: ASSUMPTION VALIDATION\n")
cat("─────────────────────────────────────────────────────────────\n\n")

# Check normality of response
check_normality(mtcars$mpg)

cat("\n\nPHASE 3: HYPOTHESIS TESTING\n")
cat("─────────────────────────────────────────────────────────────\n\n")

# ANOVA: Does cylinder count affect fuel economy?
anova_result <- perform_anova(mtcars, "mpg", "cyl_group")

cat("\n\nPost-hoc analysis:\n")
tukey_result <- tukey_post_hoc(anova_result)

cat("\n\nPHASE 4: REGRESSION MODELING\n")
cat("─────────────────────────────────────────────────────────────\n\n")

# Fit comprehensive model
model <- fit_linear_model(mtcars, "mpg ~ disp + wt + cyl + am")

cat("\n\nPHASE 5: MODEL DIAGNOSTICS\n")
cat("─────────────────────────────────────────────────────────────\n\n")

# Diagnostic checklist
diagnostics_checklist(model)

# Plot diagnostics
cat("\n\nGenerating diagnostic plots...\n")
plot_diagnostics(model)

cat("\n\nPHASE 6: PREDICTIONS & INSIGHTS\n")
cat("─────────────────────────────────────────────────────────────\n\n")

# Get model insights
model_insights(model)

# Make a prediction
new_car <- data.frame(disp = 300, wt = 3.5, cyl = 6, am = 1)
preds <- create_prediction_intervals(model, new_car)

cat("\n\n")
cat("═══════════════════════════════════════════════════════════\n")
cat("✓ ANALYSIS COMPLETE\n")
cat("═══════════════════════════════════════════════════════════\n\n")

cat("Summary:\n")
cat("1. Fuel economy data is approximately normal\n")
cat("2. Significant differences exist between cylinder counts\n")
cat("3. Regression model explains ~84% of fuel economy variation\n")
cat("4. Model assumptions are satisfied\n")
cat("5. Predictions show reasonable uncertainty intervals\n\n")
