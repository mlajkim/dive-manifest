#!/bin/bash
set -e

##################################################################
### Imports ######################################################
##################################################################
# shellcheck disable=SC1091
source "$(dirname "$0")/import.sh"

##################################################################
### Intro                                                      ###
##################################################################
echo -e "${CYAN}==============================================${NC}"
echo -e "${CYAN}   🛡️  Local Athenz Server Setup Wizard       ${NC}"
echo -e "${CYAN}==============================================${NC}"

##################################################################
### Configuration ################################################
##################################################################
REPO_URL="https://github.com/ctyano/athenz-distribution.git"
DIR_NAME="athenz"

##################################################################
### Prerequisites Check ##########################################
##################################################################
echo -e "🔍 Checking Prerequisites..."

# 1. Check Git
if ! command -v git &> /dev/null; then
  app::log::errexit_with_log "'git' is required but not installed."
fi

# 2. Check Make
if ! command -v make &> /dev/null; then
  app::log::errexit_with_log "'make' is required but not installed."
fi

# 3. Check Helm (Athenz 배포 시 종종 필요함)
if ! command -v helm &> /dev/null; then
  echo -e "${YELLOW}'helm' not found. Installing via brew...${NC}"
  brew install helm
fi

# 4. Check Cluster Connection (Athenz를 올릴 땅이 있는지 확인)
if ! kubectl cluster-info > /dev/null 2>&1; then
  app::log::errexit_with_log "Kubernetes cluster is not reachable. Please run 'make -C manifest setup' first."
fi

echo -e "${GREEN}✅ All prerequisites passed.${NC}\n"

##################################################################
### Git Operation ################################################
##################################################################
echo -e "${CYAN}--- Preparing Source Code ----------------${NC}"

# If no such directory, create one:
if [ ! -d "$DIR_NAME" ]; then
  echo -e "📥 Cloning repository to ${YELLOW}$DIR_NAME${NC}..."
  git clone "$REPO_URL" "$DIR_NAME"
else
  echo -e "🔄 Repository exists. Pulling latest changes..."
  git pull --rebase
fi

##################################################################
### Deploy Execution #############################################
##################################################################
echo -e "\n${CYAN}--- Deploying Athenz ---------------------${NC}"
make -C $DIR_NAME deploy-kubernetes-athenz

##################################################################
### Post-Check (Wait for Readiness) ##############################
##################################################################
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

echo -e "${GREEN}✅ Athenz Server deployment finished!${NC}"