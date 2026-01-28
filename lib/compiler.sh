#!/bin/bash
# fpawn Compiler Module - v19.0
# Compilation Engine and Build Management

# === ENTRY POINT DETECTION ===

function compiler_find_entry_point() {
    [ -f "main.pwn" ] && { echo "main.pwn"; return 0; }
    [ -f "src/main.pwn" ] && { echo "src/main.pwn"; return 0; }
    [ -f "gamemodes/main.pwn" ] && { echo "gamemodes/main.pwn"; return 0; }
    local ANY=$(find . -maxdepth 2 -name "*.pwn" 2>/dev/null | head -n 1 | sed 's|^./||')
    [ -n "$ANY" ] && echo "$ANY" && return 0
    return 1
}

# === MATRIX BUILD ===

function compiler_matrix_build() {
    local TARGET=$1
    [ -z "$TARGET" ] && TARGET=$(compiler_find_entry_point)
    
    echo -e " ${LBLUE}📑 $(msg mat_title)${NC}"
    echo -e " ──────────────────────────────────────────────────"
    
    local PROFILES=("qawno" "pawno")
    local PLATFORMS=("linux" "windows")
    local SUCCESS_COUNT=0
    local TOTAL=4
    local CUR=0
    
    core_progress_bar 2 "Matrix Integrity Check"

    for PROF in "${PROFILES[@]}"; do
        for PLAT in "${PLATFORMS[@]}"; do
            ((CUR++))
            echo -ne " [${CUR}/${TOTAL}] $(printf "$(msg mat_checking)" "${BOLD}$PROF${NC}" "${CYAN}$PLAT${NC}") ... "
            
            # Executing build in parallel subshell with progress indicator
            (compiler_execute "$PROF" "$PLAT" "$TARGET" >/dev/null 2>&1) & core_loading_spinner
            
            if [ $? -eq 0 ]; then
                echo -e "${GREEN}OK${NC}"
                ((SUCCESS_COUNT++))
            else
                echo -e "${RED}FAIL${NC}"
                echo -e " ${RED}[!]${NC} $(printf "$(msg mat_failed)" "$PROF-$PLAT")"
            fi
        done
    done
    
    echo -e " ──────────────────────────────────────────────────"
    if [ $SUCCESS_COUNT -eq $TOTAL ]; then
        core_success "$(msg mat_success)"
    else
        core_warning "Matrix check failed. $(($TOTAL - $SUCCESS_COUNT)) target(s) incompatible."
    fi
}

# === MICRO BENCHMARKING ===

function compiler_micro_bench() {
    local LOGIC="$1"
    if [ -z "$LOGIC" ]; then
        core_error "No logic provided for benchmarking."
        return 1
    fi
    
    echo -e " ${MAGENTA}⏱️ $(msg ben_title)${NC}"
    echo -e " ──────────────────────────────────────────────────"
    
    local BFILE="/tmp/fpawn_bench.pwn"
    local ITERATIONS=1000000
    
    # Generate temporary benchmarking script
    cat > "$BFILE" <<EOF
#include <open.mp>
#include <time>

main() {
    new start = GetTickCount();
    for(new i = 0; i < $ITERATIONS; i++) {
        $LOGIC
    }
    new end = GetTickCount();
    printf("BENCH_RESULT|%d|%d\n", $ITERATIONS, end - start);
}
EOF
    
    echo -ne " $(msg ben_start) "
    
    # Compile and Run with spinner
    local OUTPUT=$( (compiler_execute "qawno" "linux" "$BFILE" 2>/dev/null | grep "BENCH_RESULT") & core_loading_spinner )
    
    if [ -z "$OUTPUT" ]; then
        core_error "Benchmarking script failed to execute."
        return 1
    fi
    
    local ITERS=$(echo "$OUTPUT" | cut -d'|' -f2)
    local TIME=$(echo "$OUTPUT" | cut -d'|' -f3)
    
    # Avoid div by zero
    [ -z "$TIME" ] || [ "$TIME" -lt 1 ] && TIME=1
    
    local NS_PER_ITER=$(( (TIME * 1000000) / ITERS ))
    
    echo -e " ──────────────────────────────────────────────────"
    core_success "$(printf "$(msg ben_result)" "$ITERS" "$TIME" "$NS_PER_ITER")"
    
    rm -f "$BFILE" "/tmp/fpawn_bench.amx"
}

# === PROFILE DETECTION ===

function compiler_detect_profile() {
    local FILE=$1
    local FDIR="$(dirname "$FILE")"
    
    if [ -f "pawn.json" ] || [ -f "$FDIR/pawn.json" ] || [ -f "$FDIR/../pawn.json" ]; then
        echo "omp"
    else
        echo "legacy"
    fi
}

# === MAIN COMPILER ===

function compiler_execute() {
    local ENGINE=$1
    local PROFILE=$2
    shift 2
    local FILE="${!#}"
    local ARGS=()
    [ $# -gt 1 ] && ARGS=("${@:1:$#-1}")
    
    # Validate input
    [[ "$FILE" != *.pwn ]] && {
        core_error "$(printf "$(msg com_invalid_target)" "$FILE")"
        return 1
    }
    
    [ ! -f "$FILE" ] && {
        core_error "$(printf "$(msg com_file_not_found)" "$FILE")"
        return 1
    }
    
    local FDIR="$(dirname "$FILE")"
    
    # Auto-detect profile
    if [ "$PROFILE" = "auto" ]; then
        PROFILE=$(compiler_detect_profile "$FILE")
        core_info "$(printf "$(msg com_detect_profile)" "$PROFILE")"
    fi
    
    # Auto-select engine
    if [ "$ENGINE" = "auto" ]; then
        [ "$PROFILE" = "omp" ] && ENGINE="qawno" || ENGINE="pawno"
    fi
    
    # Build include flags
    local OUT="/tmp/fpawn_out.log"
    local INC_FLAGS=("-i$FPAWN_GLOBAL_INC")
    
    if [ "$PROFILE" = "omp" ]; then
        INC_FLAGS+=("-iinclude" "-idependencies" "-i$FDIR/../include" "-i$FPAWN_CACHE_DIR")
    else
        INC_FLAGS+=("-ipawno/include" "-iinclude" "-i$FPAWN_CACHE_DIR")
    fi
    
    # Execute compilation
    echo -e "${BLUE}[Compiler]${NC} $(printf "$(msg com_building)" "$FILE" "$ENGINE" "$PROFILE")"
    
    # v21.0: Auto-Snapshot
    tools_safeguard_snapshot "$FILE"
    
    local START_TIME=$(date +%s%N)
    local STATUS
    if [ "$ENGINE" = "qawno" ]; then
        chmod +x "$FPAWN_QAWNO_DIR/pawncc" 2>/dev/null
        export LD_LIBRARY_PATH="$FPAWN_QAWNO_DIR:$LD_LIBRARY_PATH"
        "$FPAWN_QAWNO_DIR/pawncc" "$FILE" "${ARGS[@]}" "${INC_FLAGS[@]}" "-i$FPAWN_QAWNO_DIR/include" "-;+" > "$OUT" 2>&1
        STATUS=$?
    else
        wine "$FPAWN_PAWNO_DIR/pawncc.exe" "$FILE" "${ARGS[@]}" "${INC_FLAGS[@]}" "-i$FPAWN_PAWNO_DIR/include" > "$OUT" 2>&1
        STATUS=$?
    fi
    local END_TIME=$(date +%s%N)
    local DURATION=$(( (END_TIME - START_TIME) / 1000000 )) # ms
    
    # Log metrics
    local AMX_FILE="${FILE%.*}.amx"
    local AMX_SIZE=0
    [ -f "$AMX_FILE" ] && AMX_SIZE=$(stat -c%s "$AMX_FILE")
    
    echo "$FILE|$AMX_SIZE|$DURATION|$(date +%s)" >> "$HOME/.ferzdevz/fpawn/builds.log"
    
    # Colorize output
    cat "$OUT" | sed -u \
        -e "s/error \([0-9]\{3\}\)/\x1b[1;31merror \1\x1b[0m/g" \
        -e "s/warning \([0-9]\{3\}\)/\x1b[1;33mwarning \1\x1b[0m/g"
    
    # Auto-Ignition
    if [ $STATUS -eq 0 ] && [ "$AUTO_IGNITE" == "ON" ]; then
        echo -e "${GREEN}[Ignite]${NC} $(msg com_ignite_success)"
        compiler_server_runner
    fi
    
    return $STATUS
}

# === SERVER RUNNER ===

# === SERVER RUNNER ===

function compiler_server_runner() {
    local BACKGROUND=$1
    local BINARY=""
    [ -f "./omp-server" ] && BINARY="./omp-server"
    [ -f "./samp03svr" ] && BINARY="./samp03svr"
    
    if [ -z "$BINARY" ]; then
        core_warning "$(msg srv_missing_bin)"
        return 1
    fi
    
    # Kill previous
    pkill -f "$BINARY" 2>/dev/null
    
    export LD_LIBRARY_PATH=".:$LD_LIBRARY_PATH"
    echo -e "${GREEN}[Server]${NC} $(printf "$(msg srv_starting)" "$BINARY")"
    
    if [ "$BACKGROUND" == "BG" ]; then
        "$BINARY" > server_log.txt 2>&1 &
        local SPID=$!
        echo "$SPID" > .server.pid
        echo -e "${LBLUE}[Daemon]${NC} Server running in background (PID: $SPID)"
    else
        "$BINARY" 2>&1 | sed -u \
            -e "s/error.*/${RED}&${NC}/i" \
            -e "s/info.*/${GREEN}&${NC}/i"
    fi
}

# === LIBRARY UPDATER ===

function compiler_library_updater() {
    local TD="include"
    [ -d "pawno/include" ] && TD="pawno/include"
    mkdir -p "$TD" "$FPAWN_CACHE_DIR"
    
    echo -e "${BLUE}[Refresher]${NC} $(msg ref_syncing)"
    
    # Official Standalones
    curl -L -s -o "$FPAWN_CACHE_DIR/open.mp.inc" \
        "https://raw.githubusercontent.com/openmultiplayer/open.mp-stdlib/master/open.mp.inc"
    curl -L -s -o "$FPAWN_CACHE_DIR/a_samp.inc" \
        "https://raw.githubusercontent.com/pawn-lang/samp-stdlib/master/a_samp.inc"
        
    cp "$FPAWN_CACHE_DIR/"* "$TD/" 2>/dev/null
    echo -e "${GREEN}[Success]${NC} Core includes synced."
}

# === WATCH MODE (LIVE RELOAD) ===

function compiler_watch_mode() {
    local TARGET=$1
    [ -z "$TARGET" ] && TARGET=$(compiler_find_entry_point)
    [ -z "$TARGET" ] && { core_error "$(msg ana_fail)"; return 1; }

    ui_show_header
    echo -e "${BLUE}⚡ $(msg menu_3) (Active)${NC}"
    echo -e " ──────────────────────────────────────────────────"
    echo -e " ${BOLD}Monitoring:${NC} $TARGET (and dependants)"
    echo -e " ${BOLD}Auto-Ignition:${NC} $AUTO_IGNITE"
    echo -e " ──────────────────────────────────────────────────"

    # Trap Ctrl+C to exit cleanly
    trap "echo -e '\n${YELLOW}[Watch]${NC} $(msg wat_deactivated)'; return" SIGINT

    local LAST_HASH=""
    
    # Use standard loop for compatibility (inotifywait is optional)
    while true; do
        # Generate hash of modification times
        local CURRENT_HASH=$(find . -maxdepth 3 \( -name "*.pwn" -o -name "*.inc" \) -printf "%T@ %p\n" | md5sum)
        
        if [ "$LAST_HASH" != "" ] && [ "$CURRENT_HASH" != "$LAST_HASH" ]; then
            echo -e "\n${BLUE}🔄 $(msg wat_sync)${NC}"
            
            # Recompile
            compiler_execute "auto" "auto" "$TARGET"
            local STATUS=$?
            
            # Restart Server if Ignite ON and Compile Success
            if [ $STATUS -eq 0 ] && [ "$AUTO_IGNITE" == "ON" ]; then
                compiler_server_runner "BG"
            fi
            
            echo -e " ${LBLUE}⚡ Waiting for changes...${NC}"
        else
            if [ "$LAST_HASH" == "" ]; then
                 echo -e " ${LBLUE}⚡ Waiting for changes...${NC}"
            fi
        fi
        
        LAST_HASH="$CURRENT_HASH"
        sleep 2
    done
}
