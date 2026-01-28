#!/bin/bash
# fpawn Core Module - v25.0
# Configuration, Colors, and Base Utilities

# === STRICT MODE (PROFESSIONAL STANDARD) ===
# -e: Exit on error
# -u: Exit on unset variable
# -o pipefail: Catch pipeline errors
set -euo pipefail

# === DIRECTORIES ===
# Default to empty, populated by init
export FPAWN_BASE_DIR=""
export FPAWN_QAWNO_DIR=""
export FPAWN_PAWNO_DIR=""
export FPAWN_GLOBAL_INC=""
export FPAWN_CONFIG_FILE="$HOME/.ferzdevz/fpawn/config"
export FPAWN_CACHE_DIR="$HOME/.ferzdevz/fpawn/cache/includes"
export FPAWN_PLUGIN_CACHE="$HOME/.ferzdevz/fpawn/cache/plugins"

# === COLORS (Synthesis Sapphire Palette) ===
export GREEN='\033[38;5;82m'
export BLUE='\033[38;5;39m'
export RED='\033[38;5;196m'
export YELLOW='\033[38;5;226m'
export CYAN='\033[38;5;51m'
export MAGENTA='\033[38;5;201m'
export ORANGE='\033[38;5;208m'
export WHITE='\033[38;5;255m'
export LBLUE='\033[38;5;123m'
export BOLD='\033[1m'
export NC='\033[0m'

# === CONFIGURATION MANAGEMENT (SECURE) ===

function core_init_dirs() {
    local SOURCE="${BASH_SOURCE[0]}" # Fix for strict mode (BASH_SOURCE[1] might be unset)
    while [ -h "$SOURCE" ]; do
        local DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
        SOURCE="$(readlink "$SOURCE")"
        [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
    done
    FPAWN_BASE_DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
    
    # Traverse up if we are in lib/
    if [[ "$FPAWN_BASE_DIR" == */lib ]]; then
        FPAWN_BASE_DIR="$(dirname "$FPAWN_BASE_DIR")"
    fi
    
    FPAWN_QAWNO_DIR="$FPAWN_BASE_DIR/qawno"
    FPAWN_PAWNO_DIR="$FPAWN_BASE_DIR/pawno"
    FPAWN_GLOBAL_INC="$FPAWN_BASE_DIR/bin/includes"
}

function core_load_config() {
    mkdir -p "$(dirname "$FPAWN_CONFIG_FILE")" "$FPAWN_CACHE_DIR" "$FPAWN_PLUGIN_CACHE"
    
    # Defaults
    export REPO_OWNER="FerzDevZ"
    export REPO_NAME="fpawn"
    export LANG="id"
    export AUTO_IGNITE="OFF"

    if [ -f "$FPAWN_CONFIG_FILE" ]; then
        # Secure Parser: Read only known keys, never eval/source
        while IFS='=' read -r key value; do
            case "$key" in
                "REPO_OWNER") REPO_OWNER="$value" ;;
                "REPO_NAME") REPO_NAME="$value" ;;
                "LANG") LANG=$(echo "$value" | tr -d '"') ;; # Strip quotes
                "AUTO_IGNITE") AUTO_IGNITE=$(echo "$value" | tr -d '"') ;;
            esac
        done < "$FPAWN_CONFIG_FILE"
    else
        # Create default safely
        cat > "$FPAWN_CONFIG_FILE" <<EOF
REPO_OWNER="FerzDevZ"
REPO_NAME="fpawn"
LANG="id"
AUTO_IGNITE="OFF"
EOF
    fi
}

function core_set_lang() {
    local L=$1
    if grep -q "LANG=" "$FPAWN_CONFIG_FILE"; then
        sed -i "s/LANG=.*/LANG=\"$L\"/" "$FPAWN_CONFIG_FILE"
    else
        echo "LANG=\"$L\"" >> "$FPAWN_CONFIG_FILE"
    fi
    echo -e "${GREEN}[Success]${NC} Language updated to $L."
    LANG=$L
}

function core_toggle_auto_ignite() {
    if [ "$AUTO_IGNITE" == "ON" ]; then
        AUTO_IGNITE="OFF"
        sed -i 's/AUTO_IGNITE=.*/AUTO_IGNITE="OFF"/' "$FPAWN_CONFIG_FILE"
    else
        AUTO_IGNITE="ON"
        sed -i 's/AUTO_IGNITE=.*/AUTO_IGNITE="ON"/' "$FPAWN_CONFIG_FILE"
    fi
}

# === UI ENHANCEMENTS ===

function core_loading_spinner() {
    local PID=$!
    local DELAY=0.1
    local SPINNER='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'
    while kill -0 "$PID" 2>/dev/null; do
        for i in $(seq 0 9); do
            echo -ne "\r  ${CYAN}${SPINNER:$i:1}${NC} $(msg load_processing)"
            sleep "$DELAY"
        done
    done
    echo -ne "\r"
}

function core_progress_bar() {
    local DURATION=$1
    local REASON=$2
    local WIDTH=50
    
    echo -e " ${BOLD}${LBLUE}Synthesis in progress: $REASON${NC}"
    for i in $(seq 1 "$WIDTH"); do
        local PERCENT=$((i * 100 / WIDTH))
        local BAR=$(printf "%${i}s" | tr ' ' '█')
        local SPACE=$(printf "%$((WIDTH - i))s")
        echo -ne "\r  ${CYAN}[${BAR}${SPACE}]${NC} ${PERCENT}%"
        sleep "$(echo "scale=3; $DURATION / $WIDTH" | bc)"
    done
    echo -e "\n ${GREEN}[Complete]${NC}"
}

function core_synthesis_loader() {
    local REASON=$1
    echo -ne " ${MAGENTA}⚡${NC} ${BOLD}Sourcing Intelligence: $REASON...${NC}"
    local SPINNER='-\|/'
    for i in {1..20}; do
        echo -ne "\b${SPINNER:i%4:1}"
        sleep 0.05
    done
    echo -e "\b${GREEN}DONE${NC}"
}

# === LOCALIZATION ENGINE ===

function msg() {
    local ID=$1
    if [ "$LANG" == "id" ]; then
        case $ID in
            welcome) echo "Selamat Datang di fpawn v23.0" ;;
            status) echo "Status Ekosistem" ;;
            
            # Dashboard Menu
            menu_1) echo "Kompilasi Script" ;;
            menu_2) echo "Jalankan Instance" ;;
            menu_3) echo "Live Reload Matrix" ;;
            menu_4) echo "Marketplace & Search" ;;
            menu_5) echo "Analisis Arsitektur" ;;
            menu_6) echo "Autopilot Scan" ;;
            menu_7) echo "Artisan Auto-Fix" ;;
            menu_8) echo "Architect Foundation" ;;
            menu_9) echo "Snippets Sandbox" ;;
            menu_10) echo "Sync Core Library" ;;
            menu_11) echo "Cloud Self-Update" ;;
            menu_12) echo "Bahasa: ID" ;;
            menu_13) echo "Project Doctor" ;;
            menu_14) echo "Auto-Ignition: $AUTO_IGNITE" ;;
            menu_15) echo "Manager Plugin" ;;
            menu_16) echo "Analitik Performa" ;;
            menu_17) echo "Pulihkan Snapshot" ;;
            menu_18) echo "Audit Keamanan" ;;
            menu_19) echo "Saran Modernisasi" ;;
            menu_20) echo "Linter Kode" ;;
            menu_21) echo "Build Matrix" ;;
            menu_22) echo "Benchmarking" ;;
            menu_23) echo "Bungkus Proyek" ;;
            menu_24) echo "Cruncher Server" ;;
            menu_25) echo "Verifikasi Plugin" ;;
            menu_0)  echo "Keluar" ;;
            
            # Compiler Messages
            comp_start) echo "Memulai kompilasi target..." ;;
            comp_success) echo "Kompilasi Berhasil!" ;;
            comp_fail) echo "Kompilasi Gagal. Periksa error di atas." ;;
            comp_binary) echo "Mencari binary pre-compiled..." ;;
            comp_extract) echo "Mengekstrak binary ke folder plugins..." ;;
            
            # GitHub Module
            git_downloading) echo "Mengunduh aset: %s..." ;;
            
            # GitHub Module
            git_downloading) echo "Downloading asset: %s..." ;;
            
            # Intelligence Frontier
            doc_analyzing) echo "Menganalisis kesehatan project..." ;;
            doc_healthy) echo "Catatan Dokter: Kode Anda sehat dan optimal!" ;;
            doc_unhealthy) echo "Ditemukan masalah! Gunakan --repair untuk memperbaiki." ;;
            doc_stack) echo "Potensi Stack Overflow (Array besar)" ;;
            doc_loop) echo "Loop pemain tidak efisien (Gunakan foreach)" ;;
            doc_timer) echo "Timer terlalu cepat (Risiko Lag)" ;;
            
            # Plugin Manager TUI
            p_cat_core) echo "Inti (Essential)" ;;
            p_cat_db) echo "Database (MySQL, Redis)" ;;
            p_cat_sec) echo "Keamanan (Bcrypt, Whirlpool)" ;;
            p_cat_net) echo "Jaringan (HTTP, Socket)" ;;
            p_cat_world) echo "Dunia (Streamer, GPS)" ;;
            p_cat_int) echo "Integrasi (Discord, Telegram)" ;;
            p_cat_game) echo "Gameplay (Damage, Weapons)" ;;
            p_cat_ui) echo "Antarmuka (Textdraws)" ;;
            p_cat_sys) echo "Sistem (Racing, Housing)" ;;
            p_cat_util) echo "Utilitas (Log, CMD)" ;;
            p_cat_lang) echo "Bahasa (JSON, PawnPlus)" ;;
            
            p_desc_core) echo "Plugin dasar yang wajib ada." ;;
            p_desc_db) echo "Penyimpanan data permanen." ;;
            p_desc_sec) echo "Enkripsi dan proteksi data." ;;
            p_desc_net) echo "Koneksi ke layanan luar." ;;
            p_desc_world) echo "Manajemen objek dan dunia luas." ;;
            p_desc_int) echo "Hubungkan server ke sosmed." ;;
            p_desc_game) echo "Mekanik permainan lanjutan." ;;
            p_desc_ui) echo "Mempercantik visual pemain." ;;
            p_desc_sys) echo "Fitur sistem server kompleks." ;;
            p_desc_util) echo "Alat bantu scripting." ;;
            p_desc_lang) echo "Ekstensi bahasa Pawn." ;;
            
            # Plugin UI
            prompt_select_cat) echo "Pilih kategori untuk melihat plugin:" ;;
            p_none_found) echo "Tidak ada plugin ditemukan di kategori" ;;
            p_cat_prefix) echo "Kategori" ;;
            p_prompt_install) echo "Pilih plugin untuk diinstal (Spasi: tandai, Enter: konfirmasi):" ;;
            p_press_enter) echo "Instalasi selesai. Tekan Enter untuk kembali..." ;;

            git_downloading) echo "Mengunduh %s..." ;;

            # Analysis Reports
            ana_start) echo "Memeriksa mendalam:" ;;
            ana_volumes) echo "Volume: %s baris kode Pawn" ;;
            ana_context) echo "Konteks: Ekosistem %s terdeteksi" ;;
            ana_fail) echo "Analisis gagal. Entry point tidak valid." ;;
            ana_success) echo "Analisis selesai" ;;
            
            neu_scan) echo "Memindai log %s untuk tanda-tanda masalah..." ;;
            neu_missing) echo "File log tidak ditemukan" ;;
            neu_logic) echo "Overflow logika terdeteksi" ;;
            neu_stack) echo "Stacktrace terdeteksi" ;;
            neu_clean) echo "Tidak ditemukan anomali kritis" ;;
            
            auto_scan) echo "Memindai Grid Neural..." ;;
            auto_integrity) echo "Integritas sistem terverifikasi" ;;
            auto_corrupt) echo "Komponen korup" ;;
            auto_repair_prompt) echo "Jalankan Perbaikan?" ;;
            
            per_title) echo "Dashboard Analitik Performa fpawn" ;;
            per_no_data) echo "Belum ada data build. Compile script dulu!" ;;
            per_cycles) echo "10 Siklus Build Terakhir" ;;
            per_stats) echo "Statistik Global" ;;
            per_total) echo "Total Kompilasi" ;;
            per_avg) echo "Rata-rata Waktu Build" ;;
            per_peak) echo "Puncak AMX Terbesar" ;;
            per_trend) echo "Tren Riwayat Build (Waktu Build)" ;;
            
            doc_analyzing) echo "Menganalisis" ;;
            doc_report) echo "Ringkasan Laporan" ;;
            doc_crit) echo "Masalah Kritis" ;;
            doc_warn) echo "Peringatan Optimasi" ;;
            doc_repair_hint) echo "Rekomendasi: Gunakan fpawn --repair untuk perbaikan otomatis." ;;

            # Code Guardian (Anti-Theft)
            grd_title) echo "Code Guardian (Sistem Anti-Maling)" ;;
            grd_enter_ip) echo "Masukkan IP Server Pengunci (Kosongkan jika tidak perlu):" ;;
            grd_enter_host) echo "Masukkan Hostname Pengunci (Kosongkan jika tidak perlu):" ;;
            grd_success) echo "Skrip berhasil diamankan dan dikompilasi!" ;;
            grd_vault_ask) echo "Pindahkan source code ke Vault pribadi dan hapus dari sini?" ;;

            # Compiler & Watch
            com_invalid_target) echo "Target file tidak valid: %s" ;;
            com_file_not_found) echo "File tidak ditemukan: %s" ;;
            com_detect_profile) echo "Profil terdeteksi: %s" ;;
            com_building) echo "Membangun %s dengan %s (%s)..." ;;
            com_ignite_success) echo "Kompilasi sukses. Menjalankan server..." ;;
            srv_missing_bin) echo "Binary server tidak ditemukan (omp-server atau samp03svr)" ;;
            srv_starting) echo "Memulai %s..." ;;
            ref_syncing) echo "Sinkronisasi distribusi inti..." ;;
            wat_active) echo "Live Reload Engine Aktif untuk %s" ;;
            wat_monitoring) echo "Memantau project untuk perubahan... (Tekan Ctrl+C untuk berhenti)" ;;
            wat_deactivated) echo "Engine dinonaktifkan." ;;
            wat_high_perf) echo "Performa Tinggi (inotify)" ;;
            wat_standard) echo "Polling Standar (Tanpa inotify-tools)" ;;
            wat_event) echo "Perubahan terdeteksi. Mencatat..." ;;
            wat_sync) echo "Modifikasi terdeteksi. Menyinkronkan..." ;;
            wat_snapshot) echo "Build selesai dalam %sms" ;;

            # Artisan & Tools
            art_polishing) echo "Memoles estetika %s..." ;;
            art_init_repair) echo "Memulai urutan perbaikan untuk %s..." ;;
            art_opt_loops) echo "Mengoptimalkan loop pemain ke 'foreach'..." ;;
            art_harden) echo "Memperkuat array lokal (new -> static)..." ;;
            art_modernize) echo "Modernisasi header: a_samp -> open.mp..." ;;
            art_success) echo "Code Artisan telah menyelesaikan pemulihan." ;;
            art_note) echo "Catatan: Selalu kompilasi ulang untuk memverifikasi integritas logika." ;;
            
            arc_title) echo "Arsitek fpawn" ;;
            arc_select) echo "Pilih Arsitektur Project:" ;;
            arc_legacy) echo "Struktur SA-MP Klasik (0.3.7)" ;;
            arc_advanced) echo "Struktur Modern open.mp Modular" ;;
            arc_casting) echo "Mencetak Fondasi %s untuk %s..." ;;
            arc_legacy_gen) echo "Struktur SA-MP Legacy '%s' berhasil dibuat" ;;
            arc_mod_gen) echo "Struktur open.mp Modular '%s' berhasil dibuat" ;;
            
            san_init) echo "Memulai Lingkungan Lab Terisolasi..." ;;
            san_ready) echo "Lingkungan siap di %s" ;;
            san_action) echo "Membuka sandbox.pwn... (Keluar untuk membersihkan)" ;;
            san_test) echo "Menguji sintesis sandbox..." ;;
            san_exit) echo "Lingkungan lab telah dimusnahkan" ;;
            
            upd_checking) echo "Memeriksa versi terbaru..." ;;
            upd_fail) echo "Gagal mengambil pembaruan" ;;
            upd_found) echo "Versi baru terdeteksi: v%s" ;;
            upd_upgrading) echo "Meningkatkan versi..." ;;
            upd_success) echo "Diperbarui ke v%s. Restart fpawn untuk menerapkan." ;;
            upd_latest) echo "Sudah menjalankan versi terbaru (v%s)" ;;
            
            saf_snapshot) echo "Snapshot dibuat untuk %s" ;;
            saf_no_backups) echo "Tidak ada backup ditemukan untuk %s" ;;
            saf_empty) echo "Direktori backup kosong" ;;
            saf_restoring) echo "Memulihkan %s dari %s..." ;;
            saf_success) echo "Pemulihan selesai." ;;

            load_processing) echo "Memproses data..." ;;
            exp_title) echo "Kamus Penjelasan Error fpawn" ;;
            exp_not_found) echo "Penjelasan untuk kode %s tidak ditemukan." ;;
            exp_001) echo "Expected token: Kurang simbol atau token tertentu di baris ini." ;;
            exp_002) echo "Only a single statement can be used in 'if': Blok if membutuhkan kurung kurawal jika lebih dari satu baris." ;;
            exp_010) echo "Duplicate symbol: Nama variabel atau fungsi ini sudah digunakan di tempat lain." ;;
            exp_017) echo "Undefined symbol: Variabel atau fungsi ini belum didefinisikan atau typo." ;;
            exp_021) echo "Symbol already defined: Simbol didefinisikan ulang di cakupan yang sama." ;;
            exp_025) echo "Function heading differs from prototype: Header fungsi tidak cocok dengan deklarasi awal." ;;
            exp_035) echo "Argument type mismatch: Tipe data argumen tidak sesuai dengan definisi fungsi." ;;
            exp_052) echo "Multi-dimensional arrays must be fully initialized: Array multi-dimensi harus diisi elemennya secara lengkap." ;;
            exp_fix) echo "Saran Perbaikan: %s" ;;

            aud_title) echo "Audit Keamanan & Logika fpawn" ;;
            aud_sqli) echo "Potensi SQL Injection: Penggunaan 'format' tanpa escape string pada query." ;;
            aud_timer) echo "Timer Berisiko: SetTimer tanpa pengecekan validitas pemain." ;;
            aud_format) echo "Format Tidak Aman: Ukuran buffer mungkin tidak cukup." ;;
            aud_clean) echo "Audit selesai. Tidak ditemukan ancaman kritis." ;;

            sug_title) echo "Saran Modernisasi Kode fpawn" ;;
            sug_omp) echo "Pertimbangkan menggunakan native open.mp daripada a_samp untuk akses fitur baru." ;;
            sug_cache) echo "Gunakan caching variabel untuk GetPlayerPos jika dipanggil berkali-kali." ;;
            
            lin_title) echo "Linter Gaya Kode fpawn" ;;
            lin_naming) echo "Ketidakkonsistenan Nama: %s sebaiknya menggunakan camelCase." ;;
            lin_braces) echo "Gaya Kurung: %s tidak sesuai dengan standar Allman/OTBS." ;;

            # Professional Automation
            mat_title) echo "Laporan Build Matrix fpawn" ;;
            mat_checking) echo "Memeriksa profil: %s (%s)..." ;;
            mat_failed) echo "Gagal pada profil %s" ;;
            mat_success) echo "Integritas Matrix Terverifikasi. Semua target kompatibel." ;;

            ben_title) echo "Benchmarking Mikro fpawn" ;;
            ben_start) echo "Mengukur performa logika... (Harap tunggu)" ;;
            ben_result) echo "Hasil: %s iterasi dalam %sms (%sns per iterasi)" ;;

            bun_title) echo "Pengepakan Proyek fpawn" ;;
            bun_start) echo "Mengarsipkan %s ke %s..." ;;
            bun_success) echo "Paket siap: %s" ;;

            ver_title) echo "Verifikasi Integritas Plugin" ;;
            ver_missing) echo "Plugin Hilang: %s (Dibutuhkan oleh server.cfg)" ;;
            ver_ok) echo "Semua plugin terverifikasi dan siap." ;;

            cru_title) echo "fpawn Cruncher - Optimasi Penyimpanan" ;;
            cru_cleaning) echo "Membersihkan %s..." ;;
            cru_done) echo "Pembersihan selesai. Ruang kosong bertambah." ;;

            ins_title) echo "Inspektur Biner AMX" ;;
            ins_reading) echo "Membaca struktur biner %s..." ;;
            ins_natives) echo "Native Terdeteksi: %s" ;;
            ins_stack) echo "Ukuran Stack: %s bytes" ;;

            rco_title) echo "Jembatan Komando RCON fpawn" ;;
            rco_sending) echo "Mengirim komando: %s..." ;;
            rco_fail) echo "Koneksi RCON gagal. Periksa IP/Port/Password." ;;

            # Marketplace & Search
            mkt_title) echo "Marketplace fpawn - Katalog Sintesis" ;;
            mkt_last_search) echo "Pencarian Terakhir: %s" ;;
            mkt_custom) echo "Cari Galaksi Kustom..." ;;
            mkt_select) echo "Pilih ID: " ;;
            neu_vault) echo "Mengakses Gudang GitHub dengan Peringkat Cerdas..." ;;
            neu_no_repos) echo "Tidak ada repository ditemukan untuk '%s'" ;;
            neu_relevance) echo "Relevansi" ;;
            neu_note) echo "Catatan" ;;
            neu_link) echo "Tautan" ;;
            neu_clone_prompt) echo "Indeks untuk Clone [1-10]: " ;;
            clo_syncing) echo "Menyinkronkan %s..." ;;
            clo_exist) echo "Direktori '%s' sudah ada. Sinkronisasi dengan origin..." ;;
            clo_sync_success) echo "Repository berhasil disinkronkan." ;;
            clo_fail_access) echo "Repository atau file tidak dapat diakses: %s (404 atau Private)" ;;
            clo_archived) echo "Plugin ini mungkin telah diarsipkan atau dipindahkan." ;;
            clo_fail) echo "Gagal melakukan clone %s" ;;

            # General
            btn_ok) echo "Oke" ;;
            btn_cancel) echo "Batal" ;;
            prompt_select) echo "Pilih Indeks: " ;;
            entry_err) echo "Entry point tidak ditemukan." ;;
            success) echo "Berhasil!" ;;
            *) echo "$ID" ;;
        esac
    else
        case $ID in
            welcome) echo "Welcome to fpawn v23.0" ;;
            status) echo "Ecosystem Status" ;;
            
            # Dashboard Menu
            menu_1) echo "Compile Target" ;;
            menu_2) echo "Start Instance" ;;
            menu_3) echo "Live Reload Matrix" ;;
            menu_4) echo "Marketplace & Search" ;;
            menu_5) echo "Arch Analyst" ;;
            menu_6) echo "Autopilot Scan" ;;
            menu_7) echo "Artisan Auto-Fix" ;;
            menu_8) echo "Architect Foundation" ;;
            menu_9) echo "Snippets Sandbox" ;;
            menu_10) echo "Sync Core Library" ;;
            menu_11) echo "Cloud Self-Update" ;;
            menu_12) echo "Language: EN" ;;
            menu_13) echo "Project Doctor" ;;
            menu_14) echo "Auto-Ignition: $AUTO_IGNITE" ;;
            menu_15) echo "Plugin Manager" ;;
            menu_16) echo "Performance Monitor" ;;
            menu_17) echo "Safe-Guard Restore" ;;
            menu_18) echo "Security Audit" ;;
            menu_19) echo "Modernization Tips" ;;
            menu_20) echo "Code Linter" ;;
            menu_21) echo "Build Matrix" ;;
            menu_22) echo "Benchmarking" ;;
            menu_23) echo "Bundle Project" ;;
            menu_24) echo "Server Cruncher" ;;
            menu_25) echo "Verify Plugins" ;;
            menu_0) echo "Shutdown Suite" ;;

            # Compiler Messages
            comp_start) echo "Starting target compilation..." ;;
            comp_success) echo "Compilation Successful!" ;;
            comp_fail) echo "Compilation Failed. Check errors above." ;;
            comp_binary) echo "Searching for pre-compiled binaries..." ;;
            comp_extract) echo "Extracting binary to plugins folder..." ;;

            # Project Doctor Keys
            doc_analyzing) echo "Analyzing" ;;
            doc_healthy) echo "Doctor's Note: Your code is healthy and optimized!" ;;
            doc_unhealthy) echo "Issues found! Use --repair to fix." ;;
            doc_stack) echo "Potential Stack Overflow (Large arrays)" ;;
            doc_loop) echo "Inefficient player loop (Use foreach)" ;;
            doc_timer) echo "Ultra-fast timer (Lag Risk)" ;;
            doc_report) echo "Report Summary" ;;
            doc_crit) echo "Critical Issues" ;;
            doc_warn) echo "Optimization Warnings" ;;
            doc_repair_hint) echo "Recommendation: Use fpawn --repair to fix common issues automatically." ;;

            # Analysis Reports
            ana_start) echo "Deep-inspecting" ;;
            ana_volumes) echo "Volume: %s lines of Pawn code" ;;
            ana_context) echo "Context: %s ecosystem detected" ;;
            ana_fail) echo "Analysis failed. Invalid entry point." ;;
            ana_success) echo "Analysis finalized" ;;

            neu_scan) echo "Scan-sweep %s for signatures..." ;;
            neu_missing) echo "Log file missing" ;;
            neu_logic) echo "Logic overflow identified" ;;
            neu_stack) echo "Stacktrace detected" ;;
            neu_clean) echo "No critical anomalies detected" ;;

            auto_scan) echo "Scanning Neural Grids..." ;;
            auto_integrity) echo "System integrity verified" ;;
            auto_corrupt) echo "Corrupted components" ;;
            auto_repair_prompt) echo "Execute Repair?" ;;

            per_title) echo "fpawn Performance Analytics Dashboard" ;;
            per_no_data) echo "No build data available yet. Compile some scripts first!" ;;
            per_cycles) echo "Last 10 Build Cycles" ;;
            per_stats) echo "Global Stats" ;;
            per_total) echo "Total Compilations" ;;
            per_avg) echo "Average Build Time" ;;
            per_peak) echo "Largest .amx Peak" ;;
            per_trend) echo "Build History Trend (Build Time)" ;;

            # Plugin Manager TUI
            p_cat_core) echo "Core (Essential)" ;;
            p_cat_db) echo "Database (MySQL, Redis)" ;;
            p_cat_sec) echo "Security (Bcrypt, Whirlpool)" ;;
            p_cat_net) echo "Network (HTTP, Socket)" ;;
            p_cat_world) echo "World (Streamer, GPS)" ;;
            p_cat_int) echo "Integration (Discord, Telegram)" ;;
            p_cat_game) echo "Gameplay (Damage, Weapons)" ;;
            p_cat_ui) echo "UI (Textdraws)" ;;
            p_cat_sys) echo "System (Racing, Housing)" ;;
            p_cat_util) echo "Utility (Log, CMD)" ;;
            p_cat_lang) echo "Language (JSON, PawnPlus)" ;;
            
            p_desc_core) echo "Mandatory base plugins." ;;
            p_desc_db) echo "Permanent data storage." ;;
            p_desc_sec) echo "Encryption and data protection." ;;
            p_desc_net) echo "Connect to external services." ;;
            p_desc_world) echo "Manage objects and large maps." ;;
            p_desc_int) echo "Connect server to social media." ;;
            p_desc_game) echo "Advanced gaming mechanics." ;;
            p_desc_ui) echo "Improve player visuals." ;;
            p_desc_sys) echo "Complex server system features." ;;
            p_desc_util) echo "Scripting helper tools." ;;
            p_desc_lang) echo "Pawn language extensions." ;;

            # Plugin UI
            prompt_select_cat) echo "Select a category to browse plugins:" ;;
            p_none_found) echo "No plugins found in category" ;;
            p_cat_prefix) echo "Category" ;;
            p_prompt_install) echo "Select plugins to install (Space: toggle, Enter: confirm):" ;;
            p_press_enter) echo "Installations completed. Press Enter to return..." ;;

            git_downloading) echo "Downloading %s..." ;;

            # Compiler & Watch
            com_invalid_target) echo "Invalid target file: %s" ;;
            com_file_not_found) echo "File not found: %s" ;;
            com_detect_profile) echo "Detected profile: %s" ;;
            com_building) echo "Building %s with %s (%s)..." ;;
            com_ignite_success) echo "Compilation successful. Launching server..." ;;
            srv_missing_bin) echo "No server binary found (omp-server or samp03svr)" ;;
            srv_starting) echo "Starting %s..." ;;
            ref_syncing) echo "Synchronizing core distribution..." ;;
            wat_active) echo "Live Reload Engine Active for %s" ;;
            wat_monitoring) echo "Monitoring project for changes... (Press Ctrl+C to stop)" ;;
            wat_deactivated) echo "Engine de-activated." ;;
            wat_high_perf) echo "High-Performance (inotify)" ;;
            wat_standard) echo "Standard Polling (No inotify-tools)" ;;
            wat_event) echo "Change detected. Debouncing..." ;;
            wat_sync) echo "Modification detected. Syncing..." ;;
            wat_snapshot) echo "Build finished in %sms" ;;

            # Artisan & Tools
            art_polishing) echo "Polishing %s aesthetics..." ;;
            art_init_repair) echo "Initiating repair sequence for %s..." ;;
            art_opt_loops) echo "Optimizing player loops to 'foreach'..." ;;
            art_harden) echo "Hardening local arrays (new -> static)..." ;;
            art_modernize) echo "Modernizing header: a_samp -> open.mp..." ;;
            art_success) echo "Code Artisan has completed the restoration." ;;
            art_note) echo "Note: Always re-compile to verify logic integrity." ;;
            
            arc_title) echo "fpawn Architect" ;;
            arc_select) echo "Select Project Architecture:" ;;
            arc_legacy) echo "Classic SA-MP structure (0.3.7)" ;;
            arc_advanced) echo "Modern open.mp modular structure" ;;
            arc_casting) echo "Casting %s Foundation for %s..." ;;
            arc_legacy_gen) echo "Legacy SA-MP structure '%s' generated" ;;
            arc_mod_gen) echo "Modular open.mp structure '%s' generated" ;;
            
            san_init) echo "Initiating Isolated Lab Environment..." ;;
            san_ready) echo "Environment ready at %s" ;;
            san_action) echo "Opening sandbox.pwn... (Exit to cleanup)" ;;
            san_test) echo "Testing sandbox synthesis..." ;;
            san_exit) echo "Lab environment de-materialized" ;;
            
            upd_checking) echo "Checking for newer version..." ;;
            upd_fail) echo "Failed to fetch update" ;;
            upd_found) echo "New version detected: v%s" ;;
            upd_upgrading) echo "Upgrading..." ;;
            upd_success) echo "Updated to v%s. Restart fpawn to apply." ;;
            upd_latest) echo "Already running latest version (v%s)" ;;
            
            saf_snapshot) echo "Snapshot created for %s" ;;
            saf_no_backups) echo "No backups found for %s" ;;
            saf_empty) echo "Backup directory is empty" ;;
            saf_restoring) echo "Restoring %s from %s..." ;;
            saf_success) echo "Restoration complete." ;;

            load_processing) echo "Processing data..." ;;
            exp_title) echo "fpawn Error Explanation Dictionary" ;;
            exp_not_found) echo "Explanation for code %s not found." ;;
            exp_001) echo "Expected token: Missing specific symbol or token on this line." ;;
            exp_002) echo "Only a single statement can be used in 'if': If block needs braces for multiple lines." ;;
            exp_010) echo "Duplicate symbol: This variable or function name is already used elsewhere." ;;
            exp_017) echo "Undefined symbol: This variable or function is not defined or has a typo." ;;
            exp_021) echo "Symbol already defined: Symbol redefined in the same scope." ;;
            exp_025) echo "Function heading differs from prototype: Function header does not match early declaration." ;;
            exp_035) echo "Argument type mismatch: Argument data type does not match function definition." ;;
            exp_052) echo "Multi-dimensional arrays must be fully initialized: All elements of a multi-dimensional array must be initialized." ;;
            exp_fix) echo "Fix Suggestion: %s" ;;

            aud_title) echo "fpawn Security & Logic Audit" ;;
            aud_sqli) echo "Potential SQL Injection: Use of 'format' without escaping strings in query." ;;
            aud_timer) echo "Risky Timer: SetTimer without player validity checks." ;;
            aud_format) echo "Unsafe Format: Buffer size might not be sufficient." ;;
            aud_clean) echo "Audit completed. No critical threats identified." ;;

            sug_title) echo "fpawn Code Modernization Suggestions" ;;
            sug_omp) echo "Consider using open.mp natives instead of a_samp for new feature access." ;;
            sug_cache) echo "Use variable caching for GetPlayerPos if called multiple times." ;;
            
            lin_title) echo "fpawn Code Style Linter" ;;
            lin_naming) echo "Naming Inconsistency: %s should ideally use camelCase." ;;
            lin_braces) echo "Brace Style: %s does not match Allman/OTBS standard." ;;

            # Professional Automation
            mat_title) echo "fpawn Build Matrix Report" ;;
            mat_checking) echo "Checking profile: %s (%s)..." ;;
            mat_failed) echo "Failed on profile %s" ;;
            mat_success) echo "Matrix Integrity Verified. All targets compatible." ;;

            ben_title) echo "fpawn Micro-Benchmarking" ;;
            ben_start) echo "Measuring logic performance... (Please wait)" ;;
            ben_result) echo "Result: %s iterations in %sms (%sns per iteration)" ;;

            bun_title) echo "fpawn Project Bundling" ;;
            bun_start) echo "Archiving %s to %s..." ;;
            bun_success) echo "Package ready: %s" ;;

            ver_title) echo "Plugin Integrity Verification" ;;
            ver_missing) echo "Missing Plugin: %s (Required by server.cfg)" ;;
            ver_ok) echo "All plugins verified and ready." ;;

            cru_title) echo "fpawn Cruncher - Storage Optimization" ;;
            cru_cleaning) echo "Cleaning %s..." ;;
            cru_done) echo "Cleanup complete. Free space increased." ;;

            ins_title) echo "AMX Binary Inspector" ;;
            ins_reading) echo "Reading binary structure of %s..." ;;
            ins_natives) echo "Natives Detected: %s" ;;
            ins_stack) echo "Stack Size: %s bytes" ;;

            rco_title) echo "fpawn RCON Command Bridge" ;;
            rco_sending) echo "Sending command: %s..." ;;
            rco_fail) echo "RCON connection failed. Check IP/Port/Password." ;;

            # Marketplace & Search
            mkt_title) echo "🌌 fpawn Marketplace - Synthesis Catalog" ;;
            mkt_last_search) echo "Last Search: %s" ;;
            mkt_custom) echo "Search Custom Galaxy..." ;;
            mkt_select) echo "Select ID: " ;;
            neu_vault) echo "Accessing GitHub Vault with Intelligent Ranking..." ;;
            neu_no_repos) echo "No repositories found for '%s'" ;;
            neu_relevance) echo "Relevance" ;;
            neu_note) echo "Note" ;;
            neu_link) echo "Link" ;;
            neu_clone_prompt) echo "Index to Clone [1-10]: " ;;
            clo_syncing) echo "Syncing %s..." ;;
            clo_exist) echo "Directory '%s' already exists. Synchronizing..." ;;
            clo_sync_success) echo "Synchronized existing repository." ;;
            clo_fail_access) echo "Repository or file is inaccessible: %s (404 or Private)" ;;
            clo_archived) echo "This plugin might have been archived or moved." ;;
            clo_fail) echo "Failed to clone %s" ;;

            # General
            btn_ok) echo "OK" ;;
            btn_cancel) echo "Cancel" ;;
            prompt_select) echo "Select Index: " ;;
            entry_err) echo "Entry point not detected." ;;
            success) echo "Success!" ;;
            *) echo "$ID" ;;
        esac
    fi
}

# === ERROR HANDLING ===

function core_error() {
    echo -e "${RED}[Error]${NC} $1" >&2
    return 1
}

function core_warning() {
    echo -e "${YELLOW}[Warning]${NC} $1" >&2
}

function core_info() {
    echo -e "${BLUE}[Info]${NC} $1"
}

function core_success() {
    echo -e "${GREEN}[Success]${NC} $1"
}

# === GIT AUTO-PILOT ===

function core_git_commit() {
    local MSG=$1
    if [ -d ".git" ]; then
        git add . >/dev/null 2>&1
        git commit -m "[fpawn v19.0] $MSG" &>/dev/null
        echo -e "${LBLUE}[Git]${NC} Auto-commit: $MSG"
    fi
}

# === NEURAL MEMORY ===

function core_neural_memory_sync() {
    local DATA=$1
    local HFILE="$HOME/.ferzdevz/fpawn/history"
    echo "$DATA" >> "$HFILE"
    local LAST=$(tail -n 5 "$HFILE" 2>/dev/null | sort -u | tr '\n' ' ')
    echo -e " ${LBLUE}[Memory]${NC} Recent: $LAST"
}
