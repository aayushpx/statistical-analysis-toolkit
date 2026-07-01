# Statistical Analysis Toolkit

[![R-CMD-check](https://github.com/yourusername/statistical-analysis-toolkit/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/yourusername/statistical-analysis-toolkit/actions/workflows/R-CMD-check.yaml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![R Version](https://img.shields.io/badge/R-%3E=4.0-brightgreen)](https://www.r-project.org/)

`statsforensics` is an R package for exploratory data analysis, statistical inference, hypothesis testing, regression modelling, and statistical visualisation.

The package provides reusable functions for common statistical workflows with an emphasis on clear, reproducible analyses.

## Installation

```r
# Install from GitHub
devtools::install_github("aayushpx/statistical-analysis-toolkit")

# Or during development
devtools::load_all()
```

## Quick Start

### Exploratory Data Analysis

```r
library(statsforensics)

data(vehicles)

# Explore a single numeric variable
eda_numeric(vehicles, "highway_mpg", quiet = FALSE)

# Compare groups
eda_by_group(vehicles, "highway_mpg", "vehicle_class")

# Group-wise summary
summarize_by_group(
  vehicles,
  c("highway_mpg", "city_mpg"),
  "vehicle_class"
)
```

### Statistical Testing

```r
# Check assumptions
check_normality(vehicles$highway_mpg)
check_heteroscedasticity(
  vehicles,
  response = "highway_mpg",
  group = "vehicle_class"
)

# One-way ANOVA and post hoc analysis
anova_result <- perform_anova(
  vehicles,
  response = "highway_mpg",
  group = "vehicle_class"
)

tukey_post_hoc(anova_result)

# Non-parametric alternative
kruskal_wallis_test(
  vehicles,
  response = "highway_mpg",
  group = "vehicle_class"
)
```

### Regression Modelling

```r
# Fit a linear model
model <- fit_linear_model(
  vehicles,
  "highway_mpg ~ engine_displacement"
)

model_summary(model)

# Validate assumptions
validate_assumptions(model)

# Diagnostic plots
plot_diagnostics(model)

# Predictions with intervals
new_data <- data.frame(
  engine_displacement = seq(1.6, 7.0, by = 0.5)
)

predictions <- create_prediction_intervals(
  model,
  newdata = new_data
)

plot_predictions(predictions)
```

## Core Functions

| Category | Function | Description |
|----------|----------|-------------|
| **EDA** | `eda_numeric()` | Histogram, boxplot, Q-Q plot, and summary statistics |
| | `eda_by_group()` | Group-wise boxplots and Q-Q plots |
| | `summarize_by_group()` | Group summary table |
| | `correlation_analysis()` | Correlation matrix and visualisation |
| | `count_missing()` | Missing value summary |
| **Assumptions** | `check_normality()` | Shapiro-Wilk and Kolmogorov-Smirnov tests |
| | `check_heteroscedasticity()` | Levene's test for data frames or models |
| | `check_multicollinearity()` | Variance inflation factors |
| | `validate_assumptions()` | Combined assumption checks |
| **Inference** | `t_test_comprehensive()` | One-sample, two-sample, and paired t-tests |
| | `perform_anova()` | One-way ANOVA with effect size |
| | `tukey_post_hoc()` | Tukey HSD comparisons |
| | `kruskal_wallis_test()` | Non-parametric group comparison |
| | `chi_squared_test()` | Chi-squared test of independence |
| | `correspondence_analysis_wrapper()` | Correspondence analysis |
| **Regression** | `fit_linear_model()` | Linear regression |
| | `fit_polynomial_model()` | Polynomial regression |
| | `fit_interaction_model()` | Regression with interaction terms |
| | `compare_models()` | Model comparison using ANOVA |
| | `model_summary()` | Formatted model summary |
| | `residual_analysis()` | Residual analysis and outlier detection |
| | `create_prediction_intervals()` | Confidence and prediction intervals |
| **Diagnostics** | `plot_diagnostics()` | Standard diagnostic plots |
| | `plot_predictions()` | Predicted values with interval bands |
| | `validate_assumptions()` | Assumption validation report |
| | `diagnostics_checklist()` | Assumption checklist |
| | `model_dashboard()` | Comparison of multiple models |
| | `model_insights()` | Plain language interpretation of model coefficients |
| | `generate_report()` | End-to-end analysis report |

## Dataset

The package includes `vehicles`, a cleaned subset of the EPA fuel economy dataset derived from `ggplot2::mpg`. The dataset contains 76 observations across 9 variables.

```r
data(vehicles)
?vehicles
```

## Repository Structure

```text
statistical-analysis-toolkit/
├── R/
│   ├── 00-utils.R
│   ├── 01-eda.R
│   ├── 02-assumptions.R
│   ├── 03-inference.R
│   ├── 04-regression.R
│   ├── 05-visualization.R
│   ├── 06-diagnostics.R
│   └── package.R
├── data/
├── tests/
│   └── testthat/
├── vignettes/
├── examples/
├── docs/
├── DESCRIPTION
├── NAMESPACE
└── README.md
```

## Development

```r
# Load the package
devtools::load_all()

# Run the test suite
devtools::test()

# Run a full package check
devtools::check()

# Regenerate documentation
devtools::document()
```

## Contributing

Contributions are welcome.

1. Fork the repository.
2. Create a feature branch.
3. Add or update tests where appropriate.
4. Ensure `devtools::check()` completes without errors or warnings.
5. Open a pull request with a clear description of the changes.

## License

Released under the MIT License. See [LICENSE](LICENSE) for details.