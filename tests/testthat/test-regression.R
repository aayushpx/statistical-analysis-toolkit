test_that("fit_linear_model returns an lm object", {
  model <- fit_linear_model(mtcars, "mpg ~ wt")
  expect_s3_class(model, "lm")
})

test_that("fit_linear_model errors if formula is not a string", {
  expect_error(fit_linear_model(mtcars, mpg ~ wt), "character string")
})

test_that("fit_polynomial_model returns an lm object", {
  model <- fit_polynomial_model(mtcars, "mpg", "wt", degree = 2)
  expect_s3_class(model, "lm")
})

test_that("fit_interaction_model returns an lm object", {
  model <- fit_interaction_model(mtcars, "mpg ~ wt * hp")
  expect_s3_class(model, "lm")
})

test_that("model_summary returns a summary.lm object", {
  model <- fit_linear_model(mtcars, "mpg ~ wt")
  result <- model_summary(model)
  expect_s3_class(result, "summary.lm")
})

test_that("model_summary errors on non-lm input", {
  expect_error(model_summary(list()), "linear model")
})

test_that("residual_analysis returns a list with residuals and outliers", {
  model <- fit_linear_model(mtcars, "mpg ~ wt")
  result <- residual_analysis(model)
  expect_type(result, "list")
  expect_named(result, c("residuals", "outliers"))
  expect_equal(length(result$residuals), nrow(mtcars))
})

test_that("create_prediction_intervals returns a data frame with fit/lwr/upr", {
  model <- fit_linear_model(mtcars, "mpg ~ wt")
  newdata <- data.frame(wt = c(2, 3, 4))
  result <- create_prediction_intervals(model, newdata)
  expect_s3_class(result, "data.frame")
  expect_equal(nrow(result), 3)
  expect_true(all(c("fit", "lwr", "upr") %in% names(result)))
})

test_that("create_prediction_intervals respects confidence level", {
  model <- fit_linear_model(mtcars, "mpg ~ wt")
  newdata <- data.frame(wt = c(3))
  r90 <- create_prediction_intervals(model, newdata, level = 0.90)
  r99 <- create_prediction_intervals(model, newdata, level = 0.99)
  # wider interval at higher confidence
  expect_lt(r90$upr - r90$lwr, r99$upr - r99$lwr)
})

test_that("model_dashboard compares multiple models correctly", {
  m1 <- fit_linear_model(mtcars, "mpg ~ wt")
  m2 <- fit_linear_model(mtcars, "mpg ~ wt + hp")
  result <- model_dashboard(list(Simple = m1, Full = m2))
  expect_s3_class(result, "data.frame")
  expect_equal(nrow(result), 2)
  expect_true("Adj_R2" %in% names(result))
})

test_that("identify_outliers returns a logical vector", {
  result <- identify_outliers(mtcars, "mpg")
  expect_type(result, "logical")
  expect_equal(length(result), nrow(mtcars))
})

test_that("transform_data returns a tibble", {
  result <- transform_data(mtcars)
  expect_s3_class(result, "tbl_df")
})
