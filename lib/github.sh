#!/bin/bash
# fpawn GitHub API Module - v20.0
# Handles release scraping and asset downloads

# Fetch latest release data from GitHub API
# Usage: github_get_release_data "owner/repo"
function github_get_release_data() {
    local REPO=$1
    local API_URL="https://api.github.com/repos/$REPO/releases/latest"
    
    # Attempt to fetch
    local DATA=$(curl -s "$API_URL")
    
    if [[ "$DATA" == *"message\": \"Not Found"* ]]; then
        return 1
    fi
    
    echo "$DATA"
}

# Filter assets for binaries or archives
# Usage: github_filter_assets "$DATA" "linux"
function github_filter_assets() {
    local DATA=$1
    local OS=$2 # linux or windows
    
    local EXT="so"
    [[ "$OS" == "windows" ]] && EXT="dll"
    
    # Try to find an asset matching the extension or common archive formats
    echo "$DATA" | jq -r ".assets[] | select(.name | (endswith(\".$EXT\") or endswith(\".zip\") or endswith(\".tar.gz\") or endswith(\".tgz\"))) | .browser_download_url"
}

# Download asset to a specific directory
# Usage: github_download_asset "url" "dest_dir" "filename"
function github_download_asset() {
    local URL=$1
    local DEST=$2
    local FILE=$3
    
    mkdir -p "$DEST"
    echo -e "${BLUE}[GitHub]${NC} $(printf "$(msg git_downloading)" "${CYAN}$FILE${NC}")"
    curl -L -s -o "$DEST/$FILE" "$URL"
    
    if [ $? -eq 0 ]; then
        return 0
    else
        return 1
    fi
}
