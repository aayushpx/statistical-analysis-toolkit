#!/usr/bin/env Rscript
#' Data Preparation Script
#'
#' This script prepares the vehicles dataset for use in the package.
#' It loads EPA fuel economy data, cleans it, and saves as an R data object.
#'
#' Run this during package setup: source("data-raw/01-vehicles-prep.R")

library(tidyverse)

# Load EPA fuel economy data (mpg dataset from ggplot2)
data("mpg", package = "ggplot2")

# Clean and prepare
vehicles <- mpg %>%
  mutate(
    # Standardize column names
    manufacturer = manufacturer,
    model = model,
    model_year = year,
    engine_displacement = displ,
    cylinders = cyl,
    highway_mpg = hwy,
    city_mpg = cty,
    drive_type = drv,
    vehicle_class = class
  ) %>%
  # Aggregate by manufacturer-model-year (use medians)
  group_by(manufacturer, model, model_year) %>%
  summarise(
    engine_displacement = median(engine_displacement),
    cylinders = median(cylinders),
    highway_mpg = median(highway_mpg),
    city_mpg = median(city_mpg),
    drive_type = first(drive_type),
    vehicle_class = first(vehicle_class),
    .groups = "drop"
  ) %>%
  arrange(manufacturer, model, model_year)

# Save to package
usethis::use_data(vehicles, overwrite = TRUE)

cat("✓ vehicles dataset prepared and saved\n")
cat("Observations:", nrow(vehicles), "\n")
cat("Variables:", ncol(vehicles), "\n")
