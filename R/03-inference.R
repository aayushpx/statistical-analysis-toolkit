#' Statistical Inference Functions
#'
#' Hypothesis testing and statistical inference methods.

#' Comprehensive t-test
#'
#' Perform one-sample, two-sample, or paired t-tests with full reporting.
#'
#' @param data A data frame
#' @param x Name of first variable (or only variable for one-sample)
#' @param y Name of second variable (for paired/two-sample tests)
#' @param mu Population mean (for one-sample test, default = 0)
#' @param var_equal Assume equal variances? (default = FALSE, uses Welch's t-test)
#' @param paired Paired test? (default = FALSE)
#'
#' @return List with test results and interpretation
#'
#' @importFrom stats t.test
#'
#' @export
#'
#' @examples
#' \dontrun{
#' t_test_comprehensive(mtcars, x = "mpg", mu = 20)
#' }
t_test_comprehensive <- function(data, x, y = NULL, mu = 0, var_equal = FALSE, paired = FALSE) {
  x_var <- data[[x]]

  if (is.null(y)) {
    # One-sample t-test
    test <- t.test(x_var, mu = mu)
    test_type <- "One-sample t-test"
  } else {
    # Two-sample or paired t-test
    y_var <- data[[y]]
    test <- t.test(x_var, y_var, var.equal = var_equal, paired = paired)
    test_type <- if (paired) "Paired t-test" else "Two-sample t-test"
  }

  cat("\n", test_type, "\n")
  cat("===============================================\n")
  cat("t-statistic:", round(test$statistic, 4), "\n")
  cat("df:", round(test$parameter, 1), "\n")
  cat("p-value:", round(test$p.value, 4), "\n")

  # Report mean or mean difference depending on test type
  if (length(test$estimate) == 1) {
    cat("Sample mean:", round(test$estimate, 4), "\n")
  } else {
    cat("Mean difference:", round(diff(test$estimate), 4), "\n")
  }

  cat("95% CI:", paste0("[", round(test$conf.int[1], 4), ", ", round(test$conf.int[2], 4), "]"), "\n\n")

  if (test$p.value < 0.05) {
    cat("\u2713 Significant difference detected (p < 0.05)\n")
  } else {
    cat("\u2717 No significant difference (p >= 0.05)\n")
  }

  invisible(test)
}

#' Perform ANOVA
#'
#' One-way ANOVA to test for differences across groups.
#'
#' @param data A data frame
#' @param response Name of numeric response variable
#' @param group Name of grouping variable
#'
#' @return ANOVA object and summary
#'
#' @export
#'
#' @examples
#' \dontrun{
#' perform_anova(mtcars, response = "mpg", group = "cyl")
#' }
perform_anova <- function(data, response, group) {
  validate_data(data, c(response, group))

  formula <- as.formula(paste(response, "~", group))
  # ensure grouping variable is a factor for ANOVA/Tukey
  data[[group]] <- as.factor(data[[group]])
  anova_result <- aov(formula, data = data)

  cat("\n", "One-way ANOVA\n")
  cat("===============================================\n")
  cat(response, "by", group, "\n\n")
  print(summary(anova_result))

  # Effect size (eta-squared)
  sum_sq <- summary(anova_result)[[1]]$`Sum Sq`
  eta_sq <- sum_sq[1] / sum(sum_sq)

  cat("\nEffect Size (eta^2):", round(eta_sq, 4), "\n")
  cat("Interpretation: Group explains", round(eta_sq * 100, 2), "% of variance\n")

  invisible(anova_result)
}

#' Tukey Post-Hoc Test
#'
#' Pairwise comparisons following ANOVA using Tukey HSD method.
#'
#' @param anova_result ANOVA object from aov()
#'
#' @return Data frame with pairwise comparisons
#'
#' @importFrom stats TukeyHSD
#'
#' @export
#'
#' @examples
#' \dontrun{
#' anova_result <- perform_anova(mtcars, "mpg", "cyl")
#' tukey_post_hoc(anova_result)
#' }
tukey_post_hoc <- function(anova_result) {
  if (!inherits(anova_result, "aov")) {
    stop("Input must be an ANOVA object from aov()")
  }

  tukey <- TukeyHSD(anova_result)

  cat("\n", "Tukey HSD Post-Hoc Test\n")
  cat("===============================================\n\n")
  print(tukey)

  # Extract comparisons
  comparisons <- as.data.frame(tukey[[1]])
  comparisons$significant <- ifelse(comparisons$`p adj` < 0.05, "\u2713", "\u2717")

  cat("\nSignificant Comparisons (p < 0.05):\n")
  sig_comps <- comparisons[comparisons$`p adj` < 0.05, , drop = FALSE]
  if (nrow(sig_comps) > 0) {
    print(sig_comps[, c("diff", "p adj", "significant")])
  } else {
    cat("None\n")
  }

  invisible(comparisons)
}

#' Kruskal-Wallis Test (Non-parametric ANOVA)
#'
#' Test for differences across groups when normality assumption is violated.
#'
#' @param data A data frame
#' @param response Name of numeric response variable
#' @param group Name of grouping variable
#'
#' @return Kruskal-Wallis test result
#'
#' @importFrom stats kruskal.test
#'
#' @export
#'
#' @examples
#' \dontrun{
#' kruskal_wallis_test(mtcars, response = "mpg", group = "cyl")
#' }
kruskal_wallis_test <- function(data, response, group) {
  validate_data(data, c(response, group))

  formula <- as.formula(paste(response, "~", group))
  kw_test <- kruskal.test(formula, data = data)

  cat("\n", "Kruskal-Wallis Test (Non-parametric)\n")
  cat("===============================================\n")
  cat(response, "by", group, "\n\n")
  print(kw_test)

  if (kw_test$p.value < 0.05) {
    cat("\n\u2713 Significant difference detected (p < 0.05)\n")
  } else {
    cat("\n\u2717 No significant difference (p >= 0.05)\n")
  }

  invisible(kw_test)
}

#' Chi-Squared Test
#'
#' Test independence between two categorical variables.
#'
#' @param data A data frame OR a contingency table (matrix)
#' @param var1 Name of first categorical variable (if data is data frame)
#' @param var2 Name of second categorical variable (if data is data frame)
#'
#' @return Chi-squared test result
#'
#' @importFrom stats chisq.test
#'
#' @export
#'
#' @examples
#' \dontrun{
#' chi_squared_test(mtcars, "am", "cyl")
#' }
chi_squared_test <- function(data, var1 = NULL, var2 = NULL) {
  if (is.matrix(data) || is.table(data)) {
    # Contingency table input
    contingency_table <- data
  } else {
    # Data frame input
    if (is.null(var1) || is.null(var2)) {
      stop("Must provide var1 and var2 for data frame input")
    }
    contingency_table <- table(data[[var1]], data[[var2]])
  }

  chi_test <- chisq.test(contingency_table)

  cat("\n", "Chi-Squared Test of Independence\n")
  cat("===============================================\n\n")
  cat("Contingency Table:\n")
  print(contingency_table)
  cat("\n")
  print(chi_test)

  # Expected frequencies
  cat("\nExpected Frequencies:\n")
  print(round(chi_test$expected, 2))

  if (any(chi_test$expected < 5)) {
    cat("\n(!) Warning: Some expected frequencies < 5\n")
    cat("Chi-squared test may not be reliable\n")
  }

  if (chi_test$p.value < 0.05) {
    cat("\n\u2713 Variables are associated (p < 0.05)\n")
  } else {
    cat("\n\u2717 No evidence of association (p >= 0.05)\n")
  }

  invisible(chi_test)
}

#' Correspondence Analysis (Wrapper)
#'
#' Correspondence Analysis for categorical data relationships.
#'
#' @param data A data frame or contingency table
#' @param var1 First categorical variable (if data frame)
#' @param var2 Second categorical variable (if data frame)
#'
#' @return CA result with interpretation
#'
#' @importFrom FactoMineR CA
#'
#' @export
#'
#' @examples
#' \dontrun{
#' correspondence_analysis_wrapper(mtcars, "am", "cyl")
#' }
correspondence_analysis_wrapper <- function(data, var1 = NULL, var2 = NULL) {
  if (!is.table(data) && !is.matrix(data)) {
    if (is.null(var1) || is.null(var2)) {
      stop("Must provide var1 and var2 for data frame input")
    }
    contingency_table <- table(data[[var1]], data[[var2]])
  } else {
    contingency_table <- data
  }

  ca_result <- FactoMineR::CA(contingency_table, graph = TRUE)

  cat("\n", "Correspondence Analysis\n")
  cat("===============================================\n")
  cat("Dimensions of chi-squared statistic:", ca_result$chi2, "\n")
  cat("p-value:", ifelse(ca_result$chi2 > qchisq(0.95, (nrow(contingency_table) - 1) * (ncol(contingency_table) - 1)), "< 0.05", "> 0.05"), "\n\n")

  print(ca_result)

  invisible(ca_result)
}
