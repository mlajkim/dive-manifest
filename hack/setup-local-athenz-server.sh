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
# 현재 스크립트 위치 기준으로 상위 폴더의 .build/athenz 디렉토리 사용
WORK_DIR="$(dirname "$0")/../.build/athenz-distribution"

##################################################################
### Prerequisites Check ##########################################
##################################################################
echo -e "🔍 Checking Prerequisites..."

# 1. Check Git
if ! command -v git &> /dev/null; then
  app::log::exit_with_log "'git' is required but not installed."
fi

# 2. Check Make
if ! command -v make &> /dev/null; then
  app::log::exit_with_log "'make' is required but not installed."
fi

# 3. Check Helm (Athenz 배포 시 종종 필요함)
if ! command -v helm &> /dev/null; then
  echo -e "${YELLOW}'helm' not found. Installing via brew...${NC}"
  brew install helm
fi

# 4. Check Cluster Connection (Athenz를 올릴 땅이 있는지 확인)
if ! kubectl cluster-info > /dev/null 2>&1; then
  app::log::exit_with_log "Kubernetes cluster is not reachable. Please run 'make cluster' first."
fi

echo -e "${GREEN}✅ All prerequisites passed.${NC}\n"

##################################################################
### Git Operation ################################################
##################################################################
echo -e "${CYAN}--- Preparing Source Code ----------------${NC}"

# 디렉토리가 없으면 Clone, 있으면 Pull
if [ ! -d "$WORK_DIR" ]; then
  echo -e "📥 Cloning repository to ${YELLOW}$WORK_DIR${NC}..."
  git clone "$REPO_URL" "$WORK_DIR"
else
  echo -e "🔄 Repository exists. Pulling latest changes..."
  cd "$WORK_DIR"
  git pull --rebase
fi

##################################################################
### Deploy Execution #############################################
##################################################################
echo -e "\n${CYAN}--- Deploying Athenz ---------------------${NC}"

cd "$WORK_DIR"

# 사용자가 요청한 Make 커맨드 실행
echo -e "🚀 Running: ${YELLOW}make clean-kubernetes-athenz deploy-kubernetes-athenz${NC}"
make clean-kubernetes-athenz deploy-kubernetes-athenz

##################################################################
### Post-Check (Wait for Readiness) ##############################
##################################################################
echo -e "\n${CYAN}--- Verifying Deployment -----------------${NC}"
echo -e "⏳ Waiting for Athenz pods to be ready (timeout: 120s)..."

# ZMS가 뜨는지 확인 (Athenz namespace가 'athenz'라고 가정)
# 만약 namespace가 다르면 수정 필요
kubectl wait --namespace athenz \
  --for=condition=ready pod \
  --selector=app=zms \
  --timeout=120s || echo -e "${YELLOW}⚠️  Timed out waiting for ZMS. Check logs manually.${NC}"

echo -e "${GREEN}✅ Athenz Server deployment finished!${NC}"