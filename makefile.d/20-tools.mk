####
## Licensei CLI
####

LICENSEI_BIN := $(BIN_DIR)/licensei
LICENSEI_CONFIG := $(ROOT_DIR)/.licensei.toml
# renovate: datasource=go depName=github.com/goph/licensei versioning=semver
LICENSEI_VERSION = 0.9.0

bin/licensei: bin/licensei-$(LICENSEI_VERSION)
	@ln -sf licensei-$(LICENSEI_VERSION) bin/licensei

bin/licensei-$(LICENSEI_VERSION): | $(BIN_DIR)
	curl -sfL https://raw.githubusercontent.com/goph/licensei/master/install.sh | bash -s v$(LICENSEI_VERSION)
	@mv bin/licensei $@

####
## ActionLint CLI
####

ACTIONLINT_BIN := $(BIN_DIR)/actionlint
# renovate: datasource=go depName=github.com/rhysd/actionlint versioning=semver
ACTIONLINT_VERSION := 1.7.7

bin/actionlint: bin/actionlint-$(ACTIONLINT_VERSION)
	@ln -sf actionlint-$(ACTIONLINT_VERSION) bin/actionlint

bin/actionlint-$(ACTIONLINT_VERSION): | $(BIN_DIR)
	curl -sSfL https://raw.githubusercontent.com/rhysd/actionlint/main/scripts/download-actionlint.bash \
	| bash -s -- "$(ACTIONLINT_VERSION)" "$(BIN_DIR)"
	@mv bin/actionlint $@

####
##  Azure CLI
####

AZURECLI_BIN := $(BIN_DIR)/az
# renovate: datasource=pypi depName=azure-cli versioning=semver
AZURECLI_VERSION := 2.55.0
AZURECLI_VENV := $(AZURECLI_BIN)-$(AZURECLI_VERSION)

bin/az: $(AZURECLI_VENV)/bin/az
	@ln -sf $(AZURECLI_VENV)/bin/az bin/az

$(AZURECLI_VENV)/bin/az: | $(BIN_DIR)
	@python3 -m venv $(AZURECLI_VENV)
	@$(AZURECLI_VENV)/bin/python3 -m pip install --upgrade pip
	@$(AZURECLI_VENV)/bin/pip install azure-cli==$(AZURECLI_VERSION)

####
##  Azure Bicep CLI
####

BICEP_BIN := $(BIN_DIR)/bicep
# renovate: datasource=github-releases depName=Azure/bicep versioning=semver
BICEP_VERSION := 0.33.93
BICEP_OSTYPE := $(OSTYPE)
BICEP_ARCH := $(ARCHTYPE)

# Set OSTYPE for macos to "osx"
ifeq ($(BICEP_OSTYPE),darwin)
	BICEP_OSTYPE = osx
endif
# Reset ARCHTYPE for amd64 to "x64"
ifeq ($(BICEP_ARCH),amd64)
	BICEP_ARCH = x64
endif

bin/bicep: bin/bicep-$(BICEP_VERSION)
	@ln -sf bicep-$(BICEP_VERSION) bin/bicep

bin/bicep-$(BICEP_VERSION): | $(BIN_DIR)
	@if [ -z "${BICEP_OSTYPE}" -o -z "${BICEP_ARCH}" ]; then printf 'ERROR: following variables must no be empty: %s %s\n' '$$BICEP_OSTYPE' '$$BICEP_ARCH'; exit 1; fi
	@curl -sSfL 'https://github.com/Azure/bicep/releases/download/v$(BICEP_VERSION)/bicep-$(BICEP_OSTYPE)-$(BICEP_ARCH)' \
	--output '$(BICEP_BIN)-$(BICEP_VERSION)'
	@chmod +x '$(BICEP_BIN)-$(BICEP_VERSION)'

####
##  CloudFormation Linter CLI
####

CFNLINT_BIN := $(BIN_DIR)/cfn-lint
# renovate: datasource=pypi depName=cfn-lint versioning=semver
CFNLINT_VERSION := 0.83.4
CFNLINT_VENV := $(CFNLINT_BIN)-$(CFNLINT_VERSION)

bin/cfn-lint: $(CFNLINT_VENV)/bin/cfn-lint
	@ln -sf $(CFNLINT_VENV)/bin/cfn-lint bin/cfn-lint

$(CFNLINT_VENV)/bin/cfn-lint: | $(BIN_DIR)
	@python3 -m venv $(CFNLINT_VENV)
	@$(CFNLINT_VENV)/bin/python3 -m pip install --upgrade pip
	@$(CFNLINT_VENV)/bin/pip install cfn-lint==$(CFNLINT_VERSION)

####
##  Golangci-lint CLI
####

GOLANGCI_BIN := $(BIN_DIR)/golangci-lint
GOLANGCI_CONFIG := $(ROOT_DIR)/.golangci.yml
# renovate: datasource=go depName=github.com/golangci/golangci-lint versioning=semver
GOLANGCI_VERSION := 1.64.5

bin/golangci-lint: bin/golangci-lint-$(GOLANGCI_VERSION)
	@ln -sf golangci-lint-$(GOLANGCI_VERSION) bin/golangci-lint

bin/golangci-lint-$(GOLANGCI_VERSION): | $(BIN_DIR)
	curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | bash -s -- -b "$(BIN_DIR)" "v$(GOLANGCI_VERSION)"
	@mv bin/golangci-lint $@

####
##  yq CLI
####

YQ_BIN := $(BIN_DIR)/yq
# renovate: datasource=github-releases depName=mikefarah/yq versioning=semver
YQ_VERSION := 4.45.1

bin/yq: bin/yq-$(YQ_VERSION)
	@ln -sf $(notdir $<) $@

bin/yq-$(YQ_VERSION): | $(BIN_DIR)
	@curl -sSfL 'https://github.com/mikefarah/yq/releases/download/v$(YQ_VERSION)/yq_$(OSTYPE)_$(ARCHTYPE)' \
	--output $@
	@chmod +x $@

####
##  Helm CLI
####

HELM_BIN := $(BIN_DIR)/helm
# renovate: datasource=github-releases depName=helm/helm versioning=semver
HELM_VERSION := 3.17.1

bin/helm: bin/helm-$(HELM_VERSION)
	@ln -sf $(notdir $<) $@

bin/helm-$(HELM_VERSION): | $(BIN_DIR)
	@curl -sSfL 'https://get.helm.sh/helm-v$(HELM_VERSION)-$(OSTYPE)-$(ARCHTYPE).tar.gz' --output - \
	| tar xzvOf - '$(OSTYPE)-$(ARCHTYPE)/helm' > $@
	@chmod +x $@

####
##  helm-docs CLI
####

HELMDOCS_BIN := $(BIN_DIR)/helm-docs
# renovate: datasource=github-releases depName=norwoodj/helm-docs versioning=semver
HELMDOCS_VERSION := 1.14.2
HELMDOCS_OSTYPE := $(OSTYPE)
HELMDOCS_ARCH := $(ARCHTYPE)

ifeq ($(HELMDOCS_OSTYPE),darwin)
	HELMDOCS_OSTYPE = Darwin
endif
ifeq ($(HELMDOCS_OSTYPE),linux)
	HELMDOCS_OSTYPE = Linux
endif
ifeq ($(HELMDOCS_ARCH),amd64)
	HELMDOCS_ARCH = x86_64
endif

bin/helm-docs: bin/helm-docs-$(HELMDOCS_VERSION)
	@ln -sf $(notdir $<) $@

bin/helm-docs-$(HELMDOCS_VERSION): | $(BIN_DIR)
	@curl -sSfL 'https://github.com/norwoodj/helm-docs/releases/download/v$(HELMDOCS_VERSION)/helm-docs_$(HELMDOCS_VERSION)_$(HELMDOCS_OSTYPE)_$(HELMDOCS_ARCH).tar.gz' --output - \
	| tar xzvOf - 'helm-docs' > $@
	@chmod +x $@

####
##  git-cliff CLI
####

GITCLIFF_BIN := $(BIN_DIR)/git-cliff
# renovate: datasource=github-releases depName=orhun/git-cliff versioning=semver
GITCLIFF_VERSION := 2.8.0
GITCLIFF_OSTYPE := $(OSTYPE)
GITCLIFF_ARCH := $(ARCHTYPE)
GITCLIFF_URL =

ifeq ($(GITCLIFF_OSTYPE),darwin)
	GITCLIFF_OSTYPE = apple-darwin
endif
ifeq ($(GITCLIFF_OSTYPE),linux)
	GITCLIFF_OSTYPE = unknown-linux-gnu
endif
ifeq ($(GITCLIFF_ARCH),amd64)
	GITCLIFF_ARCH = x86_64
endif
ifeq ($(GITCLIFF_ARCH),arm64)
	GITCLIFF_ARCH = aarch64
endif

bin/git-cliff: bin/git-cliff-$(GITCLIFF_VERSION)
	@ln -sf $(notdir $<) $@

bin/git-cliff-$(GITCLIFF_VERSION): | $(BIN_DIR)
	@curl -sSfL 'https://github.com/orhun/git-cliff/releases/download/v$(GITCLIFF_VERSION)/git-cliff-$(GITCLIFF_VERSION)-$(GITCLIFF_ARCH)-$(GITCLIFF_OSTYPE).tar.gz' --output - \
	| tar xzvOf - 'git-cliff-$(GITCLIFF_VERSION)/git-cliff' > $@
	@chmod +x $@

####
##  typos CLI
####

TYPOS_BIN := $(BIN_DIR)/typos
# renovate: datasource=github-releases depName=crate-ci/typos versioning=semver
TYPOS_VERSION := 1.29.7
TYPOS_OSTYPE := $(OSTYPE)
TYPOS_ARCH := $(ARCHTYPE)
TYPOS_URL =

ifeq ($(TYPOS_OSTYPE),darwin)
	TYPOS_OSTYPE = apple-darwin
endif
ifeq ($(TYPOS_OSTYPE),linux)
	TYPOS_OSTYPE = unknown-linux-gnu
endif
ifeq ($(TYPOS_ARCH),amd64)
	TYPOS_ARCH = x86_64
endif
ifeq ($(TYPOS_ARCH),arm64)
	TYPOS_ARCH = aarch64
endif

bin/typos: bin/typos-$(TYPOS_VERSION)
	@ln -sf $(notdir $<) $@

bin/typos-$(TYPOS_VERSION): | $(BIN_DIR)
	@curl -sSfL 'https://github.com/crate-ci/typos/releases/download/v$(TYPOS_VERSION)/typos-v$(TYPOS_VERSION)-$(TYPOS_ARCH)-$(TYPOS_OSTYPE).tar.gz' --output - \
	| tar xzvOf - './typos' > $@
	@chmod +x $@

####
##  Go MultiMod Releaser
####

MULTIMOD_VERSION := 0.13.0
MULTIMOD_BIN := $(BIN_DIR)/multimod
MULTIMOD_REPO_DIR := $(BIN_DIR)/opentelemetry-go-build-tools

bin/multimod:
	@if [ ! -d $(MULTIMOD_REPO_DIR) ]; then git clone https://github.com/open-telemetry/opentelemetry-go-build-tools --branch multimod/v$(MULTIMOD_VERSION) $(MULTIMOD_REPO_DIR); fi
	@go build -C $(MULTIMOD_REPO_DIR)/multimod -o $(MULTIMOD_BIN) main.go
	@rm -rf $(MULTIMOD_REPO_DIR)

####
##  Renovate CLI
####

# renovate: datasource=github-releases depName=renovatebot/renovate versioning=semver
RENOVATE_VERSION := 38.55.4
RENOVATE_INSTALL_DIR := $(BIN_DIR)/node
RENOVATE_BIN := $(RENOVATE_INSTALL_DIR)/node_modules/.bin/renovate

bin/renovate:
	@npm install --silent --prefix $(RENOVATE_INSTALL_DIR) renovate@$(RENOVATE_VERSION)
