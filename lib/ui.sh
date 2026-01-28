#!/bin/bash
# fpawn UI Module - v19.0
# Dashboard, Headers, and Menu System

# === HEADER ===

function ui_show_header() {
    clear
    echo -e " ${LBLUE}╔══════════════════════════════════════════════════════════╗${NC}"
    echo -e " ${LBLUE}║${NC}${BOLD}${WHITE}      fpawn v25.0 - Intelligence Frontier Edition         ${NC}${LBLUE}║${NC}"
    echo -e " ${LBLUE}╚══════════════════════════════════════════════════════════╝${NC}"
    
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
    
    local CW=20

    echo -e "  ${BOLD}${BLUE}ENGINEERING${NC}$(printf '%*s' $((CW-11)) '')${BOLD}${BLUE}ECOSYSTEM${NC}$(printf '%*s' $((CW-9)) '')${BOLD}${BLUE}ANALYSIS${NC}"
    printf "  [ 1] %-${CW}s [ 4] %-${CW}s [ 5] %s\n" "$(msg menu_1)" "$(msg menu_4)" "$(msg menu_5)"
    printf "  [ 2] %-${CW}s [15] %-${CW}s [13] %s\n" "$(msg menu_2)" "$(msg menu_15)" "$(msg menu_13)"
    printf "  [ 3] %-${CW}s [10] %-${CW}s [ 6] %s\n" "$(msg menu_3)" "$(msg menu_10)" "$(msg menu_6)"
    printf "  [14] %-${CW}s [ 8] %-${CW}s [16] %s\n" "$(msg menu_14)" "$(msg menu_8)" "$(msg menu_16)"
    echo ""
    echo -e "  ${BOLD}${BLUE}INTELLIGENCE${NC}$(printf '%*s' $((CW-12)) '')${BOLD}${BLUE}AUTOMATION${NC}$(printf '%*s' $((CW-10)) '')${BOLD}${BLUE}SYSTEM${NC}"
    printf "  [18] %-${CW}s [21] %-${CW}s [12] %s\n" "$(msg menu_18)" "$(msg menu_21)" "$(msg menu_12)"
    printf "  [19] %-${CW}s [22] %-${CW}s [11] %s\n" "$(msg menu_19)" "$(msg menu_22)" "$(msg menu_11)"
    printf "  [20] %-${CW}s [23] %-${CW}s [17] %s\n" "$(msg menu_20)" "$(msg menu_23)" "$(msg menu_17)"
    printf "  [ 9] %-${CW}s [24] %-${CW}s [25] %s\n" "$(msg menu_9)" "$(msg menu_24)" "$(msg menu_25)"
    echo ""
    echo -e "                                         [ 0] ${BOLD}${RED}$(msg menu_0)${NC}"
    echo -e " ${LBLUE}────────────────────────────────────────────────────────────${NC}"
    echo -e "  ${WHITE}Status:${NC} ${GREEN}Ready${NC} | ${CYAN}Session:${NC} ${WHITE}$(date +%H:%M)${NC}"
    read -p " Select Index: " CHOICE
    
    case $CHOICE in
        1)  local F=$(compiler_find_entry_point); compiler_execute "auto" "auto" "${F:-main.pwn}"; read -p "..." ;;
        2)  compiler_server_runner; read -p "..." ;;
        3)  local F=$(compiler_find_entry_point); compiler_watch_mode "${F:-main.pwn}" ;;
        4)  search_marketplace_hub; read -p "..." ;;
        5)  analysis_static_analyst; read -p "..." ;;
        6)  analysis_project_scanner; read -p "..." ;;
        7)  read -p " Target: " FT; tools_code_artisan "$FT"; read -p "..." ;;
        8)  tools_template_architect; read -p "..." ;;
        9)  tools_snippet_sandbox ;;
        10) compiler_library_updater; read -p "..." ;;
        11) tools_self_update; exit ;;
        12) [ "$LANG" == "id" ] && core_set_lang "en" || core_set_lang "id" ;;
        13) analysis_doctor; read -p "..." ;;
        14) core_toggle_auto_ignite ;;
        15) plugins_manager_tui; read -p "..." ;;
        16) analysis_performance_dashboard; read -p "..." ;;
        17) tools_safeguard_restore; read -p "..." ;;
        18) analysis_security_audit; read -p "..." ;;
        19) analysis_suggestion_engine; read -p "..." ;;
        20) analysis_linter; read -p "..." ;;
        21) compiler_matrix_build; read -p "..." ;;
        22) read -p " Logic: " BL; compiler_micro_bench "$BL"; read -p "..." ;;
        23) tools_project_bundler; read -p "..." ;;
        24) tools_server_cruncher; read -p "..." ;;
        25) plugins_verify_integrity; read -p "..." ;;
        0)  exit 0 ;;
    esac
    ui_show_dashboard
}
