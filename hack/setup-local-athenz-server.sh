#!/bin/bash
set -e

# shellcheck disable=SC1091
source "$(dirname "$0")/import.sh"

app::log::startofscript "🛡️  Local Athenz Server Setup Wizard"

# Arguments
DEFAULT_ATHENZ_DIR="../athenz"
DIR_NAME="${ATHENZ_DIR:-$DEFAULT_ATHENZ_DIR}"

# Configs
REPO_URL="https://github.com/ctyano/athenz-distribution.git"

app::log::progress "🔎 Checking Prerequisites..."

# Check Git
if ! command -v git &> /dev/null; then
  app::log::errexit_with_log "'git' is required but not installed."
fi

# Check Make
if ! command -v make &> /dev/null; then
  app::log::errexit_with_log "'make' is required but not installed."
fi

# Check Helm (Required for Athenz deployment)
if ! command -v helm &> /dev/null; then
  app::log::warning "'helm' not found. Installing via brew..."
  brew install helm
fi

# heck Cluster Connection (Check if cluster is reachable)
if ! kubectl cluster-info > /dev/null 2>&1; then
  app::log::errexit_with_log "Kubernetes cluster is not reachable. Please run 'make -C manifest setup' first."
fi

app::log::success "✅ All prerequisites passed!"

app::log::progress "Preparing Source Code"

# If no such directory, create one:
if [ ! -d "$DIR_NAME" ]; then
  app::log::info "📥 Cloning repository to ${YELLOW}$DIR_NAME${NC}..."
  git clone "$REPO_URL" "$DIR_NAME"
else
  app::log::info "🔄 Repository exists. Pulling latest changes..."
  git pull --rebase
fi

app::log::progress "Deploying Athenz"
make -C $DIR_NAME deploy-kubernetes-athenz

app::log::progress "Verifying Deployment"
echo -e "⏳ Waiting for Athenz pods to be ready (timeout: 120s)..."

# Please sort them with those that run first
TIMEOUT=120s
COMPONENTS=(
  "athenz-db"
  "athenz-cli"
  "athenz-zms-server"
  "athenz-zts-server"
  "athenz-ui"
)

for component in "${COMPONENTS[@]}"; do
  kubectl wait -n athenz \
    --for=condition=ready pod \
    --selector=app.kubernetes.io/name=$component \
    --timeout=${TIMEOUT} || echo -e "${YELLOW}⚠️  Timed out waiting for $component. Check logs manually.${NC}"
done

app::log::success "✅ Athenz Server deployment finished!"
