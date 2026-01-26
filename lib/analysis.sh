#!/bin/bash
# fpawn Analysis Module - v19.0
# Static Analysis, Diagnostics, and Project Scanning

# === STATIC ANALYST ===

function analysis_static_analyst() {
    local FILE=$(compiler_find_entry_point)
    
    if [ -z "$FILE" ]; then
        core_error "$(msg entry_err)"
        return 1
    fi
    
    echo -e "${BLUE}[Analyst]${NC} Deep-inspecting ${CYAN}$FILE${NC}..."
    
    # Check for main function
    if ! grep -q "main()" "$FILE"; then
        core_warning "Entry point 'main()' not found"
    fi
    
    # Count lines
    local LINES=$(wc -l < "$FILE" 2>/dev/null || echo "0")
    echo -e " [+] ${GREEN}Volume:${NC} $LINES lines of Pawn code"
    
    # Detect ecosystem
    if [ -f "pawn.json" ]; then
        echo -e " [i] ${CYAN}Context:${NC} Advanced open.mp ecosystem detected"
    elif [ -f "server.cfg" ]; then
        echo -e " [i] ${YELLOW}Context:${NC} Legacy SA-MP ecosystem detected"
    fi
    
    core_success "Analysis finalized"
}

# === NEURAL DIAGNOSE ===

function analysis_neural_diagnose() {
    local LOG="log.txt"
    [ -f "server_log.txt" ] && LOG="server_log.txt"
    
    echo -e "${ORANGE}[Neural]${NC} Scan-sweep ${CYAN}$LOG${NC} for signatures..."
    
    if [ ! -f "$LOG" ]; then
        core_error "Log file missing: $LOG"
        return 1
    fi
    
    if grep -q "Runtime error" "$LOG"; then
        echo -e "${RED}[Signature]${NC} Logic overflow identified"
        grep -A 5 "Runtime error" "$LOG" | tail -n 5
    elif grep -q "backtrace" "$LOG"; then
        echo -e "${RED}[Signature]${NC} Stacktrace detected"
        grep -B 2 -A 10 "backtrace" "$LOG" | tail -n 12
    else
        core_success "No critical anomalies detected"
    fi
}

# === PROJECT SCANNER (AUTOPILOT) ===

function analysis_project_scanner() {
    echo -e "${BLUE}[Autopilot]${NC} Scanning Neural Grids..."
    
    local MAIN_FILE=$(compiler_find_entry_point)
    if [ -z "$MAIN_FILE" ]; then
        core_error "$(msg entry_err)"
        return 1
    fi
    
    # Extract includes
    local INCS=$(grep "#include" "$MAIN_FILE" | \
        sed 's/.*<//;s/>.*//;s/.*"//;s/".*//' | sort -u)
    
    local MISSING_LIST=()
    local CORRUPT_LIST=()
    local SEARCH_PATHS=("include" "pawno/include" "dependencies" "$FPAWN_GLOBAL_INC" "$FPAWN_CACHE_DIR")
    
    # Scan each include
    for INC in $INCS; do
        # Skip built-in headers
        [[ "$INC" =~ ^(core|float|string|file|time|datagram|console)$ ]] && continue
        
        local FOUND=false
        local CORRUPT=false
        
        for PD in "${SEARCH_PATHS[@]}"; do
            if [ -f "$PD/$INC.inc" ]; then
                FOUND=true
                head -n 1 "$PD/$INC.inc" | grep -q "404:" && CORRUPT=true
                break
            fi
        done
        
        [ "$FOUND" = false ] && MISSING_LIST+=("$INC")
        [ "$CORRUPT" = true ] && CORRUPT_LIST+=("$INC")
    done
    
    # Report status
    if [ ${#MISSING_LIST[@]} -eq 0 ] && [ ${#CORRUPT_LIST[@]} -eq 0 ]; then
        core_success "System integrity verified"
        return 0
    fi
    
    # Show corrupted components
    [ ${#CORRUPT_LIST[@]} -gt 0 ] && \
        core_warning "Corrupted components: ${CORRUPT_LIST[*]}"
    
    # Offer repair
    read -p "Execute Repair? [y/N] " ANS
    if [[ "$ANS" == "y" ]]; then
        for M in "${MISSING_LIST[@]}" "${CORRUPT_LIST[@]}"; do
            rm -f "include/$M.inc" "$FPAWN_CACHE_DIR/$M.inc"
            
            # High-priority core libraries
            if [[ "$M" == "open.mp" ]] || [[ "$M" == "a_samp" ]] || [[ "$M" == "omp_version" ]]; then
                echo -e "${BLUE}[Repair]${NC} Restoring official distribution: $M..."
                compiler_library_updater
            else
                echo -e "${BLUE}[Sync]${NC} Restoring plugin: $M..."
                search_smart_finder "$M.inc" || search_dynamic_search "$M"
            fi
        done
    fi
}
