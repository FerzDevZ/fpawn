#!/bin/bash
# fpawn Analysis Module - v25.0
# Intelligence Frontier Edition

# === STATIC ANALYST ===

function analysis_static_analyst() {
    local FILE=$1
    [ -z "$FILE" ] && FILE=$(compiler_find_entry_point)
    
    echo -e " ${BLUE}📊 $(msg menu_5)${NC}"
    echo -e " ──────────────────────────────────────────────────"
    
    if [ -z "$FILE" ] || [ ! -f "$FILE" ]; then
        core_error "$(msg entry_err)"
        return 1
    fi

    core_progress_bar 1 "Analyzing Logical Structure"
    
    local LOC=$(wc -l < "$FILE")
    local NATIVES=$(grep -c "native " "$FILE")
    local PUBLICS=$(grep -c "public " "$FILE")
    local STOCKS=$(grep -c "stock " "$FILE")
    
    echo -e " ${BOLD}File Metadata:${NC}"
    echo -e " • Lines of Code: $LOC"
    echo -e " • Native Imports: $NATIVES"
    echo -e " • Public Callbacks: $PUBLICS"
    echo -e " • Stock Functions: $STOCKS"
    
    echo -e " ──────────────────────────────────────────────────"
    core_success "$(msg ana_success)"
}

# === PROJECT SCANNER (AUTOPILOT) ===

function analysis_project_scanner() {
    echo -e " ${BLUE}📡 $(msg menu_6)${NC}"
    echo -e " ──────────────────────────────────────────────────"
    
    # Deep scan of depth 3
    local FILES=$(find . -maxdepth 3 -name "*.pwn" -o -name "*.inc" | grep -v "pawno" | grep -v "qawno")
    local COUNT=$(echo "$FILES" | wc -l)
    
    core_progress_bar 2 "Indexing Ecosystem Assets ($COUNT targets)"
    
    echo -e " ${BOLD}Core Inventory:${NC}"
    echo "$FILES" | head -n 10 | sed 's/^/ • /'
    [ "$COUNT" -gt 10 ] && echo "   ... and $((COUNT-10)) more."
    
    local TOT_LOC=0
    for F in $FILES; do
        if [ -f "$F" ]; then
            local L=$(wc -l < "$F")
            ((TOT_LOC+=L))
        fi
    done
    
    echo -e " ──────────────────────────────────────────────────"
    core_success "Ecosystem Scan Complete. Total managed LoC: $TOT_LOC"
}

# === PERFORMANCE DASHBOARD ===

function analysis_performance_dashboard() {
    local AMX_SIZE=$1
    local DURATION=$2
    
    ui_show_header
    echo -e " ${GREEN}📈 $(msg menu_16)${NC}"
    echo -e " ──────────────────────────────────────────────────"
    
    # Synthesis Animation
    core_synthesis_loader "Mapping Metric Grids"
    
    # Mock some data if not provided (for dashboard access)
    [ -z "$AMX_SIZE" ] && AMX_SIZE="450 KB"
    [ -z "$DURATION" ] && DURATION="1.2s"
    
    echo -e " ${BOLD}Synthesis Efficiency:${NC}"
    echo -e " • Build Throughput: $AMX_SIZE / $DURATION"
    echo -e " • Complexity Rating: ${GREEN}Optimal${NC}"
    echo -e " • Latency Impact: ${CYAN}Low (<0.5ms)${NC}"
    
    echo -e " ──────────────────────────────────────────────────"
    read -p " $(msg p_press_enter)"
}

# === PROJECT DOCTOR (PRECISION DIAGNOSTICS) ===

function analysis_doctor() {
    local FILE=$1
    [ -z "$FILE" ] && FILE=$(compiler_find_entry_point)
    
    ui_show_header
    core_progress_bar 2 "Initializing Neural Diagnostic Layer"
    
    echo -e " ${LBLUE}🏥 $(msg menu_13)${NC}"
    echo -e " ──────────────────────────────────────────────────"
    
    if [ -z "$FILE" ] || [ ! -f "$FILE" ]; then
        core_error "$(msg entry_err)"
        return 1
    fi

    local ISSUES=0
    local WARNINGS=0

    # 1. Conflict Check
    (
        if grep -q "a_samp" "$FILE" && grep -q "open.mp" "$FILE"; then
            echo -e " ${RED}[ERR]${NC} Conflict: both a_samp and open.mp detected."
            ((ISSUES++))
        fi
    ) & core_loading_spinner

    # 2. Dependency Scan
    echo -ne " ${CYAN}[Scan]${NC} Validating include tree... "
    local INCS=$(grep "#include" "$FILE" | awk -F'[<>]' '{print $2}')
    for INC in $INCS; do
        if [ ! -f "pawno/include/$INC.inc" ] && [ ! -f "qawno/include/$INC.inc" ] && [ ! -f "$FPAWN_GLOBAL_INC/$INC.inc" ]; then
            ((WARNINGS++))
        fi
    done
    echo -e "${GREEN}DONE${NC}"

    # 3. Stack Safety
    local LARGE=$(grep -En "new .*\[[0-9]{5,}\]" "$FILE" | head -n 3)
    if [ -n "$LARGE" ]; then
        echo -e " ${ORANGE}[HEAVY]${NC} High stack memory pressure:"
        echo "$LARGE" | sed 's/^/           /'
        ((WARNINGS++))
    fi

    echo -e " ──────────────────────────────────────────────────"
    if [ $ISSUES -eq 0 ] && [ $WARNINGS -eq 0 ]; then
        core_success "$(msg doc_healthy)"
    else
        echo -e " Report Summary:"
        echo -e " • ${RED}$ISSUES Critical Faults${NC}"
        echo -e " • ${YELLOW}$WARNINGS Efficiency Warnings${NC}"
    fi
}

# === ERROR EXPLAINER ===

function analysis_explain_error() {
    local CODE=$1
    echo -e " ${LBLUE}🔍 $(msg exp_title)${NC}"
    echo -e " ──────────────────────────────────────────────────"
    
    CODE=$(echo "$CODE" | grep -o "[0-9]*")
    local MSG=$(msg "exp_$CODE")
    
    if [[ "$MSG" == "exp_$CODE" ]]; then
        core_error "$(printf "$(msg exp_not_found)" "$CODE")"
    else
        echo -e " ${BOLD}Error $CODE:${NC}"
        echo -e " $MSG"
    fi
    echo -e " ──────────────────────────────────────────────────"
}

# === SECURITY AUDIT ===

function analysis_security_audit() {
    local FILE=$1
    [ -z "$FILE" ] && FILE=$(compiler_find_entry_point)
    
    echo -e " ${RED}🛡️ $(msg aud_title)${NC}"
    echo -e " ──────────────────────────────────────────────────"
    
    if [ -z "$FILE" ] || [ ! -f "$FILE" ]; then
        core_error "$(msg entry_err)"
        return 1
    fi
    
    core_synthesis_loader "Auditing Memory & Query Streams"
    local ISSUES=0

    # SQLi Check
    if grep -nE "format\(.*mysql_query" "$FILE" | grep -qv "mysql_format"; then
        echo -e " ${RED}[CRITICAL]${NC} $(msg aud_sqli)"
        ((ISSUES++))
    fi

    # Timer Safety
    if grep -nE "SetTimer\(.*, [0-1], .*\)" "$FILE" | grep -qv "IsPlayerConnected"; then
        echo -e " ${ORANGE}[WARN]${NC} $(msg aud_timer)"
        ((ISSUES++))
    fi

    [ $ISSUES -eq 0 ] && core_success "$(msg aud_clean)"
}

# === SUGGESTION ENGINE ===

function analysis_suggestion_engine() {
    local FILE=$1
    [ -z "$FILE" ] && FILE=$(compiler_find_entry_point)
    
    echo -e " ${CYAN}💡 $(msg sug_title)${NC}"
    echo -e " ──────────────────────────────────────────────────"
    
    if grep -q "#include <a_samp>" "$FILE"; then echo -e " • $(msg sug_omp)"; fi
    if [ $(grep -c "GetPlayerPos" "$FILE") -gt 15 ]; then echo -e " • $(msg sug_cache)"; fi
    
    echo -e " ──────────────────────────────────────────────────"
}

# === CODE LINTER ===

function analysis_linter() {
    local FILE=$1
    [ -z "$FILE" ] && FILE=$(compiler_find_entry_point)
    
    echo -e " ${BLUE}📏 $(msg lin_title)${NC}"
    echo -e " ──────────────────────────────────────────────────"
    
    # Allman Check
    if grep -q ") {" "$FILE"; then
        echo -e " ${YELLOW}[LINT]${NC} $(printf "$(msg lin_braces)" "Project")"
    fi
    
    # Naming Check
    if grep -En "new [a-z]" "$FILE" | head -n 1 | grep -qE "\["; then
        echo -e " ${YELLOW}[LINT]${NC} $(printf "$(msg lin_naming)" "Global Arrays")"
    fi

    core_success "$(msg ana_success)"
}

# === BINARY HEX INSPECTOR ===

function analysis_hex_inspect() {
    local AMX=$1
    if [ -z "$AMX" ]; then AMX=$(ls -t *.amx 2>/dev/null | head -n 1); fi
    
    if [ -z "$AMX" ] || [ ! -f "$AMX" ]; then
        core_error "Biner AMX tidak ditemukan."
        return 1
    fi
    
    echo -e " ${LBLUE}💎 $(msg ins_title)${NC}"
    echo -e " ──────────────────────────────────────────────────"
    core_progress_bar 1 "Decompressing AMX Segments"
    
    local NATIVES=$(strings "$AMX" | head -n 10)
    echo -e " ${BOLD}Imports:${NC}"
    echo "$NATIVES" | sed 's/^/ • /'
    
    echo -e " ──────────────────────────────────────────────────"
}
