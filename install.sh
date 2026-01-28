#!/bin/bash

# FERZDEVZ FPAWN PRO - LINUX AUTO-INSTALLER
# Unified Installation Script for Debian, Ubuntu, and RHEL-based systems.

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}╔══════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║    FERZDEVZ FPAWN PRO - LINUX INSTALLER      ║${NC}"
echo -e "${BLUE}╚══════════════════════════════════════════════╝${NC}"

# Check for Go
if ! command -v go &> /dev/null
then
    echo -e "${RED}[Error]${NC} Go is not installed. Please install Go (1.20+) first."
    exit 1
fi

# Build logic
echo -e "${GREEN}[1/3]${NC} Compiling FPAWN Pro Engine..."
go build -ldflags="-s -w" -o fpawn ./cmd/fpawn

# Installation logic
echo -e "${GREEN}[2/3]${NC} Deploying binary to local path..."
mkdir -p "$HOME/.local/bin"
mv fpawn "$HOME/.local/bin/fpawn"
chmod +x "$HOME/.local/bin/fpawn"

# Environment check
if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    echo -e "${BLUE}[Info]${NC} Adding ~/.local/bin to PATH in .bashrc..."
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
    echo -e "${GREEN}[Success]${NC} PATH updated. Please restart your terminal or run 'source ~/.bashrc'."
fi

# Configuration setup
echo -e "${GREEN}[3/3]${NC} Initializing Proprietary Core..."
mkdir -p "$HOME/.ferzdevz/fpawn"

echo -e "\n${GREEN}──────────────────────────────────────────────────${NC}"
echo -e "${GREEN}  Installation Complete!${NC}"
echo -e "  Run 'fpawn' to launch the Power Suite."
echo -e "${GREEN}──────────────────────────────────────────────────${NC}"
