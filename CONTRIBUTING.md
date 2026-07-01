# Contributing Guide

Thank you for interest in contributing! Here's how to help.

## Development Setup

1. **Fork the repository** on GitHub
2. **Clone locally**:
   ```bash
   git clone https://github.com/yourusername/statistical-analysis-toolkit.git
   cd statistical-analysis-toolkit
   ```

3. **Install dependencies**:
   ```r
   devtools::install_dev_deps()
   ```

4. **Load the package**:
   ```r
   devtools::load_all()
   ```

## Making Changes

### Adding a New Function

1. **Create in appropriate R file**:
   - EDA functions → `R/01-eda.R`
   - Assumption checks → `R/02-assumptions.R`
   - Tests → `R/03-inference.R`
   - etc.

2. **Write roxygen documentation**:
   ```r
   #' Function Title
   #'
   #' Description of what the function does.
   #'
   #' @param param1 Description of param1
   #' @param param2 Description of param2
   #'
   #' @return What the function returns
   #'
   #' @export
   #'
   #' @examples
   #' \dontrun{
   #' your_function(mtcars, "mpg")
   #' }
   your_function <- function(param1, param2) {
     # Your code here
   }
   ```

3. **Add tests** in `tests/testthat/`:
   ```r
   test_that("your_function works correctly", {
     expect_equal(your_function(x), expected_result)
   })
   ```

4. **Generate documentation**:
   ```r
   devtools::document()  # Creates .Rd files
   ```

### Improving Existing Code

1. **Make changes** to the R file
2. **Update tests** if behavior changes
3. **Regenerate docs**: `devtools::document()`
4. **Test locally**: `devtools::test()`

## Quality Standards

### Code Style
- Use `snake_case` for functions and variables
- Use `CamelCase` for classes (rarely needed)
- Max line length: 80 characters
- Indent with 2 spaces

### Documentation
- Every exported function needs roxygen documentation
- Include examples in `@examples` section
- Keep examples short and runnable

### Testing
- Write unit tests for new functions
- Run `devtools::test()` before committing
- Aim for >80% code coverage

### Error Handling
```r
# Good error messages
if (!is.numeric(x)) {
  stop("x must be numeric, not ", class(x)[1])
}

# Use informative names
if (nrow(data) < 2) {
  stop("Need at least 2 rows of data")
}
```

## Before Submitting a PR

```r
# 1. Run all checks
devtools::check()

# 2. Run tests
devtools::test()

# 3. Check code style
lintr::lint_package()

# 4. Generate docs
devtools::document()

# 5. Build locally
devtools::build()
```

## Submitting a Pull Request

1. **Push to your fork**: `git push origin your-branch-name`
2. **Create PR on GitHub** with:
   - Clear title summarizing changes
   - Description of what and why
   - Reference to any related issues
3. **Respond to feedback** from maintainers
4. **Celebrate** when merged! 🎉

## Code Review Process

All PRs will be reviewed for:
- ✓ Functionality (does it work?)
- ✓ Quality (is it well-written?)
- ✓ Testing (are tests included?)
- ✓ Documentation (is it clear?)
- ✓ Compatibility (does it break existing code?)

---

**Questions?** Open an issue or email us!

Thank you for contributing! 💪
