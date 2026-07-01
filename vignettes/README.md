# Vignettes Directory

Vignettes are long-form guides and tutorials included in the package documentation.

## Available Vignettes

1. **01-getting-started.Rmd** - Installation and first analysis
2. **02-eda-workflow.Rmd** - Comprehensive exploratory analysis
3. **03-hypothesis-testing.Rmd** - Hypothesis testing tutorial
4. **04-regression-guide.Rmd** - Regression modeling guide

## Building Vignettes

```r
# Build vignettes during development
devtools::build_vignettes()

# View a vignette
vignette("getting-started", package = "statsforensics")
```

## Writing New Vignettes

1. Create a file: `vignettes/XX-name.Rmd`
2. Include YAML header with title, author, date
3. Use markdown + R code chunks
4. Run `devtools::build_vignettes()` to generate
5. Vignettes automatically included in package HTML docs

---

Last Updated: 2026-07-01
