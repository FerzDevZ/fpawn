# fpawn v9.5 - FerzDevZ Professional Bundle Pack

`fpawn` sekarang menyediakan paket instalasi server yang **"Ready-to-Code"**. Tidak ada lagi server kosong yang membosankan.

## Apa itu Professional Bundle?

Saat Anda menjalankan `--create-server`, `fpawn` tidak hanya mendownload engine, tapi juga menyiapkan seluruh ekosistem developer profesional:

### 1. SA-MP Legacy Pro Bundle
- **Pre-installed Plugins**: Otomatis memasang **Streamer**, **MySQL**, dan **sscanf** (Include + Linux .so).
- **Auto-Config**: `server.cfg` sudah dikonfigurasi dengan plugin-plugin tersebut.
- **Classic Structure**: Folder `gamemodes`, `filterscripts`, dan `scriptfiles` siap pakai.

### 2. open.mp Pro Bundle
- **Clean Root**: Tidak ada folder double atau nested.
- **Modern Structure**: Folder `src`, `include`, dan `dependencies` otomatis dibuat.
- **Auto-Init**: File `pawn.json` dan template `main.pwn` sudah siap dikerjakan.

## Cara Penggunaan Pro Bundle

**Bangun Server Legacy Full-Plugin:**
```bash
fpawn --create-server legacy
```

**Bangun Server open.mp Modern:**
```bash
fpawn --create-server omp
```

## Keunggulan v9.5:
- **Zero Conflict**: Struktur folder dipisahkan dengan sangat rapi sesuai standar masing-masing engine.
- **Plugin Ready**: Anda bisa langsung menggunakan fungsi MySQL atau Streamer di gamemode Anda tanpa download tambahan.
- **Auto-Chmod**: Semua binary server dan plugin otomatis diberikan izin eksekusi.

---
**Powered by FerzDevZ**
