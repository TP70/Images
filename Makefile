.PHONY: clean clean-build clean-pyc lint check-lint test environment
.EXPORT_ALL_VARIABLES:

#################################################################################
# GLOBALS                                                                       #
#################################################################################

PYTHON_VERSION = 3
PYTHON_INTERPRETER = python3

# variables
PROFILE = default
PROJECT_NAME = vehicle-order-api
PROJECT_DIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

ifeq (,$(shell which virtualenv))
HAS_VIRTUALENV=False
else
HAS_VIRTUALENV=True
endif


#################################################################################
# COMMANDS                                                                      #
#################################################################################

## Install Python Dev & Test Dependencies
environment:
ifeq (True,$(HAS_VIRTUALENV))
	@echo ">>> virtualenv available"
else
	@echo "virtualenv not installed yet. Installing ..."
	$(PYTHON_INTERPRETER) -m pip install virtualenv
	@echo ">>> virtualenv installed."
endif
ifeq (,$(wildcard .venv))
	@echo ">>> Creating virtualenv for project..."
	$(PYTHON_INTERPRETER) -m venv .venv
endif
	@echo ">>> Activating environment ..."
	. .venv/bin/activate && $(PYTHON_INTERPRETER) -m pip install -U pip setuptools wheel
	. .venv/bin/activate && $(PYTHON_INTERPRETER) -m pip install -r requirements.txt

## Run unit tests
test:
	$(PYTHON_INTERPRETER) -m pytest tests --ignore tests/integration/

## Run integration tests (requires local db, see the README)
integration-test:
	$(PYTHON_INTERPRETER) -m pytest tests/integration/ --cov=app

## Remove temporary files created during build and all compiled Python files
clean:
	rm -rf build/
	rm -rf dist/
	rm -rf *.egg-info
	find . -type d -name '__pycache__' -exec rm -rf {} +
	find . -type f -name '*.py[co]' -exec rm -f {} +
	find . -name '*~' -exec rm -f {} +

## Runs black formatter
lint:
ifeq (,$(shell which black))
	@echo "black formatter not installed. Make sure you run make environment"
else
	black app tests
endif

## Check code format
check-lint:
ifeq (,$(shell which black))
	@echo "black formatter not installed. Make sure you run make environment"
else
	black --check app tests
endif

#################################################################################
# Self Documenting Commands                                                     #
#################################################################################

.DEFAULT_GOAL := help
# Inspired by <http://marmelab.com/blog/2016/02/29/auto-documented-makefile.html>
# sed script explained:
# /^##/:
# 	* save line in hold space
# 	* purge line
# 	* Loop:
# 		* append newline + line to hold space
# 		* go to next line
# 		* if line starts with doc comment, strip comment character off and loop
# 	* remove target prerequisites
# 	* append hold space (+ newline) to line
# 	* replace newline plus comments by `---`
# 	* print line
# Separate expressions are necessary because labels cannot be delimited by
# semicolon; see <http://stackoverflow.com/a/11799865/1968>
.PHONY: help
help:
	@echo "$$(tput bold)Available rules:$$(tput sgr0)"
	@echo
	@sed -n -e "/^## / { \
		h; \
		s/.*//; \
		:doc" \
		-e "H; \
		n; \
		s/^## //; \
		t doc" \
		-e "s/:.*//; \
		G; \
		s/\\n## /---/; \
		s/\\n/ /g; \
		p; \
	}" ${MAKEFILE_LIST} \
	| LC_ALL='C' sort --ignore-case \
	| awk -F '---' \
		-v ncol=$$(tput cols) \
		-v indent=19 \
		-v col_on="$$(tput setaf 6)" \
		-v col_off="$$(tput sgr0)" \
	'{ \
		printf "%s%*s%s ", col_on, -indent, $$1, col_off; \
		n = split($$2, words, " "); \
		line_length = ncol - indent; \
		for (i = 1; i <= n; i++) { \
			line_length -= length(words[i]) + 1; \
			if (line_length <= 0) { \
				line_length = ncol - indent - length(words[i]) - 1; \
				printf "\n%*s ", -indent, " "; \
			} \
			printf "%s ", words[i]; \
		} \
		printf "\n"; \
	}' \
	| more $(shell test $(shell uname) = Darwin && echo '--no-init --raw-control-chars')

