#' Small compatibility stubs for missing exported utilities
#'
#' These provide minimal implementations so documentation and tests
#' that expect `identify_outliers` and `transform_data` to be exported
#' will succeed. Replace with fuller implementations as needed.
#'
#' @param data A data frame
#' @param var Character variable name
#' @return Logical vector indicating outliers
#' @export
identify_outliers <- function(data, var) {
  if (!is.data.frame(data)) stop("data must be a data.frame")
  if (!var %in% names(data)) stop("variable not found in data")
  x <- data[[var]]
  if (!is.numeric(x)) stop("variable must be numeric")
  # simple 3-sigma rule
  flags <- abs(x - mean(x, na.rm = TRUE)) > 3 * sd(x, na.rm = TRUE)
  return(flags)
}

#' Transform data (light-weight wrapper)
#'
#' @param data A data frame
#' @param ... Additional arguments passed to dplyr::mutate (optional)
#' @return A tibble-like data frame
#'
#' @importFrom tibble as_tibble
#'
#' @export
transform_data <- function(data, ...) {
  if (!is.data.frame(data)) stop("data must be a data.frame")
  tibble::as_tibble(data)
}
