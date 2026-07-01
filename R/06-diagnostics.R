#' Comprehensive Diagnostics and Reporting
#'
#' Generate complete diagnostic reports for statistical analyses.

#' Generate Full Analysis Report
#'
#' Create a comprehensive report including EDA, assumption checks,
#' model fit, and recommendations.
#'
#' @param model A fitted lm object
#' @param data Original data frame
#' @param response Name of response variable
#' @param predictors Character vector of predictor names
#' @param output_format "console" or "html" (default = "console")
#'
#' @return Invisibly returns report object
#'
#' @export
#'
#' @examples
#' \dontrun{
#' model <- fit_linear_model(mtcars, "mpg ~ wt + hp")
#' generate_report(model, mtcars, "mpg", c("wt", "hp"))
#' }
generate_report <- function(model, data, response, predictors, output_format = "console") {
  if (output_format == "console") {
    cat("\n")
    cat("+===========================================================+\n")
    cat("|           COMPREHENSIVE ANALYSIS REPORT                  |\n")
    cat("+===========================================================+\n\n")

    # Section 1: Data Summary
    cat("1. DATA SUMMARY\n")
    cat("-------------------------------------------------------------\n")
    cat("Sample Size:", nrow(data), "observations\n")
    cat("Response Variable:", response, "\n")
    cat("Predictor Variables:", paste(predictors, collapse = ", "), "\n")
    cat("Missing Values:", sum(is.na(data)), "total\n\n")

    # Section 2: Exploratory Analysis
    cat("2. EXPLORATORY DATA ANALYSIS\n")
    cat("-------------------------------------------------------------\n")
    cat("Response Variable Summary:\n")
    print(summary(data[[response]]))
    cat("\n")

    # Section 3: Model Fit
    cat("3. MODEL FIT STATISTICS\n")
    cat("-------------------------------------------------------------\n")
    model_summary(model)

    # Section 4: Assumption Validation
    cat("\n4. ASSUMPTION VALIDATION\n")
    cat("-------------------------------------------------------------\n")
    validate_assumptions(model)

    # Section 5: Diagnostics
    cat("\n5. DIAGNOSTIC PLOTS\n")
    cat("-------------------------------------------------------------\n")
    plot_diagnostics(model)

    # Section 6: Interpretation
    cat("\n6. INTERPRETATION & RECOMMENDATIONS\n")
    cat("-------------------------------------------------------------\n")
    summary_obj <- summary(model)

    if (summary_obj$r.squared > 0.7) {
      cat("\u2713 Model explains >70% of variance. Strong predictive power.\n")
    } else if (summary_obj$r.squared > 0.5) {
      cat("\u2713 Model explains 50-70% of variance. Moderate predictive power.\n")
    } else {
      cat("(!) Model explains <50% of variance. Consider additional variables.\n")
    }

    cat("\n\u2713 Key Findings:\n")
    for (i in 2:nrow(summary_obj$coefficients)) {
      coef <- summary_obj$coefficients[i, 1]
      p_val <- summary_obj$coefficients[i, 4]
      var_name <- rownames(summary_obj$coefficients)[i]

      if (p_val < 0.05) {
        cat("  -", var_name, "is significant (p <", format(p_val, digits = 3), ")\n")
      }
    }

    cat("\n")
    cat("+===========================================================+\n")
    cat("|                      END OF REPORT                        |\n")
    cat("+===========================================================+\n")
  }

  invisible(list(model = model, data = data))
}

#' Model Diagnostics Checklist
#'
#' Print an interactive checklist for assumption validation.
#'
#' @param model A fitted lm object
#'
#' @return Invisibly returns checklist results
#'
#' @export
#'
#' @examples
#' \dontrun{
#' model <- fit_linear_model(mtcars, "mpg ~ wt + hp")
#' diagnostics_checklist(model)
#' }
diagnostics_checklist <- function(model) {
  if (!inherits(model, "lm")) {
    stop("Input must be a fitted lm object")
  }

  residuals <- residuals(model)

  # Run all checks
  normality <- check_normality(residuals)
  hetero <- check_heteroscedasticity(model)
  multi <- check_multicollinearity(model)

  # Summarize
  cat("\n", "+========================================+\n")
  cat("|    DIAGNOSTIC CHECKLIST              |\n")
  cat("|    Pre-Inference Validation          |\n")
  cat("+========================================+\n\n")

  checks <- data.frame(
    Check = c(
      "Linearity",
      "Normality",
      "Homoscedasticity",
      "Independence",
      "Multicollinearity"
    ),
    Status = c(
      "\u2713 Review plots",
      if (normality$shapiro_wilk$normal) "\u2713 PASS" else "\u2717 FAIL",
      if (hetero$homoscedastic) "\u2713 PASS" else "\u2717 FAIL",
      "\u2713 Assumed by design",
      if (all(multi$VIF <= 5)) "\u2713 PASS" else "\u2717 CONCERN"
    ),
    Action = c(
      "Visual inspection",
      if (!normality$shapiro_wilk$normal) "Transform data" else "None",
      if (!hetero$homoscedastic) "Weighted LS" else "None",
      "Design review",
      if (!all(multi$VIF <= 5)) "Remove variables" else "None"
    ),
    stringsAsFactors = FALSE
  )

  print(checks, row.names = FALSE)

  cat("\n RECOMMENDATIONS:\n")
  cat("-------------------------------------------------------------\n")

  all_pass <- normality$shapiro_wilk$normal && hetero$homoscedastic && all(multi$VIF <= 5)

  if (all_pass) {
    cat("\u2713 ALL ASSUMPTIONS MET\n")
    cat("-> Proceed with parametric inference (t-tests, confidence intervals)\n")
  } else {
    cat("(!) Some assumptions violated\n")
    cat("-> Consider:\n")
    if (!normality$shapiro_wilk$normal) cat("  - Box-Cox or log transformation\n")
    if (!hetero$homoscedastic) cat("  - Weighted least squares\n")
    cat("  - Non-parametric alternatives (Kruskal-Wallis, Wilcoxon)\n")
  }

  invisible(checks)
}

#' Model Comparison Dashboard
#'
#' Compare multiple models with performance metrics.
#'
#' @param models Named list of fitted lm objects
#'
#' @return Data frame with model comparison
#'
#' @export
#'
#' @examples
#' \dontrun{
#' m1 <- fit_linear_model(mtcars, "mpg ~ wt")
#' m2 <- fit_linear_model(mtcars, "mpg ~ wt + hp")
#' m3 <- fit_polynomial_model(mtcars, "mpg", "wt", degree = 2)
#'
#' model_dashboard(list(Linear = m1, Full = m2, Polynomial = m3))
#' }
model_dashboard <- function(models) {
  if (!is.list(models) || !all(sapply(models, inherits, "lm"))) {
    stop("Input must be a named list of lm objects")
  }

  comparison <- data.frame(
    Model = names(models),
    R2 = sapply(models, function(m) round(summary(m)$r.squared, 4)),
    Adj_R2 = sapply(models, function(m) round(summary(m)$adj.r.squared, 4)),
    RMSE = sapply(models, function(m) round(summary(m)$sigma, 4)),
    AIC = sapply(models, function(m) round(AIC(m), 2)),
    BIC = sapply(models, function(m) round(BIC(m), 2)),
    stringsAsFactors = FALSE
  )

  cat("\n", "Model Comparison Dashboard\n")
  cat("===============================================\n\n")
  print(comparison, row.names = FALSE)

  # Recommendation
  best_model <- comparison$Model[which.max(comparison$Adj_R2)]
  cat("\n\u2713 Best Model (by Adjusted R^2):", best_model, "\n")

  invisible(comparison)
}

#' Extract Model Insights
#'
#' Provide English-language interpretation of model results.
#'
#' @param model A fitted lm object
#'
#' @return Character vector with interpretations
#'
#' @export
#'
#' @examples
#' \dontrun{
#' model <- fit_linear_model(mtcars, "mpg ~ wt")
#' model_insights(model)
#' }
model_insights <- function(model) {
  if (!inherits(model, "lm")) {
    stop("Input must be a fitted lm object")
  }

  summary_obj <- summary(model)
  coef_table <- summary_obj$coefficients

  insights <- c()

  # Overall model
  insights <- c(insights, paste(
    "This model explains", round(summary_obj$r.squared * 100, 1),
    "% of the variation in", deparse(formula(model)[[2]])
  ))

  # Coefficient interpretation
  for (i in 2:nrow(coef_table)) {
    var_name <- rownames(coef_table)[i]
    coef <- coef_table[i, 1]
    p_val <- coef_table[i, 4]

    if (p_val < 0.05) {
      direction <- if (coef > 0) "increases" else "decreases"
      insights <- c(insights, paste(
        "For each unit increase in", var_name, ",",
        deparse(formula(model)[[2]]), direction, "by", round(abs(coef), 4),
        "(p < 0.05)"
      ))
    }
  }

  cat("\n\u2713 Key Insights\n")
  cat("===============================================\n\n")
  for (i in seq_along(insights)) {
    cat(i, ".", insights[i], "\n")
  }

  invisible(insights)
}
