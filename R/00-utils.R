#' Utility Functions for Statistical Analysis
#'
#' Internal helper functions and utility wrappers for common operations.
#'


#' Safe Data Type Conversion
#'
#' Convert a column to a specified type with error handling.
#'
#' @param x A vector
#' @param type Character: "numeric", "factor", "character", "logical"
#'
#' @return Converted vector
#'
#' @keywords internal
safe_convert <- function(x, type = "numeric") {
  tryCatch(
    {
      switch(type,
        numeric = as.numeric(x),
        factor = factor(x),
        character = as.character(x),
        logical = as.logical(x),
        x
      )
    },
    warning = function(w) {
      warning(paste("Conversion to", type, "produced warnings:", w$message))
      x
    },
    error = function(e) {
      stop(paste("Cannot convert to", type, ":", e$message))
    }
  )
}

#' Validate Data Input
#'
#' Check that data meets basic requirements for analysis.
#'
#' @param data A data frame
#' @param vars Character vector of variable names to check
#'
#' @return Invisible TRUE or error message
#'
#' @keywords internal
validate_data <- function(data, vars = NULL) {
  if (!is.data.frame(data)) {
    stop("Input must be a data frame")
  }

  if (nrow(data) < 2) {
    stop("Data must have at least 2 rows")
  }

  if (!is.null(vars)) {
    missing_vars <- setdiff(vars, names(data))
    if (length(missing_vars) > 0) {
      stop(paste("Missing variables:", paste(missing_vars, collapse = ", ")))
    }
  }

  invisible(TRUE)
}

#' Count Missing Values
#'
#' Generate a summary of missing data
#'
#' @param data A data frame
#'
#' @return Data frame with variable names, counts, and percentages
#'
#' @export
count_missing <- function(data) {
  missing_summary <- data.frame(
    variable = names(data),
    missing_count = colSums(is.na(data)),
    missing_pct = round(100 * colSums(is.na(data)) / nrow(data), 2),
    row.names = NULL
  )

  missing_summary <- missing_summary[order(-missing_summary$missing_count), ]

  if (all(missing_summary$missing_count == 0)) {
    message("\u2713 No missing values detected")
  }

  return(missing_summary)
}

#' Remove or Flag Outliers
#'
#' Identify outliers using IQR method (Q1 - 1.5*IQR, Q3 + 1.5*IQR)
#'
#' @param x A numeric vector
#' @param method "remove" or "flag"
#'
#' @return Vector (if method="remove") or data frame with outlier flags
#'
#' @export
handle_outliers <- function(x, method = "flag") {
  if (!is.numeric(x)) {
    stop("Input must be numeric")
  }

  Q1 <- quantile(x, 0.25, na.rm = TRUE)
  Q3 <- quantile(x, 0.75, na.rm = TRUE)
  IQR <- Q3 - Q1

  lower_bound <- Q1 - 1.5 * IQR
  upper_bound <- Q3 + 1.5 * IQR

  outlier_flags <- (x < lower_bound | x > upper_bound) & !is.na(x)

  if (method == "remove") {
    return(x[!outlier_flags])
  } else if (method == "flag") {
    return(data.frame(
      value = x,
      is_outlier = outlier_flags,
      bound_lower = lower_bound,
      bound_upper = upper_bound,
      row.names = NULL
    ))
  }
}

#' Apply Power Transformations
#'
#' Transform a variable using Box-Cox family or common alternatives
#'
#' @param x A numeric vector (must be > 0)
#' @param lambda Power to apply; common values: -1 (reciprocal), -0.5, 0 (log), 0.5 (sqrt), 1 (none)
#'
#' @return Transformed vector
#'
#' @export
transform_power <- function(x, lambda = 0) {
  if (any(x <= 0, na.rm = TRUE)) {
    warning("Values <= 0 found. Consider shifting data or using different transformation.")
  }

  if (lambda == 0) {
    return(log(x))
  } else {
    return(x^lambda)
  }
}

#' Create a Summary Report
#'
#' Generate a human-readable summary of analysis results
#'
#' @param object Statistical object (lm, aov, etc.)
#'
#' @return Character vector with formatted summary
#'
#' @export
pretty_summary <- function(object) {
  UseMethod("pretty_summary")
}

#' @export
pretty_summary.lm <- function(object) {
  coef_table <- coef(summary(object))
  r2 <- summary(object)$r.squared
  adj_r2 <- summary(object)$adj.r.squared

  output <- c(
    "Linear Model Summary",
    "====================",
    paste("R^2 =", round(r2, 4)),
    paste("Adjusted R^2 =", round(adj_r2, 4)),
    "",
    "Coefficients:",
    capture.output(print(coef_table))
  )

  return(output)
}
