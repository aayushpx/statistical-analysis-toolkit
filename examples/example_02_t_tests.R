#!/usr/bin/env Rscript
#' Example 2: Hypothesis Testing
#'
#' Demonstrates t-tests and ANOVA for comparing groups.
#'
#' Usage: Rscript example_02_t_tests.R

library(statsforensics)
library(tidyverse)

cat("\n")
cat("═══════════════════════════════════════════════════════════\n")
cat("Example 2: Hypothesis Testing\n")
cat("═══════════════════════════════════════════════════════════\n\n")

data("mtcars")

# Add group labels for clarity
mtcars <- mtcars %>%
  mutate(
    transmission = if_else(am == 0, "Automatic", "Manual"),
    cyl_group = factor(cyl, labels = c("4 cylinders", "6 cylinders", "8 cylinders"))
  )

# Question 1: Do automatic and manual transmissions have different fuel economy?
cat("Question 1: Transmission and Fuel Economy\n")
cat("─────────────────────────────────────────────────────────────\n")
cat("Do manual transmissions have different fuel economy than automatic?\n\n")

t_test_comprehensive(mtcars, x = "mpg", y = "transmission")

# Question 2: Do all cylinder counts have equal fuel economy?
cat("\n\nQuestion 2: Cylinder Count and Fuel Economy\n")
cat("─────────────────────────────────────────────────────────────\n")
cat("Do fuel economies differ across cylinder counts?\n\n")

anova_result <- perform_anova(mtcars, response = "mpg", group = "cyl_group")

# Which groups differ?
cat("\n\nPost-hoc Comparison: Which cylinder groups differ?\n")
cat("─────────────────────────────────────────────────────────────\n")
tukey_result <- tukey_post_hoc(anova_result)

cat("\n\n✓ Testing complete!\n")
cat("Summary:\n")
cat("- Manual transmissions DO have significantly different MPG (p < 0.05)\n")
cat("- Cylinder count significantly affects fuel economy\n")
cat("- All pairwise differences are significant (Tukey test)\n\n")
