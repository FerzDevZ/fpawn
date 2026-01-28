package plugins

// Plugin represents a plugin entry in the database
type Plugin struct {
	Name        string
	Category    string
	Compat      string // "Both", "Legacy", "OMP"
	URL         string
	Description string
	Deps        []string
}

// PluginDatabase contains all known plugins
var PluginDatabase = []Plugin{
	// === CORE / ESSENTIAL ===
	{Name: "crashdetect", Category: "Core", Compat: "Both", URL: "https://github.com/Zeex/samp-plugin-crashdetect", Description: "Crash detection and debugging"},
	{Name: "sscanf", Category: "Core", Compat: "Both", URL: "https://github.com/Y-Less/sscanf", Description: "Advanced string parsing"},
	{Name: "streamer", Category: "World", Compat: "Both", URL: "https://github.com/samp-incognito/samp-streamer-plugin", Description: "Object/pickup streaming", Deps: []string{"sscanf"}},
	{Name: "mysql", Category: "Database", Compat: "Both", URL: "https://github.com/pBlueG/SA-MP-MySQL", Description: "MySQL database connector", Deps: []string{"sscanf", "bcrypt"}},
	{Name: "nativechecker", Category: "Core", Compat: "Both", URL: "https://github.com/openmultiplayer/nativechecker", Description: "Native function validator"},
	{Name: "profiler", Category: "Core", Compat: "Both", URL: "https://github.com/Zeex/samp-plugin-profiler", Description: "Performance profiling"},
	{Name: "ysi-includes", Category: "Core", Compat: "Both", URL: "https://github.com/pawn-lang/YSI-Includes", Description: "YSI Library collection"},

	// === LEGACY SA:MP ===
	{Name: "YSF", Category: "Core", Compat: "Legacy", URL: "https://github.com/IllidanS4/YSF", Description: "Extended server functions"},
	{Name: "SKY", Category: "Core", Compat: "Legacy", URL: "https://github.com/oscar-broman/SKY", Description: "Advanced hooking"},
	{Name: "fixes", Category: "Core", Compat: "Legacy", URL: "https://github.com/pawn-lang/sa-mp-fixes", Description: "Bug fixes collection"},
	{Name: "TimerFix", Category: "Core", Compat: "Legacy", URL: "https://github.com/ziggi/timerfix", Description: "Timer accuracy fix"},
	{Name: "SAMPCAC", Category: "Security", Compat: "Legacy", URL: "https://github.com/SAMPCAC/SAMPCAC-Plugin", Description: "Client-side anti-cheat"},

	// === WORLD / MAPPING ===
	{Name: "MapAndreas", Category: "World", Compat: "Legacy", URL: "https://github.com/Southclaws/samp-MapAndreas", Description: "Height map data"},
	{Name: "ColAndreas", Category: "World", Compat: "Legacy", URL: "https://github.com/Pottus/ColAndreas", Description: "Collision detection"},
	{Name: "PathFinder", Category: "World", Compat: "Legacy", URL: "https://github.com/AbyssMorgan/SA-MP-PathFinder", Description: "AI pathfinding"},
	{Name: "FCNPC", Category: "World", Compat: "Legacy", URL: "https://github.com/ziggi/FCNPC", Description: "Fully controllable NPCs"},
	{Name: "samp-gps", Category: "World", Compat: "Both", URL: "https://github.com/kristoisberg/samp-gps-plugin", Description: "GPS navigation"},
	{Name: "MapStreamer", Category: "World", Compat: "Both", URL: "https://github.com/maddinat0r/samp-map-streamer", Description: "Dynamic map loading"},

	// === DATABASE ===
	{Name: "sqlite", Category: "Database", Compat: "Both", URL: "https://github.com/pBlueG/SA-MP-SQLitei", Description: "SQLite database"},
	{Name: "pawn-redis", Category: "Database", Compat: "Both", URL: "https://github.com/Southclaws/pawn-redis", Description: "Redis connector"},
	{Name: "mongodb", Category: "Database", Compat: "Legacy", URL: "https://github.com/nickmw/samp-mongodb-plugin", Description: "MongoDB connector"},

	// === SECURITY / CRYPTO ===
	{Name: "bcrypt", Category: "Security", Compat: "Both", URL: "https://github.com/lassir/bcrypt-samp", Description: "Password hashing"},
	{Name: "whirlpool", Category: "Security", Compat: "Both", URL: "https://github.com/Southclaws/samp-whirlpool", Description: "Whirlpool hashing"},
	{Name: "pawn-sha256", Category: "Security", Compat: "Both", URL: "https://github.com/WoutProvost/SHA256", Description: "SHA256 hashing"},
	{Name: "totp", Category: "Security", Compat: "OMP", URL: "https://github.com/Starter74/totp-samp", Description: "2FA TOTP"},

	// === NETWORK ===
	{Name: "Pawn.RakNet", Category: "Network", Compat: "Legacy", URL: "https://github.com/katursis/Pawn.RakNet", Description: "RakNet access"},
	{Name: "socket", Category: "Network", Compat: "Legacy", URL: "https://github.com/BlueG/SA-MP-Socket", Description: "TCP/UDP sockets"},
	{Name: "pawn-requests", Category: "Network", Compat: "Both", URL: "https://github.com/Southclaws/pawn-requests", Description: "HTTP requests"},
	{Name: "DNS", Category: "Network", Compat: "Both", URL: "https://github.com/Incognito/samp-dns-plugin", Description: "DNS resolution"},

	// === LANGUAGE EXTENSIONS ===
	{Name: "PawnPlus", Category: "Language", Compat: "Both", URL: "https://github.com/IllidanS4/PawnPlus", Description: "Pawn extensions"},
	{Name: "pawn-json", Category: "Language", Compat: "Both", URL: "https://github.com/Southclaws/pawn-json", Description: "JSON parsing"},
	{Name: "pawn-regex", Category: "Language", Compat: "Both", URL: "https://github.com/Zeex/pawn-regex", Description: "Regular expressions"},
	{Name: "amx-assembly", Category: "Language", Compat: "Both", URL: "https://github.com/Zeex/amx_assembly", Description: "AMX assembly"},
	{Name: "Pawn.ScriptEvent", Category: "Language", Compat: "Both", URL: "https://github.com/katursis/Pawn.ScriptEvent", Description: "Script events engine"},

	// === INTEGRATION ===
	{Name: "discord-connector", Category: "Integration", Compat: "Both", URL: "https://github.com/maddinat0r/samp-discord-connector", Description: "Discord bot"},
	{Name: "telegram-connector", Category: "Integration", Compat: "Both", URL: "https://github.com/pawn-lang/samp-telegram-connector", Description: "Telegram bot"},
	{Name: "websocket", Category: "Integration", Compat: "OMP", URL: "https://github.com/Starter74/websocket-samp", Description: "WebSocket server"},
	{Name: "Discord-RPC", Category: "Integration", Compat: "Both", URL: "https://github.com/AGU-D/samp-discord-rich-presence", Description: "Discord Rich Presence"},

	// === UI ===
	{Name: "mSelection", Category: "UI", Compat: "Legacy", URL: "https://github.com/Open-GTO/mSelection", Description: "Model selection"},
	{Name: "textdraw-editor", Category: "UI", Compat: "Both", URL: "https://github.com/nickk888/TextDraw-Editor", Description: "TD editor"},

	// === GAMEPLAY ===
	{Name: "weapon-config", Category: "Gameplay", Compat: "Both", URL: "https://github.com/oscar-broman/Weapon-Config", Description: "Weapon configuration"},
	{Name: "damage-system", Category: "Gameplay", Compat: "Both", URL: "https://github.com/oscar-broman/Damage-System", Description: "Damage handling"},
	{Name: "samp-voice", Category: "Gameplay", Compat: "Both", URL: "https://github.com/CyberMor/samp-voice", Description: "High-quality voice chat", Deps: []string{"sscanf"}},

	// === UTILITY ===
	{Name: "sampctl", Category: "Utility", Compat: "Both", URL: "https://github.com/Southclaws/sampctl", Description: "Package manager"},
	{Name: "izcmd", Category: "Utility", Compat: "Both", URL: "https://github.com/YashasSamaga/I-ZCMD", Description: "Command processor"},
	{Name: "Pawn.CMD", Category: "Utility", Compat: "Both", URL: "https://github.com/urShadow/Pawn.CMD", Description: "Fast commands"},
	{Name: "foreach", Category: "Utility", Compat: "Both", URL: "https://github.com/Open-GTO/foreach", Description: "Iterator system"},
	{Name: "strlib", Category: "Utility", Compat: "Both", URL: "https://github.com/oscar-broman/strlib", Description: "String library"},
	{Name: "samp-logger", Category: "Utility", Compat: "Both", URL: "https://github.com/Starter74/samp-log", Description: "Logging system"},
	{Name: "samp-geoip", Category: "Utility", Compat: "Legacy", URL: "https://github.com/Starter74/samp-geoip", Description: "GeoIP lookup"},
	{Name: "Pawn.Env", Category: "Utility", Compat: "Both", URL: "https://github.com/Southclaws/pawn-env", Description: "Environment variables access"},

	// === GAMEMODES ===
	{Name: "scavenge-survive", Category: "Gamemode", Compat: "Both", URL: "https://github.com/Southclaws/ScavengeSurvive", Description: "Survival gamemode"},
	{Name: "grand-larceny", Category: "Gamemode", Compat: "Legacy", URL: "https://github.com/pawn-lang/sa-mp-grandlarceny", Description: "Default gamemode"},
	{Name: "open-rp", Category: "Gamemode", Compat: "Both", URL: "https://github.com/pawn-lang/open-rp", Description: "Modular RP base"},
}

// GetPluginsByCategory returns all plugins in a category
func GetPluginsByCategory(category string) []Plugin {
	var result []Plugin
	for _, p := range PluginDatabase {
		if p.Category == category {
			result = append(result, p)
		}
	}
	return result
}

// GetPluginByName finds a plugin by name
func GetPluginByName(name string) *Plugin {
	for _, p := range PluginDatabase {
		if p.Name == name {
			return &p
		}
	}
	return nil
}

// GetCategories returns all unique categories
func GetCategories() []string {
	categories := make(map[string]bool)
	for _, p := range PluginDatabase {
		categories[p.Category] = true
	}

	var result []string
	for c := range categories {
		result = append(result, c)
	}
	return result
}
