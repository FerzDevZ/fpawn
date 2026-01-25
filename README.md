# fpawn v5.0 - FerzDevZ Omnipotent Pack

Ini adalah versi **terkuat** (Overpower) dari `fpawn`. Anda sekarang memiliki kendali penuh atas ekosistem Pawn Anda di Linux.

## Fitur "Omnipotent" (Dewa)

### 1. Watch Mode (`--watch`)
Ngoding tanpa perlu pindah tab! `fpawn` akan terus memantau file `.pwn` Anda. Setiap kali Anda tekan `Ctrl+S`, `fpawn` langsung mengkompilasi ulang secara instan.
```bash
fpawn gamemode.pwn --watch
```

### 2. Plugin Master (`--plugin <name>`)
Ribet download library? Sekarang tinggal sebut namanya, `fpawn` yang ambil filenya.
```bash
fpawn --plugin streamer
fpawn --plugin mysql
fpawn --plugin ysi
fpawn --plugin sscanf
```
*File `.inc` akan otomatis diletakkan di folder `include/` project Anda.*

### 3. Integrated Decompiler (`--decompile`)
Ingin mengintip cara kerja file `.amx`? Gunakan decompiler bawaan:
```bash
fpawn --decompile gamemode.amx
```

### 4. Smart Sensing (Auto Engine)
Sama seperti v4.0, `fpawn` tetap otomatis mendeteksi antara **open.mp** dan **SAMP Legacy** tanpa perlu Anda setel manual.

## Ringkasan Perintah

| Perintah | Deskripsi |
| :--- | :--- |
| `fpawn file.pwn --watch` | Recompile otomatis setiap save |
| `fpawn --plugin streamer` | Download include Streamer instan |
| `fpawn --decompile file.amx`| Bongkar file AMX jadi assembler |
| `fpawn --init` | Bangun project structure FerzDevZ |
| `fpawn --update` | Update standard library global |

## Penting:
Jika fitur `--watch` tidak jalan, jalankan ulang `sudo ./setup.sh` untuk memasang `inotify-tools`.

---
**Powered by FerzDevZ**
