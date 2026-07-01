.PHONY: help install build check test lint docs vignettes clean

help:
	@echo "Statistical Analysis Toolkit - Build Commands"
	@echo "=============================================="
	@echo ""
	@echo "Available targets:"
	@echo "  make install     - Install the package"
	@echo "  make build       - Build the package"
	@echo "  make check       - Run R CMD check"
	@echo "  make test        - Run unit tests"
	@echo "  make lint        - Check code style"
	@echo "  make docs        - Generate documentation with roxygen2"
	@echo "  make vignettes   - Build vignettes"
	@echo "  make clean       - Remove generated files"
	@echo ""

install:
	Rscript -e "devtools::install()"

build:
	Rscript -e "devtools::load_all()"

check:
	Rscript -e "devtools::check()"

test:
	Rscript -e "devtools::test()"

lint:
	Rscript -e "lintr::lint_package()"

docs:
	Rscript -e "roxygen2::roxygenise()"

vignettes:
	Rscript -e "devtools::build_vignettes()"

clean:
	rm -rf man/*.Rd
	rm -rf *.tar.gz
	rm -rf *.Rcheck
	rm -rf docs/
	Rscript -e "devtools::clean_source()"

all: docs test check

.DEFAULT_GOAL := help
