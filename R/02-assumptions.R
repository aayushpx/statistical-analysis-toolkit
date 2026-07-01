#' Assumption Checking Functions
#'
#' Validate statistical assumptions before inference.

#' Check Normality of Data
#'
#' Test for normality using multiple approaches: Shapiro-Wilk test,
#' Kolmogorov-Smirnov test, and Q-Q plot visualization.
#'
#' @param x A numeric vector
#'
#' @return List with test results and interpretation
#'
#' @importFrom stats shapiro.test ks.test
#'
#' @export
#'
#' @examples
#' \dontrun{
#' check_normality(mtcars$mpg)
#' }
check_normality <- function(x) {
  x_clean <- x[!is.na(x)]

  if (length(x_clean) < 3) {
    stop("Need at least 3 non-missing values")
  }

  # Shapiro-Wilk test (best for n < 5000)
  sw_test <- shapiro.test(x_clean)

  # Kolmogorov-Smirnov test
  ks_test <- ks.test(x_clean, "pnorm", mean = mean(x_clean), sd = sd(x_clean))

  results <- list(
    shapiro_wilk = list(
      statistic = sw_test$statistic,
      p_value = sw_test$p.value,
      normal = sw_test$p.value > 0.05
    ),
    kolmogorov_smirnov = list(
      statistic = ks_test$statistic,
      p_value = ks_test$p.value,
      normal = ks_test$p.value > 0.05
    ),
    n = length(x_clean)
  )

  # Print summary
  cat("\n\u2713 Normality Tests\n")
  cat("=====================================\n")
  cat("Shapiro-Wilk Test:\n")
  cat("  Test Statistic:", round(sw_test$statistic, 4), "\n")
  cat("  p-value:", round(sw_test$p.value, 4), "\n")
  cat("  Interpretation:", if (sw_test$p.value > 0.05) "Data appears normal (p > 0.05)" else "Evidence of non-normality (p < 0.05)", "\n\n")

  cat("Kolmogorov-Smirnov Test:\n")
  cat("  Test Statistic:", round(ks_test$statistic, 4), "\n")
  cat("  p-value:", round(ks_test$p.value, 4), "\n")
  cat("  Interpretation:", if (ks_test$p.value > 0.05) "Data appears normal (p > 0.05)" else "Evidence of non-normality (p < 0.05)", "\n\n")

  invisible(results)
}

#' Check Heteroscedasticity
#'
#' Test for equal variance across groups using Levene's test,
#' or across fitted values for a model.
#'
#' @param object Either a data frame with variables, or a fitted model (lm, aov, etc.)
#' @param response Name of response variable (for data frame input)
#' @param group Name of grouping variable (for data frame input)
#'
#' @return List with test results
#'
#' @importFrom car leveneTest
#'
#' @export
#'
#' @examples
#' \dontrun{
#' # For data with groups
#' check_heteroscedasticity(mtcars, response = "mpg", group = "cyl")
#'
#' # For model
#' model <- lm(mpg ~ cyl, data = mtcars)
#' check_heteroscedasticity(model)
#' }
check_heteroscedasticity <- function(object, response = NULL, group = NULL) {
  if (is.data.frame(object)) {
    # Group comparison
    if (is.null(response) || is.null(group)) {
      stop("Must provide 'response' and 'group' for data frame input")
    }

    # Levene's test requires a categorical grouping variable
    object[[group]] <- as.factor(object[[group]])
    formula <- as.formula(paste(response, "~", group))
    test <- car::leveneTest(formula, data = object, center = median)

    cat("\n\u2713 Levene's Test for Homogeneity of Variance\n")
    cat("=====================================\n")
    print(test)

    result <- list(
      test = "Levene",
      statistic = test$`F value`[1],
      p_value = test$`Pr(>F)`[1],
      homoscedastic = test$`Pr(>F)`[1] > 0.05
    )

  } else if (inherits(object, "lm")) {
    # Model residuals
    residuals <- residuals(object)
    fitted <- fitted(object)

    # Split into quartiles and test
    quartiles <- cut(fitted, breaks = quantile(fitted, probs = c(0, 0.25, 0.5, 0.75, 1)), include.lowest = TRUE)
    test <- car::leveneTest(residuals ~ quartiles, center = median)

    cat("\n\u2713 Levene's Test for Homogeneity of Variance (Residuals)\n")
    cat("=====================================\n")
    print(test)

    result <- list(
      test = "Levene (Model Residuals)",
      statistic = test$`F value`[1],
      p_value = test$`Pr(>F)`[1],
      homoscedastic = test$`Pr(>F)`[1] > 0.05
    )
  } else {
    stop("Input must be a data frame or fitted model")
  }

  invisible(result)
}

#' Check Multicollinearity
#'
#' Calculate Variance Inflation Factors (VIF) to detect multicollinearity.
#'
#' @param model A fitted linear model (lm)
#' @param threshold VIF threshold for concern (default = 5)
#'
#' @return Data frame with VIF values
#'
#' @importFrom car vif
#'
#' @export
#'
#' @examples
#' \dontrun{
#' model <- lm(mpg ~ cyl + wt + hp, data = mtcars)
#' check_multicollinearity(model)
#' }
check_multicollinearity <- function(model, threshold = 5) {
  if (!inherits(model, "lm")) {
    stop("Input must be a fitted linear model")
  }

  vif_values <- car::vif(model)

  vif_df <- data.frame(
    Variable = names(vif_values),
    VIF = round(vif_values, 3),
    Concern = ifelse(vif_values > threshold, "\u2717 HIGH", "\u2713 OK")
  )

  cat("\n\u2713 Variance Inflation Factors (VIF)\n")
  cat("=====================================\n")
  cat("Threshold for concern: VIF >", threshold, "\n\n")
  print(vif_df, row.names = FALSE)

  if (any(vif_values > threshold)) {
    cat("\n(!) High multicollinearity detected!")
    cat("\nConsider:\n")
    cat("  - Removing highly correlated variables\n")
    cat("  - Using regularization (Ridge, Lasso)\n")
    cat("  - PCA for dimensionality reduction\n")
  }

  invisible(vif_df)
}

#' Comprehensive Assumption Validation
#'
#' Run all assumption checks for a fitted model.
#'
#' @param model A fitted linear model
#' @param data Original data frame (optional, for additional checks)
#'
#' @return Invisibly returns list with all results; prints comprehensive report
#'
#' @export
#'
#' @examples
#' \dontrun{
#' model <- lm(mpg ~ wt + hp, data = mtcars)
#' validate_assumptions(model)
#' }
validate_assumptions <- function(model, data = NULL) {
  cat("\n", "+====================================+\n")
  cat("|  Assumption Validation Report      |\n")
  cat("|  (Statistical Inference Guidelines)|\n")
  cat("+====================================+\n\n")

  # Normality
  cat("1. NORMALITY OF RESIDUALS\n")
  cat("---------------------------------------------\n")
  normality_result <- check_normality(residuals(model))

  # Homoscedasticity
  cat("\n2. HOMOGENEITY OF VARIANCE\n")
  cat("---------------------------------------------\n")
  hetero_result <- check_heteroscedasticity(model)

  # Multicollinearity (only meaningful with multiple predictors)
  cat("\n3. MULTICOLLINEARITY (Predictors)\n")
  cat("---------------------------------------------\n")
  multi_result <- tryCatch(
    check_multicollinearity(model),
    error = function(e) {
      cat("VIF not computed: model has fewer than 2 predictors.\n")
      NULL
    }
  )

  # Summary
  cat("\n\n", "+====================================+\n")
  cat("|  ASSUMPTION SUMMARY                |\n")
  cat("+====================================+\n\n")

  normality_ok <- normality_result$shapiro_wilk$normal
  hetero_ok <- hetero_result$homoscedastic

  cat("Normality:", if (normality_ok) "\u2713 PASS" else "\u2717 FAIL", "\n")
  cat("Homoscedasticity:", if (hetero_ok) "\u2713 PASS" else "\u2717 FAIL", "\n")
  if (!is.null(multi_result)) {
    cat("Multicollinearity:", if (all(multi_result$VIF <= 5)) "\u2713 PASS" else "\u2717 CONCERN", "\n\n")
  } else {
    cat("Multicollinearity: N/A (single predictor)\n\n")
  }

  multi_ok <- is.null(multi_result) || all(multi_result$VIF <= 5)

  if (normality_ok && hetero_ok && multi_ok) {
    cat("\u2713 Assumptions appear to be met. Proceed with inference.\n")
  } else {
    cat("(!) Some assumptions violated. Consider:\n")
    if (!normality_ok) cat("  - Data transformation (log, sqrt)\n")
    if (!hetero_ok) cat("  - Weighted least squares\n")
    if (!hetero_ok || !normality_ok) cat("  - Non-parametric alternatives\n")
    if (!is.null(multi_result) && !multi_ok) cat("  - Removing or combining collinear predictors\n")
  }

  invisible(list(
    normality = normality_result,
    homoscedasticity = hetero_result,
    multicollinearity = multi_result
  ))
}
