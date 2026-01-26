#!/bin/bash
# fpawn Plugin Database - v19.0
# Comprehensive Plugin Registry for SA:MP Legacy & Open.MP

# Format: "name|category|compat|url|description|dependencies"
# Compat: Legacy, OMP, Both

PLUGIN_DATABASE=(
    # === CORE / ESSENTIAL ===
    "crashdetect|Core|Both|https://github.com/Zeex/samp-plugin-crashdetect.git|Debug runtime errors and crashes|"
    "sscanf|Core|Both|https://github.com/Y-Less/sscanf.git|Parse command parameters efficiently|"
    "streamer|World|Both|https://github.com/samp-incognito/samp-streamer-plugin.git|Stream objects, pickups, labels beyond limits|"
    "mysql|Database|Legacy|https://github.com/pBlueG/SA-MP-MySQL.git|MySQL database connector (BlueG)|"
    "nativechecker|Core|Both|https://github.com/openmultiplayer/nativechecker.git|Check for missing natives|"
    "profiler|Core|Both|https://github.com/Zeex/samp-plugin-profiler.git|Performance profiling and optimization|"
    
    # === LEGACY SA:MP CORE ===
    "YSF|Core|Legacy|https://github.com/IllidanS4/YSF.git|Yet Another SA:MP Functions - Extended natives|"
    "SKY|Core|Legacy|https://github.com/oscar-broman/SKY.git|Low-level memory access|"
    "fixes|Core|Legacy|https://github.com/ziggi/FIXES.git|Fix SA:MP bugs and glitches|"
    "TimerFix|Core|Legacy|https://github.com/ziggi/timerfix.git|Fix timer accuracy issues|"
    "samp-precise-timers|Core|OMP|https://github.com/bmisiak/samp-precise-timers.git|High-precision timers|"
    "native-fallback|Core|OMP|https://github.com/pawn-lang/samp-native-fallback.git|Fallback for missing natives|"
    
    # === WORLD / MAPPING ===
    "MapAndreas|World|Legacy|https://github.com/Southclaws/samp-MapAndreas.git|Get ground Z coordinate|"
    "ColAndreas|World|Legacy|https://github.com/Pottus/ColAndreas.git|Collision detection and physics|"
    "PathFinder|World|Legacy|https://github.com/AbyssMorgan/SA-MP-PathFinder.git|GPS routing system|"
    "FCNPC|World|Legacy|https://github.com/ziggi/FCNPC.git|Advanced NPC with AI|"
    "textdraw-streamer|World|Legacy|https://github.com/kristoisberg/samp-td-streamer.git|Stream unlimited textdraws|"
    "samp-gps|World|OMP|https://github.com/kristoisberg/samp-gps-plugin.git|GPS and navigation system|"
    "samp-3d-tryg|World|Both|https://github.com/nykez/samp-3d-tryg.git|3D text labels advanced|"
    "actor-streamer|World|OMP|https://github.com/Dayrion/actor_plus.git|Enhanced actor system|"
    
    # === DATABASE ===
    "sqlite|Database|Legacy|https://github.com/pBlueG/SA-MP-SQLitei.git|SQLite database support|"
    "pawn-redis|Database|OMP|https://github.com/Southclaws/pawn-redis.git|Redis database connector|"
    "mongodb|Database|Legacy|https://github.com/Sasino97/samp-mongodb-plugin.git|MongoDB connector|"
    "postgresql|Database|Legacy|https://github.com/urShadow/pgsql-plugin.git|PostgreSQL connector|"
    
    # === SECURITY / CRYPTO ===
    "sampac|Security|Legacy|https://github.com/Fairfox-Astramore/sampac-server|Official anti-cheat (outdated)|"
    "bcrypt|Security|Both|https://github.com/LassiAarni/samp-bcrypt.git|bcrypt password hashing|"
    "whirlpool|Security|Legacy|https://github.com/Southclaws/pawn-whirlpool.git|Whirlpool hashing algorithm|"
    "SHA512|Security|Legacy|https://github.com/paulomart/SHA512.git|SHA512 hashing|"
    "MD5|Security|Legacy|https://github.com/P3ti/MD5.git|MD5 hashing|"
    "encrypt|Security|Legacy|https://github.com/maddinat0r/samp-encrypt.git|Basic encryption utilities|"
    "samp-crypto|Security|OMP|https://github.com/Hreesang/samp-crypto.git|Modern crypto (Argon2, scrypt)|"
    "totp|Security|OMP|https://github.com/Southclaws/pawn-totp.git|Two-factor authentication|"
    
    # === NETWORK / ADVANCED ===
    "Pawn.Raknet|Network|Legacy|https://github.com/katursis/Pawn.RakNet.git|RakNet packet hooking|"
    "RakNet|Network|Legacy|https://github.com/Loggi/SA-MP-RakNet.git|Low-level networking|"
    "KeyListener|Network|Both|https://github.com/Codeusa/Pawn-KeyListener.git|Client keypress detection|"
    "socket|Network|Legacy|https://github.com/d0p3t/samp-socket.git|TCP/UDP sockets|"
    "pawn-requests|Network|OMP|https://github.com/Southclaws/pawn-requests.git|HTTP client for API calls|"
    "curl|Network|Legacy|https://github.com/Luneotm/samp-curl.git|cURL wrapper for HTTP|"
    
    # === OPEN.MP EXCLUSIVE ===
    "PawnPlus|Language|OMP|https://github.com/IllidanS4/PawnPlus.git|Advanced Pawn language extensions|"
    "pawn-json|Utility|OMP|https://github.com/Southclaws/pawn-json.git|JSON parsing and encoding|sampson"
    "pawn-regex|Utility|OMP|https://github.com/Southclaws/pawn-regex.git|Regular expressions|"
    "pawn-memory|Utility|OMP|https://github.com/BigETI/pawn-memory.git|Memory manipulation|"
    "chrono|Utility|OMP|https://github.com/Southclaws/chrono.git|Date and time utilities|"
    "rustext|Language|OMP|https://github.com/ziggi/rustext.git|Russian text support|"
    "SAMPSON|Utility|Both|https://github.com/Southclaws/SAMPSON.git|JSON library alternative|"
    "filemanager|Utility|OMP|https://github.com/JaTochNietDan/samp-filemanager.git|Advanced file operations|"
    "pawn-xml|Utility|OMP|https://github.com/Southclaws/pawn-xml.git|XML parser|"
    "pawn-csv|Utility|OMP|https://github.com/Southclaws/pawn-csv.git|CSV file handling|"
    
    # === INTEGRATION / CONNECTORS ===
    "discord-connector|Integration|Both|https://github.com/maddinat0r/samp-discord-connector.git|Discord bot integration|"
    "telegram-connector|Integration|OMP|https://github.com/Kirima2nd/samp-telegram-connector.git|Telegram bot integration|"
    "IRC|Integration|Legacy|https://github.com/samp-incognito/samp-irc-plugin.git|IRC chat integration|"
    "TeamSpeak|Integration|Legacy|https://github.com/urShadow/Pawn.CMD.git|TeamSpeak connector|"
    "websocket|Integration|OMP|https://github.com/Southclaws/pawn-websocket.git|WebSocket support|"
    
    # === CLIENT / MODERN FEATURES ===
    "SAMPVOICE|Audio|Both|https://github.com/CyberMor/sampvoice.git|Voice chat system|"
    "samp-cef|UI|Legacy|https://github.com/ZOTTCE/samp-cef.git|Browser CEF for custom UI|"
    "CHandling|Gameplay|Legacy|https://github.com/Freaksken/samp-chandling.git|Custom vehicle handling|"
    "samp-plus|Mod|Both|https://github.com/urShadow/Pawn.CMD.git|SA:MP+ client mod|"
    "samp-js|Language|OMP|https://github.com/samp-dev/samp-js.git|JavaScript gamemode support|"
    "AudioPlugin|Audio|Legacy|https://github.com/WopsS/samp-audio-plugin.git|Audio streaming|"
    
    # === UTILITY LIBRARIES ===
    "Pawn.CMD|Utility|Both|https://github.com/urShadow/Pawn.CMD.git|Fast command processor|"
    "foreach|Utility|Both|https://github.com/karimcambridge/SAMP-foreach.git|Efficient player loops|"
    "log-core|Utility|OMP|https://github.com/pawn-lang/samp-log-core.git|Advanced logging system|"
    "progress-bar|Utility|Both|https://github.com/Southclaws/progress2.git|Visual progress bars|"
    "samp-logger|Utility|Both|https://github.com/maddinat0r/samp-log-core|Enhanced logging|"
    "format|Utility|Both|https://github.com/Southclaws/formatex.git|Extended formatting|"
    
    # === GAMEPLAY ENHANCEMENTS ===
    "weapons|Gameplay|Both|https://github.com/oscar-broman/Weapon-Config.git|Weapon damage config|"
    "attachments|Gameplay|Both|https://github.com/Southclaws/samp-attachments.git|Object attachments|"
    "animations|Gameplay|Both|https://github.com/Southclaws/pawn-animations|Animation library|"
    "damage-system|Gameplay|Both|https://github.com/Southclaws/samp-damage.git|Advanced damage|"
    "anti-cheat|Gameplay|Both|https://github.com/NexiusTailer/Anticheat-System.git|Anti-cheat base|"
    "admin-system|Gameplay|Both|https://github.com/Southclaws/pawn-admin.git|Admin framework|"
    "zcmd|Utility|Legacy|https://github.com/Southclaws/zcmd.git|Legacy command processor|"
    "IznoCommand|Utility|Legacy|https://github.com/Iznogoud/IznoCommand.git|Modern command alternative|"
    
    # === VISUAL / UI ===
    "textdraw-editor|UI|Both|https://github.com/Nickk888SAMP/TextDraw-Editor.git|In-game TD editor|"
    "dialog-pages|UI|Both|https://github.com/Southclaws/pawn-dialog-pages.git|Paginated dialogs|"
    "inv-system|UI|Both|https://github.com/Bren828/inventory-SAMP.git|Inventory system|"
    "hud-system|UI|Both|https://github.com/Southclaws/samp-hud.git|Custom HUD|"
    "mSelection|UI|Legacy|https://github.com/d0p3t/mSelection.git|Model selection menu|"
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
