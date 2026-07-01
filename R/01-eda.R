#' Exploratory Data Analysis Functions
#'
#' Functions for initial data exploration, visualization, and summarization.

#' Exploratory Analysis of a Numeric Variable
#'
#' Generate visual and numerical summaries of a single numeric variable
#' including histogram, boxplot, Q-Q plot, and summary statistics.
#'
#' @param data A data frame
#' @param var Character name of numeric variable to analyze
#' @param title Optional title for plots (defaults to variable name)
#' @param quiet Logical; if `TRUE` (default), suppress printed output and only
#'   return results invisibly.
#'
#' @return Invisibly returns a list with plots and summaries; prints summaries
#'
#' @importFrom ggplot2 ggplot aes geom_histogram geom_boxplot stat_qq stat_qq_line theme_minimal labs vars
#' @importFrom gridExtra grid.arrange
#' @importFrom dplyr pull
#'
#' @export
#'
#' @examples
#' \dontrun{
#' eda_numeric(mtcars, "mpg")
#' }
eda_numeric <- function(data, var, title = NULL, quiet = TRUE) {
  validate_data(data, var)

  x <- data |> dplyr::pull(var)

  if (!is.numeric(x)) {
    stop(paste(var, "is not numeric"))
  }

  if (is.null(title)) title <- var

  # Summary statistics (print only when not quiet)
  if (!quiet) {
    cat("\n", title, "- Summary Statistics\n")
    cat("===============================================\n")
    print(summary(x))
    cat("SD:", round(sd(x, na.rm = TRUE), 4), "\n")
    cat("CV:", round(sd(x, na.rm = TRUE) / mean(x, na.rm = TRUE), 4), "\n")
    cat("Range:", round(min(x, na.rm = TRUE), 4), "-", round(max(x, na.rm = TRUE), 4), "\n")
    cat("Missing:", sum(is.na(x)), "\n\n")
  }

  # Plots
  p_hist <- ggplot(data, aes(x = !!rlang::sym(var))) +
    geom_histogram(bins = 30, fill = "steelblue", alpha = 0.7, color = "white") +
    theme_minimal() +
    labs(title = paste("Histogram -", title), x = var, y = "Frequency")

  p_box <- ggplot(data, aes(y = !!rlang::sym(var))) +
    geom_boxplot(fill = "steelblue", alpha = 0.7) +
    theme_minimal() +
    labs(title = paste("Boxplot -", title), y = var)

  p_qq <- ggplot(data, aes(sample = !!rlang::sym(var))) +
    stat_qq(color = "steelblue") +
    stat_qq_line(color = "red") +
    theme_minimal() +
    labs(title = paste("Q-Q Plot -", title))

  combined <- gridExtra::grid.arrange(p_hist, p_box, p_qq, ncol = 1)
  if (!quiet) print(combined)

  invisible(list(
    summary = summary(x),
    plots = list(histogram = p_hist, boxplot = p_box, qq = p_qq)
  ))
}

#' Exploratory Analysis by Group
#'
#' Compare a numeric variable across groups using boxplots and Q-Q plots.
#'
#' @param data A data frame
#' @param var Character name of numeric variable
#' @param group Character name of grouping variable
#' @param quiet Logical; if `TRUE` (default), suppress printed console output.
#'
#' @return Invisibly returns plots; prints group summary table
#'
#' @importFrom dplyr group_by summarise across
#' @importFrom tidyselect all_of
#'
#' @export
#'
#' @examples
#' \dontrun{
#' eda_by_group(mtcars, "mpg", "cyl")
#' }
eda_by_group <- function(data, var, group, quiet = TRUE) {
  validate_data(data, c(var, group))

  # Summary by group
  summary_tbl <- data |>
    dplyr::group_by(!!rlang::sym(group)) |>
    dplyr::summarise(
      n = dplyr::n(),
      mean = mean(!!rlang::sym(var), na.rm = TRUE),
      median = median(!!rlang::sym(var), na.rm = TRUE),
      sd = sd(!!rlang::sym(var), na.rm = TRUE),
      min = min(!!rlang::sym(var), na.rm = TRUE),
      max = max(!!rlang::sym(var), na.rm = TRUE),
      .groups = "drop"
    )
  if (!quiet) cat("\n", var, "by", group, "\n")
  if (!quiet) cat("===============================================\n")
  if (!quiet) print(summary_tbl)

  # Boxplot
  p_box <- ggplot(data, aes(x = factor(!!rlang::sym(group)), y = !!rlang::sym(var), fill = factor(!!rlang::sym(group)))) +
    geom_boxplot(alpha = 0.7, show.legend = FALSE) +
    theme_minimal() +
    labs(title = paste(var, "by", group), x = group, y = var)

  # Q-Q by group
  p_qq <- ggplot(data, aes(sample = !!rlang::sym(var), color = factor(!!rlang::sym(group)))) +
    stat_qq() +
    stat_qq_line() +
    facet_wrap(vars(!!rlang::sym(group))) +
    theme_minimal() +
    labs(title = paste("Q-Q Plot of", var, "by", group))

  combined <- gridExtra::grid.arrange(p_box, p_qq, ncol = 1)
  if (interactive()) print(combined)

  invisible(list(
    summary = summary_tbl,
    plots = list(boxplot = p_box, qq = p_qq)
  ))
}

#' Summarize Data by Groups
#'
#' Create group-wise summary statistics for one or more numeric variables.
#'
#' @param data A data frame
#' @param numeric_vars Character vector of numeric variable names
#' @param group_vars Character vector of grouping variable names
#'
#' @return Data frame with group-wise summaries (n, mean, sd, median)
#'
#' @export
#'
#' @examples
#' \dontrun{
#' summarize_by_group(mtcars, c("mpg", "hp"), "cyl")
#' }
summarize_by_group <- function(data, numeric_vars, group_vars) {
  validate_data(data, c(numeric_vars, group_vars))

  data |>
    dplyr::group_by(dplyr::across(all_of(group_vars))) |>
    dplyr::summarise(
      dplyr::across(all_of(numeric_vars),
        list(
          n = \(x) sum(!is.na(x)),
          mean = \(x) mean(x, na.rm = TRUE),
          sd = \(x) sd(x, na.rm = TRUE),
          median = \(x) median(x, na.rm = TRUE)
        ),
        .names = "{.col}_{.fn}"
      ),
      .groups = "drop"
    )
}

#' Correlation Analysis
#'
#' Compute and visualize correlations between numeric variables.
#'
#' @param data A data frame
#' @param method "pearson" or "spearman"
#'
#' @return Invisibly returns correlation matrix; prints and plots
#'
#' @importFrom GGally ggpairs
#'
#' @export
#'
#' @examples
#' \dontrun{
#' correlation_analysis(mtcars)
#' }
correlation_analysis <- function(data, method = "pearson") {
  numeric_data <- data[, sapply(data, is.numeric)]

  if (ncol(numeric_data) < 2) {
    stop("Need at least 2 numeric variables for correlation analysis")
  }

  corr_matrix <- cor(numeric_data, use = "complete.obs", method = method)

  cat("\nCorrelation Matrix (", method, " correlations)\n")
  cat("===============================================\n")
  print(round(corr_matrix, 3))

  # Visualization
  p <- GGally::ggpairs(numeric_data) +
    theme_minimal() +
    labs(title = paste("Pairwise Correlations -", method))

  print(p)

  invisible(corr_matrix)
}
