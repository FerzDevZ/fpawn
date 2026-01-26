#!/bin/bash
# fpawn UI Module - v19.0
# Dashboard, Headers, and Menu System

# === HEADER ===

function ui_show_header() {
    clear
    echo -e " ${WHITE}╔══════════════════════════════════════════════════════════╗${NC}"
    echo -e " ${WHITE}║${NC}${BOLD}${BLUE}      fpawn v19.1 - FerzDevZ Interactive Dashboard         ${NC}${WHITE}║${NC}"
    echo -e " ${WHITE}╚══════════════════════════════════════════════════════════╝${NC}"
    
    # Detect ecosystem status
    local STATUS="${RED}DARK${NC}"
    [ -f "pawn.json" ] && STATUS="${GREEN}SYNCHRONIZED (OMP)${NC}"
    [ -f "server.cfg" ] && STATUS="${YELLOW}LEGACY (SAMP)${NC}"
    
    echo -e "  $(msg status): $STATUS"
    echo ""
}

# === MAIN DASHBOARD ===

function ui_show_dashboard() {
    ui_show_header
    
    echo -e "  ${BOLD}ENGINEERING${NC}                    ${BOLD}ECOSYSTEM HUB${NC}"
    echo -e "  [1] $(msg menu_1)             [4] $(msg menu_4)"
    echo -e "  [2] $(msg menu_2)             [5] $(msg menu_5)"
    echo -e "  [3] $(msg menu_3)             [6] $(msg menu_6)"
    echo ""
    echo -e "  ${BOLD}ANALYSIS & LAB${NC}                 ${BOLD}SYSTEM${NC}"
    echo -e "  [7] $(msg menu_7)         [10] $(msg menu_10)"
    echo -e "  [8] $(msg menu_8)      [11] $(msg menu_11)"
    echo -e "  [9] $(msg menu_9)         [12] $(msg menu_12)"
    echo -e "  [13] $(msg menu_13)        [14] $(msg menu_14)"
    echo -e "  [15] $(msg menu_15)        [0] $(msg menu_0)"
    echo ""
    echo -e " ${WHITE}────────────────────────────────────────────────────────────${NC}"
    read -p " Command Index: " CHOICE
    
    case $CHOICE in
        1)  local F=$(compiler_find_entry_point)
            compiler_execute "auto" "auto" "${F:-main.pwn}"
            exit ;;
        2)  compiler_server_runner
            exit ;;
        3)  local F=$(compiler_find_entry_point)
            # TODO: run_watch_mode "${F:-main.pwn}"
            core_info "Watch mode coming soon"
            read -p "Enter..."
            ui_show_dashboard ;;
        4)  search_marketplace_hub
            read -p "Enter..."
            ui_show_dashboard ;;
        5)  analysis_static_analyst
            read -p "Enter..."
            ui_show_dashboard ;;
        6)  analysis_project_scanner
            read -p "Enter..."
            ui_show_dashboard ;;
        7)  read -p " Target: " FT
            tools_code_polisher "$FT"
            read -p "Enter..."
            ui_show_dashboard ;;
        8)  tools_template_architect
            read -p "Enter..."
            ui_show_dashboard ;;
        9)  tools_snippet_sandbox
            ui_show_dashboard ;;
        10) compiler_library_updater
            read -p "Enter..."
            ui_show_dashboard ;;
        11) tools_self_update
            exit ;;
        12) [ "$LANG" == "id" ] && core_set_lang "en" || core_set_lang "id"
            ui_show_dashboard ;;
        13) analysis_neural_diagnose
            read -p "Enter..."
            ui_show_dashboard ;;
        14) core_toggle_auto_ignite
            ui_show_dashboard ;;
        15) plugins_manager_tui
            read -p "Enter..."
            ui_show_dashboard ;;
        0)  exit 0 ;;
        *)  ui_show_dashboard ;;
    esac
}
