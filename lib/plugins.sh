#!/bin/bash
# fpawn Plugins Module - v19.0
# Plugin Management and Installation System

# Source plugin database
if [ -f "$FPAWN_BASE_DIR/plugin_db.sh" ]; then
    source "$FPAWN_BASE_DIR/plugin_db.sh"
fi

# === PLUGIN MANAGER TUI ===

function plugins_manager_tui() {
    echo -e "${LBLUE}╔══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${LBLUE}║${NC}${BOLD}${CYAN}          fpawn Plugin Manager - 80+ Plugins Available     ${NC}${LBLUE}║${NC}"
    echo -e "${LBLUE}╚══════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    # Get total count
    local TOTAL=${#PLUGIN_DATABASE[@]}
    
    echo -e "${BOLD}📦 Database Stats:${NC} $TOTAL plugins across 11 categories"
    echo ""
    echo -e "${BOLD}🔧 Categories:${NC}"
    echo -e "  ${CYAN}[1]${NC} Core           - Essential plugins (crashdetect, sscanf, profiler)"
    echo -e "  ${CYAN}[2]${NC} Database       - MySQL, Redis, MongoDB, PostgreSQL"
    echo -e "  ${CYAN}[3]${NC} Security       - bcrypt, whirlpool, samp-crypto, 2FA"
    echo -e "  ${CYAN}[4]${NC} Network        - HTTP, WebSocket, RakNet, Sockets"
    echo -e "  ${CYAN}[5]${NC} World          - Streamer, MapAndreas, GPS, ColAndreas"
    echo -e "  ${CYAN}[6]${NC} Integration    - Discord, Telegram, IRC, TeamSpeak"
    echo -e "  ${CYAN}[7]${NC} Gameplay       - Damage, Weapons, Anti-cheat, Admin"
    echo -e "  ${CYAN}[8]${NC} UI             - TextDraw, Dialogs, Inventory, HUD"
    echo -e "  ${CYAN}[9]${NC} System         - Racing, Housing, Jobs, Businesses"
    echo -e "  ${CYAN}[10]${NC} Utility        - CMD, Logging, Progress bars, Foreach"
    echo -e "  ${CYAN}[11]${NC} Language       - PawnPlus, JSON, XML, Regex"
    echo ""
    echo -e "${BOLD}⚡ Quick Install:${NC}"
    echo -e "  ${GREEN}fpawn --plugin install crashdetect${NC}"
    echo -e "  ${GREEN}fpawn --plugin install streamer${NC}"
    echo -e "  ${GREEN}fpawn --plugin install mysql${NC}"
    echo ""
    echo -e "${BOLD}📋 Browse Category:${NC}"
    echo -e "  ${GREEN}fpawn --plugin list Core${NC}"
    echo -e "  ${GREEN}fpawn --plugin list Database${NC}"
    echo ""
    echo -e "${YELLOW}[Notice]${NC} Interactive TUI with checkboxes coming in v19.1"
    echo -e "${BLUE}[Tip]${NC} Use --plugin list to see all plugins in a category"
}

# === PLUGIN INSTALLER ===

function plugins_install() {
    local PLUGIN_NAME=$1
    
    if [ -z "$PLUGIN_NAME" ]; then
        core_error "Plugin name required"
        return 1
    fi
    
    echo -e "${BLUE}[Plugin Installer]${NC} Searching for: $PLUGIN_NAME..."
    
    # Get plugin info from database
    local PLUGIN_INFO=$(get_plugin_info "$PLUGIN_NAME" 2>/dev/null)
    
    if [ -z "$PLUGIN_INFO" ]; then
        core_warning "Plugin '$PLUGIN_NAME' not found in database"
        echo -e "${YELLOW}[Fallback]${NC} Trying GitHub search..."
        search_dynamic_search "$PLUGIN_NAME"
        return $?
    fi
    
    # Parse plugin info
    local PNAME=$(echo "$PLUGIN_INFO" | cut -d'|' -f1)
    local PCAT=$(echo "$PLUGIN_INFO" | cut -d'|' -f2)
    local PCOMPAT=$(echo "$PLUGIN_INFO" | cut -d'|' -f3)
    local PURL=$(echo "$PLUGIN_INFO" | cut -d'|' -f4)
    local PDESC=$(echo "$PLUGIN_INFO" | cut -d'|' -f5)
    
    echo -e "${CYAN}[Found]${NC} $PNAME ($PCAT)"
    echo -e "${MAGENTA}Note:${NC} $PDESC"
    echo -e "${BLUE}URL:${NC} $PURL"
    echo -e "${LBLUE}Compatibility:${NC} $PCOMPAT"
    echo ""
    
    # Check compatibility
    local PROFILE=$(compiler_detect_profile ".")
    if [ "$PCOMPAT" = "Legacy" ] && [ "$PROFILE" = "omp" ]; then
        core_warning "This is a Legacy-only plugin, but detected OMP project"
        read -p "Continue anyway? [y/N] " CONT
        [[ "$CONT" != "y" ]] && return 1
    fi
    
    if [ "$PCOMPAT" = "OMP" ] && [ "$PROFILE" = "legacy" ]; then
        core_warning "This is an OMP-only plugin, but detected Legacy project"
        read -p "Continue anyway? [y/N] " CONT
        [[ "$CONT" != "y" ]] && return 1
    fi
    
    # Clone repository
    search_repo_cloner "$PURL" "$PNAME"
    
    # TODO: Auto-configure server.cfg or config.json
    core_info "Manual configuration may be required"
    core_info "Check plugin documentation in ./$PNAME/"
}

# === LIST PLUGINS ===

function plugins_list() {
    local FILTER=$1
    
    echo -e "${LBLUE}[Plugin Database]${NC} Available Plugins:"
    echo ""
    
    if [ -z "$FILTER" ]; then
        # List all
        for PLUGIN in "${PLUGIN_DATABASE[@]}"; do
            local PNAME=$(echo "$PLUGIN" | cut -d'|' -f1)
            local PCAT=$(echo "$PLUGIN" | cut -d'|' -f2)
            local PCOMPAT=$(echo "$PLUGIN" | cut -d'|' -f3)
            echo -e "  • ${CYAN}$PNAME${NC} [$PCAT] ($PCOMPAT)"
        done
    else
        # Filter by category or compat
        for PLUGIN in "${PLUGIN_DATABASE[@]}"; do
            local PNAME=$(echo "$PLUGIN" | cut -d'|' -f1)
            local PCAT=$(echo "$PLUGIN" | cut -d'|' -f2)
            local PCOMPAT=$(echo "$PLUGIN" | cut -d'|' -f3)
            
            if [[ "$PCAT" == "$FILTER" ]] || [[ "$PCOMPAT" == "$FILTER" ]]; then
                echo -e "  • ${CYAN}$PNAME${NC} [$PCAT] ($PCOMPAT)"
            fi
        done
    fi
    echo ""
    echo -e "${BOLD}Total:${NC} ${#PLUGIN_DATABASE[@]} plugins in database"
}
