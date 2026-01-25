# fpawn v9.0 - FerzDevZ God Mode Pack

Selamat datang di level **GOD MODE**. `fpawn` sekarang bukan lagi sekadar compiler, melainkan sebuah **Full-Stack Server Suite** untuk Linux.

## Apa itu God Mode?

`fpawn` v9.0 mengelola seluruh siklus hidup server Anda:
1.  **Download Server Engine**: Langsung ambil binary original SAMP atau open.mp.
2.  **Plugin Manager (Full)**: Tidak cuma download `.inc`, tapi juga download `.so` (Linux DLL) secara otomatis.
3.  **Integrated Runner**: Jalankan server langsung dari `fpawn` dengan output yang berwarna.

## Fitur Unggulan v9.0

### 1. Server Installer (`--create-server`)
Install server SAMP atau open.mp lengkap dengan binary Linux aslinya:
```bash
fpawn --create-server legacy   # Install SAMP 0.3.7-R2 Linux
fpawn --create-server omp      # Install open.mp Linux
```

### 2. Full Plugin Support (.so + .inc)
Lupa download file `.so` untuk Linux? `fpawn` akan melakukannya untuk Anda:
```bash
fpawn --plugin streamer
```
Ini akan otomatis mendownload `streamer.inc` ke folder `include/` DAN `streamer.so` ke folder `plugins/`.

### 3. Integrated Runner (`--run`)
Jalankan server Anda dengan satu perintah:
```bash
fpawn --run
```
`fpawn` akan otomatis mengatur `LD_LIBRARY_PATH`, memberikan izin eksekusi (`chmod +x`), dan mewarnai log server Anda agar mudah dibaca (Info: Hijau, Warning: Kuning, Error: Merah).

### 4. Real-time Log Viewer (`--log`)
Lihat apa yang terjadi di server Anda secara live:
```bash
fpawn --log
```

## Ringkasan Perintah Dewa

| Perintah | Deskripsi |
| :--- | :--- |
| `fpawn --create-server [type]` | Install binary server Linux |
| `fpawn --run` | Jalankan server secara profesional |
| `fpawn --plugin streamer` | Install include & Linux binary (.so) |
| `fpawn --log` | Intip log server secara live |
| `fpawn script.pwn` | Kompilasi Autopilot (Zero-Config) |

---
**Powered by FerzDevZ**
