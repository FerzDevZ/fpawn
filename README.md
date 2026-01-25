# fpawn v6.0 - FerzDevZ FPM Edition (Smart Finder)

Selamat! Anda sekarang memegang tool CLI Pawn **paling cerdas** di dunia Linux. `fpawn` bukan sekadar compiler, tapi adalah asisten cerdas yang memahami kebutuhan proyek Anda.

## Fitur Unggulan v6.0 (FPM Edition)

### 1. FerzDevZ Smart Finder (`--ensure`)
Pernah kesal karena error `cannot read from file` saat kompilasi? Cukup jalankan:
```bash
fpawn gamemode.pwn --ensure
```
`fpawn` akan otomatis memindai script Anda, mendeteksi include yang hilang, mencarinya di GitHub, dan memasangnya secara otomatis ke folder `include/` Anda.

### 2. Dual-Engine Architecture (Smart Sensing)
`fpawn` secara otomatis mendeteksi apakah script Anda untuk **open.mp** atau **SAMP Legacy**:
- Menggunakan engine **QAWNO** untuk open.mp (Native Linux).
- Menggunakan engine **PAWNO** untuk SAMP Legacy (via Wine).

### 3. Watch Mode (`--watch`)
Kompilasi otomatis setiap kali Anda menyimpan file. Tekan Ctrl+S, dan `fpawn` langsung bekerja di latar belakang.
```bash
fpawn gamemode.pwn --watch
```

### 4. Plugin Master (`--plugin`)
Pasang library populer dalam sekejap:
```bash
fpawn --plugin streamer
fpawn --plugin mysql
fpawn --plugin ysi
fpawn --plugin sscanf
```

## Ringkasan Perintah Penting

| Perintah | Deskripsi |
| :--- | :--- |
| `fpawn file.pwn --ensure` | Scan & pasang include yang hilang otomatis |
| `fpawn file.pwn --watch` | Auto-recompile setiap save |
| `fpawn --init` | Bangun struktur proyek FerzDevZ baru |
| `fpawn --update` | Update standard library global |
| `fpawn --decompile file.amx`| Bongkar file AMX jadi assembler |

---
**Powered by FerzDevZ**
