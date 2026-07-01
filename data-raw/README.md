# Data Directory

This directory contains datasets used in examples and tests.

## vehicles.rda
Sample dataset of vehicle specifications and fuel economy, derived from EPA data. Contains:
- `engine_displacement` - Engine size in liters
- `cylinders` - Number of cylinders
- `highway_mpg` - Highway fuel economy (miles per gallon)
- `city_mpg` - City fuel economy
- `vehicle_class` - Vehicle type (compact, midsize, pickup, etc.)
- `drive_type` - Drive configuration (front/rear/four-wheel)

## Preparing Data

Data is prepared and saved as an R data object during package installation. See `data-raw/01-vehicles-prep.R` for preparation script.

To load in R:
```r
library(statsforensics)
data(vehicles)
```

## Adding Your Own Data

To use your own dataset:
```r
library(statsforensics)
my_data <- read.csv("path/to/your/file.csv")
eda_numeric(my_data, "your_variable")
```
