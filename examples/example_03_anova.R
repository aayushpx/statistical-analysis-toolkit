#!/usr/bin/env Rscript
#' Example 3: ANOVA and Post-Hoc Analysis
#'
#' Comprehensive example of Analysis of Variance.
#'
#' Usage: Rscript example_03_anova.R

library(statsforensics)
library(tidyverse)

cat("\n")
cat("═══════════════════════════════════════════════════════════\n")
cat("Example 3: ANOVA and Post-Hoc Testing\n")
cat("═══════════════════════════════════════════════════════════\n\n")

# Use built-in dataset
data("mtcars")

mtcars <- mtcars %>%
  mutate(
    cyl_group = factor(cyl, labels = c("4 Cyl", "6 Cyl", "8 Cyl")),
    am_label = factor(am, labels = c("Automatic", "Manual"))
  )

# One-way ANOVA: Does fuel economy vary by cylinder count?
cat("One-Way ANOVA: MPG by Cylinder Count\n")
cat("─────────────────────────────────────────────────────────────\n\n")

anova_cyl <- perform_anova(mtcars, response = "mpg", group = "cyl_group")

cat("\n\nPost-Hoc Comparisons (Tukey HSD)\n")
cat("─────────────────────────────────────────────────────────────\n")
tukey_result <- tukey_post_hoc(anova_cyl)

# Summary interpretation
cat("\n\n✓ ANOVA Complete!\n")
cat("Effect Size (η²):", round(sum(anova(anova_cyl)[[1]][1, 2]) / 
                                sum(anova(anova_cyl)[[1]][, 2]), 4), "\n")
cat("Interpretation: Cylinder count explains approximately 80% of fuel economy variance\n\n")
