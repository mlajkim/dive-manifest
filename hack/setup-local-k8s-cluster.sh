#!/bin/bash
set -e

##################################################################
### Imports ######################################################
##################################################################
# shellcheck disable=SC1091
source "$(dirname "$0")/colors.sh"

##################################################################
### Shellscript Intro                                          ###
##################################################################
echo -e "${CYAN}==============================================${NC}"
echo -e "${CYAN}   🚀 Local K8s Cluster Setup Wizard          ${NC}"
echo -e "${CYAN}==============================================${NC}"

##################################################################
### Prerequisites Check ##########################################
##################################################################

echo -e "🔍 Checking Prerequisites..."

if [[ "$(uname)" != "Darwin" ]]; then
  echo -e "${RED}[Error] Unsupported OS. Only macOS is supported.${NC}"
  exit 1
fi

# Check brew installed:
if ! command -v brew &> /dev/null; then
  echo -e "${RED}[Error] 'brew' is not installed.${NC}"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# 1. Check Docker Daemon
if ! docker info > /dev/null 2>&1; then
  echo -e "${RED}[Error] Docker is NOT running.${NC}"
  brew install --cask docker
fi

# 2. Check Kind installation
if ! command -v kind &> /dev/null; then
  echo -e "${RED}[Error] 'kind' is not installed.${NC}"
  brew install kind
fi

# 3. Check Kubectl installation
if ! command -v kubectl &> /dev/null; then
  echo -e "${RED}[Error] 'kubectl' is not installed.${NC}"
  brew install kubectl
fi


echo -e "${GREEN}✅ All prerequisites passed.${NC}\n"

##################################################################
### Interactive User Prompt ######################################
##################################################################

DEFAULT_CLUSTER_NAME="kind"
CLUSTER_NAME=$DEFAULT_CLUSTER_NAME

echo -e "${CYAN}--- Summary ----------------------${NC}"
echo -e "Cluster Name: ${GREEN}$CLUSTER_NAME${NC}"
echo -e "${CYAN}----------------------------------${NC}\n"

##################################################################
### Core LOGIC ###################################################
##################################################################

# Create if not exists
if ! kind get clusters | grep -q "^${CLUSTER_NAME}$"; then
  echo -e "👷 Creating cluster '${CLUSTER_NAME}'..."
  echo -e "${YELLOW}☕ This might take a minute...${NC}"

  kind create cluster --name $CLUSTER_NAME
else
  echo -e "${GREEN}✅ Cluster is ready.${NC}"
fi

# Final Verification
echo -e "\n🔍 Verifying context..."
kubectl cluster-info --context "kind-${CLUSTER_NAME}"

echo -e "\n${BLUE}🎉 Setup Complete! Happy Hacking!${NC}"