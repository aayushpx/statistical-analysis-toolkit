test_that("check_normality returns a list with shapiro_wilk entry", {
  result <- check_normality(rnorm(100))
  expect_type(result, "list")
  expect_true("shapiro_wilk" %in% names(result))
  expect_true("kolmogorov_smirnov" %in% names(result))
})

test_that("check_normality has correct structure in shapiro_wilk entry", {
  result <- check_normality(rnorm(50))
  expect_named(result$shapiro_wilk, c("statistic", "p_value", "normal"))
})

test_that("check_normality fails with fewer than 3 non-missing values", {
  expect_error(check_normality(c(1, 2)), "at least 3")
})

test_that("check_normality ignores NA values", {
  x <- c(rnorm(50), NA, NA)
  expect_no_error(check_normality(x))
})

test_that("validate_data rejects non-data-frame input", {
  expect_error(validate_data(c(1, 2, 3)))
})

test_that("validate_data accepts valid data frame", {
  expect_true(validate_data(mtcars))
})

test_that("validate_data errors when specified variables are missing", {
  expect_error(validate_data(mtcars, "nonexistent_col"), "Missing variables")
})

test_that("transform_power applies log transformation when lambda = 0", {
  x <- c(1, 2, 3, 4, 5)
  expect_equal(transform_power(x, lambda = 0), log(x))
})

test_that("transform_power applies sqrt when lambda = 0.5", {
  x <- c(1, 4, 9)
  expect_equal(transform_power(x, lambda = 0.5), sqrt(x))
})

test_that("check_heteroscedasticity works with data frame + group", {
  result <- check_heteroscedasticity(mtcars, response = "mpg", group = "cyl")
  expect_type(result, "list")
  expect_true("homoscedastic" %in% names(result))
})

test_that("check_multicollinearity returns data frame for multi-predictor model", {
  model <- lm(mpg ~ wt + hp + cyl, data = mtcars)
  result <- check_multicollinearity(model)
  expect_s3_class(result, "data.frame")
  expect_true("VIF" %in% names(result))
})

test_that("check_multicollinearity errors on non-lm input", {
  expect_error(check_multicollinearity(list(a = 1)), "linear model")
})

test_that("validate_assumptions handles single-predictor model gracefully", {
  model <- lm(mpg ~ wt, data = mtcars)
  expect_no_error(validate_assumptions(model))
})
