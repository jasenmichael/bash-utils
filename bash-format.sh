#!/usr/bin/env bash

# ========================================================================
# Script: bash-format.sh
# URL: https://github.com/jasenmichael/bash-utils/blob/main/bash-format.sh
# Description: Shell script formatter using shfmt
# Author: jasenmichael
# License: MIT License
#
# Functions:
# - install_shfmt: Installs shfmt formatter if not present
# - format: Formats shell scripts using shfmt
# ========================================================================
SHFMT_PATH="${SHFMT_PATH:-$HOME/.local/bin/shfmt}"
SHFMT_VERSION=${SHFMT_VERSION:-3.8.0}
install_shfmt() {
  # !! Detect architecture
  case "$(uname -m)" in
  x86_64) ARCH="amd64" ;;
  aarch64) ARCH="arm64" ;;
  *) echo "Unsupported architecture: $(uname -m)" && exit 1 ;;
  esac

  # !! shfmt configuration
  SHFMT_FILE="shfmt_v${SHFMT_VERSION}_linux_${ARCH}"
  SHFMT_URL="https://github.com/mvdan/sh/releases/download/v${SHFMT_VERSION}/${SHFMT_FILE}"
  if [ ! -f "$SHFMT_PATH" ]; then
    echo "Downloading shfmt"
    if ! curl -L -o "$SHFMT_PATH" "$SHFMT_URL"; then
      rm -f "$SHFMT_PATH" >/dev/null 2>&1
      echo "ERROR: Download shfmt failed."
      return 1
    fi
    chmod +x "$SHFMT_PATH"
  fi
}

format() {
  [ -z "$1" ] && echo "Missing file or directory argument" && exit 1

  # check if shfmt is installed
  if command -v shfmt >/dev/null 2>&1; then
    SHFMT_PATH=$(which shfmt)
  elif [ ! -f "$SHFMT_PATH" ]; then
    echo "shfmt is not installed. Run \`$0 --install\` to install."
    return 1
  fi

  if [ -f "$1" ]; then
    echo "Formatting file: $1"
  elif [ -d "$1" ]; then
    echo "Formatting directory: $1"
  else
    echo "Error: $1 is not a file or directory"
    return 1
  fi
  "$SHFMT_PATH" -i 2 -w "$1"
}

# bash_builder_remove_after
# @see https://github.com/jasenmichael/bash-builder
if ! (return &>/dev/null); then
  if [ "$1" = "--install" ]; then
    install_shfmt
    exit $?
  fi
  format "$@"
  # else
  # file was sourced
fi
