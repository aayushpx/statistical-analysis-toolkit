# Statistical Analysis Toolkit

[![R-CMD-check](https://github.com/yourusername/statistical-analysis-toolkit/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/yourusername/statistical-analysis-toolkit/actions/workflows/R-CMD-check.yaml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![R Version](https://img.shields.io/badge/R-%3E=4.0-brightgreen)](https://www.r-project.org/)

A comprehensive R package — `statsforensics` — for exploratory data analysis, statistical inference, hypothesis testing, regression modeling, and publication-quality visualization.

The package consolidates recurring statistical workflows into modular, well-documented functions so that rigorous analysis is reproducible and accessible.

---

## Installation

```r
# Install from GitHub
devtools::install_github("yourusername/statistical-analysis-toolkit")

# Or during development
devtools::load_all()
```

---

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
summarize_by_group(vehicles, c("highway_mpg", "city_mpg"), "vehicle_class")
```

### Statistical Testing

```r
# Check assumptions first
check_normality(vehicles$highway_mpg)
check_heteroscedasticity(vehicles, response = "highway_mpg", group = "vehicle_class")

# One-way ANOVA + post-hoc
anova_result <- perform_anova(vehicles, response = "highway_mpg", group = "vehicle_class")
tukey_post_hoc(anova_result)

# Non-parametric alternative
kruskal_wallis_test(vehicles, response = "highway_mpg", group = "vehicle_class")
```

### Regression Modeling

```r
# Fit and summarise
model <- fit_linear_model(vehicles, "highway_mpg ~ engine_displacement")
model_summary(model)

# Validate assumptions
validate_assumptions(model)

# Diagnostic plots
plot_diagnostics(model)

# Predictions with intervals
new_data <- data.frame(engine_displacement = seq(1.6, 7.0, by = 0.5))
preds    <- create_prediction_intervals(model, newdata = new_data)
plot_predictions(preds)
```

---

## Core Functions

| Category | Function | Description |
|----------|----------|-------------|
| **EDA** | `eda_numeric()` | Histogram, boxplot, Q-Q plot + summary stats |
| | `eda_by_group()` | Group-wise boxplots and Q-Q plots |
| | `summarize_by_group()` | Tidy group summary table |
| | `correlation_analysis()` | Pairwise correlation matrix and plot |
| | `count_missing()` | Missing-value audit |
| **Assumptions** | `check_normality()` | Shapiro-Wilk + K-S test |
| | `check_heteroscedasticity()` | Levene's test (data frame or model) |
| | `check_multicollinearity()` | VIF for multi-predictor models |
| | `validate_assumptions()` | All checks in one report |
| **Inference** | `t_test_comprehensive()` | One-sample, two-sample, or paired t-test |
| | `perform_anova()` | One-way ANOVA with effect size |
| | `tukey_post_hoc()` | Tukey HSD pairwise comparisons |
| | `kruskal_wallis_test()` | Non-parametric group comparison |
| | `chi_squared_test()` | Test of independence |
| | `correspondence_analysis_wrapper()` | CA for categorical relationships |
| **Regression** | `fit_linear_model()` | Linear regression |
| | `fit_polynomial_model()` | Polynomial regression |
| | `fit_interaction_model()` | Model with interaction terms |
| | `compare_models()` | ANOVA F-test model comparison |
| | `model_summary()` | Formatted model output |
| | `residual_analysis()` | Residual statistics and outlier flags |
| | `create_prediction_intervals()` | Prediction/confidence intervals |
| **Diagnostics** | `plot_diagnostics()` | 4-panel diagnostic plot |
| | `plot_predictions()` | Predicted values with interval ribbon |
| | `validate_assumptions()` | Assumption validation report |
| | `diagnostics_checklist()` | Pass/fail checklist per assumption |
| | `model_dashboard()` | Compare multiple models on key metrics |
| | `model_insights()` | Plain-English coefficient interpretation |
| | `generate_report()` | Complete analysis pipeline report |

---

## Dataset

The package ships with `vehicles`, a cleaned subset of EPA fuel economy data
(derived from `ggplot2::mpg`) with 76 observations across 9 variables:

```r
data(vehicles)
?vehicles
```

---

## Repository Structure

```
statistical-analysis-toolkit/
├── R/                      # Package source
│   ├── 00-utils.R         # Internal helpers, transformations
│   ├── 01-eda.R           # EDA functions
│   ├── 02-assumptions.R   # Assumption checks
│   ├── 03-inference.R     # Hypothesis tests
│   ├── 04-regression.R    # Regression modeling
│   ├── 05-visualization.R # Plotting functions
│   ├── 06-diagnostics.R   # Diagnostics and reporting
│   └── package.R          # Package-level imports
├── data/                   # Bundled datasets
├── tests/testthat/         # Unit tests (64 tests)
├── vignettes/              # Tutorials
├── examples/               # Standalone example scripts
└── docs/                   # Extended methodology notes
```

---

## Development

```r
devtools::load_all()   # Load package
devtools::test()       # Run tests
devtools::check()      # Full R CMD check
devtools::document()   # Regenerate documentation
```

---

## Contributing

Contributions welcome. Please:

1. Fork the repository and create a feature branch
2. Add tests for any new functions
3. Ensure `devtools::check()` passes with 0 errors and 0 warnings
4. Submit a pull request with a clear description

---

## License

MIT — see [LICENSE](LICENSE) for details.

---

## Author

**Aayush Prakash**

- GitHub: [@yourusername](https://github.com/yourusername)
- Email: aayush@example.com
