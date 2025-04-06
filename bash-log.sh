#!/usr/bin/env bash

# ==============================================================================
# Script: log.sh
# URL: https://github.com/jasenmichael/bash-utils/src/lib/log.sh
# Description: A collection of utility functions for logging with colored output.
# Author: jasenmichael
# License: MIT License
#
# Log utility functions with colored output:
# - log: Prints messages (default), used by the following functions
# - log_debug: Prints debug messages (Blue).
# - log_info: Prints informational messages (Green).
# - log_warn: Prints warning messages (Orange).
# - log_error: Prints error messages (Red).
# ==============================================================================
log() {
  if [ "$SILENT" != true ]; then
    echo -e "$@"
  fi
}

log_debug() {
  local blue='\033[0;34m'
  if [ "$DEBUG" = true ]; then
    log "${blue}[DEBUG]\033[0m" "$@"
  fi
}

log_info() {
  local green='\033[0;32m'
  log "${green}[INFO]\033[0m" "" "$@"
}

log_warn() {
  local orange='\033[0;33m'
  log "${orange}[WARNING]\033[0m" "" "$@"
}

log_error() {
  # local red='\033[0;31m'
  local red='\033[41m'
  log "${red}[ERROR]\033[0m" "$@"
}

# bash_builder_remove_after
# @see https://github.com/jasenmichael/bash-builder
if ! (return &>/dev/null); then
  case "$1" in
  debug)
    shift
    log_debug "$@"
    ;;
  info)
    shift
    log_info "$@"
    ;;
  warn)
    shift
    log_warn "$@"
    ;;
  error)
    shift
    log_error "$@"
    ;;
  *)
    log "$@"
    ;;
  esac
  # else
  # file was sourced
fi
