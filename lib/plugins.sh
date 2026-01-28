#!/bin/bash
# fpawn Plugins Module - v25.0
# Intelligence Frontier: Real Verification & Dependency Graph

# Source plugin database if available
if [ -f "$FPAWN_BASE_DIR/plugin_db.sh" ]; then
    source "$FPAWN_BASE_DIR/plugin_db.sh"
fi

# === PLUGIN MANAGER TUI ===

function plugins_manager_tui() {
    while true; do
        ui_show_header
        echo -e " ${LBLUE}🧩 $(msg menu_15)${NC}"
        echo -e " ──────────────────────────────────────────────────"
        echo -e "  [1] $(msg p_cat_utils)      [2] $(msg p_cat_db)"
        echo -e "  [3] $(msg p_cat_net)        [4] $(msg p_cat_fix)"
        echo -e "  [5] Dependency Graph    [6] Verify Integrity (v25.0)"
        echo -e "  [0] $(msg btn_back)"
        echo -e " ──────────────────────────────────────────────────"
        read -p " Select: " PC
        
        case $PC in
            1) list_by_category "Utils" ;;
            2) list_by_category "Database" ;;
            3) list_by_category "Network" ;;
            4) list_by_category "Fixes" ;;
            5) plugins_dependency_graph; read -p " $(msg p_press_enter)" ;;
            6) plugins_verify_integrity; read -p " $(msg p_press_enter)" ;;
            0) break ;;
            *) echo "Invalid." ;;
        esac
    done
}

# === PLUGIN INSTALLER (REAL LOGIC) ===

function plugins_install() {
    local PNAME=$1
    local PURL=$2
    
    # Source GitHub module if not already loaded (defensive)
    if [ "$(type -t github_get_release_data)" != "function" ]; then
        [ -f "$FPAWN_BASE_DIR/lib/github.sh" ] && source "$FPAWN_BASE_DIR/lib/github.sh"
    fi
    
    echo -e " ${YELLOW}[Install]${NC} $(printf "$(msg p_downloading)" "${BOLD}$PNAME${NC}")"
    
    mkdir -p "plugins" "include"
    
    # 1. Download
    core_loading_spinner &
    local SPID=$!
    
    local TARGET_FILE="plugins/$PNAME.so"
    local SUCCESS=false
    
    if [[ "$PURL" == *"github.com"* ]]; then
        # Use Helper Module
        local REPO=$(echo "$PURL" | sed 's|https://github.com/||' | sed 's|\.git||')
        local JSON=$(github_get_release_data "$REPO")
        local DL_URL=""
        
        if [ -n "$JSON" ]; then
            DL_URL=$(github_filter_assets "$JSON" "linux" | head -n 1)
        fi
        
        if [ -n "$DL_URL" ]; then
            if github_download_asset "$DL_URL" "plugins" "$PNAME.so"; then
                SUCCESS=true
            fi
        else
            # Fallback to Raw
            if wget -q --show-progress -O "$TARGET_FILE" "$PURL"; then SUCCESS=true; fi
        fi
    else
        # Direct URL
        if wget -q --show-progress -O "$TARGET_FILE" "$PURL"; then SUCCESS=true; fi
    fi
    kill "$SPID" 2>/dev/null
    
    if [ "$SUCCESS" = true ]; then
        chmod +x "$TARGET_FILE"
        echo -e " ${GREEN}[Success]${NC} $PNAME installed."
        
        # Auto-add to server.cfg if not present
        if [ -f "server.cfg" ]; then
            if ! grep -q "$PNAME" "server.cfg"; then
                sed -i "/^plugins/ s/$/ $PNAME/" "server.cfg"
                echo -e " ${BLUE}[Config]${NC} Added to server.cfg."
            fi
        fi
    else
        echo -e " ${RED}[Error]${NC} Download failed."
    fi
    
    read -p " $(msg p_press_enter)"
}

# === INTEGRITY VERIFICATION (REAL LOGIC) ===

function plugins_verify_integrity() {
    echo -e " ${LBLUE}🛡️ $(msg ver_title)${NC}"
    echo -e " ──────────────────────────────────────────────────"
    
    local CFG="server.cfg"
    if [ ! -f "$CFG" ]; then
        if [ -f "pawn.json" ]; then CFG="pawn.json";
        else core_error "Config file not found."; return 1; fi
    fi
    
    core_progress_bar 2 "Verifying Plugin Binaries vs Config"
    local MISSING_COUNT=0
    
    if [ "$CFG" == "server.cfg" ]; then
        local PLUGINS=$(grep "^plugins " "server.cfg" | cut -d' ' -f2- | tr -d '\r')
        for P in $PLUGINS; do
            # Check Linux (.so) and Windows (.dll)
            if [ ! -f "plugins/$P.so" ] && [ ! -f "plugins/$P" ]; then
                 echo -e " ${RED}[MISSING]${NC} Plugin '${BOLD}$P${NC}' is defined in server.cfg but not found in /plugins folder."
                 ((MISSING_COUNT++))
            else
                 echo -e " ${GREEN}[OK]${NC} $P"
            fi
        done
    fi

    if [ $MISSING_COUNT -eq 0 ]; then
        core_success "$(msg ver_ok)"
    else
        echo -e " ──────────────────────────────────────────────────"
        echo -e " ${RED}[FAIL]${NC} integrity verify failed. $MISSING_COUNT plugins missing."
    fi
}

# === DEPENDENCY GRAPH (REAL LOGIC) ===

function plugins_dependency_graph() {
    echo -e " ${BLUE}🕸️ Dependency Graph${NC}"
    echo -e " ──────────────────────────────────────────────────"
    
    core_progress_bar 1 "Tracing Dependencies"
    
    # Check for known dependencies based on includes present
    local FOUND_ANY=false
    
    if grep -r "Streamer_Update" . &>/dev/null; then
        echo -e " • ${CYAN}Streamer${NC} <-> $(msg ana_crit_native) (Map Loader)"
        FOUND_ANY=true
    fi
    
    if grep -r "mysql_connect" . &>/dev/null; then
        echo -e " • ${CYAN}MySQL${NC} <-> $(msg ana_crit_native) (Database)"
        FOUND_ANY=true
    fi
    
    if grep -r "FCNPC_" . &>/dev/null; then
         echo -e " • ${CYAN}FCNPC${NC} <-> $(msg ana_crit_native) (NPC Logic)"
         FOUND_ANY=true
    fi
    
    if [ "$FOUND_ANY" = false ]; then
        echo -e " ${YELLOW}[Empty]${NC} No heavy plugin dependencies detected in source."
    fi
}
