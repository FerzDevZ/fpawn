#!/bin/bash
# fpawn Search Module - v19.0
# Marketplace, Neural Search, and Repository Management

# === MARKETPLACE HUB ===

function search_marketplace_hub() {
    echo -e " ${LBLUE}🌌 fpawn Marketplace - Synthesis Catalog${NC}"
    
    # Show last search from history
    [ -f "$HOME/.ferzdevz/fpawn/history" ] && \
        echo -e " ${BOLD}Last Search:${NC} $(tail -n 1 "$HOME/.ferzdevz/fpawn/history" 2>/dev/null)"
    
    echo -e " [1] openmultiplayer/open.mp-stdlib (Core Library)"
    echo -e " [2] samp-incognito/samp-streamer-plugin (Streamer)"
    echo -e " [3] pBlueG/SA-MP-MySQL (Database)"
    echo -e " [4] Y-Less/sscanf (Parser)"
    echo -e " [5] Search Custom Galaxy..."
    echo ""
    read -p " Select ID: " MCHOICE
    
    case $MCHOICE in
        1) search_repo_cloner "https://github.com/openmultiplayer/open.mp-stdlib" "open.mp-stdlib" ;;
        2) search_repo_cloner "https://github.com/samp-incognito/samp-streamer-plugin" "streamer" ;;
        3) search_repo_cloner "https://github.com/pBlueG/SA-MP-MySQL" "mysql" ;;
        4) search_repo_cloner "https://github.com/Y-Less/sscanf" "sscanf" ;;
        5) read -p " Keywords: " S; core_neural_memory_sync "$S"; search_dynamic_search "$S" ;;
        *) return ;;
    esac
}

# === NEURAL SEARCH ENGINE ===

function search_dynamic_search() {
    local QUERY=$1
    echo -e "${BLUE}[Neural]${NC} Accessing GitHub Vault with Intelligent Ranking..."
    
    local JSON=$(curl -s "https://api.github.com/search/repositories?q=${QUERY}+pawn+language:Pawn&sort=stars&per_page=50")
    
    # Curated repos to filter out
    local CURATED=("openmultiplayer/open.mp-stdlib" "samp-incognito/samp-streamer-plugin" "pBlueG/SA-MP-MySQL" "Y-Less/sscanf")
    
    # Parse and score
    local SCORED=""
    while IFS= read -r ITEM; do
        local FNAME=$(echo "$ITEM" | jq -r '.full_name')
        local FURL=$(echo "$ITEM" | jq -r '.html_url')
        local FDESC=$(echo "$ITEM" | jq -r '.description // ""')
        local STARS=$(echo "$ITEM" | jq -r '.stargazers_count // 0')
        
        # Skip curated duplicates
        local SKIP=false
        for CUR in "${CURATED[@]}"; do
            [[ "$FNAME" == "$CUR" ]] && SKIP=true && break
        done
        $SKIP && continue
        
        # Calculate relevance score
        local SCORE=0
        local RNAME="${FNAME#*/}"
        [[ "${RNAME,,}" == "${QUERY,,}" ]] && SCORE=$((SCORE + 20))
        [[ "${RNAME,,}" == *"${QUERY,,}"* ]] && SCORE=$((SCORE + 10))
        [[ "${FDESC,,}" == *"${QUERY,,}"* ]] && SCORE=$((SCORE + 3))
        SCORE=$((SCORE + STARS / 100))
        
        SCORED+="${SCORE}|${FNAME}|${FURL}|${FDESC}|${RNAME}\n"
    done < <(echo "$JSON" | jq -c '.items[]' 2>/dev/null)
    
    # Sort and take top 10
    local RESULTS=$(echo -e "$SCORED" | sort -t'|' -k1 -rn | head -n 10)
    
    if [ -z "$RESULTS" ]; then
        core_warning "No repositories found for '${CYAN}$QUERY${NC}'"
        return 1
    fi
    
    # Display results
    local i=1
    local URLS=()
    local NAMES=()
    
    IFS=$'\n'
    for RES in $RESULTS; do
        local SCORE=$(echo "$RES" | cut -d'|' -f1)
        local FNAME=$(echo "$RES" | cut -d'|' -f2)
        local FURL=$(echo "$RES" | cut -d'|' -f3)
        local FDESC=$(echo "$RES" | cut -d'|' -f4)
        local RNAME=$(echo "$RES" | cut -d'|' -f5)
        
        URLS+=( "$FURL" )
        NAMES+=( "$RNAME" )
        
        # Relevance indicator
        local REL="⭐"
        [[ $SCORE -gt 15 ]] && REL="⭐⭐"
        [[ $SCORE -gt 25 ]] && REL="⭐⭐⭐"
        
        echo -e " [$i] ${REL} ${BOLD}${CYAN}$FNAME${NC}"
        [ -n "$FDESC" ] && [[ "$FDESC" != "null" ]] && \
            echo -e "     ${MAGENTA}Note:${NC} $FDESC"
        echo -e "     ${BLUE}Link:${NC} $FURL"
        ((i++))
    done
    unset IFS
    
    read -p " Index to Clone [1-10]: " PICK
    if [[ "$PICK" =~ ^[1-9]$|^10$ ]]; then
        search_repo_cloner "${URLS[$PICK-1]}" "${NAMES[$PICK-1]}"
    fi
}

# === REPOSITORY CLONER ===

function search_repo_cloner() {
    local URL=$1
    local NAME=$2
    
    echo -e "${BLUE}[Cloner]${NC} Syncing $NAME..."
    git clone --depth 1 "$URL" "$NAME"
    
    if [ $? -eq 0 ]; then
        core_success "$(msg success)"
        core_git_commit "Installed repository $NAME"
    else
        core_error "Failed to clone $NAME"
        return 1
    fi
}

# === SMART FINDER ===

function search_smart_finder() {
    local INC=$1
    local RESP=$(curl -s "https://api.github.com/search/code?q=filename:$INC+extension:inc")
    local URL=$(echo "$RESP" | grep -o "\"html_url\": \"[^\"]*\"" | head -n 1 | \
        sed 's/"html_url": //;s/"//g;s/github.com/raw.githubusercontent.com/;s/\/blob\//\//')
    
    if [ -n "$URL" ]; then
        mkdir -p "$FPAWN_CACHE_DIR"
        curl -L -s -o "$FPAWN_CACHE_DIR/$INC" "$URL"
        
        if [ -f "$FPAWN_CACHE_DIR/$INC" ] && ! head -n 1 "$FPAWN_CACHE_DIR/$INC" | grep -q "404:"; then
            cp "$FPAWN_CACHE_DIR/$INC" "include/"
            return 0
        fi
    fi
    return 1
}
