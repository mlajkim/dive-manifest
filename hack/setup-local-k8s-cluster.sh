#!/bin/bash
set -e

# shellcheck disable=SC1091
source "$(dirname "$0")/functions.sh"

app::log::startofscript "🚀 Local K8s Cluster Setup Wizard"

echo -e "🔍 Checking Prerequisites..."

if [[ "$(uname)" != "Darwin" ]]; then
  app::log::errexit_with_log "Unsupported OS. Only macOS is supported."
fi



# Check brew installed:
if ! command -v brew &> /dev/null; then
  app::log::warning "'brew' is not installed. Installing..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# 1. Check Docker Daemon
if ! docker info > /dev/null 2>&1; then
  app::log::warning "Docker is NOT running. Installing..."
  brew install --cask docker
fi

# 2. Check Kind installation
if ! command -v kind &> /dev/null; then
  app::log::warning "'kind' is not installed. Installing..."
  brew install kind
fi

# 3. Check Kubectl installation
if ! command -v kubectl &> /dev/null; then
  app::log::warning "'kubectl' is not installed. Installing..."
  brew install kubectl
fi

echo -e "${GREEN}✅ All prerequisites passed.${NC}\n"

DEFAULT_CLUSTER_NAME="kind"
CLUSTER_NAME=$DEFAULT_CLUSTER_NAME

echo -e "${CYAN}--- Summary ----------------------${NC}"
echo -e "Cluster Name: ${GREEN}$CLUSTER_NAME${NC}"
echo -e "${CYAN}----------------------------------${NC}\n"

# Create if not exists
if ! kind get clusters | grep -q "^${CLUSTER_NAME}$"; then
  app::log::info "👷 Creating cluster [$CLUSTER_NAME] with kind command..."
  kind create cluster --name $CLUSTER_NAME
fi

TARGET_CONTEXT="kind-${CLUSTER_NAME}"
CURRENT_CONTEXT=$(kubectl config current-context 2>/dev/null)

if [ "$CURRENT_CONTEXT" == "$TARGET_CONTEXT" ]; then
  app::log::success "✅ Cluster is ready (Already on expected context [$TARGET_CONTEXT]."
else
  app::log::info "Current context is '$CURRENT_CONTEXT'. Switching to '$TARGET_CONTEXT'..."

  if ! kubectl config use-context "$TARGET_CONTEXT"; then
    app::log::error "❌ Failed to switch context. Does the context exist?"
    app::log::errexit_with_log
    exit 1
  fi

  app::log::success "✅ Switched to $TARGET_CONTEXT."
fi

# Final Verification
echo -e "\n🔍 Verifying context..."
kubectl cluster-info --context "kind-${CLUSTER_NAME}"

echo -e "${GREEN}✅ Kubernetes cluster is ready.${NC}"
