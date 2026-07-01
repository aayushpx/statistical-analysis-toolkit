# Getting Started with statsforensics

Welcome! This guide helps you install and run your first analysis.

## Installation

```r
# Install dependencies (one time)
install.packages(c("tidyverse", "car", "patchwork", "FactoMineR", "GGally"))

# Install statsforensics from GitHub
devtools::install_github("yourusername/statistical-analysis-toolkit")

# Or during development
devtools::load_all()
```

## First Analysis (2 Minutes)

```r
library(statsforensics)

# Explore data
eda_numeric(mtcars, "mpg")

# Compare groups
eda_by_group(mtcars, "mpg", "cyl")

# Simple test
perform_anova(mtcars, "mpg", "cyl")
```

## What's Next?

- **For EDA**: See [example_01_basic_eda.R](../examples/example_01_basic_eda.R)
- **For Testing**: See [example_02_t_tests.R](../examples/example_02_t_tests.R)
- **For Modeling**: See [example_04_regression.R](../examples/example_04_regression.R)
- **Full Workflow**: See [example_05_complete_workflow.R](../examples/example_05_complete_workflow.R)

## Common Tasks

### Explore a variable
```r
eda_numeric(mydata, "variable_name")
```

### Compare groups
```r
perform_anova(mydata, response = "outcome", group = "group_var")
tukey_post_hoc(anova_result)  # Which groups differ?
```

### Fit a regression model
```r
model <- fit_linear_model(mydata, "outcome ~ predictor1 + predictor2")
validate_assumptions(model)  # Check assumptions first!
plot_diagnostics(model)      # Visualize diagnostics
```

### Get predictions
```r
new_data <- data.frame(predictor1 = c(1, 2, 3))
create_prediction_intervals(model, new_data)
```

## Documentation

- [Methodology](../docs/METHODOLOGY.md) - Statistical concepts
- [Workflow](../docs/WORKFLOW.md) - Step-by-step analysis
- [Troubleshooting](../docs/TROUBLESHOOTING.md) - Common issues
- [Architecture](../docs/ARCHITECTURE.md) - Package design

## Getting Help

1. Check [Troubleshooting](../docs/TROUBLESHOOTING.md)
2. Run `?function_name` for help on any function
3. Look at example scripts in `examples/`
4. File an issue on GitHub

---

Next: [WORKFLOW.md](../docs/WORKFLOW.md) for a complete analysis example
