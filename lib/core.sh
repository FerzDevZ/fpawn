#!/bin/bash
# fpawn Core Module - v19.0
# Configuration, Colors, and Base Utilities

# === DIRECTORIES ===
export FPAWN_BASE_DIR=""
export FPAWN_QAWNO_DIR=""
export FPAWN_PAWNO_DIR=""
export FPAWN_GLOBAL_INC=""
export FPAWN_CONFIG_FILE="$HOME/.ferzdevz/fpawn/config"
export FPAWN_CACHE_DIR="$HOME/.ferzdevz/fpawn/cache/includes"
export FPAWN_PLUGIN_CACHE="$HOME/.ferzdevz/fpawn/cache/plugins"

# === COLORS (Synthesis Sapphire Palette) ===
export GREEN='\033[38;5;82m'
export BLUE='\033[38;5;39m'
export RED='\033[38;5;196m'
export YELLOW='\033[38;5;226m'
export CYAN='\033[38;5;51m'
export MAGENTA='\033[38;5;201m'
export ORANGE='\033[38;5;208m'
export WHITE='\033[38;5;255m'
export LBLUE='\033[38;5;123m'
export BOLD='\033[1m'
export NC='\033[0m'

# === CONFIGURATION MANAGEMENT ===

function core_init_dirs() {
    local SOURCE="${BASH_SOURCE[1]}"
    while [ -h "$SOURCE" ]; do
        local DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
        SOURCE="$(readlink "$SOURCE")"
        [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
    done
    FPAWN_BASE_DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
    
    FPAWN_QAWNO_DIR="$FPAWN_BASE_DIR/qawno"
    FPAWN_PAWNO_DIR="$FPAWN_BASE_DIR/pawno"
    FPAWN_GLOBAL_INC="$FPAWN_BASE_DIR/bin/includes"
}

function core_load_config() {
    mkdir -p "$(dirname "$FPAWN_CONFIG_FILE")" "$FPAWN_CACHE_DIR" "$FPAWN_PLUGIN_CACHE"
    
    if [ ! -f "$FPAWN_CONFIG_FILE" ]; then
        cat > "$FPAWN_CONFIG_FILE" <<EOF
REPO_OWNER="FerzDevZ"
REPO_NAME="fpawn"
LANG="id"
AUTO_IGNITE="OFF"
EOF
    fi
    source "$FPAWN_CONFIG_FILE"
}

function core_set_lang() {
    local L=$1
    if grep -q "LANG=" "$FPAWN_CONFIG_FILE"; then
        sed -i "s/LANG=.*/LANG=\"$L\"/" "$FPAWN_CONFIG_FILE"
    else
        echo "LANG=\"$L\"" >> "$FPAWN_CONFIG_FILE"
    fi
    echo -e "${GREEN}[Success]${NC} Language updated to $L."
    LANG=$L
}

function core_toggle_auto_ignite() {
    if [ "$AUTO_IGNITE" == "ON" ]; then
        AUTO_IGNITE="OFF"
        sed -i 's/AUTO_IGNITE=.*/AUTO_IGNITE="OFF"/' "$FPAWN_CONFIG_FILE"
    else
        AUTO_IGNITE="ON"
        sed -i 's/AUTO_IGNITE=.*/AUTO_IGNITE="ON"/' "$FPAWN_CONFIG_FILE"
    fi
}

# === LOCALIZATION ENGINE ===

function msg() {
    local ID=$1
    if [ "$LANG" == "id" ]; then
        case $ID in
            welcome) echo "Selamat Datang di fpawn v19.0" ;;
            status) echo "Status Ekosistem" ;;
            menu_1) echo "Kompilasi Script" ;;
            menu_2) echo "Jalankan Instance" ;;
            menu_3) echo "Matrix Monitor" ;;
            menu_4) echo "Marketplace & Search" ;;
            menu_5) echo "Analisis Arsitektur" ;;
            menu_6) echo "Autopilot Scan" ;;
            menu_7) echo "Code Polisher (✨)" ;;
            menu_8) echo "Architect Template (🏗️)" ;;
            menu_9) echo "Snippets Sandbox (🧪)" ;;
            menu_10) echo "Sinkronisasi Library" ;;
            menu_11) echo "Cloud Self-Update" ;;
            menu_12) echo "Bahasa: ID" ;;
            menu_13) echo "Neural Diagnose (🕵️)" ;;
            menu_14) echo "Auto-Ignition: $AUTO_IGNITE" ;;
            menu_15) echo "Plugin Manager (🔌)" ;;
            menu_0) echo "Matikan Suite" ;;
            entry_err) echo "Entry point tidak ditemukan." ;;
            success) echo "Selesai!" ;;
        esac
    else
        case $ID in
            welcome) echo "Welcome to fpawn v19.0" ;;
            status) echo "Ecosystem Status" ;;
            menu_1) echo "Compile Target" ;;
            menu_2) echo "Start Instance" ;;
            menu_3) echo "Matrix Monitor" ;;
            menu_4) echo "Marketplace & Search" ;;
            menu_5) echo "Arch Analyst" ;;
            menu_6) echo "Autopilot Scan" ;;
            menu_7) echo "Code Polisher (✨)" ;;
            menu_8) echo "Architect Template (🏗️)" ;;
            menu_9) echo "Snippets Sandbox (🧪)" ;;
            menu_10) echo "Library Sync" ;;
            menu_11) echo "Cloud Self-Update" ;;
            menu_12) echo "Language: EN" ;;
            menu_13) echo "Neural Diagnose (🕵️)" ;;
            menu_14) echo "Auto-Ignition: $AUTO_IGNITE" ;;
            menu_15) echo "Plugin Manager (🔌)" ;;
            menu_0) echo "Shutdown Suite" ;;
            entry_err) echo "Entry point not detected." ;;
            success) echo "Success!" ;;
        esac
    fi
}

# === ERROR HANDLING ===

function core_error() {
    echo -e "${RED}[Error]${NC} $1" >&2
    return 1
}

function core_warning() {
    echo -e "${YELLOW}[Warning]${NC} $1" >&2
}

function core_info() {
    echo -e "${BLUE}[Info]${NC} $1"
}

function core_success() {
    echo -e "${GREEN}[Success]${NC} $1"
}

# === GIT AUTO-PILOT ===

function core_git_commit() {
    local MSG=$1
    if [ -d ".git" ]; then
        git add . >/dev/null 2>&1
        git commit -m "[fpawn v19.0] $MSG" &>/dev/null
        echo -e "${LBLUE}[Git]${NC} Auto-commit: $MSG"
    fi
}

# === NEURAL MEMORY ===

function core_neural_memory_sync() {
    local DATA=$1
    local HFILE="$HOME/.ferzdevz/fpawn/history"
    echo "$DATA" >> "$HFILE"
    local LAST=$(tail -n 5 "$HFILE" 2>/dev/null | sort -u | tr '\n' ' ')
    echo -e " ${LBLUE}[Memory]${NC} Recent: $LAST"
}
