#!/bin/bash

# ==========================================================
# fpawn - Professional Pawn CLI Auto-Setup
# Created for: FerzDevZ
# Supported Distros: Ubuntu, Debian, CentOS, RHEL, Arch Linux
# ==========================================================

GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${BLUE}==========================================================${NC}"
echo -e "${CYAN}          fpawn - PROFESSIONAL AUTO SETUP${NC}"
echo -e "${CYAN}                Powered by FerzDevZ${NC}"
echo -e "${BLUE}==========================================================${NC}"

# Check for root/sudo
if [ "$EUID" -ne 0 ]; then
  echo -e "${RED}[Error]${NC} Please run as root or using sudo."
  exit 1
fi

# 1. Detect Distribution
echo -e "${BLUE}[1/4]${NC} Detecting Linux Distribution..."
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$ID
else
    OS=$(uname -s)
fi
echo -e "${GREEN}[Ok]${NC} Detected: $OS"

# 2. Install Dependencies
echo -e "${BLUE}[2/4]${NC} checking and installing dependencies..."

install_pkg() {
    case $OS in
        ubuntu|debian|raspbian)
            apt-get update -qq
            apt-get install -y -qq "$@"
            ;;
        centos|rhel|fedora)
            yum install -y -q "$@"
            ;;
        arch)
            pacman -Sy --noconfirm "$@"
            ;;
        *)
            echo -e "${RED}[Warning]${NC} Unknown distro. Please install $@ manually."
            ;;
    esac
}

PACKAGES=("curl" "unzip" "wine" "lib32z1" "inotify-tools" "jq" "git" "zip")

for pkg in "${PACKAGES[@]}"; do
    if ! command -v $pkg &> /dev/null && [ "$pkg" != "lib32z1" ]; then
        echo -e "${YELLOW}[Info]${NC} Installing $pkg..."
        install_pkg $pkg
    fi
done

# 3. Setup Global Commands
echo -e "${BLUE}[3/4]${NC} Configuring global commands..."
BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Download Compiler if missing
if [ ! -d "$BASE_DIR/bin/compiler-community" ]; then
    echo -e "${YELLOW}[Info]${NC} Downloading Pawn Community Compiler..."
    mkdir -p "$BASE_DIR/bin"
    curl -L -s -o "$BASE_DIR/pawnc.tar.gz" "https://github.com/pawn-lang/compiler/releases/download/v3.10.10/pawnc-3.10.10-linux.tar.gz"
    tar -xzf "$BASE_DIR/pawnc.tar.gz" -C "$BASE_DIR/bin"
    mv "$BASE_DIR/bin/pawnc-3.10.10-linux" "$BASE_DIR/bin/compiler-community" 2>/dev/null || true
    rm "$BASE_DIR/pawnc.tar.gz"
fi

TARGET_BIN="/usr/local/bin/fpawn"
TARGET_BIN_ALT="/usr/local/bin/fcompile"

chmod +x "$BASE_DIR/fpawn"
ln -sf "$BASE_DIR/fpawn" "$TARGET_BIN"
ln -sf "$BASE_DIR/fpawn" "$TARGET_BIN_ALT"

# 4. Finalizing
echo -e "${BLUE}[4/4]${NC} Finalizing installation..."
echo -e "${BLUE}==========================================================${NC}"
echo -e "${GREEN}SUCCESS!${NC} fpawn has been installed successfully."
echo -e "Creator: ${CYAN}FerzDevZ${NC}"
echo -e "You can now use ${YELLOW}fpawn${NC} or ${YELLOW}fcompile${NC} from anywhere."
echo -e "${BLUE}==========================================================${NC}"
