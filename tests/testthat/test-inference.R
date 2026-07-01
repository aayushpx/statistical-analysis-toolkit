test_that("perform_anova returns an aov object", {
  result <- perform_anova(mtcars, "mpg", "cyl")
  expect_s3_class(result, "aov")
})

test_that("tukey_post_hoc returns a data frame of comparisons", {
  anova_result <- perform_anova(mtcars, "mpg", "cyl")
  result <- tukey_post_hoc(anova_result)
  expect_s3_class(result, "data.frame")
  expect_true("p adj" %in% names(result))
})

test_that("tukey_post_hoc errors on non-aov input", {
  expect_error(tukey_post_hoc(lm(mpg ~ cyl, mtcars)), "ANOVA object")
})

test_that("kruskal_wallis_test returns an htest object", {
  result <- kruskal_wallis_test(mtcars, "mpg", "cyl")
  expect_s3_class(result, "htest")
})

test_that("chi_squared_test works with a contingency table", {
  tab <- table(mtcars$am, mtcars$cyl)
  result <- chi_squared_test(tab)
  expect_s3_class(result, "htest")
})

test_that("chi_squared_test works with data frame + variable names", {
  result <- chi_squared_test(mtcars, "am", "cyl")
  expect_s3_class(result, "htest")
})

test_that("chi_squared_test errors when var1/var2 missing for data frame", {
  expect_error(chi_squared_test(mtcars), "var1 and var2")
})

test_that("compare_models returns an anova table", {
  m1 <- fit_linear_model(mtcars, "mpg ~ wt")
  m2 <- fit_linear_model(mtcars, "mpg ~ wt + hp")
  result <- compare_models(m1, m2)
  expect_s3_class(result, "anova")
})

test_that("t_test_comprehensive one-sample returns htest invisibly", {
  result <- t_test_comprehensive(mtcars, x = "mpg", mu = 20)
  expect_s3_class(result, "htest")
})

test_that("t_test_comprehensive two-sample returns htest", {
  mtcars_split <- mtcars
  result <- t_test_comprehensive(mtcars_split, x = "mpg", y = "hp")
  expect_s3_class(result, "htest")
})
