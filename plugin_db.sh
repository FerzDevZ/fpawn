#!/bin/bash
# fpawn Plugin Database - v19.0
# Comprehensive Plugin Registry for SA:MP Legacy & Open.MP

# Format: "name|category|compat|url|description|dependencies"
# Compat: Legacy, OMP, Both

PLUGIN_DATABASE=(
    # === CORE / ESSENTIAL ===
    "crashdetect|Core|Both|https://github.com/Zeex/samp-plugin-crashdetect|Debug runtime errors and crashes|"
    "sscanf|Core|Both|https://github.com/Y-Less/sscanf|Parse command parameters efficiently|"
    "streamer|World|Both|https://github.com/samp-incognito/samp-streamer-plugin|Stream objects, pickups, labels beyond limits|"
    "mysql|Database|Legacy|https://github.com/pBlueG/SA-MP-MySQL|MySQL database connector (BlueG)|"
    "nativechecker|Core|Both|https://github.com/openmultiplayer/nativechecker|Check for missing natives|"
    "profiler|Core|Both|https://github.com/Zeex/samp-plugin-profiler|Performance profiling and optimization|"
    
    # === LEGACY SA:MP CORE ===
    "YSF|Core|Legacy|https://github.com/IllidanS4/YSF|Yet Another SA:MP Functions - Extended natives|"
    "SKY|Core|Legacy|https://github.com/oscar-broman/SKY|Low-level memory access|"
    "fixes|Core|Legacy|https://github.com/ziggi/FIXES|Fix SA:MP bugs and glitches|"
    "TimerFix|Core|Legacy|https://github.com/ziggi/timerfix|Fix timer accuracy issues|"
    "samp-precise-timers|Core|OMP|https://github.com/bmisiak/samp-precise-timers|High-precision timers|"
    "native-fallback|Core|OMP|https://github.com/pawn-lang/samp-native-fallback|Fallback for missing natives|"
    
    # === WORLD / MAPPING ===
    "MapAndreas|World|Legacy|https://github.com/Southclaws/samp-MapAndreas|Get ground Z coordinate|"
    "ColAndreas|World|Legacy|https://github.com/Pottus/ColAndreas|Collision detection and physics|"
    "PathFinder|World|Legacy|https://github.com/AbyssMorgan/SA-MP-PathFinder|GPS routing system|"
    "FCNPC|World|Legacy|https://github.com/ziggi/FCNPC|Advanced NPC with AI|"
    "textdraw-streamer|World|Legacy|https://github.com/kristoisberg/samp-td-streamer|Stream unlimited textdraws|"
    "samp-gps|World|OMP|https://github.com/kristoisberg/samp-gps-plugin|GPS and navigation system|"
    "samp-3d-tryg|World|Both|https://github.com/nykez/samp-3d-tryg|3D text labels advanced|"
    "actor-streamer|World|OMP|https://github.com/Dayrion/actor_plus|Enhanced actor system|"
    
    # === DATABASE ===
    "sqlite|Database|Legacy|https://github.com/pBlueG/SA-MP-SQLitei|SQLite database support|"
    "pawn-redis|Database|OMP|https://github.com/Southclaws/pawn-redis|Redis database connector|"
    "mongodb|Database|Legacy|https://github.com/Sasino97/samp-mongodb-plugin|MongoDB connector|"
    "postgresql|Database|Legacy|https://github.com/urShadow/pgsql-plugin|PostgreSQL connector|"
    
    # === SECURITY / CRYPTO ===
    "sampac|Security|Legacy|https://github.com/Fairfox-Astramore/sampac-server|Official anti-cheat (outdated)|"
    "bcrypt|Security|Both|https://github.com/LassiAarni/samp-bcrypt|bcrypt password hashing|"
    "whirlpool|Security|Legacy|https://github.com/Southclaws/pawn-whirlpool|Whirlpool hashing algorithm|"
    "SHA512|Security|Legacy|https://github.com/paulomart/SHA512|SHA512 hashing|"
    "MD5|Security|Legacy|https://github.com/P3ti/MD5|MD5 hashing|"
    "encrypt|Security|Legacy|https://github.com/maddinat0r/samp-encrypt|Basic encryption utilities|"
    "samp-crypto|Security|OMP|https://github.com/Hreesang/samp-crypto|Modern crypto (Argon2, scrypt)|"
    "totp|Security|OMP|https://github.com/Southclaws/pawn-totp|Two-factor authentication|"
    
    # === NETWORK / ADVANCED ===
    "Pawn.Raknet|Network|Legacy|https://github.com/katursis/Pawn.RakNet|RakNet packet hooking|"
    "RakNet|Network|Legacy|https://github.com/Loggi/SA-MP-RakNet|Low-level networking|"
    "KeyListener|Network|Legacy|https://github.com/Codeusa/Pawn-KeyListener|Client keypress detection|"
    "socket|Network|Legacy|https://github.com/d0p3t/samp-socket|TCP/UDP sockets|"
    "pawn-requests|Network|OMP|https://github.com/Southclaws/pawn-requests|HTTP client for API calls|"
    "curl|Network|Legacy|https://github.com/Luneotm/samp-curl|cURL wrapper for HTTP|"
    
    # === OPEN.MP EXCLUSIVE ===
    "PawnPlus|Language|OMP|https://github.com/IllidanS4/PawnPlus|Advanced Pawn language extensions|"
    "pawn-json|Utility|OMP|https://github.com/Southclaws/pawn-json|JSON parsing and encoding|sampson"
    "pawn-regex|Utility|OMP|https://github.com/Southclaws/pawn-regex|Regular expressions|"
    "pawn-memory|Utility|OMP|https://github.com/BigETI/pawn-memory|Memory manipulation|"
    "chrono|Utility|OMP|https://github.com/Southclaws/chrono|Date and time utilities|"
    "rustext|Language|OMP|https://github.com/ziggi/rustext|Russian text support|"
    "SAMPSON|Utility|Both|https://github.com/Southclaws/SAMPSON|JSON library alternative|"
    "filemanager|Utility|OMP|https://github.com/JaTochNietDan/samp-filemanager|Advanced file operations|"
    "pawn-xml|Utility|OMP|https://github.com/Southclaws/pawn-xml|XML parser|"
    "pawn-csv|Utility|OMP|https://github.com/Southclaws/pawn-csv|CSV file handling|"
    
    # === INTEGRATION / CONNECTORS ===
    "discord-connector|Integration|Both|https://github.com/maddinat0r/samp-discord-connector|Discord bot integration|"
    "telegram-connector|Integration|OMP|https://github.com/Kirima2nd/samp-telegram-connector|Telegram bot integration|"
    "IRC|Integration|Legacy|https://github.com/samp-incognito/samp-irc-plugin|IRC chat integration|"
    "TeamSpeak|Integration|Legacy|https://github.com/urShadow/Pawn.CMD|TeamSpeak connector|"
    "websocket|Integration|OMP|https://github.com/Southclaws/pawn-websocket|WebSocket support|"
    
    # === CLIENT / MODERN FEATURES ===
    "SAMPVOICE|Audio|Both|https://github.com/CyberMor/sampvoice|Voice chat system|"
    "samp-cef|UI|Legacy|https://github.com/ZOTTCE/samp-cef|Browser CEF for custom UI|"
    "CHandling|Gameplay|Legacy|https://github.com/Freaksken/samp-chandling|Custom vehicle handling|"
    "samp-plus|Mod|Both|https://github.com/urShadow/Pawn.CMD|SA:MP+ client mod|"
    "samp-js|Language|OMP|https://github.com/samp-dev/samp-js|JavaScript gamemode support|"
    "AudioPlugin|Audio|Legacy|https://github.com/WopsS/samp-audio-plugin|Audio streaming|"
    
    # === UTILITY LIBRARIES ===
    "Pawn.CMD|Utility|Both|https://github.com/urShadow/Pawn.CMD|Fast command processor|"
    "foreach|Utility|Both|https://github.com/karimcambridge/SAMP-foreach|Efficient player loops|"
    "log-core|Utility|OMP|https://github.com/pawn-lang/samp-log-core|Advanced logging system|"
    "progress-bar|Utility|Both|https://github.com/Southclaws/progress2|Visual progress bars|"
    "samp-logger|Utility|Both|https://github.com/maddinat0r/samp-log-core|Enhanced logging|"
    "format|Utility|Both|https://github.com/Southclaws/formatex|Extended formatting|"
    
    # === GAMEPLAY ENHANCEMENTS ===
    "weapons|Gameplay|Both|https://github.com/oscar-broman/Weapon-Config|Weapon damage config|"
    "attachments|Gameplay|Both|https://github.com/Southclaws/samp-attachments|Object attachments|"
    "animations|Gameplay|Both|https://github.com/Southclaws/pawn-animations|Animation library|"
    "damage-system|Gameplay|Both|https://github.com/Southclaws/samp-damage|Advanced damage|"
    "anti-cheat|Gameplay|Both|https://github.com/NexiusTailer/Anticheat-System|Anti-cheat base|"
    "admin-system|Gameplay|Both|https://github.com/Southclaws/pawn-admin|Admin framework|"
    
    # === VISUAL / UI ===
    "textdraw-editor|UI|Both|https://github.com/Nickk888SAMP/TextDraw-Editor|In-game TD editor|"
    "dialog-pages|UI|Both|https://github.com/Southclaws/pawn-dialog-pages|Paginated dialogs|"
    "inv-system|UI|Both|https://github.com/Bren828/inventory-SAMP|Inventory system|"
    "hud-system|UI|Both|https://github.com/Southclaws/samp-hud|Custom HUD|"
    
    # === ADVANCED SYSTEMS ===
    "vehicle-damage|System|Both|https://github.com/Southclaws/samp-vehicle-damage|Vehicle damage|"
    "racing|System|Both|https://github.com/Southclaws/samp-racing|Racing system|"
    "housing|System|Both|https://github.com/Southclaws/samp-housing|Housing system|"
    "jobs|System|Both|https://github.com/Southclaws/samp-jobs|Job framework|"
    "businesses|System|Both|https://github.com/Southclaws/samp-business|Business system|"
)

# Get plugin info by name
function get_plugin_info() {
    local NAME=$1
    for PLUGIN in "${PLUGIN_DATABASE[@]}"; do
        local PNAME=$(echo "$PLUGIN" | cut -d'|' -f1)
        [[ "$PNAME" == "$NAME" ]] && echo "$PLUGIN" && return 0
    done
    return 1
}

# List plugins by category
function list_by_category() {
    local CAT=$1
    for PLUGIN in "${PLUGIN_DATABASE[@]}"; do
        local PCAT=$(echo "$PLUGIN" | cut -d'|' -f2)
        [[ "$PCAT" == "$CAT" ]] && echo "$PLUGIN"
    done
}

# List plugins by compatibility
function list_by_compat() {
    local COMPAT=$1
    for PLUGIN in "${PLUGIN_DATABASE[@]}"; do
        local PCOMPAT=$(echo "$PLUGIN" | cut -d'|' -f3)
        [[ "$PCOMPAT" == "$COMPAT" ]] || [[ "$PCOMPAT" == "Both" ]] && echo "$PLUGIN"
    done
}
