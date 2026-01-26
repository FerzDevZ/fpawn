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
    echo -e "${BLUE}[Architect]${NC} Casting Modular Foundation..."
    
    local NAME="gm_modular"
    read -p " Project Name: " PNAME
    [ -n "$PNAME" ] && NAME=$PNAME
    
    # Create structure
    mkdir -p "$NAME/core" "$NAME/modules" "$NAME/src" "$NAME/include"
    
    # Generate main file
    cat > "$NAME/src/main.pwn" <<EOF
#include <open.mp>

main() {
    print("----------------------------------");
    print(" Modular Project: $NAME v19.0    ");
    print(" Powered by FerzDevZ fpawn        ");
    print("----------------------------------");
}
EOF
    
    core_success "Modular structure '$NAME' generated"
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
