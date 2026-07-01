#' Visualization Functions
#'
#' Publication-quality plots and visualizations.

#' Plot Model Diagnostics
#'
#' Generate 4-panel diagnostic plot (residuals, Q-Q, scale-location, leverage).
#'
#' @param model A fitted lm object
#' @param figsize Figure size as c(width, height)
#'
#' @return Invisibly returns ggplot object
#'
#' @importFrom ggplot2 ggplot aes geom_point geom_hline geom_boxplot stat_qq stat_qq_line geom_smooth facet_wrap theme_minimal labs theme element_text
#' @importFrom gridExtra grid.arrange
#'
#' @export
#'
#' @examples
#' \dontrun{
#' model <- fit_linear_model(mtcars, "mpg ~ wt + hp")
#' plot_diagnostics(model)
#' }
plot_diagnostics <- function(model, figsize = c(12, 9)) {
  if (!inherits(model, "lm")) {
    stop("Input must be a fitted lm object")
  }

  residuals <- residuals(model)
  fitted <- fitted(model)
  standardized_residuals <- residuals / sd(residuals)

  # 1. Residuals vs Fitted
  p1 <- ggplot(data.frame(fitted = fitted, residuals = residuals),
    aes(x = fitted, y = residuals)
  ) +
    geom_point(alpha = 0.6, color = "steelblue") +
    geom_hline(yintercept = 0, color = "red", linetype = "dashed") +
    geom_smooth(method = "lowess", se = FALSE, color = "red") +
    theme_minimal() +
    labs(
      title = "Residuals vs Fitted",
      x = "Fitted Values",
      y = "Residuals",
      subtitle = "Should show random scatter around y=0"
    )

  # 2. Q-Q Plot
  p2 <- ggplot(data.frame(sample = residuals),
    aes(sample = sample)
  ) +
    stat_qq(color = "steelblue", alpha = 0.6) +
    stat_qq_line(color = "red") +
    theme_minimal() +
    labs(
      title = "Normal Q-Q",
      x = "Theoretical Quantiles",
      y = "Sample Quantiles",
      subtitle = "Points should follow the red line"
    )

  # 3. Scale-Location
  sqrt_abs_std_residuals <- sqrt(abs(standardized_residuals))
  p3 <- ggplot(data.frame(fitted = fitted, sqrt_res = sqrt_abs_std_residuals),
    aes(x = fitted, y = sqrt_res)
  ) +
    geom_point(alpha = 0.6, color = "steelblue") +
    geom_smooth(method = "lowess", se = FALSE, color = "red") +
    theme_minimal() +
    labs(
      title = "Scale-Location",
      x = "Fitted Values",
      y = "sqrt|Standardized Residuals|",
      subtitle = "Line should be relatively flat"
    )

  # 4. Residuals vs Leverage (simplified version)
  p4 <- ggplot(data.frame(index = seq_along(residuals), residuals = residuals),
    aes(x = index, y = residuals)
  ) +
    geom_point(alpha = 0.6, color = "steelblue") +
    geom_hline(yintercept = 0, color = "red", linetype = "dashed") +
    theme_minimal() +
    labs(
      title = "Residuals by Order",
      x = "Observation Index",
      y = "Residuals",
      subtitle = "Check for time trends or patterns"
    )

  combined <- gridExtra::grid.arrange(p1, p2, p3, p4, ncol = 2)
  print(combined)

  invisible(list(p1, p2, p3, p4))
}

#' Plot Predictions
#'
#' Visualize predicted values with confidence/prediction intervals.
#'
#' @param predictions Data frame from create_prediction_intervals()
#' @param actual Optional: data frame with actual observations
#' @param x_var Name of x variable for plotting
#' @param y_var Name of y variable for actual data
#'
#' @return ggplot object
#'
#' @importFrom ggplot2 geom_ribbon geom_line
#'
#' @export
#'
#' @examples
#' \dontrun{
#' model <- fit_linear_model(mtcars, "mpg ~ wt")
#' new_data <- data.frame(wt = seq(2, 5, 0.5))
#' preds <- create_prediction_intervals(model, new_data)
#' plot_predictions(preds)
#' }
plot_predictions <- function(predictions, actual = NULL, x_var = NULL, y_var = NULL) {
  # Infer variable names
  if (is.null(x_var)) {
    x_var <- names(predictions)[1]
  }

  p <- ggplot(predictions, aes(x = !!rlang::sym(x_var))) +
    geom_ribbon(aes(ymin = lwr, ymax = upr), alpha = 0.2, fill = "steelblue") +
    geom_line(aes(y = fit), color = "steelblue", linewidth = 1) +
    theme_minimal() +
    labs(
      title = "Predictions with Intervals",
      x = x_var,
      y = "Predicted Value",
      subtitle = "Shaded region shows 95% prediction interval"
    )

  # Add actual observations if provided
  if (!is.null(actual) && !is.null(y_var)) {
    p <- p + geom_point(data = actual, aes(y = !!rlang::sym(y_var)), alpha = 0.5, color = "red")
  }

  print(p)
  invisible(p)
}

#' Create Publication-Quality Comparison Plot
#'
#' Multi-panel comparison of groups with overlaid distributions.
#'
#' @param data A data frame
#' @param response Name of response variable
#' @param groups Character vector of grouping variables
#'
#' @return patchwork combined plot
#'
#' @importFrom patchwork wrap_plots
#'
#' @export
#'
#' @examples
#' \dontrun{
#' create_comparison_plot(mtcars, "mpg", "cyl")
#' }
create_comparison_plot <- function(data, response, groups) {
  plots <- list()

  for (group in groups) {
    p <- ggplot(data, aes(x = factor(!!rlang::sym(group)), y = !!rlang::sym(response), fill = factor(!!rlang::sym(group)))) +
      geom_boxplot(alpha = 0.7, show.legend = FALSE) +
      geom_point(alpha = 0.3, position = "jitter") +
      theme_minimal() +
      labs(
        title = paste(response, "by", group),
        x = group,
        y = response
      )

    plots[[group]] <- p
  }

  combined <- patchwork::wrap_plots(plots, ncol = ceiling(length(plots) / 2))
  print(combined)
  invisible(combined)
}

#' Create Correlation Heatmap
#'
#' Visualize correlation matrix as heatmap.
#'
#' @param data A data frame (numeric columns only)
#' @param method "pearson" or "spearman"
#'
#' @return ggplot heatmap
#'
#' @importFrom ggplot2 geom_tile scale_fill_gradient2
#'
#' @export
#'
#' @examples
#' \dontrun{
#' create_correlation_heatmap(mtcars)
#' }
create_correlation_heatmap <- function(data, method = "pearson") {
  numeric_data <- data[, sapply(data, is.numeric)]
  corr_matrix <- cor(numeric_data, use = "complete.obs", method = method)

  # Reshape for ggplot using base R
  vars <- rownames(corr_matrix)
  melted <- data.frame(
    Var1 = rep(vars, each = length(vars)),
    Var2 = rep(vars, times = length(vars)),
    value = as.vector(corr_matrix)
  )
  melted$Var1 <- factor(melted$Var1, levels = vars)
  melted$Var2 <- factor(melted$Var2, levels = vars)

  p <- ggplot(melted, aes(x = Var1, y = Var2, fill = value)) +
    geom_tile() +
    scale_fill_gradient2(low = "blue", high = "red", mid = "white", limits = c(-1, 1)) +
    theme_minimal() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
    labs(
      title = paste("Correlation Matrix -", method),
      x = NULL,
      y = NULL,
      fill = "Correlation"
    )

  print(p)
  invisible(p)
}

#' Create Residual Histogram
#'
#' Visualize distribution of residuals with normality reference.
#'
#' @param model A fitted lm object
#'
#' @return ggplot object
#'
#' @importFrom ggplot2 geom_histogram stat_function after_stat
#' @importFrom stats dnorm
#'
#' @export
#'
#' @examples
#' \dontrun{
#' model <- fit_linear_model(mtcars, "mpg ~ wt + hp")
#' plot_residual_distribution(model)
#' }
plot_residual_distribution <- function(model) {
  if (!inherits(model, "lm")) {
    stop("Input must be a fitted lm object")
  }

  residuals <- residuals(model)
  residuals_df <- data.frame(residuals = residuals)

  p <- ggplot(residuals_df, aes(x = residuals)) +
    geom_histogram(aes(y = after_stat(density)), bins = 20, fill = "steelblue", alpha = 0.7, color = "white") +
    stat_function(fun = dnorm, args = list(mean = 0, sd = sd(residuals)), color = "red", linewidth = 1) +
    theme_minimal() +
    labs(
      title = "Distribution of Residuals",
      x = "Residuals",
      y = "Density",
      subtitle = "Red curve shows normal distribution"
    )

  print(p)
  invisible(p)
}
