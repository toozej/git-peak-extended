# Set sane defaults for Make
SHELL = bash
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

# Set default goal such that `make` runs `make help`
.DEFAULT_GOAL := help

# List of all test Dockerfiles
DOCKERFILES := $(wildcard tests/dockerfiles/Dockerfile*)
# List of Docker image tags based on name of Dockerfiles
IMAGES := $(DOCKERFILES:tests/dockerfiles/Dockerfile_%=%)

build_tests_%:
	@echo -e "\nBuilding test image $*"
	docker build -f $(CURDIR)/tests/dockerfiles/Dockerfile_$* -t toozej/git-peak-extended-tests:$* .

run_tests_%:
	@echo -e "\nRunning test image $*"
	docker run --rm --name $* -v $(CURDIR):/git-peak-extended toozej/git-peak-extended-tests:$* sh -c "bash /git-peak-extended/tests/run_tests.sh"


.PHONY: all install pre-reqs test pre-commit pre-commit-install pre-commit-run help

all: pre-reqs test pre-commit

install: ## Install git-peak-extended
	sudo cp git-peak-extended /usr/local/bin/git-peak-extended
	sudo chmod 0755 /usr/local/bin/git-peak-extended

pre-reqs: ## Install pre-requisites required to use git-peak-extended
	command -v apt && sudo apt-get update -qq
	for item in bash git jq curl coreutils myrepos; do \
		command -v $${item} || sudo dnf install -y $${item} || sudo apt install -y $${item}; \
	done

test: $(addprefix build_tests_,$(IMAGES)) $(addprefix run_tests_,$(IMAGES)) ## Run tests

pre-commit: pre-commit-install pre-commit-run ## Install and run pre-commit hooks

pre-commit-install: ## Install pre-commit hooks and necessary binaries
	# pre-commit
	command -v pre-commit || sudo dnf install -y pre-commit || sudo apt install -y pre-commit
	# shellcheck
	command -v shellcheck || sudo dnf install -y ShellCheck || sudo apt install -y shellcheck
	# install and update pre-commits
	pre-commit install
	pre-commit autoupdate

pre-commit-run: ## Run pre-commit hooks against all files
	pre-commit run --all-files

help: ## Display help text
	@grep -E '^[a-zA-Z_-]+ ?:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
