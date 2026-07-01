.onAttach <- function(libname, pkgname) {
  ver <- tryCatch(
    as.character(utils::packageVersion(pkgname)),
    error = function(e) "?"
  )
  packageStartupMessage(
    "\n",
    "=====================================================================\n",
    "  Statistical Analysis Toolkit v", ver, "\n",
    "=====================================================================\n\n",
    "  A comprehensive R package for:\n",
    "  - Exploratory Data Analysis (EDA)\n",
    "  - Statistical Inference & Hypothesis Testing\n",
    "  - Regression Modeling with Diagnostics\n",
    "  - Publication-Quality Visualizations\n\n",
    "  Quick Start:\n",
    "  - ?eda_numeric          - Explore a single variable\n",
    "  - ?perform_anova        - Compare groups\n",
    "  - ?fit_linear_model     - Regression analysis\n",
    "  - ?plot_diagnostics     - Validate assumptions\n",
    "  - ?generate_report      - Complete analysis report\n\n",
    "  Learn more: https://github.com/yourusername/statistical-analysis-toolkit\n",
    "=====================================================================\n\n"
  )
}
