#' Regression Modeling Functions
#'
#' Functions for fitting, evaluating, and understanding regression models.

#' Fit Linear Regression Model
#'
#' Fit a linear regression model with formula interface.
#'
#' @param data A data frame
#' @param formula Model formula (e.g., "y ~ x1 + x2")
#'
#' @return Fitted lm object
#'
#' @export
#'
#' @examples
#' \dontrun{
#' model <- fit_linear_model(mtcars, "mpg ~ wt + hp")
#' }
fit_linear_model <- function(data, formula) {
  validate_data(data)

  if (!is.character(formula)) {
    stop("Formula must be a character string")
  }

  model <- lm(as.formula(formula), data = data)

  cat("\n", "Linear Regression Model\n")
  cat("===============================================\n")
  cat("Formula:", formula, "\n\n")
  print(summary(model))

  invisible(model)
}

#' Fit Polynomial Regression Model
#'
#' Fit polynomial regression to capture non-linearity.
#'
#' @param data A data frame
#' @param response Name of response variable
#' @param predictor Name of predictor variable
#' @param degree Polynomial degree (default = 2)
#'
#' @return Fitted lm object with polynomial terms
#'
#' @importFrom stats poly
#'
#' @export
#'
#' @examples
#' \dontrun{
#' model <- fit_polynomial_model(mtcars, "mpg", "wt", degree = 2)
#' }
fit_polynomial_model <- function(data, response, predictor, degree = 2) {
  validate_data(data, c(response, predictor))

  formula <- as.formula(paste(response, "~ poly(", predictor, ",", degree, ")"))
  model <- lm(formula, data = data)

  cat("\n", "Polynomial Regression Model (Degree", degree, ")\n")
  cat("===============================================\n")
  cat("Response:", response, "\n")
  cat("Predictor:", predictor, "\n")
  cat("Degree:", degree, "\n\n")
  print(summary(model))

  invisible(model)
}

#' Fit Model with Interaction Terms
#'
#' Fit regression with interaction effects.
#'
#' @param data A data frame
#' @param formula Model formula with interaction (e.g., "y ~ x1 * x2")
#'
#' @return Fitted lm object
#'
#' @export
#'
#' @examples
#' \dontrun{
#' model <- fit_interaction_model(mtcars, "mpg ~ wt * factor(cyl)")
#' }
fit_interaction_model <- function(data, formula) {
  validate_data(data)

  model <- lm(as.formula(formula), data = data)

  cat("\n", "Regression Model with Interactions\n")
  cat("===============================================\n")
  cat("Formula:", formula, "\n\n")
  print(summary(model))

  invisible(model)
}

#' Generate Model Summary
#'
#' Create a comprehensive summary of a fitted model.
#'
#' @param model A fitted lm object
#'
#' @return Data frame with model diagnostics
#'
#' @export
#'
#' @examples
#' \dontrun{
#' model <- fit_linear_model(mtcars, "mpg ~ wt + hp")
#' model_summary(model)
#' }
model_summary <- function(model) {
  if (!inherits(model, "lm")) {
    stop("Input must be a fitted linear model")
  }

  summary_obj <- summary(model)

  cat("\n", "===============================================\n")
  cat("MODEL SUMMARY\n")
  cat("===============================================\n\n")

  # Model fit statistics
  cat("FIT STATISTICS:\n")
  cat("---------------------------------------------\n")
  cat("R^2:", round(summary_obj$r.squared, 4), "\n")
  cat("Adjusted R^2:", round(summary_obj$adj.r.squared, 4), "\n")
  cat("Residual Std. Error:", round(summary_obj$sigma, 4), "\n")
  cat("F-statistic:", round(summary_obj$fstatistic[1], 4), "\n")
  cat("DF:", summary_obj$fstatistic[2], "and", summary_obj$fstatistic[3], "\n")
  cat("p-value:", format(pf(summary_obj$fstatistic[1], summary_obj$fstatistic[2], summary_obj$fstatistic[3], lower.tail = FALSE), scientific = TRUE), "\n\n")

  # Coefficients
  cat("COEFFICIENTS:\n")
  cat("---------------------------------------------\n")
  coef_table <- as.data.frame(summary_obj$coefficients)
  colnames(coef_table) <- c("Estimate", "Std. Error", "t value", "p value")
  coef_table$Significant <- ifelse(coef_table$`p value` < 0.05, "\u2713", "")
  # Round only numeric columns to avoid errors when non-numeric display columns exist
  num_cols <- sapply(coef_table, is.numeric)
  coef_table[num_cols] <- lapply(coef_table[num_cols], function(x) round(x, 4))
  print(coef_table)

  # Number of observations
  cat("\nObservations:", nrow(model$model), "\n")
  cat("Residuals DF:", model$df.residual, "\n")

  invisible(summary_obj)
}

#' Residual Analysis
#'
#' Analyze model residuals for patterns and violations.
#'
#' @param model A fitted lm object
#'
#' @return List with residual statistics
#'
#' @export
#'
#' @examples
#' \dontrun{
#' model <- fit_linear_model(mtcars, "mpg ~ wt + hp")
#' residual_analysis(model)
#' }
residual_analysis <- function(model) {
  if (!inherits(model, "lm")) {
    stop("Input must be a fitted linear model")
  }

  residuals <- residuals(model)
  fitted <- fitted(model)

  cat("\n", "Residual Analysis\n")
  cat("===============================================\n\n")

  # Summary statistics
  cat("RESIDUAL STATISTICS:\n")
  cat("---------------------------------------------\n")
  cat("Mean:", round(mean(residuals), 6), "(should be ~0)\n")
  cat("Std Dev:", round(sd(residuals), 4), "\n")
  cat("Min:", round(min(residuals), 4), "\n")
  cat("Max:", round(max(residuals), 4), "\n")
  cat("Range:", round(max(residuals) - min(residuals), 4), "\n\n")

  # Outliers (using 3-sigma rule)
  outliers <- which(abs(residuals) > 3 * sd(residuals))
  cat("Outliers (|residual| > 3sigma):", length(outliers), "\n")
  if (length(outliers) > 0) {
    cat("Observation indices:", paste(outliers, collapse = ", "), "\n")
  }

  invisible(list(residuals = residuals, outliers = outliers))
}

#' Create Prediction Intervals
#'
#' Generate predictions with confidence and prediction intervals.
#'
#' @param model A fitted lm object
#' @param newdata Data frame with new observations
#' @param interval "confidence" or "prediction"
#' @param level Confidence level (default = 0.95)
#'
#' @return Data frame with predictions and intervals
#'
#' @importFrom stats predict
#'
#' @export
#'
#' @examples
#' \dontrun{
#' model <- fit_linear_model(mtcars, "mpg ~ wt")
#' new_data <- data.frame(wt = seq(2, 5, 0.5))
#' create_prediction_intervals(model, new_data)
#' }
create_prediction_intervals <- function(model, newdata, interval = "prediction", level = 0.95) {
  if (!inherits(model, "lm")) {
    stop("Input must be a fitted linear model")
  }

  predictions <- predict(model, newdata = newdata, interval = interval, level = level)

  result <- cbind(newdata, as.data.frame(predictions))
  colnames(result) <- c(names(newdata), "fit", "lwr", "upr")

  cat("\nPredictions with", toupper(interval), "Intervals\n")
  cat("===============================================\n")
  cat("Confidence Level:", level * 100, "%\n")
  cat("Interval Type:", interval, "\n\n")
  print(head(result, 10))

  invisible(result)
}

#' Compare Models
#'
#' Compare two fitted models using ANOVA F-test.
#'
#' @param model1 First fitted lm object
#' @param model2 Second fitted lm object
#'
#' @return ANOVA comparison result
#'
#' @importFrom stats anova
#'
#' @export
#'
#' @examples
#' \dontrun{
#' model1 <- fit_linear_model(mtcars, "mpg ~ wt")
#' model2 <- fit_linear_model(mtcars, "mpg ~ wt + hp")
#' compare_models(model1, model2)
#' }
compare_models <- function(model1, model2) {
  if (!inherits(model1, "lm") || !inherits(model2, "lm")) {
    stop("Both inputs must be fitted lm objects")
  }

  comparison <- anova(model1, model2)

  cat("\n", "Model Comparison (ANOVA F-test)\n")
  cat("===============================================\n\n")
  print(comparison)

  p_value <- comparison$`Pr(>F)`[2]

  if (p_value < 0.05) {
    cat("\n\u2713 Model 2 is significantly better than Model 1 (p < 0.05)\n")
  } else {
    cat("\n\u2717 No significant difference between models (p >= 0.05)\n")
    cat("Consider using the simpler model (Model 1)\n")
  }

  invisible(comparison)
}
