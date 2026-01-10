#!/bin/bash
set -e

# shellcheck disable=SC1091
source "$(dirname "$0")/import.sh"

echo -e "${CYAN}==============================================${NC}"
echo -e "${CYAN}   🛡️  Local Athenz Server Setup Wizard       ${NC}"
echo -e "${CYAN}==============================================${NC}"

REPO_URL="https://github.com/ctyano/athenz-distribution.git"
DIR_NAME="athenz"

echo -e "🔍 Checking Prerequisites..."

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

echo -e "${GREEN}✅ All prerequisites passed.${NC}\n"

echo -e "${CYAN}--- Preparing Source Code ----------------${NC}"

# If no such directory, create one:
if [ ! -d "$DIR_NAME" ]; then
  echo -e "📥 Cloning repository to ${YELLOW}$DIR_NAME${NC}..."
  git clone "$REPO_URL" "$DIR_NAME"
else
  echo -e "🔄 Repository exists. Pulling latest changes..."
  git pull --rebase
fi

echo -e "\n${CYAN}--- Deploying Athenz ---------------------${NC}"
make -C $DIR_NAME deploy-kubernetes-athenz

echo -e "\n${CYAN}--- Verifying Deployment -----------------${NC}"
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
