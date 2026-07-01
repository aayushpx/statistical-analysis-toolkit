# Figures Directory

This directory stores generated plots, visualizations, and example outputs from analyses.

## Subdirectories

### diagnostic_plots/
Residual diagnostic plots from regression models:
- Residuals vs Fitted
- Q-Q plots  
- Scale-Location plots
- Residuals vs Leverage

### example_outputs/
Output plots from example scripts:
- EDA visualizations
- Model comparisons
- Prediction plots

## Generating Figures

Use functions like:
```r
# Save diagnostic plots
ggsave("figures/diagnostic_plots/residuals.png", plot = plot_diagnostics(model))

# Save predictions
ggsave("figures/example_outputs/predictions.png", plot = plot_predictions(preds))
```

## Storage

Figures are tracked in `.gitignore` by default (they're generated, not source files). Keep your `.R` scripts in `examples/` so figures can be regenerated anytime.

---

Last Updated: 2026-07-01
