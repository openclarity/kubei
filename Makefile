####
## Make settings
####

SHELL = /usr/bin/env bash -o pipefail
.SHELLFLAGS = -ec
.DEFAULT_GOAL := help

####
## Project variables
####

VERSION ?= $(shell git rev-parse --short HEAD)
DOCKER_REGISTRY ?= ghcr.io/openclarity
DOCKER_PUSH ?= false
DOCKER_TAG ?= $(VERSION)
VMCLARITY_TOOLS_BASE ?=
GO_VERSION ?= $(shell cat $(ROOT_DIR)/.go-version)
GO_BUILD_TAGS ?=

# Ignore unused C drivers for CIS Docker Benchmark libraries
GO_BUILD_TAGS += exclude_graphdriver_btrfs exclude_graphdriver_devicemapper

####
## Runtime variables
####

ROOT_DIR := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
BIN_DIR := $(ROOT_DIR)/bin
GOMODULES := $(shell find $(ROOT_DIR) -name 'go.mod' -exec dirname {} \;)
BUILD_TIMESTAMP := $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")
COMMIT_HASH := $(shell git rev-parse HEAD)
INSTALLATION_DIR := $(ROOT_DIR)/installation
HELM_CHART_DIR := $(INSTALLATION_DIR)/kubernetes/helm/openclarity
HELM_OCI_REPOSITORY := ghcr.io/openclarity/charts
DIST_DIR ?= $(ROOT_DIR)/dist
BICEP_DIR := $(INSTALLATION_DIR)/azure
CFN_DIR := $(INSTALLATION_DIR)/aws
DOCKER_COMPOSE_DIR := $(INSTALLATION_DIR)/docker
GCP_DM_DIR := $(INSTALLATION_DIR)/gcp/dm
API_DIR := $(ROOT_DIR)/api
UI_DIR := $(ROOT_DIR)/ui

####
## Load additional makefiles
####

include makefile.d/*.mk

$(BIN_DIR):
	@mkdir -p $(BIN_DIR)

$(DIST_DIR):
	@mkdir -p $(DIST_DIR)

##@ General

.PHONY: help
help: ## Display this help
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_0-9-]+:.*?##/ { printf "  \033[36m%-30s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

##@ Development

.PHONY: build
build: ui build-all-go ## Build all components

.PHONY: build-all-go
build-all-go: bin/openclarity-api-server bin/openclarity-cli bin/openclarity-orchestrator bin/openclarity-ui-backend bin/openclarity-cr-discovery-server ## Build all go components

BUILD_OPTS = -race
ifneq ($(strip $(GO_BUILD_TAGS)),)
	BUILD_OPTS += -tags=$(call subst-space-with-comma,$(GO_BUILD_TAGS))
endif

LDFLAGS = -s -w
LDFLAGS += -X 'github.com/openclarity/openclarity/core/version.Version=$(VERSION)'
LDFLAGS += -X 'github.com/openclarity/openclarity/core/version.CommitHash=$(COMMIT_HASH)'
LDFLAGS += -X 'github.com/openclarity/openclarity/core/version.BuildTimestamp=$(BUILD_TIMESTAMP)'

bin/openclarity-orchestrator: $(shell find api provider orchestrator utils core) | $(BIN_DIR)
	go -C $(ROOT_DIR)/orchestrator build $(BUILD_OPTS) -ldflags="$(LDFLAGS)" -o $(ROOT_DIR)/$@ cmd/main.go

bin/openclarity-api-server: $(shell find api api/server) | $(BIN_DIR)
	go -C $(ROOT_DIR)/api/server build $(BUILD_OPTS) -ldflags="$(LDFLAGS)" -o $(ROOT_DIR)/$@ cmd/main.go

bin/openclarity-cli: $(shell find api cli utils core) | $(BIN_DIR)
	go -C $(ROOT_DIR)/cli build $(BUILD_OPTS) -ldflags="$(LDFLAGS)" -o $(ROOT_DIR)/$@ cmd/main.go

bin/openclarity-ui-backend: $(shell find api uibackend/server)  | $(BIN_DIR)
	go -C $(ROOT_DIR)/uibackend/server build $(BUILD_OPTS) -ldflags="$(LDFLAGS)" -o $(ROOT_DIR)/$@ cmd/main.go

bin/openclarity-cr-discovery-server: $(shell find api containerruntimediscovery/server utils core) | $(BIN_DIR)
	go -C $(ROOT_DIR)/containerruntimediscovery/server build $(BUILD_OPTS) -ldflags="$(LDFLAGS)" -o $(ROOT_DIR)/$@ cmd/main.go

.PHONY: clean
clean: clean-ui clean-go clean-vendor ## Clean all build artifacts

.PHONY: clean-go
clean-go: ## Clean all Go build artifacts
	@rm -rf bin/openclarity*
	$(info GO executables cleanup done)

.PHONY: clean-ui
clean-ui: ## Clean UI build
	@rm -rf ui/build
	$(info UI cleanup done)

.PHONY: clean-vendor
clean-vendor: ## Clean go vendor directories
	$(info Clean go vendor directories)
	@find $(ROOT_DIR) -name 'vendor' -type d -exec rm -rf {} \;

.PHONY: $(LINTGOMODULES)
TIDYGOMODULES = $(addprefix tidy-, $(GOMODULES))

$(TIDYGOMODULES):
	go -C $(@:tidy-%=%) mod tidy -go=$(GO_VERSION)

.PHONY: gomod-tidy
gomod-tidy: $(TIDYGOMODULES) ## Run go mod tidy for all go modules

.PHONY: $(MODLISTGOMODULES)
MODLISTGOMODULES = $(addprefix modlist-, $(GOMODULES))

$(MODLISTGOMODULES):
	go -C $(@:modlist-%=%) list -m -mod=readonly all 1> /dev/null

.PHONY: gomod-list
gomod-list: $(MODLISTGOMODULES)

.PHONY: ui
ui: ## Build UI component
	$(info Building UI ...)
	@(cd ui && npm i && npm run build)
	@ls -l ui/build

.PHONY: ui-dev
ui-dev: ui-install ui-start ## Create UI development environment

.PHONY: ui-install
ui-install: ## Install UI dependencies
	$(info Installing UI dependencies ...)
	@(cd ui && npm install)

.PHONY: ui-start
ui-start: ## Start UI development server
	$(info Starting UI development server ...)
	@(cd ui && npm start)

##@ Testing

.PHONY: check
check: vet lint test ## Run tests and linters

LINTGOMODULES = $(addprefix lint-, $(GOMODULES))
FIXGOMODULES = $(addprefix fix-, $(GOMODULES))

.PHONY: $(LINTGOMODULES)
$(LINTGOMODULES):
	cd $(@:lint-%=%) && "$(GOLANGCI_BIN)" run --build-tags "$(GO_BUILD_TAGS)" -c "$(GOLANGCI_CONFIG)"

.PHONY: $(FIXGOMODULES)
$(FIXGOMODULES):
	cd $(@:fix-%=%) && "$(GOLANGCI_BIN)" run -c "$(GOLANGCI_CONFIG)" --fix

.PHONY: fix
fix: bin/golangci-lint $(FIXGOMODULES) ## Fix linter errors in Go source code

E2E_TARGETS =
E2E_ENV =

# Check if the CI environment is set to false to run the e2e tests with local images
ifeq ($(CI),false)
	E2E_TARGETS += docker
	E2E_ENV += OPENCLARITY_E2E_APISERVER_IMAGE=$(DOCKER_REGISTRY)/openclarity-api-server:$(DOCKER_TAG)
	E2E_ENV += OPENCLARITY_E2E_ORCHESTRATOR_IMAGE=$(DOCKER_REGISTRY)/openclarity-orchestrator:$(DOCKER_TAG)
	E2E_ENV += OPENCLARITY_E2E_UI_IMAGE=$(DOCKER_REGISTRY)/openclarity-ui:$(DOCKER_TAG)
	E2E_ENV += OPENCLARITY_E2E_UIBACKEND_IMAGE=$(DOCKER_REGISTRY)/openclarity-ui-backend:$(DOCKER_TAG)
	E2E_ENV += OPENCLARITY_E2E_SCANNER_IMAGE=$(DOCKER_REGISTRY)/openclarity-cli:$(DOCKER_TAG)
	E2E_ENV += OPENCLARITY_E2E_CR_DISCOVERY_SERVER_IMAGE=$(DOCKER_REGISTRY)/openclarity-cr-discovery-server:$(DOCKER_TAG)
	E2E_ENV += OPENCLARITY_E2E_PLUGIN_KICS_IMAGE=$(DOCKER_REGISTRY)/openclarity-plugin-kics:$(DOCKER_TAG)
endif

.PHONY: e2e
e2e: e2e-docker e2e-k8s ## Run end-to-end test suite

E2E_COMMAND = go -C $(ROOT_DIR)/e2e test -v -failfast -test.v -test.paniconexit0 -ginkgo.timeout 2h -timeout 2h -ginkgo.v .

.PHONY: e2e-docker
e2e-docker: $(E2E_TARGETS) ## Run end-to-end test suite on Docker
	$(E2E_ENV) $(E2E_COMMAND)

E2E_ENV_K8S = $(E2E_ENV)
E2E_ENV_K8S += OPENCLARITY_E2E_PLATFORM=kubernetes
E2E_ENV_K8S += OPENCLARITY_E2E_ENV_NAME=testenv-k8s

.PHONY: e2e-k8s
e2e-k8s: $(E2E_TARGETS) ## Run end-to-end test suite on Kubernetes
	$(E2E_ENV_K8S) $(E2E_COMMAND)

# Run cloud end-to-end test suite with latest images in the registry, otherwise push images to registry is required
E2E_ENV =

E2E_ENV_AWS = $(E2E_ENV)
E2E_ENV_AWS += OPENCLARITY_E2E_PLATFORM=aws
E2E_ENV_AWS += OPENCLARITY_E2E_ENV_NAME=testenv-aws
E2E_ENV_AWS += OPENCLARITY_E2E_AWS_REGION=eu-central-1

.PHONY: e2e-aws
e2e-aws: ## Run end-to-end test suite on AWS
	$(E2E_ENV_AWS) $(E2E_COMMAND)

E2E_ENV_AZURE = $(E2E_ENV)
E2E_ENV_AZURE += OPENCLARITY_E2E_PLATFORM=azure
E2E_ENV_AZURE += OPENCLARITY_E2E_ENV_NAME=testenv-azure

.PHONY: e2e-azure
e2e-azure: ## Run end-to-end test suite on Azure
	$(E2E_ENV_AZURE) $(E2E_COMMAND)

E2E_ENV_GCP = $(E2E_ENV)
E2E_ENV_GCP += OPENCLARITY_E2E_PLATFORM=gcp
E2E_ENV_GCP += OPENCLARITY_E2E_ENV_NAME=testenv-gcp

.PHONY: e2e-gcp
e2e-gcp: ## Run end-to-end test suite on GCP
	$(E2E_ENV_GCP) $(E2E_COMMAND)

.PHONY: format
format: format-ui ## Format all source code

.PHONY: format-ui
format-ui: ## Format UI source code
	@(cd ui && npm run prettier:format)

.PHONY: format-ui-check
format-ui-check: ## Format UI source code
	@(cd ui && npm run prettier:check)

VENDORMODULES = $(addprefix vendor-, $(GOMODULES))

$(VENDORMODULES):
	go -C $(@:vendor-%=%) mod vendor

.PHONY: gomod-vendor
gomod-vendor: $(VENDORMODULES) # Make vendored copy of dependencies for all modules

LICENSECHECKMODULES = $(addprefix license-check-, $(GOMODULES))

$(LICENSECHECKMODULES):
	cd $(@:license-check-%=%) && "$(LICENSEI_BIN)" check --config "$(LICENSEI_CONFIG)"

.PHONY: license-check
license-check: bin/licensei $(LICENSECHECKMODULES) ## Check licenses for software components

LICENSECACHEMODULES = $(addprefix license-cache-, $(GOMODULES))

$(LICENSECACHEMODULES):
	cd $(@:license-cache-%=%) && "$(LICENSEI_BIN)" cache --config "$(LICENSEI_CONFIG)"

.PHONY: license-cache
license-cache: bin/licensei $(LICENSECACHEMODULES) ## Generate license cache

.PHONY: lint
lint: license-check lint-actions lint-bicep lint-cfn lint-js lint-go lint-helm ## Run all the linters

.PHONY: lint-actions
lint-actions: bin/actionlint ## Lint Github Actions
	@$(ACTIONLINT_BIN) -color

.PHONY: lint-bicep
lint-bicep: bin/bicep ## Lint Azure Bicep template(s)
	@$(BICEP_BIN) lint installation/azure/openclarity.bicep

.PHONY: lint-cfn
lint-cfn: bin/cfn-lint ## Lint AWS CloudFormation template
	$(CFNLINT_BIN) installation/aws/OpenClarity.cfn

.PHONY: lint-js
lint-js: ## Lint Javascript source code
	@(cd ui && npm run lint)

.PHONY: lint-go
lint-go: bin/golangci-lint $(LINTGOMODULES) ## Lint Go source code

.PHONY: lint-helm
lint-helm: ## Lint Helm charts
	docker run --rm --workdir /workdir --volume "$(ROOT_DIR):/workdir" quay.io/helmpack/chart-testing:v3.8.0 ct lint --all

.PHONY: test
test: test-js test-go ## Run all tests

.PHONY: test-js
test-js: ## Run Javascript unit tests
	@(cd ui && npm test)

GOTEST_OPTS := -failfast -timeout 30m -short
GOTEST_OPTS += $(BUILD_OPTS)
ifeq ($(CI),true)
	GOTEST_OPTS += -v
endif

TESTGOMODULES = $(addprefix test-, $(GOMODULES))

$(TESTGOMODULES):
	go -C $(@:test-%=%) test $(GOTEST_OPTS) ./...

.PHONY: test-go
test-go: $(TESTGOMODULES) ## Run Go unit tests

GOVET_OPTS := $(BUILD_OPTS)
VETGOMODULES = $(addprefix vet-, $(GOMODULES))

$(VETGOMODULES):
	go -C $(@:vet-%=%) vet $(GOVET_OPTS) ./...

.PHONY: vet
vet: $(VETGOMODULES) ## Run go vet for modules

##@ Docker

# Export params required in Docker Bake
BAKE_ENV = DOCKER_REGISTRY=$(DOCKER_REGISTRY)
BAKE_ENV += DOCKER_TAG=$(DOCKER_TAG)
BAKE_ENV += VERSION=$(VERSION)
BAKE_ENV += BUILD_TIMESTAMP=$(BUILD_TIMESTAMP)
BAKE_ENV += COMMIT_HASH=$(COMMIT_HASH)
BAKE_ENV += BUILD_OPTS="$(BUILD_OPTS)"

BAKE_OPTS =
ifneq ($(strip $(VMCLARITY_TOOLS_BASE)),)
	BAKE_OPTS += --set openclarity-cli.args.VMCLARITY_TOOLS_BASE=$(VMCLARITY_TOOLS_BASE)
endif

ifeq ($(DOCKER_PUSH),true)
	BAKE_OPTS += --set *.output=type=registry
	BAKE_OPTS += --set *.platform=linux/amd64,linux/arm64
endif

.PHONY: docker
# TODO(paralta) Check TODO for BAKE_ENV_ORCHESTRATOR
# docker: ## Build All Docker images
# 	$(info Building all docker images ...)
# 	$(BAKE_ENV) docker buildx bake $(BAKE_OPTS)
docker: docker-api-server docker-cli docker-orchestrator docker-ui docker-ui-backend docker-cr-discovery-server docker-scanner-plugins ## Build all Docker images

.PHONY: docker-api-server
docker-api-server: ## Build API Server container image
	$(info Building api-server docker image ...)
	$(BAKE_ENV) docker buildx bake $(BAKE_OPTS) openclarity-api-server

.PHONY: docker-cli
docker-cli: ## Build CLI container image
	$(info Building cli docker image ...)
	$(BAKE_ENV) docker buildx bake $(BAKE_OPTS) openclarity-cli

# TODO(paralta) Temporary workaround to remove race flag from orchestrator build
# since build fails in arm64 after #1587
BAKE_ENV_ORCHESTRATOR = $(subst -race,, $(BAKE_ENV))

.PHONY: docker-orchestrator
docker-orchestrator: ## Build Orchestrator container image
	$(info Building orchestrator docker image ...)
	$(BAKE_ENV_ORCHESTRATOR) docker buildx bake $(BAKE_OPTS) openclarity-orchestrator

.PHONY: docker-ui
docker-ui: ## Build UI container image
	$(info Building ui docker image ...)
	$(BAKE_ENV) docker buildx bake $(BAKE_OPTS) openclarity-ui

.PHONY: docker-ui-backend
docker-ui-backend: ## Build UI Backend container image
	$(info Building ui-backend docker image ...)
	$(BAKE_ENV) docker buildx bake $(BAKE_OPTS) openclarity-ui-backend

.PHONY: docker-cr-discovery-server
docker-cr-discovery-server: ## Build K8S Image Resolver Docker image
	$(info Building cr-discovery-server docker image ...)
	$(BAKE_ENV) docker buildx bake $(BAKE_OPTS) openclarity-cr-discovery-server

.PHONY: docker-scanner-plugins
docker-scanner-plugins: ## Build scanner plugin container images
	$(info Building scanner plugin docker images ...)
	$(BAKE_ENV) docker buildx bake $(BAKE_OPTS) openclarity-scanner-plugins

##@ Code generation

.PHONY: gen
gen: gen-api-js gen-api-go gen-bicep gen-helm-docs ## Generating all code, manifests, docs

.PHONY: gen-api-js
gen-api-js: ## Generating Javascript library for API specification
	$(info Generating API for UI code ...)
	@(cd ui && npm run generate-api)

.PHONY: gen-api-go
gen-api-go: gen-apiserver-api gen-uibackend-api gen-plugin-sdk ## Generating Go API code

.PHONY: gen-apiserver-api
gen-apiserver-api: ## Generating Go library for API specification
	$(info Generating API for backend code ...)
	go -C $(ROOT_DIR)/api/types generate
	go -C $(ROOT_DIR)/api/client generate
	go -C $(ROOT_DIR)/api/server generate

.PHONY: gen-uibackend-api
gen-uibackend-api: ## Generating Go library for UI Backend API specification
	$(info Generating API for UI backend code ...)
	go -C $(ROOT_DIR)/uibackend/types generate
	go -C $(ROOT_DIR)/uibackend/client generate
	go -C $(ROOT_DIR)/uibackend/server generate

.PHONY: gen-plugin-sdk
gen-plugin-sdk: gen-plugin-sdk-go gen-plugin-sdk-python ## Generating Scanner Plugin SDK code

.PHONY: gen-plugin-sdk-go
gen-plugin-sdk-go: ## Generating Scanner Plugin SDK code for Golang
	$(info Generating Scanner Plugin SDK code for Golang ...)
	go -C $(ROOT_DIR)/plugins/sdk-go generate
	go -C $(ROOT_DIR)/plugins/runner generate

.PHONY: gen-plugin-sdk-python
gen-plugin-sdk-python: ## Generating Scanner Plugin SDK code for Python
	$(info Generating Scanner Plugin SDK code for Python ...)
	sh ./plugins/sdk-python/tools/gen-sdk.sh

.PHONY: gen-bicep
gen-bicep: bin/bicep ## Generating Azure Bicep template(s)
	$(info Generating Azure Bicep template(s) ...)
	$(BICEP_BIN) build installation/azure/openclarity.bicep

.PHONY: gen-helm-docs
gen-helm-docs: bin/helm-docs ## Generating documentation for Helm chart
	$(info Generating Helm chart(s) documentation ...)
	$(HELMDOCS_BIN) --chart-search-root $(HELM_CHART_DIR)

##@ Release

.DELETE_ON_ERROR:

.PHONY: clean-dist
clean-dist:
	rm -rf $(DIST_DIR)/*

.PHONY: dist-all
dist-all: dist-bicep dist-cloudformation dist-docker-compose dist-gcp-deployment dist-helm-chart dist-openclarity-cli

CLI_OSARCH := $(shell echo {linux-,darwin-}{amd64,arm64})
CLI_BINARIES := $(CLI_OSARCH:%=$(DIST_DIR)/%/openclarity-cli)
CLI_TARS := $(CLI_OSARCH:%=$(DIST_DIR)/openclarity-cli-$(VERSION)-%.tar.gz)
CLI_TAR_SHA256SUMS := $(CLI_TARS:%=%.sha256sum)

.PHONY: dist-openclarity-cli
dist-openclarity-cli: $(CLI_BINARIES) $(CLI_TARS) $(CLI_TAR_SHA256SUMS) | $(DIST_DIR) ## Create openclarity-cli release artifacts

$(DIST_DIR)/openclarity-cli-$(VERSION)-%.tar.gz: $(DIST_DIR)/%/openclarity-cli $(DIST_DIR)/%/LICENSE $(DIST_DIR)/%/README.md
	$(info --- Bundling $(dir $<) into $(notdir $@))
	tar cv -f $@ -C $(dir $<) --use-compress-program='gzip -9' $(notdir $^)

$(DIST_DIR)/%/openclarity-cli: $(shell find api cli utils core)
	$(info --- Building $(notdir $@) for $*)
	GOOS=$(firstword $(subst -, ,$*)) \
	GOARCH=$(lastword $(subst -, ,$*)) \
	CGO_ENABLED=0 \
	go -C $(ROOT_DIR)/cli build -ldflags="$(LDFLAGS)" -o $@ cmd/main.go

$(DIST_DIR)/%/LICENSE: $(ROOT_DIR)/LICENSE
	cp -v $< $@

$(DIST_DIR)/%/README.md: $(ROOT_DIR)/README.md
	cp -v $< $@

CFN_FILES := $(shell find $(CFN_DIR))
CFN_DIST_DIR := $(DIST_DIR)/cloudformation

.PHONY: dist-cloudformation
dist-cloudformation: $(DIST_DIR)/aws-cloudformation-$(VERSION).tar.gz $(DIST_DIR)/aws-cloudformation-$(VERSION).tar.gz.sha256sum ## Create AWS CloudFormation release artifacts

$(DIST_DIR)/aws-cloudformation-$(VERSION).tar.gz: $(DIST_DIR)/aws-cloudformation-$(VERSION).bundle $(CFN_DIST_DIR)/LICENSE | $(CFN_DIST_DIR)
	$(info --- Bundle $(CFN_DIST_DIR) into $(notdir $@))
	tar cv -f $@ -C $(CFN_DIST_DIR) --use-compress-program='gzip -9' $(shell ls $(CFN_DIST_DIR))

$(DIST_DIR)/aws-cloudformation-$(VERSION).bundle: $(CFN_FILES) | $(CFN_DIST_DIR)
	$(info --- Generate Cloudformation bundle)
	cp -vR $(CFN_DIR)/* $(CFN_DIST_DIR)/
	sed -i -E 's@(ghcr\.io\/openclarity\/openclarity\-(api-server|cli|orchestrator|ui-backend|ui)):latest@\1:$(VERSION)@' $(CFN_DIST_DIR)/OpenClarity.cfn
	@touch $@

$(CFN_DIST_DIR)/LICENSE: $(ROOT_DIR)/LICENSE | $(CFN_DIST_DIR)
	$(info --- Copy $(notdir $@) to $@)
	cp -v $< $@

$(CFN_DIST_DIR):
	@mkdir -p $@

BICEP_FILES := $(shell find $(BICEP_DIR))
BICEP_DIST_DIR := $(DIST_DIR)/bicep

.PHONY: dist-bicep
dist-bicep: $(DIST_DIR)/azure-bicep-$(VERSION).tar.gz $(DIST_DIR)/azure-bicep-$(VERSION).tar.gz.sha256sum ## Create Azure Bicep release artifacts

$(DIST_DIR)/azure-bicep-$(VERSION).tar.gz: $(DIST_DIR)/azure-bicep-$(VERSION).bundle $(BICEP_DIST_DIR)/LICENSE | $(BICEP_DIST_DIR)
	$(info --- Bundle $(BICEP_DIST_DIR) into $(notdir $@))
	tar cv -f $@ -C $(BICEP_DIST_DIR) --use-compress-program='gzip -9' $(shell ls $(BICEP_DIST_DIR))

$(DIST_DIR)/azure-bicep-$(VERSION).bundle: $(BICEP_FILES) bin/bicep | $(BICEP_DIST_DIR)
	$(info --- Generate Bicep bundle)
	cp -vR $(BICEP_DIR)/* $(BICEP_DIST_DIR)/
	sed -i -E 's@(ghcr\.io\/openclarity\/openclarity\-(api-server|cli|orchestrator|ui-backend|ui)):latest@\1:$(VERSION)@' \
		$(BICEP_DIST_DIR)/*.bicep $(BICEP_DIST_DIR)/openclarity-UI.json
	$(BICEP_BIN) build $(BICEP_DIST_DIR)/openclarity.bicep
	@touch $@

$(BICEP_DIST_DIR)/LICENSE: $(ROOT_DIR)/LICENSE | $(BICEP_DIST_DIR)
	cp -v $< $@

$(BICEP_DIST_DIR):
	@mkdir -p $@

DOCKER_COMPOSE_FILES := $(shell find $(DOCKER_COMPOSE_DIR))
DOCKER_COMPOSE_DIST_DIR := $(DIST_DIR)/docker-compose

.PHONY: dist-docker-compose
dist-docker-compose: $(DIST_DIR)/docker-compose-$(VERSION).tar.gz $(DIST_DIR)/docker-compose-$(VERSION).tar.gz.sha256sum ## Create Docker Compose release artifacts

$(DIST_DIR)/docker-compose-$(VERSION).tar.gz: $(DIST_DIR)/docker-compose-$(VERSION).bundle $(DOCKER_COMPOSE_DIST_DIR)/LICENSE | $(DOCKER_COMPOSE_DIST_DIR)
	$(info --- Bundle $(DOCKER_COMPOSE_DIST_DIR) into $(notdir $@))
	tar cv -f $@ -C $(DOCKER_COMPOSE_DIST_DIR) --use-compress-program='gzip -9' $(shell ls $(DOCKER_COMPOSE_DIST_DIR))

$(DIST_DIR)/docker-compose-$(VERSION).bundle: $(DOCKER_COMPOSE_FILES) | $(DOCKER_COMPOSE_DIST_DIR)
	$(info --- Generate Docker Compose bundle)
	cp -vR $(DOCKER_COMPOSE_DIR)/* $(DOCKER_COMPOSE_DIST_DIR)/
	sed -i -E 's@(ghcr\.io\/openclarity\/openclarity\-(api-server|cli|orchestrator|ui-backend|ui)):latest@\1:$(VERSION)@' \
		$(DOCKER_COMPOSE_DIST_DIR)/*.yml $(DOCKER_COMPOSE_DIST_DIR)/*.yaml $(DOCKER_COMPOSE_DIST_DIR)/*.env
	@touch $@

$(DOCKER_COMPOSE_DIST_DIR)/LICENSE: $(ROOT_DIR)/LICENSE | $(DOCKER_COMPOSE_DIST_DIR)
	$(info --- Copy $(notdir $@) to $@)
	cp -v $< $@

$(DOCKER_COMPOSE_DIST_DIR):
	@mkdir -p $@

GCP_DM_FILES := $(shell find $(GCP_DM_DIR))
GCP_DM_DIST_DIR := $(DIST_DIR)/gcp-deployment

.PHONY: dist-gcp-deployment
dist-gcp-deployment: $(DIST_DIR)/gcp-deployment-$(VERSION).tar.gz $(DIST_DIR)/gcp-deployment-$(VERSION).tar.gz.sha256sum ## Create Google Cloud Deployment bundle

$(DIST_DIR)/gcp-deployment-$(VERSION).tar.gz: $(DIST_DIR)/gcp-deployment-$(VERSION).bundle $(GCP_DM_DIST_DIR)/LICENSE | $(GCP_DM_DIST_DIR)
	$(info --- Bundle $(GCP_DM_DIST_DIR) into $(notdir $@))
	tar cv -f $@ -C $(GCP_DM_DIST_DIR) --use-compress-program='gzip -9' $(shell ls $(GCP_DM_DIST_DIR))

$(DIST_DIR)/gcp-deployment-$(VERSION).bundle: $(GCP_DM_FILES) | $(GCP_DM_DIST_DIR)
	$(info --- Generate Google Cloud Deployment bundle)
	cp -vR $(GCP_DM_DIR)/* $(GCP_DM_DIST_DIR)/
	sed -i -E 's@(ghcr\.io\/openclarity\/openclarity\-(api-server|cli|orchestrator|ui-backend|ui)):latest@\1:$(VERSION)@' \
		$(GCP_DM_DIST_DIR)/openclarity.py.schema $(GCP_DM_DIST_DIR)/components/openclarity-server.py.schema
	@touch $@

$(GCP_DM_DIST_DIR)/LICENSE: $(ROOT_DIR)/LICENSE | $(GCP_DM_DIST_DIR)
	cp -v $< $@

$(GCP_DM_DIST_DIR):
	@mkdir -p $@

HELM_CHART_FILES := $(shell find $(HELM_CHART_DIR))
HELM_CHART_DIST_DIR := $(DIST_DIR)/helm-openclarity-chart

.PHONY: dist-helm-chart
dist-helm-chart: $(DIST_DIR)/openclarity-$(VERSION:v%=%).tgz $(DIST_DIR)/openclarity-$(VERSION:v%=%).tgz.sha256sum ## Create Helm Chart bundle

$(DIST_DIR)/openclarity-$(VERSION:v%=%).tgz: $(DIST_DIR)/helm-openclarity-chart-$(VERSION:v%=%).bundle bin/helm | $(HELM_CHART_DIST_DIR)
	$(info --- Bundle $(HELM_CHART_DIST_DIR) into $(notdir $@))
	$(HELM_BIN) package $(HELM_CHART_DIST_DIR) --version "$(VERSION:v%=%)" --app-version "$(VERSION)" --destination $(DIST_DIR)

$(DIST_DIR)/helm-openclarity-chart-$(VERSION:v%=%).bundle: $(HELM_CHART_FILES) bin/yq bin/helm-docs | $(HELM_CHART_DIST_DIR)
	$(info --- Generate Helm Chart bundle)
	cp -vR $(HELM_CHART_DIR)/* $(HELM_CHART_DIST_DIR)/
	$(YQ_BIN) -i '.apiserver.image.tag = "$(VERSION)" | .orchestrator.image.tag = "$(VERSION)" | .orchestrator.scannerImage.tag = "$(VERSION)" | .ui.image.tag = "$(VERSION)" | .uibackend.image.tag = "$(VERSION)"' \
	$(HELM_CHART_DIST_DIR)/values.yaml
	$(YQ_BIN) -i '.version = "$(VERSION:v%=%)" | .appVersion = "$(VERSION)"' $(HELM_CHART_DIST_DIR)/Chart.yaml
	$(HELMDOCS_BIN) --chart-search-root $(HELM_CHART_DIST_DIR)
	@touch $@

$(HELM_CHART_DIST_DIR):
	@mkdir -p $@

.PHONY: publish-helm-chart
publish-helm-chart: $(DIST_DIR)/openclarity-$(VERSION:v%=%).tgz bin/helm ## Publish Helm Chart bundle to OCI registry
	$(HELM_BIN) push $< oci://$(HELM_OCI_REPOSITORY)

$(DIST_DIR)/%.sha256sum: | $(DIST_DIR)
	$(info --- Generate SHA256 for $(notdir $@))
	shasum -a 256 $(basename $@) | sed "s@$(dir $@)@@" > $@

.PHONY: generate-release-notes
generate-release-notes: $(DIST_DIR)/CHANGELOG.md ## Generate Release Notes

GITCLIFF_OPTS := --strip all
ifeq ($(CI),true)
	GITCLIFF_OPTS += -vv --latest --tag $(VERSION)
else
	GITCLIFF_OPTS += --unreleased --bump
endif

$(DIST_DIR)/CHANGELOG.md: $(ROOT_DIR)/cliff.toml bin/git-cliff | $(DIST_DIR)
	$(GITCLIFF_BIN) --config $(ROOT_DIR)/cliff.toml --output $@ $(GITCLIFF_OPTS)

.PHONY: multimod-verify
multimod-verify: bin/multimod
	$(info --- Validating versions.yaml file)
	$(MULTIMOD_BIN) verify

.PHONY: multimod-prerelease
multimod-prerelease: bin/multimod
	$(MULTIMOD_BIN) prerelease --all-module-sets --skip-go-mod-tidy=true --commit-to-different-branch=false


##@ Dependencies

.PHONY: dep-tidy
dep-tidy: gomod-tidy gen ## Fix affected code after dependency updates

# Self-hosted Renovate
# https://docs.renovatebot.com/self-hosted-configuration/
#
# NOTE(ramizpolic): The renovate.json contains config for Renovate service.
# We enrich the base renovate config with self-hosted options to enable
# additional features such as running post-dependency upgrade tasks.

RENOVATE_OPTS ?=

# Set to local platform when running default makefile target to avoid updating remote
# project data. CI/CD pipeline runs set proper platform using ENV vars to enable
# syncing dependency updates through issues and PRs.
RENOVATE_OPTS += --platform $(or $(shell echo $$RENOVATE_PLATFORM),"local")

# Enable running post-upgrade tasks
RENOVATE_OPTS += --persist-repo-data 'true'
RENOVATE_OPTS += --allowed-post-upgrade-commands '[".*"]'
RENOVATE_OPTS += --post-upgrade-tasks '{"commands": ["make dep-tidy"], "executionMode": "branch"}'

.PHONY: renovate ## Run Renovate locally to view available dependency updates
renovate: bin/renovate
	$(RENOVATE_BIN) $(RENOVATE_OPTS)
