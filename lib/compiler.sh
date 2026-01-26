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
        core_error "Invalid target file: $FILE"
        return 1
    }
    
    [ ! -f "$FILE" ] && {
        core_error "File not found: $FILE"
        return 1
    }
    
    local FDIR="$(dirname "$FILE")"
    
    # Auto-detect profile
    if [ "$PROFILE" = "auto" ]; then
        PROFILE=$(compiler_detect_profile "$FILE")
        core_info "Detected profile: $PROFILE"
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
    echo -e "${BLUE}[Compiler]${NC} Building ${CYAN}$FILE${NC} with $ENGINE ($PROFILE)..."
    
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
    
    # Colorize output
    cat "$OUT" | sed -u \
        -e "s/error \([0-9]\{3\}\)/\x1b[1;31merror \1\x1b[0m/g" \
        -e "s/warning \([0-9]\{3\}\)/\x1b[1;33mwarning \1\x1b[0m/g"
    
    # Auto-Ignition
    if [ $STATUS -eq 0 ] && [ "$AUTO_IGNITE" == "ON" ]; then
        echo -e "${GREEN}[Ignite]${NC} Compilation successful. Launching server..."
        compiler_server_runner
    fi
    
    return $STATUS
}

# === SERVER RUNNER ===

function compiler_server_runner() {
    local BINARY=""
    [ -f "./omp-server" ] && BINARY="./omp-server"
    [ -f "./samp03svr" ] && BINARY="./samp03svr"
    
    if [ -z "$BINARY" ]; then
        core_warning "No server binary found (omp-server or samp03svr)"
        return 1
    fi
    
    export LD_LIBRARY_PATH=".:$LD_LIBRARY_PATH"
    echo -e "${GREEN}[Server]${NC} Starting $BINARY..."
    "$BINARY" 2>&1 | sed -u \
        -e "s/error.*/${RED}&${NC}/i" \
        -e "s/info.*/${GREEN}&${NC}/i"
}

# === LIBRARY UPDATER ===

function compiler_library_updater() {
    local TD="include"
    [ -d "pawno/include" ] && TD="pawno/include"
    mkdir -p "$TD" "$FPAWN_CACHE_DIR"
    
    echo -e "${BLUE}[Refresher]${NC} Synchronizing core distribution..."
    
    curl -L -s -o "$FPAWN_CACHE_DIR/open.mp.inc" \
        "https://raw.githubusercontent.com/openmultiplayer/open.mp-stdlib/master/open.mp.inc"
    curl -L -s -o "$FPAWN_CACHE_DIR/a_samp.inc" \
        "https://raw.githubusercontent.com/pawn-lang/samp-stdlib/master/a_samp.inc"
    
# === WATCH MODE (LIVE RELOAD) ===

function compiler_watch_mode() {
    local TARGET=$1
    [ -z "$TARGET" ] && TARGET=$(compiler_find_entry_point)
    [ -z "$TARGET" ] && { core_error "No target file found to watch."; return 1; }

    echo -e "${BLUE}[Watch]${NC} Live Reload Engine Active for ${CYAN}$TARGET${NC}"
    echo -e "${BLUE}[Watch]${NC} Monitoring project for changes... (Press Ctrl+C to stop)"

    # Trap Ctrl+C to exit cleanly
    trap "echo -e '\n${YELLOW}[Watch]${NC} Engine de-activated.'; return" SIGINT

    local LAST_HASH=""
    
    if command -v inotifywait &> /dev/null; then
        echo -e "${GREEN}[Mode]${NC} High-Performance (inotify)"
        while true; do
            inotifywait -r -e modify,create,delete --exclude '\.amx$' . 2>/dev/null
            echo -e "${BLUE}[Event]${NC} Change detected. Debouncing..."
            sleep 0.5
            compiler_execute "auto" "auto" "$TARGET"
        done
    else
        echo -e "${YELLOW}[Mode]${NC} Standard Polling (No inotify-tools)"
        while true; do
            # Generate a hash of modification times for .pwn and .inc files
            local CURRENT_HASH=$(find . -maxdepth 3 \( -name "*.pwn" -o -name "*.inc" \) -printf "%T@ %p\n" | md5sum)
            
            if [ "$LAST_HASH" != "" ] && [ "$CURRENT_HASH" != "$LAST_HASH" ]; then
                echo -e "${BLUE}[Event]${NC} Modification detected. Syncing..."
                compiler_execute "auto" "auto" "$TARGET"
            fi
            
            LAST_HASH="$CURRENT_HASH"
            sleep 1
        done
    fi
}
