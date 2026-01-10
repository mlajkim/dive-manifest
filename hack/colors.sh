#!/bin/bash

# Make sure it is loaded only once:
if [ -n "${_COLORS_SH_LOADED:-}" ]; then
  return 0
fi
_COLORS_SH_LOADED=true

# shellcheck disable=SC2034
# ANSI Color Codes
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color (Reset)
