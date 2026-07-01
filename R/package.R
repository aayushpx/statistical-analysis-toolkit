#' @keywords internal
"_PACKAGE"

## usethis namespace: start
#' @importFrom stats AIC BIC aov as.formula coef cor formula lm median pf qchisq quantile residuals sd fitted
#' @importFrom utils capture.output head
## usethis namespace: end

# Suppress R CMD check notes for ggplot2 aesthetic variables
# (non-standard evaluation inside aes() calls)
utils::globalVariables(c(
  # create_correlation_heatmap
  "Var1", "Var2", "value",
  # plot_diagnostics
  "sqrt_res", "index",
  # plot_predictions
  "fit", "lwr", "upr",
  # plot_residual_distribution (after_stat computed aesthetic)
  "density"
))
