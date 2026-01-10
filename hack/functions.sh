#!/bin/bash

# shellcheck disable=SC1091
source "$(dirname "$0")/colors.sh"

# -----------------------------------------------------------------------------
# Function: app::log::errexit_with_log
# Description: Prints an error message and encourages the user to submit a PR.
# -----------------------------------------------------------------------------
function app::log::errexit_with_log() {
  local error_msg="$1"
  
  # Print the error message in red
  echo -e "${RED}[ERROR] ${error_msg}${NC}"
  
  # Print the PR encouragement message in yellow
  echo -e "${YELLOW}-------------------------------------------------------------${NC}"
  echo -e "${YELLOW}  Found a bug? Or have a better idea?                        ${NC}"
  echo -e "${YELLOW}  Please feel free to submit a Pull Request!                 ${NC}"
  echo -e "${YELLOW}  👉 https://github.com/mlajkim/dive-manifest                ${NC}"
  echo -e "${YELLOW}-------------------------------------------------------------${NC}"
  
  exit 1
}
