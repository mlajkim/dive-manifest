#!/bin/bash

# shellcheck disable=SC1091
source "$(dirname "$0")/colors.sh"

# NOTE: Function Naming Convention:
# - Project Name: mykube, app, deploy (Scope of the function)
# - Module: log, util, check, err (Functionality classification)
# - Action: fatal, ensure, validate (Specific action)

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

# -----------------------------------------------------------------------------
# Function: app::log::success
# Description: Prints a success message in green.
# Arguments:
#   $1 - The message to display.
# Examples:
#   app::log::success "Setup completed successfully!"
# -----------------------------------------------------------------------------
function app::log::success() {
  local msg="$1"
  echo -e "${GREEN}${msg}${NC}"
}

# -----------------------------------------------------------------------------
# Function: app::log::warning
# Description: Prints a warning message in yellow.
# Arguments:
#   $1 - The message to display.
# Examples:
#   app::log::warning "This is a warning message."
# -----------------------------------------------------------------------------
function app::log::warning() {
  local msg="$1"
  echo -e "${YELLOW}[WARNING] ${msg}${NC}"
}

# -----------------------------------------------------------------------------
# Function: app::log::error
# Description: Prints an error message in red.
# Arguments:
#   $1 - The message to display.
# Examples:
#   app::log::error "This is an error message."
# -----------------------------------------------------------------------------
function app::log::error() {
  local msg="$1"
  echo -e "${RED}[ERROR] ${msg}${NC}"
}

function app::log::startofscript() {
  local msg="$1"
  
  echo -e "${CYAN}==============================================${NC}"
  echo -e "${CYAN} $msg${NC}"
  echo -e "${CYAN}==============================================${NC}"
}

function app::log::progress() {
  local msg="$1"
  echo -e "${CYAN}---$msg-----------------${NC}"
}

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
  app::log::error "$error_msg"
  
  # Print the PR encouragement message in yellow
  app::log::warning "-------------------------------------------------------------"
  app::log::warning "  Found a bug? Or have a better idea?                        "
  app::log::warning "  Please feel free to submit a Pull Request!                 "
  app::log::warning "  👉 https://github.com/mlajkim/dive-manifest                "
  app::log::warning "-------------------------------------------------------------"
  
  exit 1
}