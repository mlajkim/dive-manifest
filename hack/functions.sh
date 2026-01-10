#!/bin/bash

# shellcheck disable=SC1091
source "$(dirname "$0")/colors.sh"

# NOTE: Function Naming Convention:
# - Project Name: mykube, app, deploy (Scope of the function)
# - Module: log, util, check, err (Functionality classification)
# - Action: fatal, ensure, validate (Specific action)

# -----------------------------------------------------------------------------
# Function: app::log::errexit_with_log
# Description: Prints an error message and encourages the user to submit a PR.
# Arguments:
#   $1 - The error message to display.
# Examples:
#   app::log::errexit_with_log "'git' is required but not installed."
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
# -----------------------------------------------------------------------------
# Function: app::log::info
# Description: Prints an information message in green.
# Arguments:
#   $1 - The message to display.
# Examples:
#   app::log::info "Starting the setup process..."
# -----------------------------------------------------------------------------
function app::log::info() {
  local msg="$1"
  echo -e "${GREEN}[INFO] ${msg}${NC}"
}
