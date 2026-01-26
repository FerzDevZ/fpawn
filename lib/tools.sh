#!/bin/bash
# fpawn Tools Module - v19.0
# Code Polisher, Template Architect, Snippet Sandbox

# === CODE POLISHER ===

function tools_code_polisher() {
    local TARGET=$1
    
    if [ -z "$TARGET" ]; then
        TARGET=$(compiler_find_entry_point)
    fi
    
    if [ -z "$TARGET" ] || [ ! -f "$TARGET" ]; then
        core_error "$(msg entry_err)"
        return 1
    fi
    
    echo -e "${CYAN}[Artisan]${NC} Polishing ${BOLD}$TARGET${NC} aesthetics..."
    
    local TEMP="/tmp/polisher_tmp.pwn"
    
    # Apply formatting
    cat "$TARGET" | \
        sed 's/^\s*//' | \
        sed 's/\s*$//' | \
        sed -E 's/([^ <>!=])=([^ =])/\1 = \2/g' | \
        sed 's/{/ {\n/g' | \
        sed 's/}/\n}\n/g' | \
        awk '{
            if ($0 ~ /}/) indent--;
            for (i=0; i<indent; i++) printf "    ";
            print $0;
            if ($0 ~ /{/) indent++;
        }' > "$TEMP"
    
    cp "$TEMP" "$TARGET"
    rm -f "$TEMP"
    
    core_success "$(msg success)"
    core_git_commit "Polished code for $TARGET"
}

# === ARCHITECT TEMPLATE ===

function tools_template_architect() {
    # Check for whiptail
    if ! command -v whiptail &> /dev/null; then
        core_error "Whiptail not found. Architecture selection requires whiptail."
        return 1
    fi

    local ARCH_CHOICE=$(whiptail --title "fpawn Architect" --menu "Select Project Architecture:" 15 60 2 \
        "Legacy" "Classic SA-MP structure (0.3.7)" \
        "Advanced" "Modern open.mp modular structure" 3>&1 1>&2 2>&3)

    [ -z "$ARCH_CHOICE" ] && return

    local NAME="new_project"
    read -p " Project Name: " PNAME
    [ -n "$PNAME" ] && NAME=$PNAME

    echo -e "${BLUE}[Architect]${NC} Casting $ARCH_CHOICE Foundation for ${CYAN}$NAME${NC}..."

    if [ "$ARCH_CHOICE" == "Legacy" ]; then
        # Legacy Structure
        mkdir -p "$NAME/src" "$NAME/include" "$NAME/plugins" "$NAME/gamemodes" "$NAME/filterscripts"
        
        # Legacy server.cfg
        cat > "$NAME/server.cfg" <<EOF
echo Executing Server Config...
lanmode 0
rcon_password change_me
maxplayers 50
port 7777
hostname SA-MP Legacy: $NAME
gamemode0 main 1
filterscripts 
plugins 
announce 0
chatlogging 0
weburl www.sa-mp.com
onfoot_rate 40
incar_rate 40
weapon_rate 40
stream_distance 300.0
stream_rate 1000
maxnpc 0
logtimeformat [%H:%M:%S]
language English
EOF

        # Legacy Main
        cat > "$NAME/src/main.pwn" <<EOF
#include <a_samp>

main() {
    print("----------------------------------");
    print(" Legacy Project: $NAME v19.3    ");
    print(" Powered by FerzDevZ fpawn        ");
    print("----------------------------------");
}
EOF
        core_success "Legacy SA-MP structure '$NAME' generated"
        
    else
        # Advanced (OMP) Structure
        mkdir -p "$NAME/core" "$NAME/modules" "$NAME/src" "$NAME/include" "$NAME/dependencies"
        
        # OMP pawn.json
        cat > "$NAME/pawn.json" <<EOF
{
    "user": "FerzDevZ",
    "repo": "$NAME",
    "entry": "src/main.pwn",
    "output": "gamemodes/main.amx",
    "dependencies": [
        "openmultiplayer/open.mp-stdlib"
    ]
}
EOF

        # OMP config.json
        cat > "$NAME/config.json" <<EOF
{
    "hostname": "open.mp server: $NAME",
    "gamemode": "main",
    "pawn": {
        "main_scripts": ["main"]
    }
}
EOF

        # OMP Main
        cat > "$NAME/src/main.pwn" <<EOF
#include <open.mp>

main() {
    print("----------------------------------");
    print(" Advanced Project: $NAME v19.3  ");
    print(" Powered by FerzDevZ fpawn        ");
    print("----------------------------------");
}
EOF
        core_success "Modular open.mp structure '$NAME' generated"
    fi
}

# === SNIPPET SANDBOX ===

function tools_snippet_sandbox() {
    echo -e "${MAGENTA}[Sandbox]${NC} Initiating Isolated Lab Environment..."
    
    local WORK_DIR=$(mktemp -d -t fpawn_sandbox.XXXXXX)
    cd "$WORK_DIR" || return 1
    
    mkdir include
    cp -r "$FPAWN_GLOBAL_INC/"* include/ 2>/dev/null
    
    # Generate sandbox file
    cat > sandbox.pwn <<EOF
#include <open.mp>

main() {
    print("----------------------------------");
    print(" fpawn NEBULA SANDBOX ONLINE      ");
    print(" Testing logic in isolation...    ");
    print("----------------------------------");
    
    // Write your test logic here
    
}
EOF
    
    echo -e "${BLUE}[Lab]${NC} Environment ready at ${CYAN}$WORK_DIR${NC}"
    echo -e "${YELLOW}[Action]${NC} Opening sandbox.pwn... (Exit to cleanup)"
    
    nano sandbox.pwn
    
    echo -e "${BLUE}[Compile]${NC} Testing sandbox synthesis..."
    compiler_execute "auto" "auto" "sandbox.pwn"
    
    cd - >/dev/null
    rm -rf "$WORK_DIR"
    core_success "Lab environment de-materialized"
}

# === SELF-UPDATE ===

function tools_self_update() {
    local REPO_URL="https://raw.githubusercontent.com/${REPO_OWNER}/${REPO_NAME}/main/fpawn"
    
    echo -e "${BLUE}[Update]${NC} Checking for newer version..."
    curl -L -s -o /tmp/fupd "$REPO_URL"
    
    if [ ! -f /tmp/fupd ]; then
        core_error "Failed to fetch update"
        return 1
    fi
    
    local NEW_VER=$(grep "Version:" /tmp/fupd | head -n 1 | awk '{print $3}')
    
    if [ "$NEW_VER" != "19.0" ] && [ -n "$NEW_VER" ]; then
        echo -e "${YELLOW}[Alert]${NC} New version detected: v$NEW_VER"
        echo -e "${YELLOW}[Alert]${NC} Upgrading..."
        cp /tmp/fupd "$FPAWN_BASE_DIR/fpawn"
        chmod +x "$FPAWN_BASE_DIR/fpawn"
        core_success "Updated to v$NEW_VER. Restart fpawn to apply."
        exit 0
    else
        core_success "Already running latest version (v19.0)"
    fi
}
