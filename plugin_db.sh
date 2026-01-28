#!/bin/bash
# fpawn Plugin Database - v23.0 - Multilingual Expansion
# Comprehensive Plugin Registry for SA:MP Legacy & Open.MP
# Format: "name|category|compat|url|description_key|dependencies"

PLUGIN_DATABASE=(
    # === CORE / ESSENTIAL ===
    "crashdetect|Core|Both|https://github.com/Zeex/samp-plugin-crashdetect.git|p_desc_core|"
    "sscanf|Core|Both|https://github.com/Y-Less/sscanf.git|p_desc_core|"
    "streamer|World|Both|https://github.com/samp-incognito/samp-streamer-plugin.git|p_desc_world|"
    "mysql|Database|Both|https://github.com/pBlueG/SA-MP-MySQL.git|p_desc_db|"
    "nativechecker|Core|Both|https://github.com/openmultiplayer/nativechecker.git|p_desc_core|"
    "profiler|Core|Both|https://github.com/Zeex/samp-plugin-profiler.git|p_desc_util|"
    "ysi-includes|Core|Both|https://github.com/pawn-lang/YSI-Includes.git|p_desc_core|"
    
    # === LEGACY SA:MP CORE ===
    "YSF|Core|Legacy|https://github.com/IllidanS4/YSF.git|p_desc_core|"
    "SKY|Core|Legacy|https://github.com/oscar-broman/SKY.git|p_desc_core|"
    "fixes|Core|Legacy|https://github.com/ziggi/FIXES.git|p_desc_core|"
    "TimerFix|Core|Legacy|https://github.com/ziggi/timerfix.git|p_desc_core|"
    
    # === WORLD / MAPPING ===
    "MapAndreas|World|Legacy|https://github.com/Southclaws/samp-MapAndreas.git|p_desc_world|"
    "ColAndreas|World|Legacy|https://github.com/Pottus/ColAndreas.git|p_desc_world|"
    "PathFinder|World|Legacy|https://github.com/AbyssMorgan/SA-MP-PathFinder.git|p_desc_world|"
    "FCNPC|World|Legacy|https://github.com/ziggi/FCNPC.git|p_desc_world|"
    "samp-gps|World|Both|https://github.com/kristoisberg/samp-gps-plugin.git|p_desc_world|"
    "actor-streamer|World|Both|https://github.com/Dayrion/actor_plus.git|p_desc_world|"
    
    # === DATABASE ===
    "sqlite|Database|Both|https://github.com/pBlueG/SA-MP-SQLitei.git|p_desc_db|"
    "pawn-redis|Database|Both|https://github.com/m-pawn/samp-redis.git|p_desc_db|"
    "mongodb|Database|Legacy|https://github.com/Sasino97/samp-mongodb-plugin.git|p_desc_db|"
    
    # === SECURITY / CRYPTO ===
    "bcrypt|Security|Both|https://github.com/LassiAarni/samp-bcrypt.git|p_desc_sec|"
    "whirlpool|Security|Both|https://github.com/Southclaws/pawn-whirlpool.git|p_desc_sec|"
    "pawn-sha256|Security|Both|https://github.com/scripter-cz/pawn-sha256.git|p_desc_sec|"
    "totp|Security|OMP|https://github.com/Southclaws/pawn-totp.git|p_desc_sec|"
    
    # === NETWORK / ADVANCED ===
    "Pawn.Raknet|Network|Legacy|https://github.com/katursis/Pawn.RakNet.git|p_desc_net|"
    "socket|Network|Legacy|https://github.com/d0p3t/samp-socket.git|p_desc_net|"
    "pawn-requests|Network|Both|https://github.com/Southclaws/pawn-requests.git|p_desc_net|"
    "pawn-socket|Network|Both|https://github.com/BlueG/SA-MP-Socket.git|p_desc_net|"
    
    # === OPEN.MP / MODERN LANGUAGES ===
    "PawnPlus|Language|Both|https://github.com/IllidanS4/PawnPlus.git|p_desc_lang|"
    "pawn-json|Language|Both|https://github.com/Southclaws/pawn-json.git|p_desc_lang|"
    "pawn-regex|Language|Both|https://github.com/Zeex/pawn-regex.git|p_desc_lang|"
    "pawn-amx-utils|Language|Both|https://github.com/pawn-lang/pawn-amx-utils.git|p_desc_lang|"
    "pawn-memory|Language|Both|https://github.com/pawn-lang/pawn-memory.git|p_desc_lang|"
    "amx-assembly|Language|Both|https://github.com/Zeex/amx_assembly.git|p_desc_lang|"
    
    # === INTEGRATION ===
    "discord-connector|Integration|Both|https://github.com/m-pawn/samp-discord-connector.git|p_desc_int|"
    "telegram-connector|Integration|Both|https://github.com/m-pawn/samp-telegram-connector.git|p_desc_int|"
    "websocket|Integration|OMP|https://github.com/Southclaws/pawn-websocket.git|p_desc_int|"
    
    # === GAMEPLAY & UI ===
    "mSelection|UI|Legacy|https://github.com/d0p3t/mSelection.git|p_desc_ui|"
    "inv-system|UI|Both|https://github.com/Bren828/inventory-SAMP.git|p_desc_ui|"
    "hud-system|UI|Both|https://github.com/Southclaws/samp-hud.git|p_desc_ui|"
    "textdraw-editor|UI|Both|https://github.com/Nickk888SAMP/TextDraw-Editor.git|p_desc_ui|"
    "weapon-config|Gameplay|Both|https://github.com/oscar-broman/Weapon-Config.git|p_desc_game|"
    "damage-system|Gameplay|Both|https://github.com/Southclaws/samp-damage.git|p_desc_game|"
    
    # === UTILITY & TOOLS ===
    "sampctl|Utility|Both|https://github.com/Southclaws/sampctl|p_desc_util|"
    "pawn-os|Utility|OMP|https://github.com/Southclaws/pawn-os.git|p_desc_util|"
    "pawn-env|Utility|Both|https://github.com/Southclaws/pawn-env.git|p_desc_util|"
    "izcmd|Utility|Both|https://github.com/YashasSamaga/I-ZCMD.git|p_desc_util|"
    "Pawn.CMD|Utility|Both|https://github.com/urShadow/Pawn.CMD.git|p_desc_util|"
    "foreach|Utility|Both|https://github.com/karimcambridge/SAMP-foreach.git|p_desc_util|"
    "strlib|Utility|Both|https://github.com/oscar-broman/strlib.git|p_desc_util|"
    "samp-logger|Utility|Both|https://github.com/Southclaws/samp-logger.git|p_desc_util|"
    "samp-geoip|Utility|Legacy|https://github.com/Southclaws/samp-geoip.git|p_desc_util|"
    "discord-cmd|Integration|Both|https://github.com/Southclaws/samp-discord-command.git|p_desc_int|"
    
    # === ADVANCED / AI ===
    "samp-ml|Advanced|Legacy|https://github.com/Y-Less/samp-ml.git|p_desc_adv|"
    "rust-mysql|Database|OMP|https://github.com/pblueg/rust-mysql.git|p_desc_db|"
    "pawn-uuid|Utility|Both|https://github.com/Southclaws/pawn-uuid.git|p_desc_util|"
    "pawn-chrono|Utility|Both|https://github.com/Southclaws/pawn-chrono.git|p_desc_util|"
    "pawn-test|Core|Both|https://github.com/Southclaws/pawn-test.git|p_desc_core|"
    
    # === GAMEMODE BASES ===
    "scavenge-survive|Gamemode|Both|https://github.com/Southclaws/ScavengeSurvive.git|p_desc_gm|"
    "grand-larcency|Gamemode|Legacy|https://github.com/pawn-lang/sa-mp-grand-larcency.git|p_desc_gm|"
    "samp-voice|Gameplay|Both|https://github.com/CyberMor/samp-voice.git|p_desc_game|"
    "SAMPCAC|Security|Legacy|https://github.com/SAMPCAC/SAMPCAC-Plugin.git|p_desc_sec|"
    "MapStreamer|World|Both|https://github.com/maddinat0r/samp-map-streamer.git|p_desc_world|"
    "DNS|Network|Both|https://github.com/Incognito/samp-dns-plugin.git|p_desc_net|"
    "open-rp|Gamemode|Both|https://github.com/pawn-lang/open-rp.git|p_desc_gm|"
    "samp-ml|Advanced|Legacy|https://github.com/Y-Less/samp-ml.git|p_desc_adv|"
    "rust-mysql|Database|OMP|https://github.com/pblueg/rust-mysql.git|p_desc_db|"
    "pawn-uuid|Utility|Both|https://github.com/Southclaws/pawn-uuid.git|p_desc_util|"
    "pawn-chrono|Utility|Both|https://github.com/Southclaws/pawn-chrono.git|p_desc_util|"
    "pawn-test|Core|Both|https://github.com/Southclaws/pawn-test.git|p_desc_core|"
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
