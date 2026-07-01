#!/usr/bin/env Rscript
#' Example 1: Basic Exploratory Data Analysis
#' 
#' Demonstrates how to explore a dataset and understand its structure.
#'
#' Usage: Rscript example_01_basic_eda.R

library(statsforensics)
library(tidyverse)

cat("\n")
cat("═══════════════════════════════════════════════════════════\n")
cat("Example 1: Exploratory Data Analysis\n")
cat("═══════════════════════════════════════════════════════════\n\n")

# Use built-in dataset
data("mtcars")

cat("Dataset: mtcars (Motor Trend Car Road Tests)\n")
cat("Variables:", ncol(mtcars), "| Observations:", nrow(mtcars), "\n\n")

# 1. Explore the response variable
cat("Step 1: Explore fuel efficiency (mpg)\n")
cat("─────────────────────────────────────────────────────────────\n")
eda_numeric(mtcars, "mpg")

# 2. Compare by groups
cat("\n\nStep 2: Compare fuel efficiency by number of cylinders\n")
cat("─────────────────────────────────────────────────────────────\n")
eda_by_group(mtcars, "mpg", "cyl")

# 3. Check for relationships
cat("\n\nStep 3: Correlation between numeric variables\n")
cat("─────────────────────────────────────────────────────────────\n")
correlation_analysis(mtcars)

cat("\n\n✓ Exploration complete!\n")
cat("Key observations:\n")
cat("- MPG varies by cylinder count (check boxplot)\n")
cat("- Negative correlations with engine size (displ, cyl, hp)\n")
cat("- Positive correlation with fuel efficiency (mpg vs am)\n\n")
