#!/bin/bash
# fpawn Plugins Module - v19.0
# Plugin Management and Installation System

# Source plugin database
if [ -f "$FPAWN_BASE_DIR/plugin_db.sh" ]; then
    source "$FPAWN_BASE_DIR/plugin_db.sh"
fi

# === PLUGIN MANAGER TUI ===

function plugins_manager_tui() {
    echo -e "${LBLUE}[Plugin Manager]${NC} Preparing interactive catalog..."
    echo ""
    echo -e "${YELLOW}[Notice]${NC} Full Plugin Manager TUI coming in v19.1"
    echo -e "${BLUE}[Info]${NC} Use CLI for now: ${CYAN}fpawn --plugin install <name>${NC}"
    echo ""
    echo -e "${BOLD}Available Categories:${NC}"
    echo -e "  • Core (crashdetect, sscanf, streamer, nativechecker)"
    echo -e "  • Database (mysql, pawn-redis)"
    echo -e "  • Security (bcrypt, samp-crypto, whirlpool)"
    echo -e "  • Network (pawn-requests, discord-connector)"
    echo -e "  • World (MapAndreas, ColAndreas, FCNPC)"
    echo ""
    echo -e "${BOLD}Example:${NC} fpawn --plugin install crashdetect"
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
