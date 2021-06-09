NECO_CLI_VERSION := $(shell curl -Ls -o /dev/null -w %{url_effective} https://github.com/cybozu-go/neco/releases/latest | grep -Po "\d{4}\.\d{2}\.\d{2}-\d+")
SUDO = sudo
KUSTOMIZE_VERSION := $(shell curl -Ls https://raw.githubusercontent.com/cybozu/neco-containers/main/argocd/Dockerfile | grep -Po "(?<=ENV KUSTOMIZE_VERSION=)\d+\.\d+\.\d+")
KIND_VERSION := 0.11.0
CASE := case1

.PHONY: setup-operation-cli
setup-operation-cli:
	curl -sSLf -o /tmp/neco-operation-cli-linux_$(NECO_CLI_VERSION)_amd64.deb https://github.com/cybozu-go/neco/releases/latest/download/neco-operation-cli-linux_$(NECO_CLI_VERSION)_amd64.deb
	$(SUDO) dpkg -i /tmp/neco-operation-cli-linux_$(NECO_CLI_VERSION)_amd64.deb
	$(SUDO) sh -c 'kubectl completion bash > /etc/bash_completion.d/kubectl'

.PHONY: setup-kustomize
setup-kustomize:
	curl -sSLf https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv${KUSTOMIZE_VERSION}/kustomize_v$(KUSTOMIZE_VERSION)_linux_amd64.tar.gz | $(SUDO) tar zxf - -C /usr/bin

.PHONY: setup
setup: setup-operation-cli
	go install sigs.k8s.io/kind@v$(KIND_VERSION)

.PHONY: start
start:
	scripts/common/setup-and-start-cluster.sh $(CASE)
	scripts/$(CASE)/setup.sh
	scripts/common/apply-case.sh $(CASE)
	@echo "==========\n"
	@cat stories/$(CASE)/story.txt

.PHONY: stop
stop:
	scripts/common/teardown-cluster.sh
