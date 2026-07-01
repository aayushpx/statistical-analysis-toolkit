test_that("eda_numeric returns invisibly with valid numeric column", {
  result <- eda_numeric(mtcars, "mpg")
  expect_type(result, "list")
  expect_named(result, c("summary", "plots"))
})

test_that("eda_numeric fails on a non-numeric column", {
  df <- data.frame(x = c("a", "b", "c"), stringsAsFactors = FALSE)
  expect_error(eda_numeric(df, "x"), "not numeric")
})

test_that("eda_numeric fails when variable is missing from data", {
  expect_error(eda_numeric(mtcars, "nonexistent"), "Missing variables")
})

test_that("eda_by_group returns invisibly with summary and plots", {
  result <- eda_by_group(mtcars, "mpg", "cyl")
  expect_type(result, "list")
  expect_named(result, c("summary", "plots"))
})

test_that("summarize_by_group returns a data frame with correct structure", {
  result <- summarize_by_group(mtcars, c("mpg", "hp"), "cyl")
  expect_s3_class(result, "data.frame")
  expect_true("cyl" %in% names(result))
})

test_that("count_missing identifies no missing data in mtcars", {
  result <- count_missing(mtcars)
  expect_true(all(result$missing_count == 0))
})

test_that("count_missing counts NAs correctly", {
  df <- data.frame(x = c(1, NA, 3), y = c(NA, NA, 1))
  result <- count_missing(df)
  expect_equal(result$missing_count[result$variable == "x"], 1)
  expect_equal(result$missing_count[result$variable == "y"], 2)
})

test_that("handle_outliers flags extreme values", {
  x <- c(1, 2, 3, 4, 5, 100)
  result <- handle_outliers(x, method = "flag")
  expect_true(result$is_outlier[6])
  expect_false(result$is_outlier[1])
})

test_that("handle_outliers removes outliers when method is 'remove'", {
  x <- c(1, 2, 3, 4, 5, 100)
  result <- handle_outliers(x, method = "remove")
  expect_false(100 %in% result)
})

test_that("handle_outliers errors on non-numeric input", {
  expect_error(handle_outliers(c("a", "b")), "numeric")
})

test_that("correlation_analysis returns a matrix invisibly", {
  result <- correlation_analysis(mtcars[, c("mpg", "wt", "hp")])
  expect_true(is.matrix(result))
  expect_equal(dim(result), c(3L, 3L))
})
