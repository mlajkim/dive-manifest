.PHONY: setup help

setup:
	@chmod +x hack/setup-local-k8s-cluster.sh
	@./hack/setup-local-k8s-cluster.sh
	@chmod +x hack/setup-local-athenz-server.sh
	@./hack/setup-local-athenz-server.sh

help:
	@echo "Available targets:"
	@echo "  make setup - Setup local k8s and athenz server"
	@echo "  make help - Show this help message"
