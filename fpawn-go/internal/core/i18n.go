package core

// Localization strings for Indonesian and English
var messages = map[string]map[string]string{
	"id": {
		// Menu
		"menu_title":    "fpawn v26.0 - Intelligence Frontier (Go Edition)",
		"menu_1":        "Kompilasi Script",
		"menu_2":        "Jalankan Instance",
		"menu_3":        "Live Reload Matrix",
		"menu_4":        "Marketplace & Search",
		"menu_5":        "Analisis Arsitektur",
		"menu_6":        "Autopilot Scan",
		"menu_8":        "Architect Foundation",
		"menu_9":        "Snippets Sandbox",
		"menu_10":       "Sync Core Library",
		"menu_11":       "Cloud Self-Update",
		"menu_12":       "Bahasa",
		"menu_13":       "Project Doctor",
		"menu_14":       "Auto-Ignition",
		"menu_15":       "Manager Plugin",
		"menu_16":       "Analitik Performa",
		"menu_17":       "Pulihkan Snapshot",
		"menu_18":       "Audit Keamanan",
		"menu_19":       "Saran Modernisasi",
		"menu_20":       "Linter Kode",
		"menu_21":       "Build Matrix",
		"menu_22":       "Benchmarking",
		"menu_23":       "Bungkus Proyek",
		"menu_24":       "Cruncher Server",
		"menu_25":       "Verifikasi Plugin",
		"menu_0":        "Keluar",

		// Status
		"status_ready":     "Ready",
		"status_compiling": "Kompilasi...",
		"status_watching":  "Mengawasi perubahan...",

		// Compiler
		"comp_start":   "Memulai kompilasi target...",
		"comp_success": "Kompilasi Berhasil!",
		"comp_fail":    "Kompilasi Gagal. Periksa error di atas.",
		"entry_err":    "Entry point tidak ditemukan.",

		// Doctor
		"doc_healthy":   "Catatan Dokter: Kode Anda sehat dan optimal!",
		"doc_unhealthy": "Ditemukan masalah! Periksa laporan di atas.",
		"doc_analyzing": "Menganalisis kesehatan project...",

		// Security
		"aud_title": "Audit Keamanan Mendalam",
		"aud_sqli":  "Potensi SQL Injection terdeteksi!",
		"aud_timer": "Timer tanpa validasi pemain terdeteksi!",
		"aud_clean": "Tidak ditemukan masalah keamanan kritis.",

		// Guardian
		"grd_title":     "Code Guardian (Sistem Anti-Maling)",
		"grd_enter_ip":  "Masukkan IP Server Pengunci:",
		"grd_success":   "Skrip berhasil diamankan dan dikompilasi!",
		"grd_vault_ask": "Enkripsi dan vault source code?",

		// Watch
		"wat_active":      "Watch Mode aktif untuk: %s",
		"wat_deactivated": "Watch Mode dinonaktifkan.",
		"wat_sync":        "Perubahan terdeteksi, merecompile...",

		// General
		"press_enter": "Tekan Enter untuk melanjutkan...",
		"select_idx":  "Pilih Index:",
	},
	"en": {
		// Menu
		"menu_title":    "fpawn v26.0 - Intelligence Frontier (Go Edition)",
		"menu_1":        "Compile Script",
		"menu_2":        "Run Instance",
		"menu_3":        "Live Reload Matrix",
		"menu_4":        "Marketplace & Search",
		"menu_5":        "Analyze Architecture",
		"menu_6":        "Autopilot Scan",
		"menu_8":        "Architect Foundation",
		"menu_9":        "Snippets Sandbox",
		"menu_10":       "Sync Core Library",
		"menu_11":       "Cloud Self-Update",
		"menu_12":       "Language",
		"menu_13":       "Project Doctor",
		"menu_14":       "Auto-Ignition",
		"menu_15":       "Plugin Manager",
		"menu_16":       "Performance Analytics",
		"menu_17":       "Restore Snapshot",
		"menu_18":       "Security Audit",
		"menu_19":       "Modernization Tips",
		"menu_20":       "Code Linter",
		"menu_21":       "Build Matrix",
		"menu_22":       "Benchmarking",
		"menu_23":       "Bundle Project",
		"menu_24":       "Server Cruncher",
		"menu_25":       "Verify Plugins",
		"menu_0":        "Exit",

		// Status
		"status_ready":     "Ready",
		"status_compiling": "Compiling...",
		"status_watching":  "Watching for changes...",

		// Compiler
		"comp_start":   "Starting compilation...",
		"comp_success": "Compilation Successful!",
		"comp_fail":    "Compilation Failed. Check errors above.",
		"entry_err":    "Entry point not found.",

		// Doctor
		"doc_healthy":   "Doctor's Note: Your code is healthy and optimal!",
		"doc_unhealthy": "Issues found! Check the report above.",
		"doc_analyzing": "Analyzing project health...",

		// Security
		"aud_title": "Deep Security Audit",
		"aud_sqli":  "Potential SQL Injection detected!",
		"aud_timer": "Timer without player validation detected!",
		"aud_clean": "No critical security issues found.",

		// Guardian
		"grd_title":     "Code Guardian (Anti-Theft System)",
		"grd_enter_ip":  "Enter Server IP Lock:",
		"grd_success":   "Script secured and compiled successfully!",
		"grd_vault_ask": "Encrypt and vault source code?",

		// Watch
		"wat_active":      "Watch Mode active for: %s",
		"wat_deactivated": "Watch Mode deactivated.",
		"wat_sync":        "Change detected, recompiling...",

		// General
		"press_enter": "Press Enter to continue...",
		"select_idx":  "Select Index:",
	},
}

// Msg returns the localized message for the given key
func Msg(key string) string {
	lang := "id"
	if AppConfig != nil && AppConfig.Lang != "" {
		lang = AppConfig.Lang
	}

	if msgs, ok := messages[lang]; ok {
		if msg, ok := msgs[key]; ok {
			return msg
		}
	}

	// Fallback to English
	if msgs, ok := messages["en"]; ok {
		if msg, ok := msgs[key]; ok {
			return msg
		}
	}

	return key
}
