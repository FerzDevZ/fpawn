#!/bin/bash

# fpawn Global Installer
# FerzDevZ Intelligence & Mastery

INSTALL_DIR="$HOME/.ferzdevz/fpawn"
BIN_DIR="$HOME/.local/bin"

echo -e "\033[0;34m[Installer]\033[0m Installing fpawn v16.3 (Master Integrity)..."

# 0. Check Dependencies
if ! command -v jq &> /dev/null; then
    echo -e "\033[0;33m[Dependency]\033[0m 'jq' not found. Attempting to install..."
    sudo apt-get update && sudo apt-get install -y jq || { echo -e "\033[0;31m[Error]\033[0m Please install 'jq' manually."; exit 1; }
fi

# 1. Prepare Directory
mkdir -p "$INSTALL_DIR"
mkdir -p "$BIN_DIR"

# 2. Copy Assets
echo -e "\033[0;36m[Copy]\033[0m Migrating engines and libraries..."
cp -r qawno "$INSTALL_DIR/"
cp -r pawno "$INSTALL_DIR/"
cp -r bin "$INSTALL_DIR/"
cp fpawn "$INSTALL_DIR/"

# 3. Validating Permissions
chmod +x "$INSTALL_DIR/fpawn"
chmod +x "$INSTALL_DIR/qawno/pawncc"
# Permissions for wine exe usually don't matter, but good to check

# 4. Global Link
echo -e "\033[0;36m[Link]\033[0m Registering command..."
rm -f "$BIN_DIR/fpawn"
ln -s "$INSTALL_DIR/fpawn" "$BIN_DIR/fpawn"

# 5. Path Check
if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    echo -e "\033[0;33m[Path]\033[0m Adding ~/.local/bin to PATH..."
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
    export PATH="$HOME/.local/bin:$PATH"
fi

echo -e "\033[0;32m[Success]\033[0m fpawn is now installed system-wide!"
echo -e "You can now type \033[1mfpawn\033[0m from ANY folder."
echo -e "Restart your terminal to apply changes fully."
